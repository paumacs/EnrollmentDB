CREATE TABLE dbo.EnrollmentAuditLog (
    LogId           INT IDENTITY(1,1) PRIMARY KEY,
    AccountId       INT NOT NULL,
    Action          VARCHAR(10) NOT NULL,      -- 'INSERT', 'UPDATE'
    OldIsEnrolled   BIT,
    NewIsEnrolled   BIT,
    OldSectionId    INT,
    NewSectionId    INT,
    OldSubjectId    INT,
    NewSubjectId    INT,
    ChangedBy       NVARCHAR(128) DEFAULT SUSER_SNAME(),
    ChangeDate      DATETIME2(3) DEFAULT SYSDATETIME()
);

ALTER TABLE dbo.Accounts
ADD paymentStatus VARCHAR(20) NULL;   -- 'Unpaid','Partial','Paid'

CREATE TRIGGER trg_ValidateAccountsInsert
ON dbo.Accounts
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Prevent duplicate active enrollment for the same enrollee
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Accounts a
            ON a.enrolleeId = i.enrolleeId
            AND a.id <> i.id       -- exclude itself if somehow already exists (INSERT usually not)
        WHERE i.isEnrolled = 1
          AND a.isEnrolled = 1
    )
    BEGIN
        RAISERROR('Enrollee already has an active enrolled account.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- 2. Check section capacity (overflow)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Sections sec ON i.sectionId = sec.id
        WHERE i.isEnrolled = 1
          AND sec.slotsTaken >= sec.totalSlots
    )
    BEGIN
        RAISERROR('Cannot enroll: the target section is already full.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- 3. Prerequisite check (requires StudentSubjectCompletions table and fn_IsPrerequisiteMet)
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.isEnrolled = 1
          AND dbo.fn_IsPrerequisiteMet(i.enrolleeId, i.subjectId) = 0
    )
    BEGIN
        RAISERROR('Prerequisite not met for the subject.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- If all checks pass, perform the actual INSERT
    INSERT INTO dbo.Accounts (accountId, password, status, enrolleeId,
                              accountabilityId, documentId, isEnrolled,
                              sectionId, subjectId, paymentStatus)
    SELECT accountId, password, status, enrolleeId,
           accountabilityId, documentId, isEnrolled,
           sectionId, subjectId, paymentStatus
    FROM inserted;
END;

CREATE TRIGGER trg_UpdateSectionSlots
ON dbo.Accounts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Handle enrollment into a section (isEnrolled changes to 1)
    IF UPDATE(isEnrolled) OR UPDATE(sectionId)
    BEGIN
        -- Increment for newly enrolled students (isEnrolled 0→1, section assigned)
        UPDATE sec
        SET slotsTaken = sec.slotsTaken + 1
        FROM dbo.Sections sec
        INNER JOIN inserted i ON i.sectionId = sec.id
        INNER JOIN deleted d ON d.id = i.id
        WHERE i.isEnrolled = 1
          AND (d.isEnrolled = 0 OR d.sectionId IS NULL OR d.sectionId <> i.sectionId);

        -- Decrement for unenrolled students (isEnrolled 1→0)
        UPDATE sec
        SET slotsTaken = sec.slotsTaken - 1
        FROM dbo.Sections sec
        INNER JOIN deleted d ON d.sectionId = sec.id
        INNER JOIN inserted i ON i.id = d.id
        WHERE d.isEnrolled = 1
          AND i.isEnrolled = 0;

        -- Decrement if section changed from one to another (old section loses one)
        UPDATE sec
        SET slotsTaken = sec.slotsTaken - 1
        FROM dbo.Sections sec
        INNER JOIN deleted d ON d.sectionId = sec.id
        INNER JOIN inserted i ON i.id = d.id
        WHERE d.isEnrolled = 1
          AND i.isEnrolled = 1
          AND d.sectionId <> i.sectionId
          AND d.sectionId IS NOT NULL;
    END;
END;

CREATE TRIGGER trg_AutoCloseAccountability
ON dbo.Accountabilities
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(status)
    BEGIN
        UPDATE acc
        SET dateResolved = SYSDATETIME()
        FROM dbo.Accountabilities acc
        INNER JOIN inserted i ON i.id = acc.id
        INNER JOIN deleted d ON d.id = i.id
        WHERE i.status = 'Resolved'
          AND d.status <> 'Resolved'
          AND acc.dateResolved IS NULL;
    END;
END;

CREATE TRIGGER trg_SetPaymentStatus
ON dbo.Payments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Recalculate payment status for affected accounts
    WITH AccountBalances AS (
        SELECT
            a.id AS AccountId,
            ISNULL(SUM(CASE WHEN acc.status <> 'Resolved' THEN acc.amount ELSE 0 END), 0) AS TotalDue,
            ISNULL(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0) AS TotalPaid
        FROM dbo.Accounts a
        INNER JOIN (SELECT DISTINCT accountId FROM inserted) i ON a.id = i.accountId
        LEFT JOIN dbo.Accountabilities acc ON acc.accountId = a.id
        LEFT JOIN dbo.Payments p ON p.accountId = a.id AND p.status = 'Completed'
        GROUP BY a.id
    )
    UPDATE a
    SET paymentStatus = CASE
            WHEN ab.TotalDue = 0 AND ab.TotalPaid = 0 THEN 'N/A'
            WHEN ab.TotalPaid >= ab.TotalDue THEN 'Paid'
            WHEN ab.TotalPaid > 0 THEN 'Partial'
            ELSE 'Unpaid'
        END
    FROM dbo.Accounts a
    INNER JOIN AccountBalances ab ON a.id = ab.AccountId;
END;

CREATE TRIGGER trg_AuditEnrollmentLog
ON dbo.Accounts
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT audit
    INSERT INTO dbo.EnrollmentAuditLog
        (AccountId, Action, OldIsEnrolled, NewIsEnrolled,
         OldSectionId, NewSectionId, OldSubjectId, NewSubjectId)
    SELECT
        i.id,
        'INSERT',
        NULL,
        i.isEnrolled,
        NULL,
        i.sectionId,
        NULL,
        i.subjectId
    FROM inserted i
    WHERE NOT EXISTS (SELECT 1 FROM deleted d WHERE d.id = i.id);

    -- UPDATE audit (only log when enrollment‑related fields change)
    INSERT INTO dbo.EnrollmentAuditLog
        (AccountId, Action, OldIsEnrolled, NewIsEnrolled,
         OldSectionId, NewSectionId, OldSubjectId, NewSubjectId)
    SELECT
        i.id,
        'UPDATE',
        d.isEnrolled,
        i.isEnrolled,
        d.sectionId,
        i.sectionId,
        d.subjectId,
        i.subjectId
    FROM inserted i
    INNER JOIN deleted d ON i.id = d.id
    WHERE (i.isEnrolled <> d.isEnrolled)
       OR (i.sectionId <> d.sectionId OR (i.sectionId IS NULL AND d.sectionId IS NOT NULL) OR (i.sectionId IS NOT NULL AND d.sectionId IS NULL))
       OR (i.subjectId <> d.subjectId OR (i.subjectId IS NULL AND d.subjectId IS NOT NULL) OR (i.subjectId IS NOT NULL AND d.subjectId IS NULL));
END;