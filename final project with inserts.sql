-- down script

if not exists( select * from sys.databases where name = 'compu')

    create database compu

GO
use compu
GO

--drop procedures
IF OBJECT_ID('EvaluateStudentRequests') IS NOT NULL 
DROP PROCEDURE EvaluateStudentRequests

-- Drop the procedure if it already exists
IF OBJECT_ID('AssignDeviceToStudent', 'P') IS NOT NULL
    DROP PROCEDURE AssignDeviceToStudent;
GO

-- drop views 
IF OBJECT_ID('EvaluateStudentRequestView') IS NOT NULL
  DROP VIEW EvaluateStudentRequestView

-- Drop tables in reverse order of creation
DROP TABLE IF EXISTS order_logs;
DROP TABLE IF EXISTS requests;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS grade_ranks;
DROP TABLE IF EXISTS inventorys;
DROP TABLE IF EXISTS device_types;
DROP TABLE IF EXISTS donors;
DROP TABLE IF EXISTS schools;
DROP TABLE if exists disability_ranks;
DROP table if exists district_ranks;
DROP TABLE IF EXISTS districts;

-- up script

-- Create table for districts

CREATE TABLE districts (
  district_id INT NOT NULL identity,
  district_name VARCHAR(100)
  CONSTRAINT pk_districts_district_id primary key (district_id)
);

-- Insert records for districts

INSERT INTO districts (district_name) VALUES ( 'North School District');
INSERT INTO districts (district_name) VALUES ( 'West School District');
INSERT INTO districts (district_name) VALUES ('Town Square District');
INSERT INTO districts (district_name) VALUES ('Uptown District');
INSERT INTO districts (district_name) VALUES ('East Town District');

-- create table for district rank

CREATE TABLE district_ranks (
  district_rank_id INT NOT NULL identity,
  district_rank_district_id INT,
  district_rank_rank INT,
  CONSTRAINT pk_district_ranks_district_rank_id PRIMARY KEY (district_rank_id),
  FOREIGN KEY (district_rank_district_id) REFERENCES districts(district_id)
);

-- insert into district ranks

INSERT INTO district_ranks (district_rank_district_id, district_rank_rank) VALUES ( 1, 5);
INSERT INTO district_ranks (district_rank_district_id, district_rank_rank) VALUES (2, 3);
INSERT INTO district_ranks (district_rank_district_id, district_rank_rank) VALUES (3, 2);
INSERT INTO district_ranks (district_rank_district_id, district_rank_rank) VALUES ( 4, 4);
INSERT INTO district_ranks (district_rank_district_id, district_rank_rank) VALUES (5, 1);

-- create table for disability priority

create table disability_ranks(
disability_rank_id INT NOT NULL identity,
disability_rank_type VARCHAR(100) NOT NULL,
disability_rank_priority INT NOT NULL
CONSTRAINT pk_disability_ranks_disability_rank_id PRIMARY KEY (disability_rank_id)
);

-- Insert records into disability_ranks

INSERT INTO disability_ranks (disability_rank_type, disability_rank_priority) VALUES ('Multiple Disabilities', 5);
INSERT INTO disability_ranks (disability_rank_type, disability_rank_priority) VALUES ('Learning Disability', 4);
INSERT INTO disability_ranks (disability_rank_type, disability_rank_priority) VALUES ( 'Hearing Disability', 3);
INSERT INTO disability_ranks (disability_rank_type, disability_rank_priority) VALUES ( 'Visual Disability', 2);
INSERT INTO disability_ranks (disability_rank_type, disability_rank_priority) VALUES ( 'Physical Disability', 1);
INSERT INTO disability_ranks (disability_rank_type, disability_rank_priority) VALUES ( 'None', 0);


-- Create table for schools

CREATE TABLE schools (
  school_id INT NOT NULL identity,
  school_name VARCHAR(100),
  school_district_id INT,
  school_disabilities_program TINYINT DEFAULT 0,
  CONSTRAINT pk_schools_school_id PRIMARY KEY (school_id),
  CONSTRAINT fk_schools_district
    FOREIGN KEY (school_district_id)
    REFERENCES districts(district_id)
);

-- Inserting records for District 1
INSERT INTO schools (school_name, school_district_id, school_disabilities_program)
VALUES ('North Middle School', 1, 0);
INSERT INTO schools (school_name, school_district_id, school_disabilities_program)
VALUES ('North High School', 1, 1);

-- Inserting records for District 2
INSERT INTO schools (school_name, school_district_id, school_disabilities_program)
VALUES ('West High School', 2, 0);
INSERT INTO schools ( school_name, school_district_id, school_disabilities_program)
VALUES ('West Middle School', 2, 1);
INSERT INTO schools (school_name, school_district_id, school_disabilities_program)
VALUES ('Tom Barady High School', 2, 0);

-- Inserting records for District 3
INSERT INTO schools (school_name, school_district_id, school_disabilities_program)
VALUES ('Town Middle School', 3, 1);
INSERT INTO schools ( school_name, school_district_id, school_disabilities_program)
VALUES ('Town High School', 3, 0);

-- Inserting records for District 4
INSERT INTO schools ( school_name, school_district_id, school_disabilities_program)
VALUES ( 'Uptown Middle School', 4, 1);
INSERT INTO schools ( school_name, school_district_id, school_disabilities_program)
VALUES ( 'Uptown High School', 4, 0);

-- Inserting records for District 5
INSERT INTO schools ( school_name, school_district_id, school_disabilities_program)
VALUES ( 'East Middle School', 5, 0);
INSERT INTO schools ( school_name, school_district_id, school_disabilities_program)
VALUES ( 'East High School', 5, 1);


-- Create table for donors

CREATE TABLE donors (
  donor_id INT NOT NULL identity,
  donor_firstname VARCHAR(50) NOT NULL,
  donor_lastname VARCHAR(50) NOT NULL,
  donor_email VARCHAR(100) NOT NULL
  CONSTRAINT pk_donors_donor_id PRIMARY KEY (donor_id)
);

-- Insert records for donors

INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'John', 'Smith', 'john.smith@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Jane', 'Doe', 'jane.doe@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Michael', 'Johnson', 'michael.johnson@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Emily', 'Brown', 'emily.brown@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'David', 'Miller', 'david.miller@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Olivia', 'Taylor', 'olivia.taylor@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Daniel', 'Anderson', 'daniel.anderson@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Sophia', 'Clark', 'sophia.clark@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Matthew', 'Walker', 'matthew.walker@example.com');
INSERT INTO donors ( donor_firstname, donor_lastname, donor_email) VALUES ( 'Ava', 'Harris', 'ava.harris@example.com');

-- Create table for devices

CREATE TABLE device_types (
  device_type_id INT NOT NULL identity,
  device_type_name VARCHAR(100)
 CONSTRAINT pk_device_types_device_type_id primary key (device_type_id)
);

INSERT INTO device_types ( device_type_name) VALUES ('iPad');
INSERT INTO device_types (device_type_name) VALUES ('Samsung Tablet');
INSERT INTO device_types (device_type_name) VALUES ('Macbook');
INSERT INTO device_types (device_type_name) VALUES ('Chromebook');


-- Create table for inventory

CREATE TABLE inventorys (
  inventory_id INT NOT NULL identity,
  inventory_device_id INT,
  inventory_donor_id INT,
  CONSTRAINT pk_inventorys_inventory_id primary key (inventory_id),
  CONSTRAINT fk_inventorys_device_id
    FOREIGN KEY (inventory_device_id)
    REFERENCES device_types(device_type_id),
constraint fk_inventorys_donor_id
    FOREIGN KEY (inventory_donor_id)
    REFERENCES donors(donor_id)
);

-- Insert records into inventorys

-- Inserting records for inventory_id 1-10
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 2, 2);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 3);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 4);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 5);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 6);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 7);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 8);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 9);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 10);

-- Inserting records for inventory_id 11-20
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 2, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 4);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 6);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 6);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 2, 7);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 8);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 6);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 2, 10);

-- Inserting records for inventory_id 21-30
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 2, 2);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 7);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 7);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 5);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 1, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 2, 1);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 8);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 4, 10);
INSERT INTO inventorys ( inventory_device_id, inventory_donor_id)
VALUES ( 3, 10);

--create table for grade_ranks
create table grade_ranks(
    grade_rank_id INT NOT NULL ,
    grade_rank_name VARCHAR(15) NOT NULL,
    grade_rank_rank INT NULL
    CONSTRAINT pk_grade_ranks_grade_rank_id PRIMARY KEY (grade_rank_id)
);

INSERT INTO grade_ranks (grade_rank_id, grade_rank_name, grade_rank_rank)
VALUES
    (8, '8th Grade', 1),
    (9, '9th Grade', 2),
    (10, '10th Grade', 3),
    (11, '11th Grade', 4),
    (12, '12th Grade', 5);

-- Create table for students

CREATE TABLE students (
  student_id INT NOT NULL identity,
  student_firstname VARCHAR(50) NOT NULL,
  student_lastname VARCHAR(50) NOT NULL,
  student_email VARCHAR(50) NOT NULL UNIQUE,
  student_age INT NULL,
  student_grade_year INT NOT NULL,
  student_gpa DECIMAL (3,2) NULL,
  student_disability_id INT not null,
  student_school_id INT NOT NULL,
  student_requests_made INT NULL
  CONSTRAINT pk_students_student_id PRIMARY key (student_id),
  CONSTRAINT fk_students_disability_id
    FOREIGN KEY (student_disability_id)
    REFERENCES disability_ranks(disability_rank_id),
  CONSTRAINT fk_students_school
    FOREIGN KEY (student_school_id)
    REFERENCES schools(school_id),
    constraint fk_students_student_grade_year
    FOREIGN key (student_grade_year)
    REFERENCES grade_ranks(grade_rank_id)
);

ALTER TABLE students
ALTER COLUMN student_gpa DECIMAL(3, 2);

ALTER TABLE students
DROP COLUMN student_requests_made;



-- Insert records for students

INSERT INTO students ( student_firstname, student_lastname, student_email, student_age, student_grade_year, student_gpa, student_disability_id, student_school_id)
VALUES
  ('John', 'Smith', 'john.smith@example.edu', 16, 10, 3.75, 1, 1),
  ('Emily', 'Johnson', 'emily.johnson@funnyemail.edu', 15, 9, 3.88, 6, 1),
  ( 'Michael', 'Williams', 'michael.williams@lolmail.edu', 17, 11, 3.60, 4, 1),
  ( 'Olivia', 'Brown', 'olivia.brown@hilariousmail.edu', 14, 8, 3.92, 5, 2),
  ( 'James', 'Jones', 'james.jones@crazymail.edu', 15, 9, 2.80, 1, 2),
  ( 'Sophia', 'Davis', 'sophia.davis@randommail.edu', 16, 10, 3.65, 2, 3),
  ( 'Daniel', 'Miller', 'daniel.miller@sillymail.edu', 15, 9, 3.95, 1, 4),
  ( 'Ava', 'Wilson', 'ava.wilson@weirdmail.edu', 17, 11, 3.72, 5, 4),
  ( 'Liam', 'Taylor', 'liam.taylor@goofymail.edu', 14, 8, 2.81, 1, 5),
  ( 'Emma', 'Anderson', 'emma.anderson@oddmail.edu', 15, 9, 3.88, 2, 5),
  ( 'Benjamin', 'Martinez', 'benjamin.martinez@crazymail.edu', 16, 10, 3.70, 4, 6),
  ( 'Mia', 'Hernandez', 'mia.hernandez@funnyemail.edu', 14, 8, 3.91, 5, 6),
  ( 'Elijah', 'Lopez', 'elijah.lopez@lolmail.edu', 15, 9, 2.76, 5, 6),
  ( 'Charlotte', 'Garcia', 'charlotte.garcia@hilariousmail.edu', 17, 11, 3.84, 2, 7),
  ( 'William', 'Smith', 'william.smith@crazymail.edu', 14, 8, 3.90, 6, 7),
  ( 'Amelia', 'Johnson', 'amelia.johnson@randommail.edu', 15, 9, 3.78, 2, 7),
  ( 'Alexander', 'Williams', 'alexander.williams@weirdmail.edu', 16, 10, 3.68, 1, 8),
  ( 'Harper', 'Brown', 'harper.brown@hilariousmail.edu', 14, 8, 3.89, 2, 8),
  ( 'Daniel', 'Jones', 'daniel.jones@crazymail.edu', 15, 9, 2.83, 6, 9),
  ('Evelyn', 'Davis', 'evelyn.davis@randommail.edu', 17, 11, 3.79, 2, 9),
  ( 'Jacob', 'Miller', 'jacob.miller@sillymail.edu', 15, 9, 3.82, 6, 9),
  ( 'Abigail', 'Wilson', 'abigail.wilson@weirdmail.edu', 16, 12, 2.73, 3, 10),
  ( 'Noah', 'Taylor', 'noah.taylor@goofymail.edu', 14, 8, 3.93, 6, 10),
  ( 'Sofia', 'Anderson', 'sofia.anderson@oddmail.edu', 15, 9, 3.87, 2, 11),
  ( 'Logan', 'Martinez', 'logan.martinez@crazymail.edu', 17, 12, 2.77, 5, 11);

-- Create table for requests

CREATE TABLE requests (
  request_id INT NOT NULL identity,
  request_student_id INT,
  request_device_type_id INT,
  request_date DATE,
 request_is_eligible TINYINT,
 CONSTRAINT pk_requests_request_id PRIMARY key (request_id),
  CONSTRAINT fk_requests_student
    FOREIGN KEY (request_student_id)
    REFERENCES students(student_id),
  CONSTRAINT fk_requests_device
    FOREIGN KEY (request_device_type_id)
    REFERENCES device_types(device_type_id)
);

-- insert into requests

INSERT INTO requests (request_student_id, request_device_type_id, request_date, request_is_eligible)
VALUES
(1, 1, '2022-08-15',1),
(2, 2, '2022-07-04',0),
(3, 3, '2022-08-17',1),
(4, 4, '2022-09-19',1),
(5, 1, '2022-10-25', 0),
(6, 2, '2022-08-15',1),
(7, 2, '2022-08-20',0),
(8, 4, '2022-07-12',1);

create table order_logs (
  order_log_id int NOT NULL identity,
  order_log_student_id int NOT NULL,
  order_log_device_id int NOT NULL,
  order_log_assignment_date DATE NOT NULL,
  CONSTRAINT pk_order_logs_order_log_id primary key (order_log_id),
  CONSTRAINT fk_order_logs_student_id
    FOREIGN key (order_log_student_id)
    REFERENCES students(student_id),
  CONSTRAINT fk_order_logs_order_log_device_id
    FOREIGN key (order_log_device_id)
    REFERENCES device_types(device_type_id)
)

-- procedure to insert a new request 
use compu
GO
select * from requests
select * from students
DROP PROCEDURE IF EXISTS dbo.InsertRequest;
GO
CREATE PROCEDURE dbo.InsertRequest
    @firstName varchar(50),
    @lastName varchar(50),
    @email varchar(50),
    @grade INT,
    @gpa DECIMAL(3,2),
    @disability varchar(100),
    @school varchar(100),
    @request_date DATE,
    @deviceType VARCHAR(100)
AS
BEGIN 
 -- checking whether or not the student is a new student in the database
    If Not Exists (Select 1 from students where student_email = @email)
    BEGIN
    --inserting new student 
    Insert into students(student_firstname, student_lastname, student_email, student_grade_year, student_gpa, student_disability_id, student_school_id)
    Values (@firstName, @lastName, @email, @grade, @gpa, (select disability_rank_id from disability_ranks where disability_rank_type = @disability),
    (select school_id from schools where school_name = @school)
    );
    END

    --insert the request
    INSERT INTO requests (request_student_id, request_device_type_id, request_date)
    VALUES ((select student_id from students where student_email=@email), (select device_type_id from device_types where device_type_name =@deviceType), @request_date );

END

GO 
declare @studentfirstname varchar(50), @studentlastname varchar(50), @email varchar(50), @grade INT, @gpa decimal (3,2), @disability varchar(100), @school varchar(100),
@request_date DATE, @devicetype VARCHAR(100)

SET @studentfirstname = 'Wade'
set @studentlastname = 'Wilson'
set @email = 'wadewilly@deadpool.edu'
set @grade = 10
set @gpa = 3.82
set @disability = 'Learning Disability'
set @school = 'North High School'
set @request_date = '2022-09-10'
set @devicetype = 'Macbook'

EXEC dbo.InsertRequest @studentfirstname, @studentlastname, @email, @grade, @gpa, @disability, @school, @request_date, @devicetype

select * from requests 
select * from students

-- view for us to decide if they get a laptop, enter in a student to get a composite score back
GO
CREATE VIEW EvaluateStudentRequestView
AS
    SELECT
        s.student_id,
        s.student_firstname + ' ' + s.student_lastname as Student_name,
        s.student_gpa,
        dr.disability_rank_type,
        g.grade_rank_name,
        r.request_date,
        sc.school_name,
        dis.district_name,
        (
            (s.student_gpa / 4.0) * 0.3 + 
            dr.disability_rank_priority * 0.3 + 
            g.grade_rank_rank * 0.2 + 
            disr.district_rank_rank * 0.2
        ) AS composite_score,
        RANK() OVER (ORDER BY 
            (s.student_gpa / 4.0) * 0.3 + 
            dr.disability_rank_priority * 0.3 + 
            g.grade_rank_rank * 0.2 + 
            disr.district_rank_rank * 0.2 DESC
        ) AS student_rank
    FROM
        requests r
        left join students as s on r.request_student_id = s.student_id
        left join disability_ranks as dr on s.student_disability_id = dr.disability_rank_id
        left join schools as sc on s.student_school_id = sc.school_id
        left join grade_ranks as g on g.grade_rank_id = s.student_grade_year
        left join districts as dis on sc.school_district_id = dis.district_id
        left join district_ranks as disr on disr.district_rank_district_id = dis.district_id  

GO
select * from EvaluateStudentRequestView

-- Create Procedure for AssignDevicetoStudent if they are evaluated and accepted
GO
CREATE PROCEDURE AssignDeviceToStudent (@student_email VARCHAR(50), @device_type_name VARCHAR(100))
AS
BEGIN
    -- Check if the student exists in the 'students' table
    IF NOT EXISTS (SELECT 1 FROM students WHERE student_email = @student_email)
    BEGIN
      RAISERROR ('Student does not exist.',12,1)
      RETURN
      END

      -- check if requested device type is available in inventory
      IF NOT Exists (Select 1 from inventorys left join device_types on device_type_id = inventory_device_id where device_type_name = @device_type_name)
      BEGIN
        RAISERROR ( 'Device type is not available inventory.', 16, 1)
        RETURN 
        END
           -- Check if there is an available device of the requested type
    DECLARE @deviceId INT
    SELECT TOP 1 @deviceId = inventory_device_id
    FROM inventorys left join device_types on device_type_id = inventory_device_id
    WHERE device_type_name = @device_type_name 

    IF @deviceId IS NULL
    BEGIN
        RAISERROR('No available device of the requested type.', 12, 1)
        RETURN
    END

    -- Assign the device to the student
    delete from inventorys
    WHERE inventory_device_id = @deviceId

    -- Delete the request
    DELETE FROM requests
    WHERE request_student_id = (SELECT student_id FROM students WHERE student_email = @student_Email)
        AND request_device_type_id = (SELECT device_type_id FROM device_types WHERE device_type_name = @device_type_name)

    -- Store the assignment information in a separate table (e.g., assignments_history)
    INSERT INTO order_logs (order_log_student_id, order_log_device_id, order_log_assignment_date)
    VALUES ((SELECT student_id FROM students WHERE student_email = @student_Email), @deviceId, GETDATE())
    
    -- Return success message
    SELECT 'Device assigned successfully.' AS Message
END

 

-- Test Procedure AssignDevicetoStudent
GO
declare @student_email VARCHAR(50) , @device_type_name Varchar(50)
set @student_email = 'emily.johnson@funnyemail.edu'
set @device_type_name = 'Macbook'
EXEC AssignDeviceToStudent @student_email , @device_type_name

select * from order_logs

