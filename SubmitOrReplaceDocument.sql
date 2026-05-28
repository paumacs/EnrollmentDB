-- STORED PROCEDURE TO SUBMIT OR REPLACE A DOCUMENT FOR AN ACCOUNT
CREATE PROCEDURE dbo.usp_SubmitDocument
    @AccountId    INT,
    @DocumentId   VARCHAR(50),        -- unique document code (e.g., BC-2026-001)
    @DocumentName VARCHAR(250),
    @IssuedBy     VARCHAR(250) = NULL,
    @Status       VARCHAR(100) = 'Submitted',
    @ExpiryDate   DATE         = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Validate account exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE id = @AccountId)
    BEGIN
        RAISERROR('Account not found.', 16, 1);
        RETURN;
    END;

    -- 2. Ensure document record exists (upsert)
    DECLARE @DocId INT;
    SELECT @DocId = id FROM dbo.Documents WHERE documentId = @DocumentId;

    IF @DocId IS NULL
    BEGIN
        INSERT INTO dbo.Documents (documentId, documentName, issuedBy, status, expiryDate)
        VALUES (@DocumentId, @DocumentName, @IssuedBy, @Status, @ExpiryDate);
        SET @DocId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        -- Update existing document details if needed
        UPDATE dbo.Documents
        SET documentName = @DocumentName,
            issuedBy     = @IssuedBy,
            status       = @Status,
            expiryDate   = @ExpiryDate
        WHERE id = @DocId;
    END;

    -- 3. Link document to the account
    UPDATE dbo.Accounts
    SET documentId = @DocId
    WHERE id = @AccountId;

    SELECT 'Document linked successfully.' AS Result,
           @DocId AS DocumentId,
           @DocumentId AS DocumentCode;
END;