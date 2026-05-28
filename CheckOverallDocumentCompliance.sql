CREATE FUNCTION dbo.fn_IsDocumentCompliant
(
    @AccountId INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Status VARCHAR(100), @Expiry DATE;

    SELECT @Status = d.status, @Expiry = d.expiryDate
    FROM dbo.Accounts a
    JOIN dbo.Documents d ON a.documentId = d.id
    WHERE a.id = @AccountId;

    IF @Status IS NULL
        RETURN 0;

    IF @Status IN ('Verified','Submitted')
       AND (@Expiry IS NULL OR @Expiry >= CAST(SYSDATETIME() AS DATE))
        RETURN 1;

    RETURN 0;
END;