--!! fn_IsDocumentCompliant must be created before this function as it is called within this function
-- FUNCTION TO CHECK IF AN ACCOUNT IS FULLY CLEARED (BALANCE ZERO AND DOCUMENTS COMPLIANT)
CREATE FUNCTION dbo.fn_IsAccountCleared
(
    @AccountId INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Balance FLOAT, @DocCompliant BIT;

    SET @Balance = dbo.fn_OutstandingBalance(@AccountId);
    SET @DocCompliant = dbo.fn_IsDocumentCompliant(@AccountId);

    IF @Balance = 0 AND @DocCompliant = 1
        RETURN 1;
    RETURN 0;
END;