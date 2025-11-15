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

@WebServlet("/UpdateCourseServlet")
public class UpdateCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Retrieve form data
        String idStr = request.getParameter("id");
        String courseName = request.getParameter("course_name");
        String description = request.getParameter("description");
        String duration = request.getParameter("duration");
        String feeStr = request.getParameter("fee");
        String teacherIdStr = request.getParameter("teacher_id");
        String lastDateToEnroll = request.getParameter("last_date_to_enroll");
        String startDate = request.getParameter("start_date");

        // Debugging: Print received values
        System.out.println("Received Data:");
        System.out.println("ID: " + idStr);
        System.out.println("Course Name: " + courseName);
        System.out.println("Description: " + description);
        System.out.println("Duration: " + duration);
        System.out.println("Fee: " + feeStr);
        System.out.println("Teacher ID: " + teacherIdStr);
        System.out.println("Last Date to Enroll: " + lastDateToEnroll);
        System.out.println("Start Date: " + startDate);

        // Check for missing fields
        if (idStr == null || idStr.trim().isEmpty() ||
            courseName == null || courseName.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            duration == null || duration.trim().isEmpty() ||
            feeStr == null || feeStr.trim().isEmpty() ||
            teacherIdStr == null || teacherIdStr.trim().isEmpty() ||
            lastDateToEnroll == null || lastDateToEnroll.trim().isEmpty() ||
            startDate == null || startDate.trim().isEmpty()) {

            System.out.println("❌ Error: One or more form parameters are missing!");
            response.sendRedirect("editCourse.jsp?id=" + idStr + "&error=Missing form fields");
            return;
        }

        int courseId = Integer.parseInt(idStr);
        double fee = Double.parseDouble(feeStr);
        int teacherId = Integer.parseInt(teacherIdStr);

        // Database credentials
        String jdbcURL = "jdbc:mysql://localhost:3306/cms";
        String dbUser = "root";
        String dbPassword = "root";

        // SQL query to update the course details including start_date and last_date_to_enroll
        String sql = "UPDATE course SET course_name=?, description=?, duration=?, fee=?, teacher_id=?, last_date_to_enroll=?, start_date=? WHERE id=?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL Driver
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, courseName);
            stmt.setString(2, description);
            stmt.setString(3, duration);
            stmt.setDouble(4, fee);
            stmt.setInt(5, teacherId);
            stmt.setString(6, lastDateToEnroll);
            stmt.setString(7, startDate);
            stmt.setInt(8, courseId);

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("✅ Course updated successfully!");
                response.sendRedirect("admin/manageCourses.jsp?success=Course updated successfully");
            } else {
                System.out.println("❌ Error: No rows updated!");
                response.sendRedirect("admin/editCourse.jsp?id=" + courseId + "&error=Failed to update course");
            }

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/editCourse.jsp?id=" + courseId + "&error=Something went wrong.");
        }
    }
}
