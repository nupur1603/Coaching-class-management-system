<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Check if admin is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }

    // Get course ID from request
    String courseId = request.getParameter("id");

    if (courseId == null || courseId.trim().isEmpty()) {
        response.sendRedirect("manageCourses.jsp?error=Invalid course ID");
        return;
    }

    // Database credentials
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL Driver
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Delete the course
        String sql = "DELETE FROM course WHERE id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(courseId));

        int rowsDeleted = stmt.executeUpdate();

        if (rowsDeleted > 0) {
            response.sendRedirect("manageCourses.jsp?success=Course deleted successfully");
        } else {
            response.sendRedirect("manageCourses.jsp?error=Failed to delete course");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageCourses.jsp?error=Something went wrong");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
