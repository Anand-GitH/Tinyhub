--  Database Created for CSE 4/560 Project1: TinyHub
--  Team Members
--  Anand
--  Jing Chen
--  Rahul Patil 
--  Date Created  : 11-07-2020
--  Date Modified : 11-29-2020 

DROP DATABASE IF EXISTS tinyhub;
CREATE DATABASE IF NOT EXISTS tinyhub;
USE tinyhub;

SELECT 'Database TinyHub is Created' as 'INFO';

DROP TABLE IF EXISTS users,
					 department,
					 student,
					 staff,
					 professor,
					 student_major,
					 programs,
					 courses,
					 prerequisites,
					 semester,
					 student_sem,
					 sem_course,
					 ta_sem_course,
					 stud_course_enrol,
					 exams,
					 problems,
					 exam_scores,
					 student_exam_grad,
					 author,
					 books,
					 library,
					 purchased_books,
					 borrow,
					 instructor,
					 teachassist,
					 student_feedback;

CREATE TABLE users (
   user_id      INTEGER NOT NULL,
   email        VARCHAR(100)   NOT NULL,
   passwrd      VARCHAR(20)    NOT NULL,
   dispname     VARCHAR(30)    DEFAULT NULL,
   PRIMARY KEY (email),
   UNIQUE KEY  (dispname),
   UNIQUE KEY  (user_id)
);

CREATE TABLE department(
deptno INTEGER NOT NULL,
deptname VARCHAR(100),
hod      VARCHAR(100),
PRIMARY KEY(deptno)
);

CREATE TABLE staff(
staffid INTEGER NOT NULL,
deptno INTEGER NOT NULL,
PRIMARY KEY (staffid),
FOREIGN KEY (staffid) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (deptno) REFERENCES department(deptno) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE professor(
profid INTEGER NOT NULL,
deptno INTEGER NOT NULL,
PRIMARY KEY (profid),
FOREIGN KEY (profid) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (deptno) REFERENCES department(deptno) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE instructor(
instid  INTEGER NOT NULL,
hours   DECIMAL NOT NULL,
primary KEY (instid),
FOREIGN KEY (instid) REFERENCES professor(profid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE student(
stid INTEGER NOT NULL,
PRIMARY KEY (stid),
FOREIGN KEY (stid) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE teachassist(
taid  INTEGER NOT NULL,
hours DECIMAL NOT NULL,
PRIMARY KEY (taid),
FOREIGN KEY (taid) REFERENCES student(stid) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE student_major(
stid INTEGER NOT NULL,
deptno INTEGER NOT NULL,
PRIMARY KEY (stid,deptno),
FOREIGN KEY (stid) REFERENCES student(stid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (deptno) REFERENCES department(deptno) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE programs(
progid INTEGER NOT NULL,
progname varchar(100),
progdirector varchar(100),
deptno INTEGER NOT NULL,
PRIMARY KEY (progid),
FOREIGN KEY (deptno) REFERENCES department(deptno) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE courses(
courseid INTEGER NOT NULL,
coursename VARCHAR(100) NOT NULL,
deptno INTEGER NOT NULL,
capacity INTEGER,
PRIMARY KEY (courseid),
FOREIGN KEY (deptno) REFERENCES department(deptno) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE prerequisites(
courseid INTEGER NOT NULL,
preqid  INTEGER NOT NULL,
PRIMARY KEY(courseid,preqid),
FOREIGN KEY (courseid) REFERENCES courses(courseid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (preqid) REFERENCES courses(courseid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE semester(
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
nweeks INTEGER,
PRIMARY KEY(syear,season)
);

CREATE TABLE student_sem(
stid INTEGER NOT NULL,
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
PRIMARY KEY(stid,syear,season),
FOREIGN KEY (stid) REFERENCES student(stid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (syear,season) REFERENCES semester(syear,season) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE sem_course(
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
courseid INTEGER NOT NULL,
instructid INTEGER NOT NULL,
totenrold INTEGER,
PRIMARY KEY (syear,season,courseid),
FOREIGN KEY (syear,season) REFERENCES semester(syear,season) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (courseid) REFERENCES courses(courseid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (instructid) REFERENCES instructor(instid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ta_sem_course(
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
courseid INTEGER NOT NULL,
taid INTEGER NOT NULL,
PRIMARY KEY (syear,season,courseid,taid),
FOREIGN KEY (syear,season,courseid) REFERENCES sem_course(syear,season,courseid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (taid) REFERENCES teachassist(taid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE stud_course_enrol(
stid INTEGER NOT NULL,
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
courseid INTEGER NOT NULL,
coursegrade VARCHAR(5),
PRIMARY KEY(stid,syear,season,courseid),
FOREIGN KEY (stid,syear,season) REFERENCES student_sem(stid,syear,season) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (courseid) REFERENCES sem_course(courseid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE exams(
exam_id INTEGER NOT NULL,
exam_name VARCHAR(50) NOT NULL,
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
courseid INTEGER NOT NULL,
PRIMARY KEY (exam_id),
FOREIGN KEY (syear,season) REFERENCES semester(syear,season) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (courseid) REFERENCES courses(courseid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE problems(
prob_id INTEGER NOT NULL,
exam_id INTEGER NOT NULL,
maxscore INTEGER NOT NULL,
PRIMARY KEY (prob_id,exam_id),
FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE exam_scores(
stid INTEGER NOT NULL,
exam_id INTEGER NOT NULL,
prob_id INTEGER NOT NULL,
score INTEGER,
PRIMARY KEY (stid,exam_id,prob_id),
FOREIGN KEY (stid) REFERENCES stud_course_enrol(stid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (prob_id) REFERENCES problems(prob_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE student_exam_grad(
stid      INTEGER NOT NULL,
exam_id   INTEGER NOT NULL,
exam_grade VARCHAR(1),
FOREIGN KEY (stid) REFERENCES exam_scores(stid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (exam_id) REFERENCES exam_scores(exam_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE author(
authorid INTEGER NOT NULL,
author_name VARCHAR(100),
PRIMARY KEY(authorid)
);

CREATE TABLE books
(
ISBN VARCHAR(100) NOT NULL,
title VARCHAR(100) NOT NULL,
publicationdate DATE NOT NULL,
noofpages INTEGER NOT NULL,
authorid INTEGER NOT NULL,
PRIMARY KEY (ISBN,publicationdate),
FOREIGN KEY (authorid) REFERENCES author(authorid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE library(
liabid INTEGER NOT NULL,
liabname VARCHAR(100) NOT NULL,
location  VARCHAR(50) NOT NULL,
PRIMARY KEY(liabid)
);

CREATE TABLE purchased_books(
bookid integer NOT NULL,
ISBN VARCHAR(100),
purchase_date DATE,
liabid INTEGER NOT NULL,
PRIMARY KEY (bookid),
FOREIGN KEY (ISBN) REFERENCES books(ISBN) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (liabid) REFERENCES library(liabid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE borrow(
user_id INTEGER NOT NULL,
bookid integer NOT NULL,
borrowed_date DATE,
return_date DATE GENERATED ALWAYS AS (DATE_ADD(borrowed_date, interval 2 WEEK)) STORED,
previous_rdate DATE,
extension VARCHAR(1),
realtime_rdate DATE,
returned VARCHAR(1),
PRIMARY KEY(user_id,bookid),
FOREIGN KEY (bookid) REFERENCES purchased_books(bookid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE student_feedback(
feedid INTEGER NOT NULL,
rating INTEGER NOT NULL,
feedback VARCHAR(500),
stid INTEGER NOT NULL,
syear  YEAR NOT NULL,
season VARCHAR(15) NOT NULL,
courseid INTEGER NOT NULL,
instructid INTEGER NOT NULL,
PRIMARY KEY(stid,syear,season,courseid,instructid,feedid),
FOREIGN KEY (stid,syear,season,courseid) REFERENCES stud_course_enrol(stid,syear,season,courseid) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (instructid) REFERENCES sem_course(instructid) ON UPDATE CASCADE ON DELETE CASCADE
);


SELECT 'All Tables Created Successfully' as 'INFO';
SHOW TABLES;