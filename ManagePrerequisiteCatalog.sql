-- STORED PROCEDURE TO MANAGE PREREQUISITE CATALOG (INSERT OR UPDATE)
CREATE PROCEDURE dbo.usp_ManagePrerequisite
    @PrerequisiteId INT = NULL OUTPUT,   -- NULL = insert; else update
    @SubjectTitle   VARCHAR(100),
    @Units          FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PrerequisiteId IS NULL
    BEGIN
        INSERT INTO dbo.Prerequisites (subjectTitle, units)
        VALUES (@SubjectTitle, @Units);
        SET @PrerequisiteId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.Prerequisites
        SET subjectTitle = @SubjectTitle,
            units        = @Units
        WHERE id = @PrerequisiteId;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Prerequisite not found.', 16, 1);
            RETURN;
        END;
    END;
    SELECT @PrerequisiteId AS PrerequisiteId;
END;