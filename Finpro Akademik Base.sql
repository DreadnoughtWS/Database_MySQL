
--Done--
CREATE TABLE Users
(
Users_ID CHAR (5) PRIMARY KEY,
Users_name VARCHAR (50) NOT NULL,
Users_email VARCHAR (100) NOT NULL,
Users_address VARCHAR (50),
Users_dob DATE,
Users_status VARCHAR (30) NOT NULL,
)

CREATE TABLE Course
(
Course_ID CHAR(5) PRIMARY KEY,
Course_name VARCHAR (50) NOT NULL,
Course_type VARCHAR (30) NOT NULL,
)

CREATE TABLE Experts
(
Experts_ID CHAR (5) PRIMARY KEY,
Experts_name VARCHAR (50) NOT NULL,
Experts_email VARCHAR (100) NOT NULL,
Experts_address VARCHAR (30),
Experts_dob DATE,
Experts_role VARCHAR (30) NOT NULL,
)

CREATE TABLE Projects
(
Project_ID CHAR (5) PRIMARY KEY,
Project_name VARCHAR (50) NOT NULL,
Project_desc VARCHAR (200),
Project_date DATE NOT NULL,
Course_ID CHAR (5),
FOREIGN KEY (Course_ID) 
        REFERENCES Course (Course_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
)



CREATE TABLE Classroom
(
Class_ID CHAR (5) PRIMARY KEY,
Class_name VARCHAR (50) NOT NULL,
Class_link VARCHAR(2083) NOT NULL,
Course_ID CHAR (5) NOT NULL,
FOREIGN KEY (Course_ID) 
        REFERENCES Course (Course_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Classroom_content
(
Users_ID CHAR (5) NOT NULL,
Experts_ID CHAR (5),
Course_ID CHAR (5) NOT NULL,
FOREIGN KEY (Users_ID) 
        REFERENCES Users (Users_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Course_ID) 
        REFERENCES Course (Course_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE topics
(
Topic_ID CHAR (5) PRIMARY KEY,
Title VARCHAR (30) NOT NULL,
SessionNumber VARCHAR (20) NOT NULL,
Course_ID CHAR (5) NOT NULL,
FOREIGN KEY (Course_ID) 
        REFERENCES Course (Course_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE quiz
(
Question_ID CHAR (5) PRIMARY KEY,
Question VARCHAR (500) NOT NULL,
Topic_ID CHAR (5),
FOREIGN KEY (Topic_ID) 
        REFERENCES topics (Topic_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE answers
(
Answers_ID CHAR (5) PRIMARY KEY,
Answer VARCHAR (500) NOT NULL,
Question_ID CHAR (5),
Users_ID CHAR (5),
FOREIGN KEY (Question_ID) 
        REFERENCES quiz (Question_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Users_ID) 
        REFERENCES Users (Users_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Pass
(
	Pass VARCHAR(20) NOT NULL,
	Email VARCHAR(100) NOT NULL,
	PRIMARY KEY(Email)
)

CREATE TABLE course_assigned
(
	Experts_ID CHAR (5),
	Course_ID CHAR (5) NOT NULL,
	FOREIGN KEY (Course_ID) 
        REFERENCES Course (Course_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
)