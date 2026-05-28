CREATE FUNCTION dbo.fn_GetCourseDetails
(
    @CourseId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.id, c.courseName, c.totalYears, c.totalUnits,
           d.departmentName, d.departmentId AS DepartmentCode
    FROM dbo.Courses c
    INNER JOIN dbo.Departments d ON c.departmentId = d.id
    WHERE c.id = @CourseId
);