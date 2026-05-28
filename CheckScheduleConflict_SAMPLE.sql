-- Before creating a new schedule, check for conflict
DECLARE @Conflict BIT;
SET @Conflict = dbo.fn_CheckScheduleConflict('Mon/Wed', '08:00', '09:30', 101, DEFAULT);

IF @Conflict = 0
    EXEC dbo.usp_ManageSchedule @Days='Mon/Wed', @TimeStart='08:00', @TimeEnd='09:30', @RoomNumber=101;
ELSE
    PRINT 'Time slot conflicts with an existing schedule.';