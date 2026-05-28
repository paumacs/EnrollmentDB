-- TABLE-VALUED FUNCTION TO GET ALL SECTIONS WITH AVAILABLE SLOTS AND RELATED INFO
CREATE FUNCTION dbo.fn_GetAllSections
( )
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
        dep.departmentName
    FROM dbo.Sections s
    INNER JOIN dbo.Subjects sub ON s.subjectId = sub.id
    INNER JOIN dbo.Departments dep ON sub.departmentId = dep.id
);