-- STORED PROCEDURE TO UPDATE DOCUMENT STATUS AND/OR EXPIRY DATE
CREATE PROCEDURE dbo.usp_UpdateDocumentStatus
    @AccountId    INT,
    @NewStatus    VARCHAR(100) = NULL,
    @NewExpiry    DATE         = NULL,
    @DocumentCode VARCHAR(50)  = NULL   -- optional, if multiple docs need specific targeting
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DocId INT;

    -- If document code is provided, use it; otherwise use the account's linked document
    IF @DocumentCode IS NOT NULL
        SELECT @DocId = id FROM dbo.Documents WHERE documentId = @DocumentCode;
    ELSE
        SELECT @DocId = documentId FROM dbo.Accounts WHERE id = @AccountId;

    IF @DocId IS NULL
    BEGIN
        RAISERROR('No document found for this account.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Documents
    SET status     = ISNULL(@NewStatus, status),
        expiryDate = ISNULL(@NewExpiry, expiryDate)
    WHERE id = @DocId;

    SELECT 'Document updated.' AS Result;
END;