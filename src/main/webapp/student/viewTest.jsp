<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentId") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    int studentId = (Integer) sessionObj.getAttribute("studentId");

    // Database Connection
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
    <title>View Tests</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        .main-content {
            margin-left: 250px;
            padding: 20px;
            width: calc(100% - 250px);
            margin-top: 80px;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />

    <div class="main-content">
        <h2 class="text-center">Scheduled Tests</h2>

        <table class="table table-bordered text-center">
            <thead class="table-dark">
    <tr>
        <th>Course Name</th>
        <th>Test Topic</th>
        <th>Date</th>
        <th>Time</th>
        <th>Marks</th>
        <th>Action</th>  <%-- NEW COLUMN --%>
    </tr>
</thead>
<tbody>
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Fetch tests for enrolled courses
            String query = "SELECT t.id, t.topic, t.test_date, t.test_time, t.marks, c.course_name " +
                           "FROM test t " +
                           "JOIN enroll_courses e ON t.course_id = e.course_id " +
                           "JOIN course c ON e.course_id = c.id " +
                           "WHERE e.student_id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            boolean hasTests = false;
            while (rs.next()) {
                hasTests = true;
                int testId = rs.getInt("id");  // Get the test ID
    %>
    <tr>
        <td><%= rs.getString("course_name") %></td>
        <td><%= rs.getString("topic") %></td>
        <td><%= rs.getDate("test_date") %></td>
        <td><%= rs.getTime("test_time") %></td>
        <td><%= rs.getInt("marks") %></td>
        <td>
            <a href="startTest.jsp?testId=<%= testId %>" class="btn btn-success btn-sm">Start Test</a>
        </td>  <%-- NEW BUTTON --%>
    </tr>
    <%
            }
            if (!hasTests) {
    %>
    <tr>
        <td colspan="6" class="text-danger">No upcoming tests scheduled.</td>
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

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
