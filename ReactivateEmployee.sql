-- STORED PROCEDURE TO REACTIVATE AN EMPLOYEE (SET dateTerminated TO NULL AND UPDATE STATUS)
CREATE PROCEDURE dbo.usp_ReactivateEmployee
    @EmployeeId INT,
    @Status     VARCHAR(50) = 'Active'
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Employees
    SET dateTerminated = NULL,
        status         = @Status
    WHERE id = @EmployeeId
      AND dateTerminated IS NOT NULL;

    IF @@ROWCOUNT = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE id = @EmployeeId)
            RAISERROR('Employee not found.', 16, 1);
        ELSE
            RAISERROR('Employee is already active.', 16, 1);
        RETURN;
    END;

    SELECT 'Employee reactivated.' AS Result;
END;