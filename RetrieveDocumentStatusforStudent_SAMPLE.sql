-- TABLE-VALUED FUNCTION TO RETRIEVE DOCUMENT STATUS FOR A STUDENT
-- All documents for account 5
SELECT * FROM dbo.fn_GetStudentDocuments(@AccountId = 5);

-- Documents for enrollee ID 12
SELECT * FROM dbo.fn_GetStudentDocuments(@EnrolleeId = 12);