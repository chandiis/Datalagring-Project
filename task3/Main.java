//this is for the IDE --> (used from the directory where .xml file is) package com.kth;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

public class Main 
{
    public static void main( String[] args )
    {
        // PostgreSQL connection parameters
        String url = "jdbc:postgresql://localhost:5432/project"; // byt till din databas
        String user = "postgres"; // ditt användarnamn
        String password = "Chanda-280905"; // ditt lösenord

        String query = """
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
            AND ci.course_instance_id = 1

            GROUP BY 
                cl.course_code,
                ci.course_instance_id,
                ci.study_period;
            """;

        Connection conn = null;

        try {
                conn = DriverManager.getConnection(url, user, password);
                // 1) Turn off autocommit
                conn.setAutoCommit(false);

            try(PreparedStatement ps = conn.prepareStatement(query)) {
                
                try(ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        System.out.println(
                            rs.getString("course_code") + " | " +
                            rs.getInt("course_instance_id") + " | " +
                            rs.getString("period") + " | " +
                            rs.getDouble("planned_cost_KSEK") + " | " +
                            rs.getDouble("actual_cost_KSEK")
                        );
                    }
                }
                //if everything went well, commit
                conn.commit();
                System.out.println("Transaction committed successfully.");
            }
                
        } catch (SQLException e) {
            System.err.println("Error while executing query - rollback");
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("Rollback successful.");
                } catch (SQLException rbEx) {
                    System.err.println("Rollback failed:");
                    rbEx.printStackTrace();
                }
            }   
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
}
