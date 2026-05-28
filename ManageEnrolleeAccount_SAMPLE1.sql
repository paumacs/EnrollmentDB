-- SAMPLE EXECUTION
DECLARE @NewId INT;
EXEC dbo.usp_ManageEnrolleeAccount
    @EnrolleeId  = @NewId OUTPUT,
    @FirstName   = 'Maria',
    @MiddleName  = 'Santos',
    @LastName    = 'Dela Cruz',
    @Email       = 'maria.delacruz@university.edu',
    @StudentType = 'New',
    @Address     = '123 Mabini St.',
    @Age         = 19,
    @BirthDate   = '2007-04-12',
    @AccountId   = 'STU-2026-0042',
    @Password    = 'TempPass123',
    @AccountStatus = 'Active';

SELECT @NewId AS NewEnrolleeId;