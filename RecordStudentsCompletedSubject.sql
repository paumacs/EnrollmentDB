CREATE PROCEDURE dbo.usp_RecordCompletion
    @EnrolleeId     INT,
    @SubjectId      INT,
    @CompletedDate  DATE,
    @Grade          VARCHAR(5) = NULL,
    @Status         VARCHAR(20) = 'Passed'
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.StudentSubjectCompletions (enrolleeId, subjectId, completedDate, grade, status)
    VALUES (@EnrolleeId, @SubjectId, @CompletedDate, @Grade, @Status);
    SELECT SCOPE_IDENTITY() AS CompletionId;
END;