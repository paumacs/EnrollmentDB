-- TABLE-VALUED FUNCTION TO GET SECTIONS FOR A GIVEN DEPARTMENT
CREATE FUNCTION dbo.fn_GetDepartmentSections
(
    @DepartmentId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        s.id                 AS SectionId,
        s.sectionName,
        s.yearLevel,
        s.isBlockSection,
        s.totalSlots,
        s.slotsTaken,
        s.totalSlots - s.slotsTaken AS AvailableSlots,
        sub.title            AS SubjectTitle,
        sub.subjectId        AS SubjectCode,
        dep.departmentName
    FROM dbo.Sections s
    INNER JOIN dbo.Subjects sub ON s.subjectId = sub.id
    INNER JOIN dbo.Departments dep ON sub.departmentId = dep.id
    WHERE dep.id = @DepartmentId
);