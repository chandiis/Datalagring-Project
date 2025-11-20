SET search_path = public;

-- PERSON
------------------------------------------------------------
INSERT INTO person (personal_number, first_name, last_name, phone_number, address) VALUES
('19850101-2001','Anna','Svensson','0702000101','Teknikringen 21, Stockholm'),
('19860302-2002','Erik','Johansson','0702000102','Lindstedtsvägen 30, Stockholm'),
('19791215-2003','Maria','Lindberg','0702000103','Valhallavägen 10, Stockholm'),
('19920412-2004','Karl','Andersson','0702000104','Hantverkargatan 5, Stockholm'),
('19900630-2005','Sara','Nilsson','0702000105','Sveavägen 50, Stockholm'),
('19881111-2006','Oskar','Berg','0702000106','Frescativägen 1, Stockholm'),
('19930503-2007','Eva','Lund','0702000107','Karlavägen 8, Stockholm'),
('19870622-2008','Jonas','Pettersson','0702000108','Kungsgatan 2, Stockholm'),
('19901205-2009','Lina','Eriksson','0702000109','Kungsholmen 12, Stockholm'),
('19891210-2010','Mikael','Olsson','0702000110','Östermalm 4, Stockholm');


------------------------------------------------------------
-- JOB TITLES
------------------------------------------------------------
INSERT INTO job_title (job_title) VALUES
('Professor'),
('Lektor'),
('Adjunkt'),
('Administratör'),
('Doktorand');


------------------------------------------------------------
-- DEPARTMENTS
------------------------------------------------------------
INSERT INTO department (department_name) VALUES
('EECS'),
('CBH'),
('SCI');


------------------------------------------------------------
-- EMPLOYEES (all 10 persons represented)
------------------------------------------------------------
INSERT INTO employee (skill_set, person_id, job_id, manager_id, department_id)
VALUES
-- Managers
('Artificial Intelligence, ML',
 (SELECT person_id FROM person WHERE personal_number='19850101-2001'),
 (SELECT job_id FROM job_title WHERE job_title='Professor'),
 NULL,
 (SELECT department_id FROM department WHERE department_name='EECS')),

('Organic Chemistry, Lab',
 (SELECT person_id FROM person WHERE personal_number='19791215-2003'),
 (SELECT job_id FROM job_title WHERE job_title='Professor'),
 NULL,
 (SELECT department_id FROM department WHERE department_name='CBH')),

-- EECS employees
('Software Engineering, Java',
 (SELECT person_id FROM person WHERE personal_number='19860302-2002'),
 (SELECT job_id FROM job_title WHERE job_title='Lektor'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19850101-2001')),
 (SELECT department_id FROM department WHERE department_name='EECS')),

('Embedded Systems',
 (SELECT person_id FROM person WHERE personal_number='19920412-2004'),
 (SELECT job_id FROM job_title WHERE job_title='Adjunkt'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19850101-2001')),
 (SELECT department_id FROM department WHERE department_name='EECS')),

('Electronics',
 (SELECT person_id FROM person WHERE personal_number='19901205-2009'),
 (SELECT job_id FROM job_title WHERE job_title='Adjunkt'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19850101-2001')),
 (SELECT department_id FROM department WHERE department_name='EECS')),

-- CBH employees
('Lab Technician',
 (SELECT person_id FROM person WHERE personal_number='19900630-2005'),
 (SELECT job_id FROM job_title WHERE job_title='Administratör'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19791215-2003')),
 (SELECT department_id FROM department WHERE department_name='CBH')),

('Bioinformatics',
 (SELECT person_id FROM person WHERE personal_number='19930503-2007'),
 (SELECT job_id FROM job_title WHERE job_title='Doktorand'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19791215-2003')),
 (SELECT department_id FROM department WHERE department_name='CBH')),

-- SCI employees
('Statistics, Data',
 (SELECT person_id FROM person WHERE personal_number='19870622-2008'),
 (SELECT job_id FROM job_title WHERE job_title='Lektor'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19850101-2001')),
 (SELECT department_id FROM department WHERE department_name='SCI')),

('Mathematics Teaching',
 (SELECT person_id FROM person WHERE personal_number='19891210-2010'),
 (SELECT job_id FROM job_title WHERE job_title='Lektor'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19870622-2008')),
 (SELECT department_id FROM department WHERE department_name='SCI')),

-- Extra employee (unused before)
('Control Systems',
 (SELECT person_id FROM person WHERE personal_number='19881111-2006'),
 (SELECT job_id FROM job_title WHERE job_title='Adjunkt'),
 (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19870622-2008')),
 (SELECT department_id FROM department WHERE department_name='SCI'));


------------------------------------------------------------
-- SET DEPARTMENT MANAGERS
------------------------------------------------------------
UPDATE department SET manager_employee_id =
    (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19850101-2001'))
WHERE department_name = 'EECS';

UPDATE department SET manager_employee_id =
    (SELECT employee_id FROM employee WHERE person_id=(SELECT person_id FROM person WHERE personal_number='19791215-2003'))
WHERE department_name = 'CBH';


------------------------------------------------------------
-- SALARY HISTORY
------------------------------------------------------------
INSERT INTO salary_history (salary_amount, version, employee_id) VALUES
(65000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19850101-2001')),
(68000, 2, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19850101-2001')),

(54000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19791215-2003')),
(36000, 2, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19791215-2003')),

(38000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19860302-2002')),
(42000, 2, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19860302-2002')),

(40000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19920412-2004')),
(30000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19900630-2005')),
(32000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19870622-2008')),
(31000, 1, (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19930503-2007'));


------------------------------------------------------------
-- TEACHING LIMIT
------------------------------------------------------------
INSERT INTO teaching_limit (max_courses) VALUES (4);


------------------------------------------------------------
-- TEACHING ACTIVITY
------------------------------------------------------------
INSERT INTO teaching_activity (activity_name, factor) VALUES
('Lecture', 1.8),
('Exercise', 1.2),
('Lab', 2.4),
('Seminar', 1.6),
('Examination', 3.0);


------------------------------------------------------------
-- COURSE LAYOUT
------------------------------------------------------------
INSERT INTO course_layout (course_code, course_name, min_students, max_students, hp, version) VALUES
('DD1310','Programming I',10,120,7.5,1),
('DD1310','Programming I',12,140,7.5,2),
('DD1320','Programming II',10,100,7.5,1),
('SF1624','Algebra and Geometry',15,150,7.5,1),
('ME1003','Mechanics Basics',10,80,7.5,1),
('CS2001','Data Storage Paradigms',10,200,7.5,1),
('CS3001','Advanced Databases',8,80,15,1),
('EN1000','Intro to Electronics',12,60,6.0,1);


------------------------------------------------------------
-- COURSE INSTANCE
------------------------------------------------------------
INSERT INTO course_instance (num_students, study_period, study_year, course_layout_id) VALUES
(110,'P1',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='DD1310' AND version=1)),
(130,'P2',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='DD1310' AND version=2)),
(90,'P1',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='DD1320')),
(120,'P3',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='SF1624')),
(55,'P2',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='ME1003')),
(40,'P1',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='EN1000')),
(75,'P2',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='CS2001')),
(60,'P4',2024,(SELECT course_layout_id FROM course_layout WHERE course_code='CS3001'));


------------------------------------------------------------
-- PLANNED ACTIVITY (no invalid courses)
------------------------------------------------------------
INSERT INTO planned_activity (planned_hours, course_instance_id, teaching_activity_id) VALUES
(30, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='DD1310' AND version=1)), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lecture')),
(15, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='DD1310' AND version=1)), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lab')),
(25, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='DD1310' AND version=2)), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lecture')),
(10, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='DD1320')), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lecture')),
(20, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='SF1624')), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lecture')),
(12, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='ME1003')), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lab')),
(18, (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='CS2001')), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lecture')),
(8,  (SELECT course_instance_id FROM course_instance WHERE course_layout_id=(SELECT course_layout_id FROM course_layout WHERE course_code='EN1000')), (SELECT teaching_activity_id FROM teaching_activity WHERE activity_name='Lecture'));


------------------------------------------------------------
-- ALLOCATION (all valid references)
------------------------------------------------------------
INSERT INTO allocation (allocated_hours, planned_activity_id, employee_id) VALUES
(15, (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=30), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19850101-2001')),
(12, (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=15), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19900630-2005')),
(25, (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=25), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19860302-2002')),
(10, (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=10), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19860302-2002')),
(8,  (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=12), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19900630-2005')),
(18, (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=18), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19870622-2008')),
(20, (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=20), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19850101-2001')),
(5,  (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=10), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19920412-2004')),
(9,  (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=8), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19891210-2010')),
(6,  (SELECT planned_activity_id FROM planned_activity WHERE planned_hours=18), (SELECT employee_id FROM employee e JOIN person p ON e.person_id=p.person_id WHERE p.personal_number='19930503-2007'));

------------------------------------------------------------
