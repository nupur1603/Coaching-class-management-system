<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherName") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }
    
    int teacherId = (Integer) sessionObj.getAttribute("teacherId");

    // Database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrolled Students - Teacher Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    <style>
        /* Adjust main content to prevent overlap */
        .main-content {
            margin-left: 260px; 
            margin-top: 80px; 
            padding: 20px;
            background: #f8f9fa;
        }
    </style>
</head>
<body>

<%-- Include Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<!-- Main Content -->
<div class="main-content">
    <h2 class="mb-4">Enrolled Students</h2>

    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Course Enrolled</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                        // Fetch students enrolled in the teacher's courses
                        String query = "SELECT s.sid, s.sname, s.smail, c.course_name " +
                                       "FROM enroll_courses e " +
                                       "JOIN student s ON e.student_id = s.sid " +
                                       "JOIN course c ON e.course_id = c.id " +
                                       "WHERE c.teacher_id = ?";
                        
                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, teacherId);
                        rs = stmt.executeQuery();

                        boolean hasStudents = false;
                        while (rs.next()) {
                            hasStudents = true;
                %>
                            <tr>
                                <td><%= rs.getInt("sid") %></td>
                                <td><%= rs.getString("sname") %></td>
                                <td><%= rs.getString("smail") %></td>
                                <td><%= rs.getString("course_name") %></td>
                            </tr>
                <%
                        }
                        if (!hasStudents) {
                %>
                            <tr>
                                <td colspan="4" class="text-danger">No students enrolled yet.</td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<%-- Include Footer --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
