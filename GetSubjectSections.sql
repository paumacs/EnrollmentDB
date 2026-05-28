-- TABLE-VALUED FUNCTION TO GET SECTIONS FOR A GIVEN SUBJECT
CREATE FUNCTION dbo.fn_GetSubjectSections
(
    @SubjectId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        s.id             AS SectionId,
        s.sectionName,
        s.yearLevel,
        s.isBlockSection,
        s.totalSlots,
        s.slotsTaken,
        s.totalSlots - s.slotsTaken AS AvailableSlots,
        CASE WHEN s.slotsTaken < s.totalSlots THEN 'Open' ELSE 'Full' END AS Status
    FROM dbo.Sections s
    WHERE s.subjectId = @SubjectId
);