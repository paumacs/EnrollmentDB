CREATE PROCEDURE dbo.usp_ManageSection
    @SectionId      INT          = NULL OUTPUT,   -- NULL = insert; else update
    @SectionName    VARCHAR(100),
    @YearLevel      INT,
    @IsBlockSection BIT,
    @TotalSlots     INT,
    @SubjectId      INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @TotalSlots < 0
    BEGIN
        RAISERROR('Total slots cannot be negative.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Subjects WHERE id = @SubjectId)
    BEGIN
        RAISERROR('Subject not found.', 16, 1);
        RETURN;
    END;

    IF @SectionId IS NULL
    BEGIN
        INSERT INTO dbo.Sections (sectionName, yearLevel, isBlockSection, totalSlots, slotsTaken, subjectId)
        VALUES (@SectionName, @YearLevel, @IsBlockSection, @TotalSlots, 0, @SubjectId);
        SET @SectionId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        -- Don't allow reducing totalSlots below current slotsTaken
        DECLARE @CurrentTaken INT;
        SELECT @CurrentTaken = slotsTaken FROM dbo.Sections WHERE id = @SectionId;
        IF @TotalSlots < @CurrentTaken
        BEGIN
            RAISERROR('New total slots cannot be less than currently taken slots.', 16, 1);
            RETURN;
        END;

        UPDATE dbo.Sections
        SET sectionName    = @SectionName,
            yearLevel      = @YearLevel,
            isBlockSection = @IsBlockSection,
            totalSlots     = @TotalSlots,
            subjectId      = @SubjectId
        WHERE id = @SectionId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Section not found.', 16, 1);
            RETURN;
        END;
    END;

    SELECT @SectionId AS SectionId;
END;