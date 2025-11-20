SET search_path = course_manage;

CREATE TABLE course_layout (
 course_layout_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 course_code VARCHAR(10) NOT NULL,
 course_name VARCHAR(150) NOT NULL,
 min_students INT NOT NULL,
 max_students INT NOT NULL,
 hp NUMERIC(4,1) NOT NULL,
 version INT NOT NULL
);

ALTER TABLE course_layout 
    ADD CONSTRAINT PK_course_layout PRIMARY KEY (course_layout_id),
    ADD CONSTRAINT uq_course_layout_code_version UNIQUE (course_code, version);


CREATE TABLE department (
 department_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 department_name VARCHAR(150) NOT NULL,
 manager_employee_id INT
);

ALTER TABLE department 
    ADD CONSTRAINT PK_department PRIMARY KEY (department_id),
    ADD CONSTRAINT UQ_department_name UNIQUE (department_name);


CREATE TABLE employee (
 employee_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 skill_set VARCHAR(250) NOT NULL,
 person_id INT NOT NULL,
 job_id INT NOT NULL,
 manager_id INT,
 department_id INT NOT NULL
);

ALTER TABLE employee 
    ADD CONSTRAINT PK_employee PRIMARY KEY (employee_id);


CREATE TABLE job_title (
 job_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 job_title VARCHAR(100) NOT NULL
);

ALTER TABLE job_title 
    ADD CONSTRAINT PK_job_title PRIMARY KEY (job_id);


CREATE TABLE person (
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 personal_number VARCHAR(20) NOT NULL,
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(150) NOT NULL,
 phone_number VARCHAR(20) NOT NULL,
 address VARCHAR(255) NOT NULL
);

ALTER TABLE person 
    ADD CONSTRAINT PK_person PRIMARY KEY (person_id),
    ADD CONSTRAINT uq_personal_number UNIQUE (personal_number);


CREATE TABLE salary_history (
 salary_history_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 salary_amount NUMERIC(12,2) NOT NULL,
 version INT NOT NULL,
 employee_id INT NOT NULL
);

ALTER TABLE salary_history 
    ADD CONSTRAINT PK_salary_history PRIMARY KEY (salary_history_id),
    ADD CONSTRAINT uq_salary_employee_version UNIQUE (employee_id, version);


CREATE TABLE teaching_activity (
 teaching_activity_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 activity_name VARCHAR(100) NOT NULL,
 factor NUMERIC(6,3) NOT NULL
);

ALTER TABLE teaching_activity 
    ADD CONSTRAINT PK_teaching_activity PRIMARY KEY (teaching_activity_id);


CREATE TABLE teaching_limit (
 teaching_limit_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 max_courses INT DEFAULT 4 NOT NULL
);

ALTER TABLE teaching_limit 
    ADD CONSTRAINT PK_teaching_limit PRIMARY KEY (teaching_limit_id);


CREATE TABLE course_instance (
 course_instance_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 num_students INT NOT NULL,
 study_period CHAR(2) NOT NULL,
 study_year INT NOT NULL,
 course_layout_id INT NOT NULL
);

ALTER TABLE course_instance 
    ADD CONSTRAINT PK_course_instance PRIMARY KEY (course_instance_id);


CREATE TABLE planned_activity (
 planned_activity_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 planned_hours NUMERIC(8,2) NOT NULL,
 course_instance_id INT NOT NULL,
 teaching_activity_id INT NOT NULL
);

ALTER TABLE planned_activity 
    ADD CONSTRAINT PK_planned_activity PRIMARY KEY (planned_activity_id);


CREATE TABLE allocation (
 allocation_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 allocated_hours NUMERIC(8,2),
 planned_activity_id INT NOT NULL,
 employee_id INT NOT NULL
);

ALTER TABLE allocation 
    ADD CONSTRAINT PK_allocation PRIMARY KEY (allocation_id);


ALTER TABLE department 
    ADD CONSTRAINT FK_department_0 FOREIGN KEY (manager_employee_id) REFERENCES employee (employee_id);


ALTER TABLE employee 
    ADD CONSTRAINT FK_employee_0 FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE employee 
    ADD CONSTRAINT FK_employee_1 FOREIGN KEY (job_id) REFERENCES job_title (job_id);

ALTER TABLE employee 
    ADD CONSTRAINT FK_employee_2 FOREIGN KEY (manager_id) REFERENCES employee (employee_id);

ALTER TABLE employee 
    ADD CONSTRAINT FK_employee_3 FOREIGN KEY (department_id) REFERENCES department (department_id);


ALTER TABLE salary_history 
    ADD CONSTRAINT FK_salary_history_0 FOREIGN KEY (employee_id) REFERENCES employee (employee_id);


ALTER TABLE course_instance 
    ADD CONSTRAINT FK_course_instance_0 FOREIGN KEY (course_layout_id) REFERENCES course_layout (course_layout_id);


ALTER TABLE planned_activity 
    ADD CONSTRAINT FK_planned_activity_0 FOREIGN KEY (course_instance_id) REFERENCES course_instance (course_instance_id);

ALTER TABLE planned_activity 
    ADD CONSTRAINT FK_planned_activity_1 FOREIGN KEY (teaching_activity_id) REFERENCES teaching_activity (teaching_activity_id);


ALTER TABLE allocation 
    ADD CONSTRAINT FK_allocation_0 FOREIGN KEY (planned_activity_id) REFERENCES planned_activity (planned_activity_id);

ALTER TABLE allocation 
    ADD CONSTRAINT FK_allocation_1 FOREIGN KEY (employee_id) REFERENCES employee (employee_id);


