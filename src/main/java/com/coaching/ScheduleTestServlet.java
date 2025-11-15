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
import jakarta.servlet.http.HttpSession;

@WebServlet("/ScheduleTestServlet")
public class ScheduleTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database Connection Details
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("teacherId") == null) {
            response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
            return;
        }

        int teacherId = (Integer) session.getAttribute("teacherId");
        String courseIdStr = request.getParameter("courseId");
        String topic = request.getParameter("topic");
        String testDate = request.getParameter("testDate");
        String testTime = request.getParameter("testTime");
        String marksStr = request.getParameter("marks");

        if (courseIdStr == null || topic == null || testDate == null || testTime == null || marksStr == null) {
            response.sendRedirect("scheduleTest.jsp?error=All fields are required.");
            return;
        }

        int courseId = Integer.parseInt(courseIdStr);
        int marks = Integer.parseInt(marksStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            String query = "INSERT INTO test (course_id, teacher_id, topic, test_date, test_time, marks) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, courseId);
            stmt.setInt(2, teacherId);
            stmt.setString(3, topic);
            stmt.setString(4, testDate);
            stmt.setString(5, testTime);
            stmt.setInt(6, marks);

            int rowsInserted = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (rowsInserted > 0) {
                response.sendRedirect("teacher/manageTest.jsp?message=Test scheduled successfully.");
            } else {
                response.sendRedirect("teacher/scheduleTest.jsp?error=Failed to schedule test.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacher/scheduleTest.jsp?error=Something went wrong.");
        }
    }
}
