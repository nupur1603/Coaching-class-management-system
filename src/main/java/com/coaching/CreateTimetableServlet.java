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

@WebServlet("/admin/CreateTimetableServlet")
public class CreateTimetableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("course_id");
        String teacherId = request.getParameter("teacher_id");
        String day_of_week = request.getParameter("day_of_week");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String meetingLink = request.getParameter("meeting_link");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Validate input fields
            if (courseId == null || teacherId == null || day_of_week == null || startTime == null || endTime == null || meetingLink == null ||
                courseId.isEmpty() || teacherId.isEmpty() || day_of_week.isEmpty() || startTime.isEmpty() || endTime.isEmpty() || meetingLink.isEmpty()) {
                
                response.sendRedirect("createTimetable.jsp?message=All fields are required!");
                return;
            }

            // Load database driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            // Insert timetable entry into database
            String sql = "INSERT INTO timetable (course_id, teacher_id, day_of_week, start_time, end_time, meeting_link) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(courseId));
            stmt.setInt(2, Integer.parseInt(teacherId));
            stmt.setString(3, day_of_week);
            stmt.setString(4, startTime);
            stmt.setString(5, endTime);
            stmt.setString(6, meetingLink);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("createTimetable.jsp?message=Timetable created successfully!");
            } else {
                response.sendRedirect("createTimetable.jsp?message=Failed to create timetable.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("createTimetable.jsp?message=Error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
