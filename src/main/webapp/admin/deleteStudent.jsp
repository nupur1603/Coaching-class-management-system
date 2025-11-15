<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*"%>

<%
    // Check if admin is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }

    // Get student ID from request
    String sid = request.getParameter("sid");

    // Database credentials
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Load MySQL driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // SQL query to delete student
        String sql = "DELETE FROM student WHERE sid = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, sid);

        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("manageStudents.jsp?success=Student deleted successfully.");
        } else {
            response.sendRedirect("manageStudents.jsp?error=Student not found.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageStudents.jsp?error=Error deleting student.");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
