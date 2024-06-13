-- Number of blank majors in a club
DROP PROCEDURE IF EXISTS ListMajorsInClubs;
DELIMITER $$
CREATE PROCEDURE ListMajorsInClubs(IN major VARCHAR(50))
BEGIN
    SELECT COUNT(DISTINCT s.student_id) AS num_majors_involved_in_clubs
    FROM Student s
    JOIN Major m ON s.primary_major = m.title
    JOIN StudentTakesClub stc ON s.student_id = stc.student
    WHERE m.title = major;
END$$
DELIMITER ;

-- list faculty and their assigned sections
DROP PROCEDURE IF EXISTS FacultyAndSections;
DELIMITER $$
CREATE PROCEDURE FacultyAndSections()
BEGIN
    SELECT f.full_name AS faculty_name, s.section_id
    FROM Faculty f
    LEFT JOIN Sections s ON f.fac_id = s.instructor;
END$$
DELIMITER ;

-- Select all the faculty that are advisors for clubs with a budget higher than budget
DROP PROCEDURE IF EXISTS FacultyAdvisorBudget;
DELIMITER $$
CREATE PROCEDURE FacultyAdvisorBudget(IN budget SMALLINT)
BEGIN
    SELECT f.full_name AS faculty_advisor
    FROM Faculty f
    JOIN Club c ON f.fac_id = c.facultyadvisor_id
    WHERE c.budget >= budget ;
END$$
DELIMITER ;

-- Find the total budget allocation for clubs advised by a specific faculty member
DROP PROCEDURE IF EXISTS FacultyBudgetAllocation;
DELIMITER $$
CREATE PROCEDURE FacultyBudgetAllocation(IN FacName TEXT)
BEGIN
    SELECT Faculty.full_name, SUM(Club.budget) AS Total_Budget
    FROM Club
    JOIN Faculty ON Club.facultyadvisor_id = Faculty.fac_id
    WHERE Faculty.full_name = FacName
    GROUP BY Faculty.full_name;
END$$
DELIMITER ;

 -- List faculty members and the number of clubs they advise
DROP PROCEDURE IF EXISTS FacultyAndClubs;
DELIMITER $$
CREATE PROCEDURE FacultyAndClubs()
BEGIN
    SELECT Faculty.full_name, COUNT(Club.club_id) AS Clubs_Advised
    FROM Faculty
    JOIN Club ON Club.facultyadvisor_id = Faculty.fac_id
    GROUP BY Faculty.full_name
    ORDER BY Clubs_Advised DESC;
END$$
DELIMITER ;

 -- the full_name of all the students who are presidents of clubs along with the faculty advisor to that club
DROP PROCEDURE IF EXISTS PrezAndAdvisor;
DELIMITER $$
CREATE PROCEDURE PrezAndAdvisor()
BEGIN
    SELECT s.full_name AS president_name, f.full_name AS faculty_advisor
    FROM Student s
    JOIN Club c ON s.student_id = c.president
    JOIN Faculty f ON c.facultyadvisor_id = f.fac_id;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS DeptAndMajors;
DELIMITER $$
CREATE PROCEDURE DeptAndMajors()
BEGIN
    SELECT d.dept_name, COUNT(m.title) AS num_majors
    FROM Department d
    JOIN Major m ON d.dept_id = m.department_id;
    GROUP BY d.dept_name;
   
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ProfAndSection;
DELIMITER $$
CREATE PROCEDURE ProfAndSection(IN PROF VARCHAR(50))
BEGIN
    SELECT Sections.section_id
    FROM Faculty
    JOIN Sections ON Faculty.fac_id = Sections.instructor
    WHERE Faculty.full_name = PROF;
END$$
DELIMITER ;

#Checks the number of students in each major
DROP PROCEDURE IF EXISTS NumStudentMajor;
DELIMITER $$
CREATE PROCEDURE NumStudentMajor()
BEGIN
    SELECT m.title, COUNT(*) AS num_students
    FROM Major m
    JOIN Student s1 ON m.title = s1.primary_major
    GROUP BY m.title;
END$$
DELIMITER ;

-- Selects all of the different Departments and the faculty associated with those departments
DROP PROCEDURE IF EXISTS FacultyInDept;
DELIMITER $$
CREATE PROCEDURE FacultyInDept()
BEGIN
    SELECT f.full_name, d.dept_name
    FROM Department d
    LEFT JOIN Faculty f ON d.dept_id = f.department_id;
    GROUP BY Faculty.name;
END$$
DELIMITER ;

-- gets the phone number of a faculty that teaches a specific section
DROP PROCEDURE IF EXISTS FacultyPhone;
DELIMITER $$
CREATE PROCEDURE FacultyPhone(IN section_id CHAR(10) )
BEGIN
    SELECT f.phone
    FROM Faculty f
    JOIN Sections s ON f.fac_id = s.instructor
    WHERE s.section_id = section_id;
END$$
DELIMITER ;

-- gets the department code for a specific course
DROP PROCEDURE IF EXISTS CourseCode;
DELIMITER $$
CREATE PROCEDURE CourseCode(IN courseNumber SMALLINT )
BEGIN
    SELECT c.title, d.dept_code
    FROM Course c
    JOIN Department d ON c.course_department = d.dept_id
    WHERE c.course_number = courseNumber;
END$$
DELIMITER ;

-- returns a list of free rooms at the input time
DROP PROCEDURE IF EXISTS FreeRooms;
DELIMITER $$
CREATE PROCEDURE FreeRooms(IN input_time VARCHAR(30))
BEGIN
	SELECT r.room_number, r.building
	FROM Room r
	LEFT JOIN Sections s ON r.room_id = s.room
	LEFT JOIN MeetingTimes mt ON s.meeting_time = mt.meeting_time
	WHERE s.section_id IS NULL OR mt.meeting_time != input_time;
END$$
DELIMITER ;

-- returns all the faculty members in the input departemnt
DROP PROCEDURE IF EXISTS DepartmentFaculty;
DELIMITER $$
CREATE PROCEDURE DepartmentFaculty(IN DepartmentID TINYINT)
BEGIN
	SELECT f.full_name
	FROM Faculty f
	WHERE f.fac_id = DepartmentID;
END$$
DELIMITER ;

# Retrieves the total number of students enrolled in each course
-- DROP PROCEDURE IF EXISTS TotalEnrollments;
-- DELIMITER $$
-- CREATE PROCEDURE TotalEnrollments()
-- BEGIN
--     SELECT c.title, COUNT(sts.student) AS total_enrollments
--     FROM Course AS c
--     JOIN Sections AS sec ON c.course_number = sec.course_number AND c.course_department = sec.course_department
--     JOIN StudentTakesSection AS sts ON sec.section_id = sts.section_id
--     GROUP BY c.title;
-- END$$
-- DELIMITER ;

# Displays the total number of sections each faculty is teaching and total number of students across sections
DROP PROCEDURE IF EXISTS FacultyTotalWork;
DELIMITER $$
CREATE PROCEDURE FacultyTotalWork()
BEGIN
    SELECT f.full_name AS faculty_name, COUNT(s.section_id) AS total_sections, SUM(st.count_students) AS total_students
    FROM Faculty AS f
    JOIN Sections AS s ON f.fac_id = s.instructor
    JOIN (SELECT section_id, COUNT(*) AS count_students 
          FROM StudentTakesSection 
          GROUP BY section_id) 
    AS st ON s.section_id = st.section_id
    GROUP BY f.full_name
    ORDER BY total_students DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ClubPrez;
DELIMITER $$
CREATE PROCEDURE ClubPrez(IN clubid TINYINT)
BEGIN
    SELECT full_name
    FROM Student
    WHERE student_id = (
        SELECT president
        FROM Club
        WHERE club_id = clubid);
END$$
DELIMITER ;
