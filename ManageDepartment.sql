CREATE PROCEDURE dbo.usp_ManageDepartment
    @DepartmentId   INT          = NULL OUTPUT,   -- NULL = insert; else update
    @DepartmentCode VARCHAR(30),                  -- unique departmentId
    @DepartmentName VARCHAR(100),
    @Description    VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @DepartmentId IS NULL
    BEGIN
        INSERT INTO dbo.Departments (departmentId, departmentName, description)
        VALUES (@DepartmentCode, @DepartmentName, @Description);
        SET @DepartmentId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.Departments
        SET departmentId   = @DepartmentCode,
            departmentName = @DepartmentName,
            description    = @Description
        WHERE id = @DepartmentId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Department not found.', 16, 1);
            RETURN;
        END;
    END;

    SELECT @DepartmentId AS DepartmentId;
END;