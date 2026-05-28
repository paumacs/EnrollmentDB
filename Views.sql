-- ============================================================
-- 1. vw_EnrolledStudents
-- ============================================================
CREATE VIEW dbo.vw_EnrolledStudents
AS
SELECT
    e.firstName + ' ' + ISNULL(e.middleName + ' ', '') + e.lastName AS FullName,
    a.accountId                    AS AccountID,
    s.sectionName,
    sub.title                      AS SubjectTitle,
    sub.yearLevel,
    a.status                       AS EnrollmentStatus
FROM dbo.Accounts a
INNER JOIN dbo.Enrollees e ON a.enrolleeId = e.id
INNER JOIN dbo.Sections s ON a.sectionId = s.id
INNER JOIN dbo.Subjects sub ON a.subjectId = sub.id
WHERE a.isEnrolled = 1;
GO

-- ============================================================
-- 2. vw_PaymentSummary
-- ============================================================
CREATE VIEW dbo.vw_PaymentSummary
AS
WITH PaymentAgg AS (
    SELECT
        accountId,
        SUM(amount) AS TotalPaid,
        MAX(paymentDate) AS LatestPaymentDate
    FROM dbo.Payments
    WHERE status = 'Completed'
    GROUP BY accountId
),
LatestPaymentMode AS (
    SELECT
        p.accountId,
        p.modeOfPayment AS LatestPaymentMode
    FROM dbo.Payments p
    INNER JOIN (
        SELECT accountId, MAX(paymentDate) AS MaxDate
        FROM dbo.Payments
        WHERE status = 'Completed'
        GROUP BY accountId
    ) sub ON p.accountId = sub.accountId AND p.paymentDate = sub.MaxDate AND p.status = 'Completed'
),
Outstanding AS (
    SELECT
        accountId,
        SUM(amount) AS OutstandingBalance
    FROM dbo.Accountabilities
    WHERE status <> 'Resolved' OR status IS NULL
    GROUP BY accountId
)
SELECT
    a.id                            AS AccountId,
    e.firstName + ' ' + ISNULL(e.middleName + ' ', '') + e.lastName AS StudentName,
    ISNULL(pa.TotalPaid, 0)         AS TotalPaid,
    lpm.LatestPaymentMode,
    pa.LatestPaymentDate,
    ISNULL(o.OutstandingBalance, 0) AS OutstandingBalance
FROM dbo.Accounts a
INNER JOIN dbo.Enrollees e ON a.enrolleeId = e.id
LEFT JOIN PaymentAgg pa ON a.id = pa.accountId
LEFT JOIN LatestPaymentMode lpm ON a.id = lpm.accountId
LEFT JOIN Outstanding o ON a.id = o.accountId;
GO

-- ============================================================
-- 3. vw_SectionCapacity
-- ============================================================
CREATE VIEW dbo.vw_SectionCapacity
AS
SELECT
    sec.sectionName,
    sub.title                       AS SubjectTitle,
    dep.departmentName,
    sec.totalSlots,
    sec.slotsTaken,
    sec.totalSlots - sec.slotsTaken AS RemainingCapacity
FROM dbo.Sections sec
INNER JOIN dbo.Subjects sub ON sec.subjectId = sub.id
INNER JOIN dbo.Departments dep ON sub.departmentId = dep.id;
GO

-- ============================================================
-- 4. vw_SubjectPrerequisites
-- ============================================================
CREATE VIEW dbo.vw_SubjectPrerequisites
AS
SELECT
    sub.subjectId                   AS SubjectCode,
    sub.title                       AS SubjectTitle,
    sub.yearLevel,
    sub.units                       AS SubjectUnits,
    pr.subjectTitle                 AS PrerequisiteTitle,
    pr.units                        AS PrerequisiteUnits
FROM dbo.Subjects sub
LEFT JOIN dbo.Prerequisites pr ON sub.prerequisiteId = pr.id;
GO

-- ============================================================
-- 5. vw_EmployeeDirectory
-- ============================================================
CREATE VIEW dbo.vw_EmployeeDirectory
AS
SELECT
    e.employeeId,
    e.firstName + ' ' + ISNULL(e.middleName + ' ', '') + e.lastName AS FullName,
    e.employeeType,
    e.title,
    d.departmentName,
    e.status                        AS EmploymentStatus
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.departmentId = d.id;
GO

-- ============================================================
-- 6. vw_AccountabilityReport
-- ============================================================
CREATE VIEW dbo.vw_AccountabilityReport
AS
SELECT
    a.accountId                     AS AccountCode,
    e.firstName + ' ' + ISNULL(e.middleName + ' ', '') + e.lastName AS StudentName,
    acc.amount                      AS AmountDue,
    acc.documentName,
    acc.status,
    acc.dateIssued,
    acc.description
FROM dbo.Accountabilities acc
INNER JOIN dbo.Accounts a ON acc.accountId = a.id
INNER JOIN dbo.Enrollees e ON a.enrolleeId = e.id
WHERE acc.status <> 'Resolved' OR acc.status IS NULL;
GO

-- ============================================================
-- 7. vw_CourseOfferings
-- ============================================================
CREATE VIEW dbo.vw_CourseOfferings
AS
SELECT
    c.courseName,
    c.totalYears,
    c.totalUnits,
    d.departmentName,
    d.description                   AS DepartmentDescription
FROM dbo.Courses c
INNER JOIN dbo.Departments d ON c.departmentId = d.id;
GO