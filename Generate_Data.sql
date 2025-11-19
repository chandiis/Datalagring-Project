SET search_path = project;
---------------------------------------------------------
-- PERSON
---------------------------------------------------------
INSERT INTO person (personal_number, first_name, last_name, phone_number, address)
VALUES
 ('850312-1234', 'Anna', 'Svensson', '070-1234567', 'Storgatan 12, Göteborg'),
 ('900721-5678', 'Erik', 'Johansson', '070-9876543', 'Lundavägen 4, Malmö'),
 ('820504-2233', 'Maria', 'Lindgren', '073-1122334', 'Ringvägen 88, Stockholm'),
 ('790101-3322', 'Johan', 'Berg', '076-4433221', 'Södra Vägen 45, Borås'),
 ('880912-4545', 'Emma', 'Holm', '070-5566778', 'Kyrkogatan 19, Uppsala'),
 ('920303-1122', 'Oskar', 'Blom', '072-9988776', 'Norrgatan 3, Växjö'),
 ('890410-9988', 'Sara', 'Engström', '070-6655443', 'Åsvägen 21, Linköping'),
 ('950805-6677', 'Daniel', 'Strand', '073-2233445', 'Sveavägen 101, Stockholm'),
 ('840215-7766', 'Linda', 'Hedman', '076-8899001', 'Hamnvägen 7, Helsingborg'),
 ('870617-8899', 'Patrik', 'Nyberg', '070-3344556', 'Parkgatan 14, Örebro');

---------------------------------------------------------
-- JOB TITLE
---------------------------------------------------------
INSERT INTO job_title (job_title)
VALUES
 ('Lektor'),
 ('Universitetsadjunkt'),
 ('Professor'),
 ('Assistent'),
 ('Studievägledare'),
 ('Kursansvarig'),
 ('Forskningsingenjör'),
 ('Labassistent'),
 ('Administratör'),
 ('Gästföreläsare');

---------------------------------------------------------
-- DEPARTMENT
---------------------------------------------------------
-- Managers must be inserted later since employees don’t exist yet
INSERT INTO department (department_name, manager_employee_id)
VALUES
 ('Institutionen för Data- och Systemvetenskap', NULL),
 ('Institutionen för Matematik', NULL),
 ('Institutionen för Fysik', NULL),
 ('Institutionen för Humaniora', NULL),
 ('Institutionen för Ekonomi', NULL);

---------------------------------------------------------
-- EMPLOYEE
---------------------------------------------------------
-- Insert employees without managers first, then update manager fields
INSERT INTO employee (skill_set, salary, person_id, job_id, manager_id, department_id)
VALUES
 ('Java, SQL, System Design', 52000, 1, 1, NULL, 1),   -- Anna
 ('Databaser, Undervisning', 47000, 2, 2, NULL, 1),     -- Erik
 ('Forskning, Pedagogik', 65000, 3, 3, NULL, 2),        -- Maria
 ('Fysiklab, Utrustning', 36000, 4, 8, NULL, 3),        -- Johan
 ('HR, Administration', 40000, 5, 9, NULL, 4),          -- Emma
 ('Programmering, Python', 49000, 6, 1, NULL, 1),       -- Oskar
 ('Studierådgivning', 38000, 7, 5, NULL, 4),            -- Sara
 ('Ekonomi, Redovisning', 54000, 8, 10, NULL, 5),       -- Daniel
 ('Systemdrift, Linux', 45000, 9, 7, NULL, 2),          -- Linda
 ('Kursansvar, Undervisning', 56000, 10, 6, NULL, 1);   -- Patrik

---------------------------------------------------------
-- SET MANAGERS
---------------------------------------------------------
UPDATE employee SET manager_id = 1 WHERE employee_id IN (2,6,10); -- Anna manages them
UPDATE employee SET manager_id = 3 WHERE employee_id = 9;         -- Maria manages Linda
UPDATE employee SET manager_id = 8 WHERE employee_id = 5;         -- Daniel manages Emma

---------------------------------------------------------
-- SET DEPARTMENT MANAGERS
---------------------------------------------------------
UPDATE department SET manager_employee_id = 1 WHERE department_id = 1;
UPDATE department SET manager_employee_id = 3 WHERE department_id = 2;
UPDATE department SET manager_employee_id = 4 WHERE department_id = 3;
UPDATE department SET manager_employee_id = 5 WHERE department_id = 4;
UPDATE department SET manager_employee_id = 8 WHERE department_id = 5;

---------------------------------------------------------
-- COURSE LAYOUT
---------------------------------------------------------
INSERT INTO course_layout (course_code, course_name, min_students, max_students, hp)
VALUES
 ('DA101', 'Databasteknik', 10, 50, 7.5),
 ('DA201', 'Programmering i Java', 15, 60, 7.5),
 ('MA101', 'Analys I', 20, 80, 10.0),
 ('FY150', 'Grundläggande Fysik', 10, 40, 7.5),
 ('HU120', 'Vetenskapligt skrivande', 5, 30, 5.0),
 ('EC200', 'Nationalekonomi A', 20, 70, 7.5),
 ('DA301', 'Systemutveckling', 15, 40, 7.5),
 ('DA305', 'Datavetenskapens grunder', 12, 60, 7.5),
 ('MA201', 'Linjär Algebra', 20, 80, 7.5),
 ('FY250', 'Experimentell Fysik', 8, 25, 5.0);

---------------------------------------------------------
-- COURSE INSTANCE
---------------------------------------------------------
INSERT INTO course_instance (num_students, study_period, study_year, course_layout_id)
VALUES
 (45, 'P1', 2024, 1),
 (38, 'P2', 2024, 2),
 (72, 'P1', 2024, 3),
 (28, 'P2', 2024, 4),
 (14, 'P1', 2024, 5),
 (55, 'P2', 2025, 6),
 (33, 'P1', 2025, 7),
 (48, 'P2', 2025, 8),
 (60, 'P1', 2025, 9),
 (20, 'P2', 2025, 10);

---------------------------------------------------------
-- TEACHING ACTIVITY
---------------------------------------------------------
INSERT INTO teaching_activity (activity_name, factor)
VALUES
 ('Föreläsning', 1.000),
 ('Laboration', 0.500),
 ('Seminarium', 0.750),
 ('Handledningspass', 0.300),
 ('Examination', 0.800),
 ('Kursutveckling', 1.200),
 ('Rättning', 0.250),
 ('Projektledning', 0.900),
 ('Introduktion', 0.400),
 ('Workshop', 0.600);

---------------------------------------------------------
-- PLANNED ACTIVITY
---------------------------------------------------------
INSERT INTO planned_activity (planned_hours, course_instance_id, teaching_activity_id)
VALUES
 (40, 1, 1),
 (20, 1, 2),
 (35, 2, 1),
 (10, 2, 7),
 (50, 3, 1),
 (25, 3, 3),
 (30, 4, 2),
 (45, 5, 1),
 (15, 5, 9),
 (20, 6, 5);

---------------------------------------------------------
-- ALLOCATION
---------------------------------------------------------
INSERT INTO allocation (allocated_hours, planned_activity_id, employee_id)
VALUES
 (40, 1, 1),
 (20, 2, 2),
 (35, 3, 10),
 (10, 4, 6),
 (50, 5, 3),
 (25, 6, 1),
 (30, 7, 4),
 (45, 8, 7),
 (15, 9, 5),
 (20, 10, 8);