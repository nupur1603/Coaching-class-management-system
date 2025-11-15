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

@WebServlet("/TeacherLoginServlet")
public class TeacherLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get username and password from the login form
        String username = request.getParameter("tuser");
        String password = request.getParameter("tpass");

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/cms"; // Change 'cms' if your DB name is different
        String dbUser = "root"; // Change this to your MySQL username
        String dbPassword = "root"; // Change this to your MySQL password

        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish Database Connection
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Prepare SQL query to check username and password
            String sql = "SELECT * FROM teacher WHERE tuser=? AND tpass=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Login Successful → Store teacher info in session
                HttpSession session = request.getSession();
                session.setAttribute("teacherName", rs.getString("tname"));
                session.setAttribute("teacherId", rs.getInt("tid"));
                
                response.sendRedirect("teacher/teacherDashboard.jsp"); // Redirect to Teacher Dashboard
            } else {
                // Login Failed → Redirect back to login page with error message
                response.sendRedirect("teacherLogin.jsp?error=Invalid Username or Password");
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacherLogin.jsp?error=Database Connection Failed");
        }
    }
}
