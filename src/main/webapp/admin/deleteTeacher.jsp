<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*"%>

<%
    // Check if admin is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }

    // Get teacher ID from request
    String tid = request.getParameter("tid");

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

        // Check if the teacher exists before deleting
        String checkSql = "SELECT COUNT(*) FROM teacher WHERE tid = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, tid);
        ResultSet rs = checkStmt.executeQuery();
        rs.next();
        int count = rs.getInt(1);
        rs.close();
        checkStmt.close();

        if (count == 0) {
            response.sendRedirect("manageTeachers.jsp?error=Teacher not found.");
            return;
        }

        // Delete the teacher
        String deleteSql = "DELETE FROM teacher WHERE tid = ?";
        stmt = conn.prepareStatement(deleteSql);
        stmt.setString(1, tid);

        int rowsDeleted = stmt.executeUpdate();

        if (rowsDeleted > 0) {
            response.sendRedirect("manageTeachers.jsp?success=Teacher deleted successfully");
        } else {
            response.sendRedirect("manageTeachers.jsp?error=Failed to delete teacher.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageTeachers.jsp?error=Something went wrong: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
