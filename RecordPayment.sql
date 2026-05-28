-- STORED PROCEDURE TO RECORD A PAYMENT FOR AN ACCOUNT
CREATE PROCEDURE dbo.usp_RecordPayment
    @AccountId      INT,
    @Amount         FLOAT,
    @PaymentType    VARCHAR(100),     -- e.g., 'Tuition', 'Misc Fee', 'Document'
    @ModeOfPayment  VARCHAR(100) = NULL,
    @PaymentDate    DATETIME     = NULL,  -- defaults to current UTC
    @Status         VARCHAR(50)  = 'Completed'
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE id = @AccountId)
    BEGIN
        RAISERROR('Account not found.', 16, 1);
        RETURN;
    END;

    IF @Amount <= 0
    BEGIN
        RAISERROR('Payment amount must be greater than zero.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.Payments (amount, status, paymentType, paymentDate, modeOfPayment, accountId)
    VALUES (
        @Amount,
        @Status,
        @PaymentType,
        ISNULL(@PaymentDate, SYSUTCDATETIME()),
        @ModeOfPayment,
        @AccountId
    );

    SELECT SCOPE_IDENTITY() AS PaymentId, 'Payment recorded.' AS Result;
END;