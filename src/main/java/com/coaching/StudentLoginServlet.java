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

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get username and password from the login form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

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
            String sql = "SELECT * FROM student WHERE suser=? AND spass=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Login Successful → Store student info in session
                HttpSession session = request.getSession();
                session.setAttribute("studentName", rs.getString("sname"));
                session.setAttribute("studentId", rs.getInt("sid"));
                
                response.sendRedirect("student/studentDashboard.jsp"); // Redirect to Student Dashboard
            } else {
                // Login Failed → Redirect back to login page with error message
                response.sendRedirect("studentLogin.jsp?error=Invalid Username or Password");
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentLogin.jsp?error=Database Connection Failed");
        }
    }
}
