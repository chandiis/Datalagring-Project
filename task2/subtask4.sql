SELECT
    e.employee_id AS "Employee ID",
    CONCAT(p.first_name, ' ', p.last_name) AS "Teacher's Name",
    ci.study_period AS period,
    COUNT(DISTINCT ci.course_instance_id) AS "No of courses"
FROM allocation a
JOIN planned_activity pa
    ON a.planned_activity_id = pa.planned_activity_id
JOIN course_instance ci
    ON pa.course_instance_id = ci.course_instance_id
JOIN employee e
    ON a.employee_id = e.employee_id
JOIN person p
    ON e.person_id = p.person_id
WHERE ci.study_year = 2025        -- only current year's course instances
AND ci.study_period = 'P1'        -- current period (adjust as needed)
GROUP BY
    e.employee_id,
    p.first_name,
    p.last_name,
    ci.study_period
HAVING
    COUNT(DISTINCT ci.course_instance_id) > 1   -- change 1 to any threshold you want
ORDER BY
    p.last_name,
    p.first_name;
