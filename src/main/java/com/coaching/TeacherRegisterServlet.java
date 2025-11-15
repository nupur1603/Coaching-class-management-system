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

@WebServlet("/TeacherRegisterServlet")
public class TeacherRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tname = request.getParameter("tname");
        String tphone = request.getParameter("tphone");
        String tmail = request.getParameter("tmail");
        String taddr = request.getParameter("taddr");
        String tuser = request.getParameter("tuser");
        String tpass = request.getParameter("tpass");
        String confirmPass = request.getParameter("confirmPassword");

        if (!tpass.equals(confirmPass)) {
            response.sendRedirect("teacherRegister.jsp?message=Passwords do not match!");
            return;
        }

        String jdbcURL = "jdbc:mysql://localhost:3306/cms";
        String dbUser = "root";
        String dbPassword = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String checkUserQuery = "SELECT * FROM teacher WHERE tuser=?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUserQuery);
            checkStmt.setString(1, tuser);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.sendRedirect("teacherRegister.jsp?message=Username already exists.");
                return;
            }

            String insertQuery = "INSERT INTO teacher (tname, tphone, tmail, taddr, tuser, tpass) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(insertQuery);
            stmt.setString(1, tname);
            stmt.setString(2, tphone);
            stmt.setString(3, tmail);
            stmt.setString(4, taddr);
            stmt.setString(5, tuser);
            stmt.setString(6, tpass);

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("teacherLogin.jsp?message=Registration successful!");
            } else {
                response.sendRedirect("teacherRegister.jsp?message=Registration failed.");
            }

            stmt.close();
            checkStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacherRegister.jsp?message=Database Connection Failed");
        }
    }
}
