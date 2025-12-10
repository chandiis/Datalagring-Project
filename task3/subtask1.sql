SELECT 
    cl.course_code,
    ci.course_instance_id,
    ci.study_period AS period,

    -- PLANNED COST
    ROUND(SUM(pa.planned_hours * ta.factor * 300) / 1000) AS "planned_cost_KSEK",

    -- ACTUAL COST
    ROUND(SUM(a.allocated_hours * (sh.salary_amount) / 160) / 1000) AS "actual_cost_KSEK"

    FROM course_instance ci
        JOIN course_layout cl
            ON cl.course_layout_id = ci.course_layout_id

        JOIN planned_activity pa
            ON pa.course_instance_id = ci.course_instance_id

        JOIN teaching_activity ta
            ON ta.teaching_activity_id = pa.teaching_activity_id

        LEFT JOIN allocation a
            ON a.planned_activity_id = pa.planned_activity_id

        LEFT JOIN salary_history sh
            ON sh.employee_id = a.employee_id
            AND sh.version = (
                SELECT MAX(version)
                FROM salary_history sh2
                WHERE sh2.employee_id = a.employee_id
            )

        WHERE ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
        AND ci.course_instance_id = 7 --change to any id

        GROUP BY 
            cl.course_code,
            ci.course_instance_id,
            ci.study_period;