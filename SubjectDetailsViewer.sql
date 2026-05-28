CREATE FUNCTION dbo.fn_GetSubjectDetails
(
    @SubjectId INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        s.id            AS SubjectId,
        s.subjectId     AS SubjectCode,
        s.title         AS SubjectTitle,
        s.yearLevel,
        s.units,
        d.departmentName,
        p.subjectTitle  AS PrerequisiteTitle,
        p.units         AS PrerequisiteUnits,
        CASE WHEN p.id IS NULL THEN 'None' ELSE 'Required' END AS PrerequisiteType
    FROM dbo.Subjects s
    LEFT JOIN dbo.Prerequisites p ON s.prerequisiteId = p.id
    LEFT JOIN dbo.Departments d ON s.departmentId = d.id
    WHERE @SubjectId IS NULL OR s.id = @SubjectId
);