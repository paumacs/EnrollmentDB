CREATE PROCEDURE dbo.usp_ManageSchedule
    @ScheduleId   INT          = NULL OUTPUT,  -- NULL = insert; else update
    @Days         VARCHAR(100),
    @TimeStart    TIME,
    @TimeEnd      TIME,
    @RoomNumber   INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @TimeStart >= @TimeEnd
    BEGIN
        RAISERROR('Start time must be before end time.', 16, 1);
        RETURN;
    END;

    IF @ScheduleId IS NULL
    BEGIN
        INSERT INTO dbo.Schedules (days, timeStart, timeEnd, roomNumber)
        VALUES (@Days, @TimeStart, @TimeEnd, @RoomNumber);
        SET @ScheduleId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.Schedules
        SET days       = @Days,
            timeStart  = @TimeStart,
            timeEnd    = @TimeEnd,
            roomNumber = @RoomNumber
        WHERE id = @ScheduleId;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Schedule not found.', 16, 1);
            RETURN;
        END;
    END;

    SELECT @ScheduleId AS ScheduleId;
END;