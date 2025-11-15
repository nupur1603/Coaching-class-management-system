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

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/cms"; // Change 'cms' if DB name is different
        String dbUser = "root"; // Change this to your MySQL username
        String dbPassword = "root"; // Change this to your MySQL password

        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish Database Connection
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Prepare SQL query
            String sql = "SELECT * FROM admin WHERE username=? AND password=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Login Successful → Store Admin info in session
                HttpSession session = request.getSession();
                session.setAttribute("adminName", rs.getString("aname"));
                response.sendRedirect("admin/adminDashboard.jsp"); // Redirect to Admin Dashboard
            } else {
                // Login Failed → Redirect back to login page with error message
                response.sendRedirect("adminLogin.jsp?error=Invalid Username or Password");
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminLogin.jsp?error=Database Connection Failed" + e.getMessage());
        }
    }
}
