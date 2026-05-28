-- STORED PROCEDURE TO TERMINATE AN EMPLOYEE
CREATE PROCEDURE dbo.usp_TerminateEmployee
    @EmployeeId      INT,
    @TerminationDate DATE = NULL,
    @Status          VARCHAR(50) = 'Terminated'
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Employees
    SET dateTerminated = ISNULL(@TerminationDate, CAST(SYSDATETIME() AS DATE)),
        status         = @Status
    WHERE id = @EmployeeId
      AND dateTerminated IS NULL;   -- only if not already terminated

    IF @@ROWCOUNT = 0
    BEGIN
        -- Either employee doesn't exist or is already terminated
        IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE id = @EmployeeId)
            RAISERROR('Employee not found.', 16, 1);
        ELSE
            RAISERROR('Employee is already terminated.', 16, 1);
        RETURN;
    END;

    SELECT 'Employee terminated.' AS Result;
END;