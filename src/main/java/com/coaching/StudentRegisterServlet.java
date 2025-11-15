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

@WebServlet("/StudentRegisterServlet")
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String sname = request.getParameter("name");
        String sphone = request.getParameter("phone");
        String smail = request.getParameter("email");
        String saddr = request.getParameter("address");
        String suser = request.getParameter("username");
        String spass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");

        // Check if passwords match
        if (!spass.equals(confirmPass)) {
            response.sendRedirect("studentRegister.jsp?message=Passwords do not match!");
            return;
        }

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/cms"; // Change 'cms' if DB name is different
        String dbUser = "root"; // Change this to your MySQL username
        String dbPassword = "root"; // Change this to your MySQL password

        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish Database Connection
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Check if username already exists
            String checkUserQuery = "SELECT * FROM student WHERE suser=?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery);
            checkStmt.setString(1, suser);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Username already taken
                response.sendRedirect("studentRegister.jsp?message=Username already exists. Choose another.");
                return;
            }

            // Insert student data into database
            String insertQuery = "INSERT INTO student (sname, sphone, smail, saddr, suser, spass) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(insertQuery);
            stmt.setString(1, sname);
            stmt.setString(2, sphone);
            stmt.setString(3, smail);
            stmt.setString(4, saddr);
            stmt.setString(5, suser);
            stmt.setString(6, spass);

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                // Registration successful
                response.sendRedirect("studentLogin.jsp?message=Registration successful! Please log in.");
            } else {
                response.sendRedirect("studentRegister.jsp?message=Registration failed. Please try again.");
            }

            // Close resources
            stmt.close();
            checkStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentRegister.jsp?message=Database Connection Failed: " + e.getMessage());
        }
    }
}
