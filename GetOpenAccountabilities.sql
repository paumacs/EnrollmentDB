-- TABLE-VALUED FUNCTION TO GET OPEN ACCOUNTABILITIES FOR AN ACCOUNT (OR ALL IF NULL)
CREATE FUNCTION dbo.fn_GetOpenAccountabilities
(
    @AccountId INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        acc.id          AS AccountabilityId,
        acc.amount,
        acc.documentName,
        acc.status,
        acc.dateIssued,
        acc.description,
        a.accountId     AS AccountCode,
        e.firstName + ' ' + ISNULL(e.middleName+' ','') + e.lastName AS StudentName
    FROM dbo.Accountabilities acc
    INNER JOIN dbo.Accounts a ON acc.accountId = a.id
    INNER JOIN dbo.Enrollees e ON a.enrolleeId = e.id
    WHERE acc.status <> 'Resolved'
      AND (@AccountId IS NULL OR acc.accountId = @AccountId)
);