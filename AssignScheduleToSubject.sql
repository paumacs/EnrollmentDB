CREATE PROCEDURE dbo.usp_AssignScheduleToSubject
    @SubjectId   INT,
    @ScheduleId  INT = NULL   -- NULL = remove schedule
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Subjects WHERE id = @SubjectId)
    BEGIN
        RAISERROR('Subject not found.', 16, 1);
        RETURN;
    END;

    IF @ScheduleId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Schedules WHERE id = @ScheduleId)
    BEGIN
        RAISERROR('Schedule not found.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.Subjects
    SET scheduleId = @ScheduleId
    WHERE id = @SubjectId;

    SELECT CASE WHEN @ScheduleId IS NULL THEN 'Schedule removed.' ELSE 'Schedule assigned.' END AS Result;
END;