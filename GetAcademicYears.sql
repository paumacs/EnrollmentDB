CREATE FUNCTION dbo.fn_GetAcademicYears()
RETURNS TABLE
AS
RETURN
(
    SELECT id, yearLevel, totalYears
    FROM dbo.AcademicYears
);