<%@ page import="java.sql.*" %>

<%
    int studentId = Integer.parseInt(request.getParameter("student_id"));
    int courseId = Integer.parseInt(request.getParameter("course_id"));
    String collegeName = request.getParameter("college_name");
    String classYear = request.getParameter("class_year");

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms", "root", "root");
    PreparedStatement stmt = conn.prepareStatement("INSERT INTO enroll_courses (student_id, course_id, college_name, class_year) VALUES (?, ?, ?, ?)");
    stmt.setInt(1, studentId);
    stmt.setInt(2, courseId);
    stmt.setString(3, collegeName);
    stmt.setString(4, classYear);
    stmt.executeUpdate();

    response.sendRedirect("enrollmentSuccess.jsp");
%>
