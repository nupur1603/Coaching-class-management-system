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

@WebServlet("/DeleteTestServlet")
public class DeleteTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("teacherId") == null) {
            response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
            return;
        }

        int teacherId = (Integer) session.getAttribute("teacherId");
        int testId = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            String query = "DELETE FROM test WHERE id = ? AND teacher_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, testId);
            stmt.setInt(2, teacherId);

            int rowsDeleted = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (rowsDeleted > 0) {
                response.sendRedirect("teacher/manageTest.jsp?message=Test deleted successfully.");
            } else {
                response.sendRedirect("teacher/manageTest.jsp?error=Failed to delete test.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacher/manageTest.jsp?error=Something went wrong.");
        }
    }
}
