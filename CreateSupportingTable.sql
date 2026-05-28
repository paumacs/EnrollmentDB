-- SQL SCRIPT TO CREATE SUPPORTING TABLES FOR ENROLLMENT MODULE
CREATE TABLE StudentSubjectCompletions (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    enrolleeId     INT  NOT NULL,
    subjectId      INT  NOT NULL,
    completedDate  DATE NOT NULL,
    grade          VARCHAR(5)  NULL,
    status         VARCHAR(20) NOT NULL DEFAULT 'Passed',
    CONSTRAINT FK_Completions_Enrollees FOREIGN KEY (enrolleeId) REFERENCES Enrollees(id),
    CONSTRAINT FK_Completions_Subjects  FOREIGN KEY (subjectId)  REFERENCES Subjects(id)
);