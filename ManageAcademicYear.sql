CREATE PROCEDURE dbo.usp_ManageAcademicYear
    @AcademicYearId INT = NULL OUTPUT,   -- NULL = insert; else update
    @YearLevel      INT,
    @TotalYears     INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @YearLevel <= 0 OR @TotalYears <= 0
    BEGIN
        RAISERROR('Year level and total years must be positive.', 16, 1);
        RETURN;
    END;

    IF @AcademicYearId IS NULL
    BEGIN
        INSERT INTO dbo.AcademicYears (yearLevel, totalYears)
        VALUES (@YearLevel, @TotalYears);
        SET @AcademicYearId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.AcademicYears
        SET yearLevel  = @YearLevel,
            totalYears = @TotalYears
        WHERE id = @AcademicYearId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Academic year record not found.', 16, 1);
            RETURN;
        END;
    END;

    SELECT @AcademicYearId AS AcademicYearId;
END;