CREATE PROCEDURE dbo.usp_LinkDocument
    @AccountId  INT,
    @DocumentId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE id = @AccountId)
    BEGIN
        RAISERROR('Account not found.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Documents WHERE id = @DocumentId)
    BEGIN
        RAISERROR('Document not found.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Accounts
    SET documentId = @DocumentId
    WHERE id = @AccountId;

    SELECT 'Document linked successfully.' AS Result;
END;