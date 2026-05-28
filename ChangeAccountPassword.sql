-- STORED PROCEDURE TO CHANGE ACCOUNT PASSWORD
CREATE PROCEDURE dbo.usp_ChangeAccountPassword
    @AccountId  INT,            -- Accounts.id (PK)
    @OldPassword VARCHAR(50),
    @NewPassword VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM dbo.Accounts
        WHERE id = @AccountId AND password = @OldPassword
    )
    BEGIN
        RAISERROR('Incorrect current password or account not found.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Accounts
    SET password = @NewPassword
    WHERE id = @AccountId;

    SELECT 'Password changed successfully.' AS Result;
END;