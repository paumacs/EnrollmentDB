CREATE FUNCTION dbo.fn_GetDepartmentCourses
(
    @DepartmentId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.id, c.courseName, c.totalYears, c.totalUnits,
           d.departmentName
    FROM dbo.Courses c
    INNER JOIN dbo.Departments d ON c.departmentId = d.id
    WHERE c.departmentId = @DepartmentId
);