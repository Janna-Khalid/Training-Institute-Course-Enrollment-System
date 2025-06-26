-- CREATE DATABASE
CREATE DATABASE Training_Institution 
USE Training_Institution

-- CREATE TRAINEE TABLE
CREATE TABLE Trainee (
						TraineeID INT PRIMARY KEY,
						FName NVARCHAR(20),
						LName NVARCHAR(20),
						Specialty NVARCHAR(50), --Trainer
						Phone NVARCHAR(11),
						Email NVARCHAR(50)
					)
ALTER TABLE Trainee
ADD Gender BIT DEFAULT 0

ALTER TABLE Trainee
ADD TraineeName NVARCHAR(50)

UPDATE Trainee
SET TraineeName = CONCAT(FName, ' ', LName)

ALTER TABLE Trainee
DROP COLUMN FName

ALTER TABLE Trainee
DROP COLUMN LName

ALTER TABLE Trainee
DROP COLUMN Specialty

ALTER TABLE Trainee
ADD Background NVARCHAR(50)

ALTER TABLE Trainee
DROP COLUMN Gender
ALTER TABLE Trainee
ADD Gender NVARCHAR(10)

ALTER TABLE Trainee
DROP CONSTRAINT DF__Trainee__Gender__32E0915F
ALTER TABLE Trainee
DROP COLUMN Gender
ALTER TABLE Trainee
ADD Gender NVARCHAR(10)

ALTER TABLE Trainee
DROP COLUMN Phone

-- CREATE TRAINER TABLE
CREATE TABLE Trainer(
						TrainerID INT PRIMARY KEY,
						FName NVARCHAR(20),
						LName NVARCHAR(20),
						Gender BIT DEFAULT 0, --Trainee
						Email NVARCHAR(50),
						Background NVARCHAR(50) --Trainee
					)
ALTER TABLE Trainer
DROP CONSTRAINT DF__Trainer__Gender__267ABA7A
ALTER TABLE Trainer
DROP COLUMN Gender

ALTER TABLE Trainer
ADD Specialty NVARCHAR(50)

ALTER TABLE Trainer
DROP COLUMN Background

ALTER TABLE Trainer
ADD Phone NVARCHAR(11)

ALTER TABLE Trainer
ADD TrainerName NVARCHAR(50)

UPDATE Trainer
SET TrainerName = CONCAT(FName, ' ', LName)

ALTER TABLE Trainer
DROP COLUMN FName

ALTER TABLE Trainer
DROP COLUMN LName

-- CREATE COURSE TABLE
CREATE TABLE Course (
						CourseID INT PRIMARY KEY,
						Title NVARCHAR(20),
						Category NVARCHAR(50),
						Hrs INT,
						Level NVARCHAR(20)	
					)
ALTER TABLE Course
ALTER COLUMN Title NVARCHAR(50)

-- CREATE SCHEDULE TABLE
CREATE TABLE Schedule (
						ScheduleID INT PRIMARY KEY,
						StartDate Date,
						EndDate Date,
						TimeSlot INT,
						CourseID INT,
						TrainerID INT,
						FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
						FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
					)

ALTER TABLE Schedule
ALTER COLUMN TimeSlot NVARCHAR(20)


-- CREATE ENROLLMENT TABLE
CREATE TABLE Enrollment (
						  EnrollmentID INT PRIMARY KEY,
						  EnrollmentDate Date,
						  TraineeID INT,
						  CourseID INT,
						  FOREIGN KEY (TraineeID) REFERENCES Trainee(TraineeID),
						  FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
						)

-- DISPLAY THE TABLES
SELECT * FROM Trainee
SELECT * FROM Trainer
SELECT * FROM Course
SELECT * FROM Schedule
SELECT * FROM Enrollment

-- INSERT TRAINEE
INSERT INTO Trainee (TraineeID, FName, LName, Gender, Email, Background)
VALUES
(1, 'Aisha', 'Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan', 'Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam', 'Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar', 'Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma', 'Al-Hinai', 'Female', 'fatma@example.com', 'Data Science')

-- INSERT TRAINER
INSERT INTO Trainer (TrainerID, FName, LName, Specialty, Phone, Email)
VALUES
(1, 'Khalid', 'Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura', 'Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim', 'Al-Harthy', 'Data Science', '96893456789', 'salim@example.com')

-- INSERTING COURSES
INSERT INTO Course (CourseID, Title, Category, Hrs, Level)
VALUES
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2,'Web Development','Basics Web', 30, 'Beginner'),
(3, 'Data Science', 'Introduction Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced')

-- INSERTING SCHEDULE
INSERT INTO Schedule (ScheduleID, CourseID, TrainerID, StartDate, EndDate, TimeSlot)
VALUES
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning')

-- INSERTING ENROLLMENT
INSERT INTO Enrollment(EnrollmentID, TraineeID, CourseID, EnrollmentDate)
VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06')


-- Trainee Perspective
-- 1. Show all available courses (title, level, category)
SELECT Title, Level, Category
FROM Course

-- 2. View beginner-level Data Science courses 
SELECT Title, Level, Category
FROM Course
WHERE Level = 'Beginner' AND Category = 'Data Science'

-- 3. Show courses trainee (TraineeID = 3) is enrolled in
SELECT C.Title
FROM Course C JOIN Enrollment E 
ON C.CourseID = E.CourseID
WHERE E.TraineeID = 3

-- 4. View the schedule for the trainee's enrolled courses
SELECT S.StartDate, S.TimeSlot
FROM Enrollment E
JOIN Schedule S 
ON E.CourseID = S.CourseID
WHERE E.TraineeID = 3

-- 5. Count how many courses the trainee is enrolled in
SELECT COUNT(*) as Total_Enrolled_Courses
FROM Enrollment
WHERE TraineeID = 3

-- 6. Show course titles, trainer names, and time slots the trainee is attending
SELECT C.Title, T.TrainerName , S.TimeSlot
FROM Course C
JOIN Enrollment E ON C.CourseID = E.CourseID
JOIN Schedule S ON C.CourseID = S.CourseID
JOIN Trainer T ON S.TrainerID = T.TrainerID
WHERE E.TraineeID = 3


-- Trainer Perspective
-- 1. List all courses the trainer is assigned to
SELECT C.Title
FROM Course C JOIN Schedule S ON C.CourseID = S.CourseID
WHERE S.TrainerID = 1

-- 2. Display future sessions this trainer is conducting, including start and end dates, and the time slot
SELECT C.Title, S.StartDate, S.EndDate, S.TimeSlot
FROM Course C JOIN Schedule S	
ON C.CourseID = S.CourseID
WHERE S.TrainerID = 1 
ORDER BY S.StartDate

-- 3. Count and display how many trainees are registered in each of the trainer’s courses
SELECT C.Title, COUNT(TraineeID) AS Enrolled_Trainees
FROM Course C
JOIN Schedule S
ON C.CourseID = S.CourseID
LEFT JOIN Enrollment e 
ON C.CourseID = E.CourseID
WHERE S.TrainerID = 1
GROUP BY C.Title

-- 4. Join Enrollment and Trainee tables to list trainee details for each course taught by the trainer
SELECT C.Title, TR.TraineeName, TR.Email
FROM Course C
JOIN Schedule S ON C.CourseID = S.CourseID
JOIN Enrollment E ON C.CourseID = E.CourseID
JOIN Trainee TR ON E.TraineeID = TR.TraineeID
WHERE S.TrainerID = 1
ORDER BY C.Title

-- 5. Return the trainer’s phone and email along with a list of their assigned courses.
SELECT T.TrainerName, T.Phone, T.Email
FROM Trainer T
JOIN Schedule S ON T.TrainerID = S.TrainerID
JOIN Course C ON S.CourseID = C.CourseID
WHERE T.TrainerID = 1

-- 6. Count the number of courses the trainer teaches
SELECT COUNT(DISTINCT S.CourseID) AS Total_Courses_Teaching
FROM Schedule S
WHERE S.TrainerID = 1

-- Admin Perspective
-- 1. Add a new course (INSERT statement) 
INSERT INTO Course (CourseID, Title, Category, Hrs, Level)
VALUES (5, 'Python Programming', 'Programming', 40, 'Beginner')

-- 2. Create a new schedule for a trainer 
INSERT INTO Schedule (ScheduleID, CourseID, TrainerID, StartDate, EndDate, TimeSlot)
VALUES (5, 5, 2, '2025-08-01', '2025-08-15', 'Evening')

-- 3. View all trainee enrollments with course title and schedule info 
SELECT TR.TraineeName, C.Title, S.StartDate, S.EndDate, S.TimeSlot
FROM Enrollment E
JOIN Trainee TR ON E.TraineeID = TR.TraineeID
JOIN Course C ON E.CourseID = C.CourseID
JOIN Schedule S ON c.CourseID = S.CourseID
ORDER BY S.StartDate

-- 4. Show how many courses each trainer is assigned to
SELECT T.TrainerName, COUNT(S.CourseID) AS Assigned_Courses
FROM Trainer T 
LEFT JOIN Schedule S ON T.TrainerID = S.TrainerID
GROUP BY T.TrainerName

-- 5. List all trainees enrolled in "Data Basics"
SELECT TR.TraineeName, TR.Email
FROM Trainee TR 
JOIN Enrollment E ON TR.TraineeID = E.TraineeID
JOIN Course C ON E.CourseID = C.CourseID
WHERE Title = 'Data Basics'

-- 6. Identify the course with the highest number of enrollments
SELECT TOP 1 C.Title, COUNT(E.EnrollmentID) AS Enrollment_Count
FROM Course C 
LEFT JOIN Enrollment E ON C.CourseID = E.CourseID
GROUP BY C.Title
ORDER BY Enrollment_Count DESC

-- 7. Display all schedules sorted by start date
SELECT *
FROM Schedule 
ORDER BY StartDate ASC