SELECT
    cl.course_code,
    ci.course_instance_id,
    cl.hp,
    ci.study_period AS period,
    ci.num_students AS "# Students",

    COALESCE(SUM(pa.planned_hours * ta.factor)
             FILTER (WHERE ta.activity_name = 'Lecture'), 0) AS lecture_hours,

    COALESCE(SUM(pa.planned_hours * ta.factor)
             FILTER (WHERE ta.activity_name = 'Tutorial'), 0) AS tutorial_hours,

    COALESCE(SUM(pa.planned_hours * ta.factor)
             FILTER (WHERE ta.activity_name = 'Lab'), 0) AS lab_hours,

    COALESCE(SUM(pa.planned_hours * ta.factor)
             FILTER (WHERE ta.activity_name = 'Seminar'), 0) AS seminar_hours,

    COALESCE(SUM(pa.planned_hours * ta.factor)
             FILTER (WHERE ta.activity_name = 'Other'), 0) AS other_overhead_hours,

    (32 + 0.725 * ci.num_students) AS exam_hours,
    (2 * cl.hp + 28 + 0.2 * ci.num_students) AS admin_hours,

    COALESCE(SUM(pa.planned_hours * ta.factor), 0)
        + (32 + 0.725 * ci.num_students)
        + (2 * cl.hp + 28 + 0.2 * ci.num_students)
        AS total_hours

FROM course_layout cl
JOIN course_instance ci
    ON cl.course_layout_id = ci.course_layout_id
JOIN planned_activity pa
    ON ci.course_instance_id = pa.course_instance_id
JOIN teaching_activity ta
    ON pa.teaching_activity_id = ta.teaching_activity_id
GROUP BY
    cl.course_code,
    ci.course_instance_id,
    cl.hp,
    ci.study_period,
    ci.num_students
ORDER BY
    cl.course_code,
    ci.course_instance_id;