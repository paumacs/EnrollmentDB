CREATE FUNCTION dbo.fn_GetAccountDashboard
(
    @AccountId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        -- Account info
        a.id                    AS AccountId,
        a.accountId             AS AccountCode,
        a.status                AS AccountStatus,
        a.isEnrolled,
        -- Student info
        e.id                    AS EnrolleeId,
        e.firstName + ' ' + ISNULL(e.middleName+' ','') + e.lastName AS FullName,
        e.email,
        e.studentType,
        e.address,
        -- Section & Subject
        sec.sectionName,
        sub.title               AS SubjectTitle,
        sub.yearLevel           AS SubjectYearLevel,
        dept.departmentName,
        -- Schedule
        sched.days              AS ScheduleDays,
        sched.timeStart,
        sched.timeEnd,
        sched.roomNumber,
        -- Document
        doc.documentId          AS LinkedDocumentId,
        doc.documentName        AS LinkedDocument,
        doc.status              AS DocumentStatus,
        -- Outstanding balance
        ISNULL(SUM(accbl.amount), 0) AS TotalOutstanding,
        -- Recent payments
        p.TotalPaid
    FROM dbo.Accounts a
    INNER JOIN dbo.Enrollees e ON a.enrolleeId = e.id
    LEFT JOIN dbo.Sections sec ON a.sectionId = sec.id
    LEFT JOIN dbo.Subjects sub ON a.subjectId = sub.id
    LEFT JOIN dbo.Departments dept ON sub.departmentId = dept.id
    LEFT JOIN dbo.Schedules sched ON sub.scheduleId = sched.id
    LEFT JOIN dbo.Documents doc ON a.documentId = doc.id
    LEFT JOIN dbo.Accountabilities accbl ON a.id = accbl.accountId AND accbl.status <> 'Resolved'
    LEFT JOIN (
        SELECT accountId, SUM(amount) AS TotalPaid
        FROM dbo.Payments
        WHERE status = 'Completed'
        GROUP BY accountId
    ) p ON a.id = p.accountId
    WHERE a.id = @AccountId
    GROUP BY
        a.id, a.accountId, a.status, a.isEnrolled,
        e.id, e.firstName, e.middleName, e.lastName, e.email, e.studentType, e.address,
        sec.sectionName, sub.title, sub.yearLevel, dept.departmentName,
        sched.days, sched.timeStart, sched.timeEnd, sched.roomNumber,
        doc.documentId, doc.documentName, doc.status,
        p.TotalPaid
);