-- FUNCTION TO GET ENROLLEE MANAGEMENT INFO
CREATE FUNCTION dbo.fn_EnrolleeManagement
(
    @EnrolleeId INT
)
RETURNS TABLE
AS
RETURN
(
    WITH EnrolleeBase AS
    (
        SELECT
            id,
            firstName,
            middleName,
            lastName,
            email,
            studentType,
            address,
            age,
            birthDate
        FROM Enrollees
        WHERE id = @EnrolleeId
    ),
    AccountDetails AS
    (
        SELECT
            a.id                 AS AccountId,
            a.enrolleeId,
            a.accountId          AS AccountCode,
            a.status             AS AccountStatus,
            a.isEnrolled,
            a.sectionId,
            a.subjectId,
            sec.sectionName,
            sub.title            AS SubjectTitle,
            sub.yearLevel        AS SubjectYearLevel,
            sched.days           AS ScheduleDays,
            sched.timeStart,
            sched.timeEnd,
            sched.roomNumber,
            dept.departmentName,
            COALESCE(SUM(acc.amount), 0) AS TotalDue
        FROM Accounts a
        LEFT JOIN Sections sec
               ON a.sectionId = sec.id
        LEFT JOIN Subjects sub
               ON a.subjectId = sub.id
        LEFT JOIN Schedules sched
               ON sub.scheduleId = sched.id
        LEFT JOIN Departments dept
               ON sub.departmentId = dept.id
        LEFT JOIN Accountabilities acc
               ON a.id = acc.accountId
              AND acc.status <> 'Resolved'   -- change according to your status values
        WHERE a.enrolleeId = @EnrolleeId
        GROUP BY
            a.id,
            a.enrolleeId,
            a.accountId,
            a.status,
            a.isEnrolled,
            a.sectionId,
            a.subjectId,
            sec.sectionName,
            sub.title,
            sub.yearLevel,
            sched.days,
            sched.timeStart,
            sched.timeEnd,
            sched.roomNumber,
            dept.departmentName
    )
    SELECT
        e.id                                        AS EnrolleeId,
        e.firstName + ' '
            + ISNULL(e.middleName + ' ', '')
            + e.lastName                            AS FullName,
        e.email,
        e.studentType,
        e.address,
        e.age,
        e.birthDate,
        ad.AccountId,
        ad.AccountCode,
        ad.AccountStatus,
        ad.isEnrolled,
        ad.sectionName,
        ad.SubjectTitle,
        ad.SubjectYearLevel,
        ad.ScheduleDays,
        ad.timeStart,
        ad.timeEnd,
        ad.roomNumber,
        ad.departmentName,
        ad.TotalDue
    FROM EnrolleeBase e
    LEFT JOIN AccountDetails ad
           ON e.id = ad.enrolleeId
);