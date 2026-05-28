-- TABLE-VALUED FUNCTION TO RETRIEVE DOCUMENT STATUS FOR A STUDENT
CREATE FUNCTION dbo.fn_GetStudentDocuments
(
    @AccountId  INT = NULL,
    @EnrolleeId INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        a.id                    AS AccountId,
        a.accountId             AS AccountCode,
        e.firstName + ' ' + ISNULL(e.middleName+' ','') + e.lastName AS StudentName,
        doc.documentId          AS DocumentCode,
        doc.documentName        AS DocumentType,
        doc.issuedBy,
        doc.status,
        doc.expiryDate,
        CASE
            WHEN doc.expiryDate IS NOT NULL AND doc.expiryDate < CAST(SYSDATETIME() AS DATE)
                THEN 'Expired'
            ELSE 'Valid'
        END AS Validity
    FROM dbo.Accounts a
    INNER JOIN dbo.Enrollees e ON a.enrolleeId = e.id
    LEFT JOIN dbo.Documents doc ON a.documentId = doc.id
    WHERE (@AccountId IS NULL OR a.id = @AccountId)
      AND (@EnrolleeId IS NULL OR e.id = @EnrolleeId)
);