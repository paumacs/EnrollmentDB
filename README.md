# EnrollmentDB
Enrollment Module in SSMS

| Routine | Type | Purpose |
|---------|------|---------|
| `usp_ManageEnrolleeAccount` | Procedure | Insert or update an enrollee’s personal information and ensure a linked Accounts record exists. Automatically creates an account on first creation. |
| `usp_ChangePassword` | Procedure | Validates old password and updates to new. |
| `usp_SetEnrollment` | Procedure | Sets isEnrolled, assigns section/subject, manages section capacity. |
| `usp_LinkDocument` | Procedure | Links a document to the student’s account. |
| `usp_AddAccountability` | Procedure | Adds a new fee/obligation and updates the circular FK. |
| `fn_GetAccountDashboard` | Function | Returns a read‑only dashboard of the student’s entire record. |
| `usp_SubmitDocument` | Procedure | Link a new or existing document to a student account; creates or updates the Documents record. |
| `usp_UpdateDocumentStatus` | Procedure | Change the document’s verification status and/or expiry date. |
| `fn_GetStudentDocuments` | Function | Retrieve the linked document (type, issuer, status, expiry, computed validity) for an account/enrollee. |
| `fn_IsDocumentCompliant` | Function | Returns 1 if the student’s linked document is valid and not expired; 0 otherwise. |
| `usp_ManagePrerequisite` | Procedure | Insert/update a generic prerequisite (title + units) in the catalog. |
| `usp_ManageSubject` | Procedure | Insert/update a subject, assign professor, schedule, department, and link its prerequisite. |
| `usp_RecordCompletion` | Procedure | Record that a student has completed a specific subject (necessary for prerequisite tracking). |
| `fn_IsPrerequisiteMet` | Function | Scalar check: returns 1 if the student has passed a subject matching the prerequisite title, else 0. |
| `fn_GetSubjectDetails` | Function | Returns the subject catalog with prerequisite information for viewing or reporting. |
| `usp_ManageSchedule` | Procedure | Insert / update a schedule (days, times, room). |
| `usp_AssignScheduleToSubject` | Procedure | Link a schedule to a subject or remove it (set scheduleId = NULL). |
| `fn_GetSubjectSchedule` | Function | Return the full schedule details for a given subject. |
| `fn_GetRoomSchedules` | Function | Return all schedules (and linked subjects) for a specific room. |
| `fn_CheckScheduleConflict` | Function | Check if a proposed schedule conflicts (same room, overlapping days & time). Use before inserting/updating. |
| `usp_ManageSection` | Procedure | Insert or update a section (name, year, block flag, capacity, subject). |
| `usp_SetSlotsTaken` | Procedure | Administratively correct the number of slots taken (e.g., after manual enrolment). |
| `fn_IsSectionAvailable` | Function | Returns 1 if the section still has free slots (slotsTaken < totalSlots). |
| `fn_GetSubjectSections` | Function | List all sections of a given subject, with available slots and status. |
| `fn_GetDepartmentSections` | Function | List all sections in a department (via subject -> department). |
| `fn_GetAllSections` | Function | List every section across the university, with availability. |
| `usp_RecordPayment` | Procedure | Insert a payment record (amount, type, mode, date) against an account. |
| `usp_ResolveAccountability` | Procedure | Mark a specific accountability as 'Resolved', recording the resolution date. |
| `fn_OutstandingBalance` | Function | Return the total unresolved accountabilities amount for a given account. |
| `fn_TotalPayments` | Function | Return the total completed payments for an account. |
| `fn_IsAccountCleared` | Function | Returns 1 if the account has zero outstanding balance and a valid document – ready for enrollment. |
| `fn_GetOpenAccountabilities` | Function | List all unresolved accountabilities (optionally filtered by account). |
| `usp_ManageEmployee` | Procedure | Insert or update an employee record (type, name, title, hire/termination dates, department). |
| `usp_TerminateEmployee` | Procedure | Set the termination date and status for an employee. |
| `usp_ReactivateEmployee` | Procedure | Clear the termination date and set employee back to active. |
| `fn_GetActiveEmployees` | Function | Return all active employees, optionally filtered by department. |
| `fn_GetEmployeeDetails` | Function | Return full details of a single employee (including department name). |
| `usp_ManageDepartment` | Procedure | Insert or update a department (unique code, name, description). |
| `usp_ManageCourse` | Procedure | Insert or update a course (name, duration, total units, linked department). |
| `usp_ManageAcademicYear` | Procedure | Insert or update an academic year level definition (year level and its corresponding total program years). |
| `fn_GetDepartments` | Function | Retrieve all departments. |
| `fn_GetDepartmentCourses` | Function | List all courses offered by a specific department. |
| `fn_GetCourseDetails` | Function | Return full details of a single course including its department. |
| `fn_GetAcademicYears` | Function | List all defined academic year levels. |
