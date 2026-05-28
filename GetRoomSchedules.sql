CREATE FUNCTION dbo.fn_GetRoomSchedules
(
    @RoomNumber INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        s.id            AS ScheduleId,
        s.days,
        s.timeStart,
        s.timeEnd,
        s.roomNumber,
        sub.title       AS SubjectTitle,
        sub.subjectId   AS SubjectCode
    FROM dbo.Schedules s
    LEFT JOIN dbo.Subjects sub ON sub.scheduleId = s.id
    WHERE s.roomNumber = @RoomNumber
);