package com.kth;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.SQLException;

public class Main 
{
    public static void main( String[] args )
    {
        // PostgreSQL connection parameters
        String url = "jdbc:postgresql://localhost:5432/project"; // database
        String user = "postgres"; // username
        String password = " "; // password

        //USER--INPUT
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter course_instance_id: ");
        int instanceId = scanner.nextInt(); 

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
            AND ci.course_instance_id = ?

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
                
                ps.setInt(1, instanceId);

                try(ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        System.out.println("No data found for course_instance_id = " + instanceId);
                        conn.rollback();
                    } else {
                        System.out.println("\n=== Teaching Cost Result ===");
                        System.out.println("Course Code:        " + rs.getString("course_code"));
                        System.out.println("Instance ID:        " + rs.getInt("course_instance_id"));
                        System.out.println("Period:             " + rs.getString("period"));
                        System.out.println("Planned Cost:       " + rs.getInt("planned_cost_KSEK") + " KSEK");
                        System.out.println("Actual Cost:        " + rs.getInt("actual_cost_KSEK") + " KSEK");
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
            scanner.close();
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
