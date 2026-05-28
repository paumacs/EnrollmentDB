CREATE FUNCTION dbo.fn_GetSubjectSchedule
(
    @SubjectId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        sub.id                      AS SubjectId,
        sub.subjectId               AS SubjectCode,
        sub.title                   AS SubjectTitle,
        s.id                        AS ScheduleId,
        s.days,
        s.timeStart,
        s.timeEnd,
        s.roomNumber
    FROM dbo.Subjects sub
    LEFT JOIN dbo.Schedules s ON sub.scheduleId = s.id
    WHERE sub.id = @SubjectId
);
