CREATE FUNCTION dbo.fn_IsPrerequisiteMet
(
    @EnrolleeId INT,
    @SubjectId  INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @PrereqTitle VARCHAR(100), @Result BIT = 0;

    -- 1. Get prerequisite title (if any)
    SELECT @PrereqTitle = p.subjectTitle
    FROM dbo.Subjects s
    JOIN dbo.Prerequisites p ON s.prerequisiteId = p.id
    WHERE s.id = @SubjectId;

    -- No prerequisite required → automatically met
    IF @PrereqTitle IS NULL
        RETURN 1;

    -- 2. Check if student has completed a subject whose title matches the prerequisite title
    IF EXISTS (
        SELECT 1
        FROM dbo.StudentSubjectCompletions c
        JOIN dbo.Subjects sub ON c.subjectId = sub.id
        WHERE c.enrolleeId = @EnrolleeId
          AND sub.title = @PrereqTitle
          AND c.status = 'Passed'
    )
        SET @Result = 1;
    ELSE
        SET @Result = 0;

    RETURN @Result;
END;