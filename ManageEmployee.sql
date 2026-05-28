-- STORED PROCEDURE TO MANAGE EMPLOYEE RECORDS (INSERT OR UPDATE)
CREATE PROCEDURE dbo.usp_ManageEmployee
    @EmployeeId       INT          = NULL OUTPUT,   -- NULL = insert; else update
    @EmployeeCode     VARCHAR(30),                  -- employeeId (unique user‑facing code)
    @EmployeeType     VARCHAR(30),
    @FirstName        VARCHAR(30),
    @MiddleName       VARCHAR(30)  = NULL,
    @LastName         VARCHAR(30),
    @Title            VARCHAR(100) = NULL,
    @DateHired        DATE         = NULL,
    @DateTerminated   DATE         = NULL,
    @Status           VARCHAR(50),
    @DepartmentId     INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate department
    IF NOT EXISTS (SELECT 1 FROM dbo.Departments WHERE id = @DepartmentId)
    BEGIN
        RAISERROR('Department not found.', 16, 1);
        RETURN;
    END;

    IF @EmployeeId IS NULL
    BEGIN
        -- Insert new employee
        INSERT INTO dbo.Employees (employeeId, employeeType, firstName, middleName, lastName,
                                   title, dateHired, dateTerminated, status, departmentId)
        VALUES (@EmployeeCode, @EmployeeType, @FirstName, @MiddleName, @LastName,
                @Title, @DateHired, @DateTerminated, @Status, @DepartmentId);
        SET @EmployeeId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        -- Update existing employee
        UPDATE dbo.Employees
        SET employeeId     = @EmployeeCode,
            employeeType   = @EmployeeType,
            firstName      = @FirstName,
            middleName     = @MiddleName,
            lastName       = @LastName,
            title          = @Title,
            dateHired      = @DateHired,
            dateTerminated = @DateTerminated,
            status         = @Status,
            departmentId   = @DepartmentId
        WHERE id = @EmployeeId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Employee not found.', 16, 1);
            RETURN;
        END;
    END;

    SELECT @EmployeeId AS EmployeeId;
END;