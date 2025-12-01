SELECT
    cl.course_code,
    ci.course_instance_id,
    cl.hp,
    ci.study_period AS period,
    CONCAT(p.first_name, ' ', p.last_name) AS teacher_name,

    -- Factored hours per activity (return 0 if NULL)
    COALESCE(SUM(a.allocated_hours * ta.factor) 
        FILTER (WHERE ta.activity_name = 'Lecture'), 0) AS lecture_hours,

    COALESCE(SUM(a.allocated_hours * ta.factor) 
        FILTER (WHERE ta.activity_name = 'Tutorial'), 0) AS tutorial_hours,

    COALESCE(SUM(a.allocated_hours * ta.factor) 
        FILTER (WHERE ta.activity_name = 'Lab'), 0) AS lab_hours,

    COALESCE(SUM(a.allocated_hours * ta.factor) 
        FILTER (WHERE ta.activity_name = 'Seminar'), 0) AS seminar_hours,

    COALESCE(SUM(a.allocated_hours * ta.factor) 
        FILTER (WHERE ta.activity_name = 'Other'), 0) AS other_overhead_hours,

    -- Derived (never NULL)
    (2 * cl.hp + 28 + 0.2 * ci.num_students) AS admin_hours,
    (32 + 0.725 * ci.num_students) AS exam_hours,

    -- Total hours (uses COALESCE to avoid NULL)
    COALESCE(SUM(a.allocated_hours * ta.factor), 0)
        + (2 * cl.hp + 28 + 0.2 * ci.num_students)
        + (32 + 0.725 * ci.num_students)
        AS total_hours

FROM allocation a
JOIN planned_activity pa
    ON a.planned_activity_id = pa.planned_activity_id
JOIN teaching_activity ta
    ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN course_instance ci
    ON pa.course_instance_id = ci.course_instance_id
JOIN course_layout cl
    ON ci.course_layout_id = cl.course_layout_id
JOIN employee e
    ON a.employee_id = e.employee_id
JOIN person p
    ON e.person_id = p.person_id

WHERE ci.study_year = 2025

GROUP BY
    cl.course_code,
    ci.course_instance_id,
    cl.hp,
    ci.study_period,
    ci.num_students,
    p.first_name,
    p.last_name

ORDER BY
    p.last_name,
    p.first_name,
    cl.course_code,
    ci.course_instance_id;