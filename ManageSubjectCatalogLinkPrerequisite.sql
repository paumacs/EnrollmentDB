-- STORED PROCEDURE TO MANAGE SUBJECT CATALOG (INSERT OR UPDATE)
CREATE PROCEDURE dbo.usp_ManageSubject
    @SubjectId       INT = NULL OUTPUT,  -- NULL = insert; else update
    @SubjectCode     VARCHAR(30),
    @Title           VARCHAR(100),
    @YearLevel       INT,
    @Units           FLOAT,
    @ProfessorId     INT = NULL,
    @ScheduleId      INT = NULL,
    @PrerequisiteId  INT = NULL,   -- references Prerequisites.id
    @DepartmentId    INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @SubjectId IS NULL
    BEGIN
        INSERT INTO dbo.Subjects (subjectId, title, yearLevel, units, professorId, scheduleId, prerequisiteId, departmentId)
        VALUES (@SubjectCode, @Title, @YearLevel, @Units, @ProfessorId, @ScheduleId, @PrerequisiteId, @DepartmentId);
        SET @SubjectId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE dbo.Subjects
        SET subjectId      = @SubjectCode,
            title          = @Title,
            yearLevel      = @YearLevel,
            units          = @Units,
            professorId    = @ProfessorId,
            scheduleId     = @ScheduleId,
            prerequisiteId = @PrerequisiteId,
            departmentId   = @DepartmentId
        WHERE id = @SubjectId;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Subject not found.', 16, 1);
            RETURN;
        END;
    END;
    SELECT @SubjectId AS SubjectId;
END;
