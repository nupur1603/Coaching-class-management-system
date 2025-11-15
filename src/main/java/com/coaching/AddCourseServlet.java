package com.coaching;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Retrieve form parameters
        String courseName = request.getParameter("course_name");
        String description = request.getParameter("description");
        String duration = request.getParameter("duration");
        String feeStr = request.getParameter("fee");
        String teacherIdStr = request.getParameter("teacher_id");
        String lastDateToEnroll = request.getParameter("last_date_to_enroll"); // New field
        String startDate = request.getParameter("start_date"); // New field

        // Debugging - Print received data
        System.out.println("Received Data:");
        System.out.println("Course Name: " + courseName);
        System.out.println("Description: " + description);
        System.out.println("Duration: " + duration);
        System.out.println("Fee: " + feeStr);
        System.out.println("Teacher ID: " + teacherIdStr);
        System.out.println("Last Date to Enroll: " + lastDateToEnroll);
        System.out.println("Start Date: " + startDate); // Debugging log

        // Validate required fields
        if (courseName == null || description == null || duration == null || 
            feeStr == null || teacherIdStr == null || lastDateToEnroll == null || startDate == null ||
            courseName.isEmpty() || description.isEmpty() || duration.isEmpty() ||
            feeStr.isEmpty() || teacherIdStr.isEmpty() || lastDateToEnroll.isEmpty() || startDate.isEmpty()) {
            
            System.out.println("Error: Missing parameters!");
            response.sendRedirect("admin/manageCourses.jsp?error=Missing form fields");
            return;
        }

        // Convert fee and teacherId to appropriate types
        double fee = Double.parseDouble(feeStr);
        int teacherId = Integer.parseInt(teacherIdStr);

        // Database credentials
        String jdbcURL = "jdbc:mysql://localhost:3306/cms";
        String dbUser = "root";
        String dbPassword = "root";

        // SQL query to insert the course data
        String sql = "INSERT INTO course (course_name, description, duration, fee, teacher_id, last_date_to_enroll, start_date, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL Driver
            
            try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                // Set values in the query
                stmt.setString(1, courseName);
                stmt.setString(2, description);
                stmt.setString(3, duration);
                stmt.setDouble(4, fee);
                stmt.setInt(5, teacherId);
                stmt.setString(6, lastDateToEnroll);
                stmt.setString(7, startDate); // New field

                // Execute the query
                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    System.out.println("Course added successfully!");
                    response.sendRedirect("admin/manageCourses.jsp?success=Course added successfully");
                } else {
                    System.out.println("Failed to add course!");
                    response.sendRedirect("admin/manageCourses.jsp?error=Failed to add course");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/manageCourses.jsp?error=Something went wrong.");
        }
    }
}
