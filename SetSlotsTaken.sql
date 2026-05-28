-- !!ADMIN PURPOSES ONLY!!
-- STORED PROCEDURE TO MANUALLY SET SLOTS TAKEN FOR A SECTION
CREATE PROCEDURE dbo.usp_SetSlotsTaken
    @SectionId INT,
    @SlotsTaken INT           -- absolute value
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Total INT;

    SELECT @Total = totalSlots FROM dbo.Sections WHERE id = @SectionId;

    IF @Total IS NULL
    BEGIN
        RAISERROR('Section not found.', 16, 1);
        RETURN;
    END;

    IF @SlotsTaken > @Total
    BEGIN
        RAISERROR('Slots taken cannot exceed total slots.', 16, 1);
        RETURN;
    END;

    IF @SlotsTaken < 0
    BEGIN
        RAISERROR('Slots taken cannot be negative.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Sections
    SET slotsTaken = @SlotsTaken
    WHERE id = @SectionId;

    SELECT 'SlotsTaken updated.' AS Result;
END;