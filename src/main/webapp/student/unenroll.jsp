<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentId") == null) {
        response.sendRedirect("studentLogin.jsp?error=Please log in first.");
        return;
    }

    // Get studentId from session
    int studentId = (Integer) sessionObj.getAttribute("studentId");

    // Get course_id from URL
    String courseIdParam = request.getParameter("course_id");

    if (courseIdParam != null) {
        int courseId = Integer.parseInt(courseIdParam);

        // Database connection setup
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms", "root", "root");

            // Delete the course only if it belongs to the logged-in student
            String sql = "DELETE FROM enroll_courses WHERE course_id = ? AND student_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, courseId);
            stmt.setInt(2, studentId);
            
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Redirect to enrolled courses page with success message
                response.sendRedirect("viewEnrolledCourses.jsp?message=Successfully unenrolled.");
            } else {
                // Redirect if course is not found or doesn't belong to the student
                response.sendRedirect("viewEnrolledCourses.jsp?error=Course not found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewEnrolledCourses.jsp?error=Something went wrong.");
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("viewEnrolledCourses.jsp?error=Invalid course ID.");
    }
%>
