CREATE PROCEDURE dbo.usp_SetEnrollment
    @AccountId   INT,
    @IsEnrolled  BIT          = 1,
    @SectionId   INT          = NULL,
    @SubjectId   INT          = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Optional: verify that SectionId and SubjectId are consistent
    IF @SectionId IS NOT NULL AND @SubjectId IS NULL
    BEGIN
        -- Automatically set subjectId from section if not provided
        SELECT @SubjectId = subjectId
        FROM dbo.Sections
        WHERE id = @SectionId;
    END;

    -- Verify section capacity (if trying to enroll)
    IF @IsEnrolled = 1 AND @SectionId IS NOT NULL
    BEGIN
        IF (SELECT slotsTaken FROM dbo.Sections WHERE id = @SectionId)
           >= (SELECT totalSlots FROM dbo.Sections WHERE id = @SectionId)
        BEGIN
            RAISERROR('Section is full.', 16, 1);
            RETURN;
        END;
    END;

    -- Update account enrollment
    UPDATE dbo.Accounts
    SET isEnrolled = @IsEnrolled,
        sectionId  = CASE WHEN @IsEnrolled = 1 THEN @SectionId ELSE NULL END,
        subjectId  = CASE WHEN @IsEnrolled = 1 THEN @SubjectId ELSE NULL END
    WHERE id = @AccountId;

    -- Increase slotsTaken if enrolling; decrease if unenrolling
    IF @IsEnrolled = 1 AND @SectionId IS NOT NULL
        UPDATE dbo.Sections SET slotsTaken = slotsTaken + 1 WHERE id = @SectionId;
    ELSE IF @IsEnrolled = 0
    BEGIN
        DECLARE @OldSection INT;
        SELECT @OldSection = sectionId FROM dbo.Accounts WHERE id = @AccountId;
        IF @OldSection IS NOT NULL
            UPDATE dbo.Sections SET slotsTaken = slotsTaken - 1 WHERE id = @OldSection;
    END;

    SELECT 'Enrollment updated.' AS Result;
END;