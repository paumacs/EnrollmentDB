
-- STORED PROCEDURE TO MANAGE ENROLLEE ACCOUNT (INSERT/UPDATE)
CREATE PROCEDURE dbo.usp_ManageEnrolleeAccount
    @EnrolleeId      INT          = NULL OUTPUT,   -- NULL = insert; else update
    @FirstName       VARCHAR(30),
    @MiddleName      VARCHAR(30)  = NULL,
    @LastName        VARCHAR(30),
    @Email           VARCHAR(250),
    @StudentType     VARCHAR(30),
    @Address         VARCHAR(250) = NULL,
    @Age             INT          = NULL,
    @BirthDate       DATE         = NULL,
    @AccountId       VARCHAR(30),                  -- unique user‑facing account code
    @Password        VARCHAR(50),
    @AccountStatus   VARCHAR(30)  = 'Active',
    @DocumentId      INT          = NULL,
    @IsEnrolled      BIT          = 0,
    @SectionId       INT          = NULL,
    @SubjectId       INT          = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Validate required inputs
    IF @FirstName IS NULL OR @LastName IS NULL OR @Email IS NULL
       OR @StudentType IS NULL OR @AccountId IS NULL OR @Password IS NULL
    BEGIN
        RAISERROR('First name, last name, email, student type, account ID, and password are required.', 16, 1);
        RETURN;
    END;

    -- 2. Insert or update the Enrollee
    IF @EnrolleeId IS NULL
    BEGIN
        INSERT INTO dbo.Enrollees (firstName, middleName, lastName, email,
                                   studentType, address, age, birthDate)
        VALUES (@FirstName, @MiddleName, @LastName, @Email,
                @StudentType, @Address, @Age, @BirthDate);

        SET @EnrolleeId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.Enrollees
        SET firstName  = @FirstName,
            middleName = @MiddleName,
            lastName   = @LastName,
            email      = @Email,
            studentType= @StudentType,
            address    = @Address,
            age        = @Age,
            birthDate  = @BirthDate
        WHERE id = @EnrolleeId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Enrollee with ID %d not found.', 16, 1, @EnrolleeId);
            RETURN;
        END;
    END;

    -- 3. Ensure an Account exists for this enrollee
    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE enrolleeId = @EnrolleeId)
    BEGIN
        -- accountabilityId is intentionally left NULL (circular FK).
        INSERT INTO dbo.Accounts (accountId, password, status, enrolleeId,
                                  documentId, isEnrolled, sectionId, subjectId)
        VALUES (@AccountId, @Password, @AccountStatus, @EnrolleeId,
                @DocumentId, @IsEnrolled, @SectionId, @SubjectId);
    END;
    -- If an account already exists, you could optionally update it here.
    -- For this procedure we simply guarantee that an account is present.

    -- 4. Return the enrollee ID (and account info if desired)
    SELECT
        @EnrolleeId AS EnrolleeId,
        a.id        AS AccountId,
        a.accountId AS AccountCode,
        a.status    AS AccountStatus
    FROM dbo.Accounts a
    WHERE a.enrolleeId = @EnrolleeId;
END;
