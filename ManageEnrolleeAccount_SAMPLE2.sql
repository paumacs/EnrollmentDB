-- SAMPLE UPDATE (change student type and address for the same enrollee)
EXEC dbo.usp_ManageEnrolleeAccount
    @EnrolleeId  = 5,
    @FirstName   = 'Maria',
    @MiddleName  = 'Santos',
    @LastName    = 'Dela Cruz',
    @Email       = 'maria.delacruz@university.edu.ph',
    @StudentType = 'Continuing',
    @Address     = '456 Rizal Ave.',
    @Age         = 20,
    @BirthDate   = '2007-04-12',
    @AccountId   = 'STU-2026-0042',   -- will be ignored if account already exists
    @Password    = 'TempPass123',
    @AccountStatus = 'Active';