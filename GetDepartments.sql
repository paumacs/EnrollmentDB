CREATE FUNCTION dbo.fn_GetDepartments()
RETURNS TABLE
AS
RETURN
(
    SELECT id, departmentId, departmentName, description
    FROM dbo.Departments
);