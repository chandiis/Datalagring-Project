SELECT
    cl.course_code,
    ci.course_instance_id,
    cl.hp,
    ci.study_period AS period,
    CONCAT(p.first_name, ' ', p.last_name) AS teacher_name,
    e.employee_id AS employee_id,
    jt.job_title AS designation,

    COALESCE(SUM(a.allocated_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Lecture'), 0)  AS lecture_hours,
    COALESCE(SUM(a.allocated_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Tutorial'), 0) AS tutorial_hours,
    COALESCE(SUM(a.allocated_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Lab'), 0)      AS lab_hours,
    COALESCE(SUM(a.allocated_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Seminar'), 0)  AS seminar_hours,
    COALESCE(SUM(a.allocated_hours * ta.factor) FILTER (WHERE ta.activity_name = 'Other'), 0)    AS other_overhead_hours,

    -- Derived hours (computed per course instance)
    (2 * cl.hp + 28 + 0.2 * ci.num_students) AS admin_hours,
    (32 + 0.725 * ci.num_students)           AS exam_hours,

    -- Total = sum of all factored allocated hours + admin + exam
    COALESCE(SUM(a.allocated_hours * ta.factor), 0)
      + (2 * cl.hp + 28 + 0.2 * ci.num_students)
      + (32 + 0.725 * ci.num_students) AS total_hours

FROM course_layout cl
JOIN course_instance ci
    ON ci.course_layout_id = cl.course_layout_id
JOIN planned_activity pa
    ON ci.course_instance_id = pa.course_instance_id
JOIN teaching_activity ta
    ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN allocation a
    ON a.planned_activity_id = pa.planned_activity_id
JOIN employee e
    ON a.employee_id = e.employee_id
JOIN job_title jt
    ON e.job_id = jt.job_id
JOIN person p
    ON e.person_id = p.person_id

WHERE cl.course_code = 'IV1351'       -- change this to the course you want
  AND cl.version = 2                   -- change version
  AND ci.study_year = 2025             -- ensure current year's course instances

GROUP BY
    cl.course_code,
    ci.course_instance_id,
    cl.hp,
    ci.study_period,
    ci.num_students,
    e.employee_id,
    p.first_name,
    p.last_name,
    jt.job_title

ORDER BY
    p.last_name,
    p.first_name,
    cl.course_code,
    ci.course_instance_id;