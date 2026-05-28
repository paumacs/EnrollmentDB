-- STORED PROCEDURE TO RESOLVE AN ACCOUNTABILITY AND UPDATE STATUS
CREATE PROCEDURE dbo.usp_ResolveAccountability
    @AccountabilityId INT,
    @ResolvedDate     DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Accountabilities WHERE id = @AccountabilityId)
    BEGIN
        RAISERROR('Accountability not found.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Accountabilities
    SET status        = 'Resolved',
        dateResolved  = ISNULL(@ResolvedDate, SYSUTCDATETIME())
    WHERE id = @AccountabilityId;

    -- Optionally remove the circular FK reference if it was the "primary" accountability
    UPDATE dbo.Accounts
    SET accountabilityId = NULL
    WHERE accountabilityId = @AccountabilityId;

    SELECT 'Accountability resolved.' AS Result;
END;