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

@WebServlet("/EditTestServlet")
public class EditTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
        int testId = Integer.parseInt(request.getParameter("testId"));
        String topic = request.getParameter("topic");
        String testDate = request.getParameter("testDate");
        String testTime = request.getParameter("testTime");
        int marks = Integer.parseInt(request.getParameter("marks"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            String query = "UPDATE test SET topic=?, test_date=?, test_time=?, marks=? WHERE id=? AND teacher_id=?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, topic);
            stmt.setString(2, testDate);
            stmt.setString(3, testTime);
            stmt.setInt(4, marks);
            stmt.setInt(5, testId);
            stmt.setInt(6, teacherId);

            int rowsUpdated = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (rowsUpdated > 0) {
                response.sendRedirect("teacher/manageTest.jsp?message=Test updated successfully.");
            } else {
                response.sendRedirect("teacher/editTest.jsp?id=" + testId + "&error=Update failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacher/editTest.jsp?id=" + testId + "&error=Something went wrong.");
        }
    }
}

