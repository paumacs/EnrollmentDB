-- TABLE-VALUED FUNCTION TO CALCULATE TOTAL PAYMENTS MADE FOR AN ACCOUNT
CREATE FUNCTION dbo.fn_TotalPayments
(
    @AccountId INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Total FLOAT;
    SELECT @Total = ISNULL(SUM(amount), 0)
    FROM dbo.Payments
    WHERE accountId = @AccountId AND status = 'Completed';
    RETURN @Total;
END;