-- ============================================================
-- 0. PREPARATION : ensure prerequisite-check sample is ready
-- ============================================================
-- Carlos Mendoza (enrollee 1) completed CS101, enabling CS201 later
INSERT INTO dbo.StudentSubjectCompletions (enrolleeId, subjectId, completedDate, status)
VALUES (1, 1, '2025-06-01', 'Passed');
GO

-- ============================================================
-- 1. Show an existing department and its courses
-- ============================================================
PRINT '=== 1. Department & Courses ===';
SELECT * FROM dbo.Departments WHERE id = 1;
SELECT * FROM dbo.fn_GetDepartmentCourses(1);
GO

-- ============================================================
-- 2. Academic Years → Sections (capacity)
-- ============================================================
PRINT '=== 2. Academic Years & Section Capacity ===';
SELECT * FROM dbo.AcademicYears;

-- Show a specific section with all details
SELECT
    s.sectionName,
    sub.title         AS SubjectTitle,
    d.departmentName,
    s.totalSlots,
    s.slotsTaken,
    s.totalSlots - s.slotsTaken AS RemainingSlots
FROM dbo.Sections s
JOIN dbo.Subjects sub ON s.subjectId = sub.id
JOIN dbo.Departments d ON sub.departmentId = d.id
WHERE s.id = 1;  -- CS101-A
GO

-- ============================================================
-- 3. Subjects & Prerequisites
-- ============================================================
PRINT '=== 3. Subject List & Prerequisites ===';
SELECT * FROM dbo.vw_SubjectPrerequisites;

-- Highlight CS201 (subject id 2) which requires CS101
PRINT 'CS201 requires:';
SELECT pr.subjectTitle AS PrerequisiteName
FROM dbo.Subjects s
JOIN dbo.Prerequisites pr ON s.prerequisiteId = pr.id
WHERE s.id = 2;

-- Check prerequisite for Carlos (enrollee 1) trying to enrol in CS201
SELECT dbo.fn_IsPrerequisiteMet(1, 2) AS PrerequisiteMet;   -- should return 1
GO

-- ============================================================
-- 4. Faculty Profile
-- ============================================================
PRINT '=== 4. Faculty Profile ===';
SELECT * FROM dbo.vw_EmployeeDirectory WHERE employeeId = 'EMP-001';
-- Show which subject he teaches
SELECT sub.title AS AssignedSubject
FROM dbo.Subjects sub
WHERE sub.professorId = 1;
GO

-- ============================================================
-- 5. Create / Open a Student Record
-- ============================================================
PRINT '=== 5. New Enrollee ===';
DECLARE @NewEnrollee INT;
EXEC dbo.usp_ManageEnrolleeAccount
    @EnrolleeId  = @NewEnrollee OUTPUT,
    @FirstName   = 'Demo',
    @MiddleName  = 'X',
    @LastName    = 'Student',
    @Email       = 'demo.student@school.edu',
    @StudentType = 'New',
    @Address     = '123 Demo Lane',
    @Age         = 19,
    @BirthDate   = '2007-03-15',
    @AccountId   = 'ACC-DEMO-001',
    @Password    = 'demo123',
    @AccountStatus = 'Active';

SELECT 'New enrollee ID: ' + CAST(@NewEnrollee AS VARCHAR) AS Message;
SELECT * FROM dbo.Enrollees WHERE id = @NewEnrollee;
GO

-- ============================================================
-- 6. Documents
-- ============================================================
PRINT '=== 6. Document Linking & Verification ===';
-- Use the new account (assume it was id 21, but we'll capture dynamically)
DECLARE @NewAccountId INT, @NewEnrolleeId INT;
SELECT @NewEnrolleeId = id FROM dbo.Enrollees WHERE email = 'demo.student@school.edu';
SELECT @NewAccountId = id FROM dbo.Accounts WHERE enrolleeId = @NewEnrolleeId;

-- Link the existing Birth Certificate document (id=1) to this account
EXEC dbo.usp_SubmitDocument
    @AccountId    = @NewAccountId,
    @DocumentId   = 'DOC-BC',       -- existing document code
    @DocumentName = 'Birth Certificate',
    @IssuedBy     = 'PSA',
    @Status       = 'Submitted',
    @ExpiryDate   = NULL;

-- Show the linked document
SELECT * FROM dbo.fn_GetStudentDocuments(@AccountId = @NewAccountId);

-- Simulate verification
UPDATE dbo.Documents
SET status = 'Verified'
WHERE documentId = 'DOC-BC';
SELECT * FROM dbo.fn_GetStudentDocuments(@AccountId = @NewAccountId);
GO

-- ============================================================
-- 7. Account & Enrollment
-- ============================================================
PRINT '=== 7. Account & Enrollment ===';
DECLARE @NewEnrolleeId INT, @NewAccountId INT;
SELECT @NewEnrolleeId = id FROM dbo.Enrollees WHERE email = 'demo.student@school.edu';
SELECT @NewAccountId = id FROM dbo.Accounts WHERE enrolleeId = @NewEnrolleeId;

-- Show current state (should be isEnrolled = 0)
SELECT * FROM dbo.fn_EnrolleeManagement(@NewEnrolleeId);

-- Enrol into section CS101-A (id=1) – no prerequisite required for CS101
EXEC dbo.usp_SetEnrollment
    @AccountId  = @NewAccountId,
    @IsEnrolled = 1,
    @SectionId  = 1,     -- CS101-A
    @SubjectId  = 1;     -- CS101

-- Show the updated enrollment record
SELECT * FROM dbo.fn_EnrolleeManagement(@NewEnrolleeId);
-- Also check section capacity change
SELECT * FROM dbo.vw_SectionCapacity WHERE sectionName = 'CS101-A';
GO

-- ============================================================
-- 8. Record a Payment
-- ============================================================
PRINT '=== 8. Payment ===';
DECLARE @NewAccountId INT;
SELECT @NewAccountId = id FROM dbo.Accounts WHERE accountId = 'ACC-DEMO-001';

EXEC dbo.usp_RecordPayment
    @AccountId     = @NewAccountId,
    @Amount        = 1500.00,
    @PaymentType   = 'Tuition',
    @ModeOfPayment = 'Online',
    @PaymentDate   = GETDATE(),
    @Status        = 'Completed';

-- Show payment summary for the student
SELECT * FROM dbo.vw_PaymentSummary WHERE AccountId = @NewAccountId;
GO

-- ============================================================
-- 9. Accountabilities
-- ============================================================
PRINT '=== 9. Accountabilities ===';
DECLARE @NewAccountId INT;
SELECT @NewAccountId = id FROM dbo.Accounts WHERE accountId = 'ACC-DEMO-001';

-- Add an accountability (unpaid tuition balance)
EXEC dbo.usp_AddAccountability
    @AccountId    = @NewAccountId,
    @Amount       = 2000.00,
    @DocumentName = 'Tuition Fee',
    @Status       = 'Unpaid',
    @Description  = 'Remaining balance for semester';

-- Show open accountabilities
SELECT * FROM dbo.fn_GetOpenAccountabilities(@NewAccountId);

-- Resolve the accountability (e.g., after payment)
DECLARE @AccId INT;
SELECT TOP 1 @AccId = id FROM dbo.Accountabilities WHERE accountId = @NewAccountId AND status = 'Unpaid';
EXEC dbo.usp_ResolveAccountability @AccountabilityId = @AccId;

-- Confirm it is resolved
SELECT * FROM dbo.Accountabilities WHERE id = @AccId;
GO

-- ============================================================
-- 10. (BONUS) Show the Audit Log for enrollment changes
-- ============================================================
PRINT '=== Audit Log ===';
SELECT * FROM dbo.EnrollmentAuditLog ORDER BY ChangeDate DESC;
GO