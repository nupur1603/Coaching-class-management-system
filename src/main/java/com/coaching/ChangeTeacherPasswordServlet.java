package com.coaching;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ChangeTeacherPasswordServlet")
public class ChangeTeacherPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("teacherId") == null) {
            response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
            return;
        }

        int teacherId = (Integer) session.getAttribute("teacherId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        String jdbcURL = "jdbc:mysql://localhost:3306/cms";
        String dbUser = "root";
        String dbPassword = "root";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Check current password
            String query = "SELECT tpass FROM teacher WHERE tid=?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, teacherId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("tpass");
                if (!storedPassword.equals(currentPassword)) {
                    response.sendRedirect("teacher/changeTeacherPassword.jsp?error=Incorrect current password.");
                    return;
                }
            } else {
                response.sendRedirect("teacher/changeTeacherPassword.jsp?error=User not found.");
                return;
            }

            // Update password
            String updateQuery = "UPDATE teacher SET tpass=? WHERE tid=?";
            stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, newPassword);
            stmt.setInt(2, teacherId);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("teacher/changeTeacherPassword.jsp?success=Password changed successfully.");
            } else {
                response.sendRedirect("teacher/changeTeacherPassword.jsp?error=Failed to update password.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacher/changeTeacherPassword.jsp?error=Something went wrong. Try again.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
