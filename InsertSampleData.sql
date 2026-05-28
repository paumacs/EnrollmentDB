-- ============================================================
-- 1. DEPARTMENTS (3 rows)
-- ============================================================
SET IDENTITY_INSERT Departments ON;
INSERT INTO Departments (id, departmentId, departmentName, description) VALUES
(1, 'DEPT-CS', 'Computer Science', 'Department of Computer Science and IT'),
(2, 'DEPT-MATH', 'Mathematics', 'Department of Mathematics and Statistics'),
(3, 'DEPT-ENG', 'English', 'Department of English and Humanities');
SET IDENTITY_INSERT Departments OFF;

-- ============================================================
-- 2. COURSES (3 rows)
-- ============================================================
SET IDENTITY_INSERT Courses ON;
INSERT INTO Courses (id, courseName, totalYears, totalUnits, departmentId) VALUES
(1, 'Bachelor of Science in Computer Science', 4, 164, 1),
(2, 'Bachelor of Science in Mathematics', 4, 152, 2),
(3, 'Bachelor of Arts in English', 4, 140, 3);
SET IDENTITY_INSERT Courses OFF;

-- ============================================================
-- 3. ACADEMIC YEARS (4 rows)
-- ============================================================
SET IDENTITY_INSERT AcademicYears ON;
INSERT INTO AcademicYears (id, yearLevel, totalYears) VALUES
(1, 1, 4),
(2, 2, 4),
(3, 3, 4),
(4, 4, 4);
SET IDENTITY_INSERT AcademicYears OFF;

-- ============================================================
-- 4. EMPLOYEES (5 rows)
-- ============================================================
SET IDENTITY_INSERT Employees ON;
INSERT INTO Employees (id, employeeId, employeeType, firstName, middleName, lastName, title, dateHired, dateTerminated, status, departmentId) VALUES
(1, 'EMP-001', 'Professor', 'Juan', 'R.', 'Dela Cruz', 'Dr.', '2015-06-15', NULL, 'Active', 1),
(2, 'EMP-002', 'Professor', 'Maria', 'L.', 'Santos', 'Prof.', '2018-01-10', NULL, 'Active', 1),
(3, 'EMP-003', 'Professor', 'Jose', 'P.', 'Rizal', 'Dr.', '2012-08-20', NULL, 'Active', 2),
(4, 'EMP-004', 'Professor', 'Anna', 'M.', 'Garcia', 'Prof.', '2020-03-01', NULL, 'Active', 2),
(5, 'EMP-005', 'Professor', 'Luis', 'A.', 'Torres', 'Prof.', '2019-07-05', NULL, 'Active', 3);
SET IDENTITY_INSERT Employees OFF;

-- ============================================================
-- 5. DOCUMENTS (3 rows)
-- ============================================================
SET IDENTITY_INSERT Documents ON;
INSERT INTO Documents (id, documentId, documentName, issuedBy, status, expiryDate) VALUES
(1, 'DOC-BC', 'Birth Certificate', 'PSA', 'Valid', NULL),
(2, 'DOC-TOR', 'Transcript of Records', 'Registrar', 'Valid', NULL),
(3, 'DOC-ID', 'School ID', 'Admin Office', 'Valid', '2027-06-01');
SET IDENTITY_INSERT Documents OFF;

-- ============================================================
-- 6. SCHEDULES (5 rows)
-- ============================================================
SET IDENTITY_INSERT Schedules ON;
INSERT INTO Schedules (id, days, timeStart, timeEnd, roomNumber) VALUES
(1, 'Mon/Wed', '08:00', '09:30', 101),
(2, 'Mon/Wed', '10:00', '11:30', 102),
(3, 'Tue/Thu', '08:00', '09:30', 201),
(4, 'Tue/Thu', '13:00', '14:30', 202),
(5, 'Fri', '09:00', '12:00', 301);
SET IDENTITY_INSERT Schedules OFF;

-- ============================================================
-- 7. PREREQUISITES (2 rows)
-- ============================================================
SET IDENTITY_INSERT Prerequisites ON;
INSERT INTO Prerequisites (id, subjectTitle, units) VALUES
(1, 'Introduction to Programming', 3.0),
(2, 'Basic Algebra', 3.0);
SET IDENTITY_INSERT Prerequisites OFF;

-- ============================================================
-- 8. SUBJECTS (5 rows)
-- ============================================================
SET IDENTITY_INSERT Subjects ON;
INSERT INTO Subjects (id, subjectId, title, yearLevel, units, professorId, scheduleId, prerequisiteId, departmentId) VALUES
(1, 'CS101', 'Introduction to Computer Science', 1, 3.0, 1, 1, NULL, 1),
(2, 'CS201', 'Data Structures', 2, 4.0, 2, 2, 1, 1),    -- requires CS101
(3, 'MATH101', 'Calculus I', 1, 4.0, 3, 3, NULL, 2),
(4, 'MATH201', 'Linear Algebra', 2, 3.0, 4, 4, 2, 2),    -- requires Basic Algebra (prereq 2)
(5, 'ENG101', 'English Communication Skills', 1, 3.0, 5, 5, NULL, 3);
SET IDENTITY_INSERT Subjects OFF;

-- ============================================================
-- 9. SECTIONS (5 rows – block sections for the subjects)
-- ============================================================
SET IDENTITY_INSERT Sections ON;
INSERT INTO Sections (id, sectionName, yearLevel, isBlockSection, totalSlots, slotsTaken, subjectId) VALUES
(1, 'CS101-A', 1, 1, 40, 8, 1),
(2, 'CS201-A', 2, 1, 35, 5, 2),
(3, 'MATH101-A', 1, 1, 45, 10, 3),
(4, 'MATH201-A', 2, 1, 30, 4, 4),
(5, 'ENG101-A', 1, 1, 50, 12, 5);
SET IDENTITY_INSERT Sections OFF;

-- ============================================================
-- 10. ENROLLEES (20 rows)
-- ============================================================
SET IDENTITY_INSERT Enrollees ON;
INSERT INTO Enrollees (id, firstName, middleName, lastName, email, studentType, address, age, birthDate) VALUES
(1, 'Carlos', 'D.', 'Mendoza', 'carlos.mendoza@school.edu', 'New', '123 Rizal St.', 18, '2008-04-12'),
(2, 'Angela', 'R.', 'Santos', 'angela.santos@school.edu', 'New', '456 Mabini Ave.', 19, '2007-08-22'),
(3, 'Miguel', 'T.', 'Cruz', 'miguel.cruz@school.edu', 'Continuing', '789 Bonifacio Dr.', 20, '2006-01-15'),
(4, 'Sofia', 'L.', 'Reyes', 'sofia.reyes@school.edu', 'New', '101 Aguinaldo Blvd.', 18, '2008-07-30'),
(5, 'Rafael', 'M.', 'Torres', 'rafael.torres@school.edu', 'Continuing', '202 Quezon Ave.', 21, '2005-03-10'),
(6, 'Isabel', 'S.', 'Garcia', 'isabel.garcia@school.edu', 'New', '303 Davao St.', 19, '2007-11-05'),
(7, 'Luis', 'A.', 'Hernandez', 'luis.hernandez@school.edu', 'Continuing', '404 Cebu Rd.', 20, '2006-06-18'),
(8, 'Maria', 'C.', 'Lopez', 'maria.lopez@school.edu', 'New', '505 Palawan Ln.', 18, '2008-02-14'),
(9, 'Jose', 'P.', 'Ramos', 'jose.ramos@school.edu', 'Continuing', '606 Baguio Dr.', 22, '2004-09-25'),
(10, 'Clara', 'E.', 'Diaz', 'clara.diaz@school.edu', 'New', '707 Tagaytay Cir.', 19, '2007-12-01'),
(11, 'Pedro', 'G.', 'Aquino', 'pedro.aquino@school.edu', 'Continuing', '808 Iloilo St.', 21, '2005-05-30'),
(12, 'Elena', 'V.', 'Rivera', 'elena.rivera@school.edu', 'New', '909 Bacolod Ave.', 18, '2008-08-08'),
(13, 'Antonio', 'F.', 'Castro', 'antonio.castro@school.edu', 'Continuing', '111 Laguna Blvd.', 20, '2006-10-10'),
(14, 'Lucia', 'B.', 'Ortiz', 'lucia.ortiz@school.edu', 'New', '222 Mindoro Rd.', 19, '2007-04-20'),
(15, 'Diego', 'H.', 'Flores', 'diego.flores@school.edu', 'Continuing', '333 Bulacan Ave.', 21, '2005-07-13'),
(16, 'Carmen', 'J.', 'Gonzales', 'carmen.gonzales@school.edu', 'New', '444 Cavite St.', 18, '2008-01-07'),
(17, 'Francisco', 'K.', 'Morales', 'francisco.morales@school.edu', 'Continuing', '555 Batangas Ln.', 22, '2004-11-22'),
(18, 'Rosa', 'N.', 'Jimenez', 'rosa.jimenez@school.edu', 'New', '666 Pampanga Dr.', 19, '2007-06-05'),
(19, 'Manuel', 'Q.', 'Villanueva', 'manuel.villanueva@school.edu', 'Continuing', '777 Tarlac Ave.', 20, '2006-03-14'),
(20, 'Teresa', 'W.', 'Navarro', 'teresa.navarro@school.edu', 'New', '888 Bataan Cir.', 18, '2008-09-17');
SET IDENTITY_INSERT Enrollees OFF;

-- ============================================================
-- 11. ACCOUNTS (20 rows – one per enrollee)
-- ============================================================
SET IDENTITY_INSERT Accounts ON;
INSERT INTO Accounts (id, accountId, password, status, enrolleeId, accountabilityId, documentId, isEnrolled, sectionId, subjectId) VALUES
(1, 'ACC-1001', 'pass1001', 'Active', 1, NULL, 1, 1, 1, 1),
(2, 'ACC-1002', 'pass1002', 'Active', 2, NULL, 2, 1, 3, 3),
(3, 'ACC-1003', 'pass1003', 'Active', 3, NULL, NULL, 1, 2, 2),
(4, 'ACC-1004', 'pass1004', 'Active', 4, NULL, 3, 1, 5, 5),
(5, 'ACC-1005', 'pass1005', 'Active', 5, NULL, NULL, 1, 4, 4),
(6, 'ACC-1006', 'pass1006', 'Active', 6, NULL, 1, 1, 1, 1),
(7, 'ACC-1007', 'pass1007', 'Active', 7, NULL, 2, 1, 3, 3),
(8, 'ACC-1008', 'pass1008', 'Active', 8, NULL, NULL, 1, 2, 2),
(9, 'ACC-1009', 'pass1009', 'Active', 9, NULL, 3, 1, 5, 5),
(10, 'ACC-1010', 'pass1010', 'Active', 10, NULL, 1, 1, 4, 4),
(11, 'ACC-1011', 'pass1011', 'Active', 11, NULL, NULL, 0, NULL, NULL),
(12, 'ACC-1012', 'pass1012', 'Active', 12, NULL, 2, 1, 1, 1),
(13, 'ACC-1013', 'pass1013', 'Active', 13, NULL, 3, 1, 3, 3),
(14, 'ACC-1014', 'pass1014', 'Active', 14, NULL, NULL, 0, NULL, NULL),
(15, 'ACC-1015', 'pass1015', 'Active', 15, NULL, 1, 1, 2, 2),
(16, 'ACC-1016', 'pass1016', 'Active', 16, NULL, 2, 1, 5, 5),
(17, 'ACC-1017', 'pass1017', 'Active', 17, NULL, NULL, 0, NULL, NULL),
(18, 'ACC-1018', 'pass1018', 'Active', 18, NULL, 3, 1, 4, 4),
(19, 'ACC-1019', 'pass1019', 'Active', 19, NULL, 1, 1, 1, 1),
(20, 'ACC-1020', 'pass1020', 'Active', 20, NULL, NULL, 1, 3, 3);
SET IDENTITY_INSERT Accounts OFF;

-- ============================================================
-- 12. ACCOUNTABILITIES (5 rows – some open fees)
-- ============================================================
SET IDENTITY_INSERT Accountabilities ON;
INSERT INTO Accountabilities (id, amount, documentName, status, dateIssued, dateResolved, description, accountId) VALUES
(1, 1500.00, 'Tuition Fee', 'Unpaid', '2026-05-01', NULL, 'First semester tuition', 1),
(2, 2500.00, 'Misc Fee', 'Unpaid', '2026-05-01', NULL, 'Laboratory and library fees', 2),
(3, 800.00, 'ID Replacement', 'Resolved', '2026-04-15', '2026-05-10', 'Lost ID replacement', 3),
(4, 3000.00, 'Tuition Fee', 'Unpaid', '2026-05-01', NULL, 'Full tuition', 5),
(5, 500.00, 'Late Registration', 'Unpaid', '2026-05-20', NULL, 'Late enrollment penalty', 7);
SET IDENTITY_INSERT Accountabilities OFF;

-- Now update Accounts to set accountabilityId for those that have one
UPDATE Accounts SET accountabilityId = 1 WHERE id = 1;
UPDATE Accounts SET accountabilityId = 2 WHERE id = 2;
UPDATE Accounts SET accountabilityId = 3 WHERE id = 3;
UPDATE Accounts SET accountabilityId = 4 WHERE id = 5;
UPDATE Accounts SET accountabilityId = 5 WHERE id = 7;

-- ============================================================
-- 13. PAYMENTS (5 rows)
-- ============================================================
SET IDENTITY_INSERT Payments ON;
INSERT INTO Payments (id, amount, status, paymentType, paymentDate, modeOfPayment, accountId) VALUES
(1, 1500.00, 'Completed', 'Tuition', '2026-05-05', 'Online', 1),
(2, 1000.00, 'Completed', 'Misc', '2026-05-03', 'Over the Counter', 2),
(3, 800.00, 'Completed', 'ID Replacement', '2026-05-10', 'Cash', 3),
(4, 1500.00, 'Pending', 'Tuition', '2026-05-25', 'Bank Transfer', 4),
(5, 2500.00, 'Completed', 'Tuition', '2026-05-12', 'Online', 5);
SET IDENTITY_INSERT Payments OFF;