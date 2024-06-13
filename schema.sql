CREATE TABLE IF NOT EXISTS Student (
    student_id INT,
    full_name TEXT NOT NULL,
    email VARCHAR(50) NOT NULL,
    grad_year YEAR NOT NULL,
    primary_major VARCHAR(50) NOT NULL,
    secondary_major VARCHAR(50),
    minors VARCHAR(50),
    UNIQUE (email),
    PRIMARY KEY (student_id)
);

CREATE TABLE IF NOT EXISTS Department(
    dept_id TINYINT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    dept_code VARCHAR(5) NOT NULL
);

CREATE TABLE IF NOT EXISTS Faculty (
    fac_id SMALLINT,
    full_name TEXT NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone CHAR(10) NOT NULL,
    department_id TINYINT,
    office VARCHAR(10),
    UNIQUE (phone),
    PRIMARY KEY (fac_id),
    FOREIGN KEY (department_id) REFERENCES Department(dept_id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Club (
    club_id SMALLINT,
    club_name VARCHAR(50) NOT NULL,
    descrip VARCHAR(500),
    budget MEDIUMINT NOT NULL,
    facultyadvisor_id SMALLINT NOT NULL,
    president INT NOT NULL,
    UNIQUE (club_name),
    PRIMARY KEY (club_id),
    FOREIGN KEY (facultyadvisor_id) REFERENCES Faculty(fac_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (president) REFERENCES Student(student_id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS MeetingTimes (
    meeting_time VARCHAR(30), -- format is something like "MWF 11:00-11:50"
    PRIMARY KEY (meeting_time)
);

CREATE TABLE IF NOT EXISTS Course (
    course_number SMALLINT NOT NULL,
    course_department TINYINT NOT NULL,
    PRIMARY KEY (course_number,course_department),
    title VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_department) REFERENCES Department(dept_id) 
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Sections (
    section_id INT PRIMARY KEY,
    course_number SMALLINT NOT NULL,
    course_department TINYINT NOT NULL,
    FOREIGN KEY (course_number, course_department) REFERENCES Course(course_number, course_department)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    letter VARCHAR(2) NOT NULL,
    meeting_time VARCHAR(30) NOT NULL,
    room INT NOT NULL,
    CONSTRAINT UNIQUE(meeting_time, room),
    FOREIGN KEY (room) REFERENCES Room(room_id),
    instructor INT,
    FOREIGN KEY (instructor) REFERENCES Faculty(fac_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (meeting_time) REFERENCES MeetingTimes(meeting_time)
        ON UPDATE CASCADE
        ON DELETE RESTRICT 
);


CREATE TABLE IF NOT EXISTS Room (
    room_id INT PRIMARY KEY,
    room_number SMALLINT NOT NULL,
    building ENUM(
        "OLIN",
        "MAXEY",
        "HALL OF SCIENCE",
        "SHERWOOD",
        "HUNTER",
        "HALL OF MUSIC",
        "PENROSE",
        "BAKER FERGUSON FITNESS CENTER",
        "DANCE STUDIO",
        "FOUTS",
        "REID",
        "OTHER"
    ) NOT NULL
);

CREATE TABLE IF NOT EXISTS Major (
    title VARCHAR(50),
    department_id TINYINT,
    PRIMARY KEY (title),
    FOREIGN KEY (department_id) REFERENCES Department(dept_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS StudentTakesSection (
    student INT,
    section_id INT,
    FOREIGN KEY (student) REFERENCES Student(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES Sections(section_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (student, section_id)
);


CREATE TABLE IF NOT EXISTS StudentInClub (
    student INT,
    club_id INT,
    FOREIGN KEY (student) REFERENCES Student(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (student, club_id)
);
