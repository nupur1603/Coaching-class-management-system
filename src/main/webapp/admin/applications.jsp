<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*" %>

<%
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
    response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
    return;
}
String adminName = (String) sessionObj.getAttribute("adminName");

// Database Connection Details
String jdbcURL = "jdbc:mysql://localhost:3306/cms";
String dbUser = "root";
String dbPassword = "root";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    // Fetch student enrollments
    String sql = "SELECT s.sid AS student_id, s.sname, " +
                 "e.class_year, e.college_name, " +
                 "c.course_name, c.duration, c.fee, c.start_date, " +
                 "(SELECT tname FROM teacher WHERE tid = c.teacher_id) AS teacher_name " +
                 "FROM enroll_courses e " +
                 "INNER JOIN student s ON e.student_id = s.sid " +
                 "INNER JOIN course c ON e.course_id = c.id";

    stmt = conn.prepareStatement(sql);
    rs = stmt.executeQuery();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Applications - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="includes/style.css">


    <style>

        /* Main Content */
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 20px;
            flex-grow: 1;
            background: #f4f4f4;
        }

        /* Table Styling */
        .table-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #007bff;
            color: white;
            padding: 10px;
            text-align: center;
            font-size: 16px;
        }

        .table td {
            padding: 10px;
            text-align: center;
            font-size: 14px;
            border-bottom: 1px solid #ddd;
        }

        .table tr:hover {
            background: #f8f9fa;
        }

      
    </style>
</head>
<body>

<%-- Include Admin Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>


<!-- Main Content -->
<div class="main-content">
    <div class="container table-container">
        <h2 class="text-center mb-4">📋 Student Course Enrollments</h2>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Class</th>
                    <th>College</th>
                    <th>Course Name</th>
                    <th>Duration</th>
                    <th>Fee (₹)</th>
                    <th>Start Date</th>
                    <th>Teacher</th>
                </tr>
            </thead>
            <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("student_id") %></td>
                    <td><%= rs.getString("sname") %></td>
                    <td><%= rs.getString("class_year") %></td>
                    <td><%= rs.getString("college_name") %></td>
                    <td><%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("duration") %></td>
                    <td>₹<%= rs.getDouble("fee") %></td>
                    <td><%= rs.getDate("start_date") %></td>
                    <td><%= rs.getString("teacher_name") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>


<%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
