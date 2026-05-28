CREATE TABLE Departments (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    departmentId   VARCHAR(30)  NOT NULL UNIQUE,
    departmentName VARCHAR(100) NOT NULL,
    description    VARCHAR(250) NULL
);
-- COURSES
CREATE TABLE Courses (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    courseName   VARCHAR(100) NOT NULL,
    totalYears   INT          NOT NULL,
    totalUnits   FLOAT        NOT NULL,
    departmentId INT          NOT NULL,
    CONSTRAINT FK_Courses_Departments
        FOREIGN KEY (departmentId) REFERENCES Departments(id)
);
-- ACADEMICYEARS
CREATE TABLE AcademicYears (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    yearLevel  INT NOT NULL,
    totalYears INT NOT NULL
);
-- EMPLOYEES
CREATE TABLE Employees (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    employeeId     VARCHAR(30)  NOT NULL UNIQUE,
    employeeType   VARCHAR(30)  NOT NULL,
    firstName      VARCHAR(30)  NOT NULL,
    middleName     VARCHAR(30)  NULL,
    lastName       VARCHAR(30)  NOT NULL,
    title          VARCHAR(100) NULL,
    dateHired      DATE         NULL,
    dateTerminated DATE         NULL,
    status         VARCHAR(50)  NOT NULL,
    departmentId   INT          NOT NULL,
    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (departmentId) REFERENCES Departments(id)
);
-- ENROLLEES (students/applicants)
CREATE TABLE Enrollees (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    firstName   VARCHAR(30)  NOT NULL,
    middleName  VARCHAR(30)  NULL,
    lastName    VARCHAR(30)  NOT NULL,
    email       VARCHAR(250) NOT NULL,
    studentType VARCHAR(30)  NOT NULL,
    address     VARCHAR(250) NULL,
    age         INT          NULL,
    birthDate   DATE         NULL
);
-- DOCUMENTS (reference library of document types/records)
CREATE TABLE Documents (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    documentId   VARCHAR(50)  NOT NULL UNIQUE,
    documentName VARCHAR(250) NOT NULL,
    issuedBy     VARCHAR(250) NULL,
    status       VARCHAR(100) NULL,
    expiryDate   DATE         NULL
);
-- SCHEDULES (time slots / rooms)
CREATE TABLE Schedules (
    id        INT IDENTITY(1,1) PRIMARY KEY,
    days      VARCHAR(100) NOT NULL, -- e.g., "Mon/Wed"
    timeStart TIME         NOT NULL,
    timeEnd   TIME         NOT NULL,
    roomNumber INT         NOT NULL
);
-- PREREQUISITES (catalog of prereq subjects)
CREATE TABLE Prerequisites (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    subjectTitle VARCHAR(100) NOT NULL,
    units        FLOAT        NOT NULL
);
-- SUBJECTS (class catalog)
CREATE TABLE Subjects (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    subjectId       VARCHAR(30)  NOT NULL UNIQUE,
    title           VARCHAR(100) NOT NULL,
    yearLevel       INT          NOT NULL,
    units           FLOAT        NOT NULL,
    professorId     INT          NULL, -- references Employees
    scheduleId      INT          NULL, -- references Schedules
    prerequisiteId  INT          NULL, -- references Prerequisites
    departmentId    INT          NOT NULL,
    CONSTRAINT FK_Subjects_Professor
        FOREIGN KEY (professorId) REFERENCES Employees(id),
    CONSTRAINT FK_Subjects_Schedule
        FOREIGN KEY (scheduleId) REFERENCES Schedules(id),
    CONSTRAINT FK_Subjects_Prerequisite
        FOREIGN KEY (prerequisiteId) REFERENCES Prerequisites(id),
    CONSTRAINT FK_Subjects_Departments
        FOREIGN KEY (departmentId) REFERENCES Departments(id)
);
-- SECTIONS (offerings of subjects)
CREATE TABLE Sections (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    sectionName    VARCHAR(100) NOT NULL,
    yearLevel      INT          NOT NULL,
    isBlockSection BIT          NOT NULL DEFAULT(0),
    totalSlots     INT          NOT NULL,
    slotsTaken     INT          NOT NULL DEFAULT(0),
    subjectId      INT          NOT NULL,
    CONSTRAINT FK_Sections_Subjects
        FOREIGN KEY (subjectId) REFERENCES Subjects(id)
);
-- ACCOUNTS (student accounts for enrollment)
CREATE TABLE Accounts (
    id               INT IDENTITY(1,1) PRIMARY KEY,
    accountId        VARCHAR(30)  NOT NULL UNIQUE,
    password         VARCHAR(50)  NOT NULL,
    status           VARCHAR(30)  NOT NULL,
    enrolleeId       INT          NOT NULL,
    accountabilityId INT          NULL,
    documentId       INT          NULL,
    isEnrolled       BIT          NOT NULL DEFAULT(0),
    sectionId        INT          NULL,
    subjectId        INT          NULL,
    CONSTRAINT FK_Accounts_Enrollees
        FOREIGN KEY (enrolleeId) REFERENCES Enrollees(id),
    CONSTRAINT FK_Accounts_Documents
        FOREIGN KEY (documentId) REFERENCES Documents(id),
    CONSTRAINT FK_Accounts_Sections
        FOREIGN KEY (sectionId) REFERENCES Sections(id),
    CONSTRAINT FK_Accounts_Subjects
        FOREIGN KEY (subjectId) REFERENCES Subjects(id)
    -- accountabilityId will reference Accountabilities after that table exists
);
-- ACCOUNTABILITIES (fees/dues tied to an account)
CREATE TABLE Accountabilities (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    amount         FLOAT        NOT NULL,
    documentName   VARCHAR(250) NULL,
    status         VARCHAR(50)  NOT NULL,
    dateIssued     DATETIME     NULL,
    dateResolved   DATETIME     NULL,
    description    VARCHAR(250) NULL,
    accountId      INT          NOT NULL,
    CONSTRAINT FK_Accountabilities_Accounts
        FOREIGN KEY (accountId) REFERENCES Accounts(id)
);
-- Backfill the circular FK (Accounts.accountabilityId -> Accountabilities.id)
ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Accountabilities
    FOREIGN KEY (accountabilityId) REFERENCES Accountabilities(id);
-- PAYMENTS
CREATE TABLE Payments (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    amount         FLOAT        NOT NULL,
    status         VARCHAR(50)  NOT NULL,
    paymentType    VARCHAR(100) NOT NULL,
    paymentDate    DATETIME     NOT NULL DEFAULT (SYSUTCDATETIME()),
    modeOfPayment  VARCHAR(100) NULL,
    accountId      INT          NOT NULL,
    CONSTRAINT FK_Payments_Accounts
        FOREIGN KEY (accountId) REFERENCES Accounts(id)
);
