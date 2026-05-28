-- TABLE-VALUED FUNCTION TO GET ACTIVE EMPLOYEES, WITH OPTIONAL DEPARTMENT FILTER
CREATE FUNCTION dbo.fn_GetActiveEmployees
(
    @DepartmentId INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.id                AS EmployeeId,
        e.employeeId        AS EmployeeCode,
        e.employeeType,
        e.firstName + ' ' + ISNULL(e.middleName + ' ', '') + e.lastName AS FullName,
        e.title,
        e.dateHired,
        e.status,
        d.departmentName
    FROM dbo.Employees e
    INNER JOIN dbo.Departments d ON e.departmentId = d.id
    WHERE e.dateTerminated IS NULL
      AND (@DepartmentId IS NULL OR e.departmentId = @DepartmentId)
);