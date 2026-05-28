-- TABLE-VALUED FUNCTION TO CALCULATE OUTSTANDING BALANCE FOR AN ACCOUNT
CREATE FUNCTION dbo.fn_OutstandingBalance
(
    @AccountId INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Total FLOAT;

    SELECT @Total = ISNULL(SUM(amount), 0)
    FROM dbo.Accountabilities
    WHERE accountId = @AccountId
      AND (status <> 'Resolved' OR status IS NULL);

    RETURN @Total;
END;