CREATE PROCEDURE dbo.usp_ManageCourse
    @CourseId     INT          = NULL OUTPUT,   -- NULL = insert; else update
    @CourseName   VARCHAR(100),
    @TotalYears   INT,
    @TotalUnits   FLOAT,
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Departments WHERE id = @DepartmentId)
    BEGIN
        RAISERROR('Department not found.', 16, 1);
        RETURN;
    END;

    IF @TotalYears <= 0 OR @TotalUnits <= 0
    BEGIN
        RAISERROR('Total years and total units must be positive.', 16, 1);
        RETURN;
    END;

    IF @CourseId IS NULL
    BEGIN
        INSERT INTO dbo.Courses (courseName, totalYears, totalUnits, departmentId)
        VALUES (@CourseName, @TotalYears, @TotalUnits, @DepartmentId);
        SET @CourseId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.Courses
        SET courseName   = @CourseName,
            totalYears   = @TotalYears,
            totalUnits   = @TotalUnits,
            departmentId = @DepartmentId
        WHERE id = @CourseId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Course not found.', 16, 1);
            RETURN;
        END;
    END;

    SELECT @CourseId AS CourseId;
END;