CREATE FUNCTION dbo.fn_IsSectionAvailable
(
    @SectionId INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM dbo.Sections
        WHERE id = @SectionId
          AND slotsTaken < totalSlots
    )
        SET @Result = 1;

    RETURN @Result;
END;