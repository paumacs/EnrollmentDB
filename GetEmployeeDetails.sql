-- TABLE-VALUED FUNCTION TO GET EMPLOYEE DETAILS BY EMPLOYEE ID
CREATE FUNCTION dbo.fn_GetEmployeeDetails
(
    @EmployeeId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.id                AS EmployeeId,
        e.employeeId        AS EmployeeCode,
        e.employeeType,
        e.firstName,
        e.middleName,
        e.lastName,
        e.title,
        e.dateHired,
        e.dateTerminated,
        e.status,
        d.departmentName
    FROM dbo.Employees e
    INNER JOIN dbo.Departments d ON e.departmentId = d.id
    WHERE e.id = @EmployeeId
);