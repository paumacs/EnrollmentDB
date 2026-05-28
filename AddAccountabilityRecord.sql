CREATE PROCEDURE dbo.usp_AddAccountability
    @AccountId    INT,
    @Amount       FLOAT,
    @DocumentName VARCHAR(250) = NULL,
    @Status       VARCHAR(50)  = 'Unpaid',
    @Description  VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE id = @AccountId)
    BEGIN
        RAISERROR('Account not found.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.Accountabilities
        (amount, documentName, status, dateIssued, description, accountId)
    VALUES
        (@Amount, @DocumentName, @Status, SYSUTCDATETIME(), @Description, @AccountId);

    -- Update the circular FK (accountabilityId) in Accounts if you want to track the "primary" accountability
    DECLARE @NewAccId INT = SCOPE_IDENTITY();
    UPDATE dbo.Accounts
    SET accountabilityId = @NewAccId
    WHERE id = @AccountId;

    SELECT 'Accountability added.' AS Result;
END;