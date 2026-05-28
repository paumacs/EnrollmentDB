CREATE FUNCTION dbo.fn_CheckScheduleConflict
(
    @Days         VARCHAR(100),
    @TimeStart    TIME,
    @TimeEnd      TIME,
    @RoomNumber   INT,
    @ExcludeScheduleId INT = NULL   -- for updates: ignore the current record
)
RETURNS BIT
AS
BEGIN
    DECLARE @Conflict BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM dbo.Schedules s
        WHERE s.roomNumber = @RoomNumber
          AND (@ExcludeScheduleId IS NULL OR s.id <> @ExcludeScheduleId)
          AND dbo.fn_DaysOverlap(s.days, @Days) = 1
          AND s.timeStart < @TimeEnd
          AND s.timeEnd   > @TimeStart
    )
        SET @Conflict = 1;

    RETURN @Conflict;
END;