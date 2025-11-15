<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Database connection details
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
    <title>Manage Fees</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="includes/style.css">
    <style>
        .container {
    margin-top: 100px;
    margin-left: 250px; /* Adjust according to sidebar width */
    width: calc(100% - 250px); /* Prevent it from shrinking too much */
}
        table {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>

<%-- Include Admin Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />

    <div class="container">
        <h2 class="text-center text-primary">Paid Students List</h2>
        <table class="table table-bordered table-hover text-center">
            <thead class="table-dark">
                <tr>
                    <th>Enrollment ID</th>
                    <th>Student Name</th>
                    <th>Course Name</th>
                    <th>College Name</th>
                    <th>Class Year</th>
                    <th>Enrollment Date</th>
                    <th>Amount Paid</th>
                </tr>
            </thead>
            <tbody>
                <%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        String query = "SELECT e.enrollment_id, s.sname, c.course_name, e.college_name, e.class_year, e.enrollment_date, c.fee AS course_fee " +
                "FROM enroll_courses e " +
                "JOIN student s ON e.student_id = s.sid " +
                "JOIN course c ON e.course_id = c.id " +
                "WHERE e.fees > 0";


        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        boolean hasData = false; // Track if data exists
        while (rs.next()) {
            hasData = true;
%>
            <tr>
                <td><%= rs.getInt("enrollment_id") %></td>
                <td><%= rs.getString("sname") %></td>
                <td><%= rs.getString("course_name") %></td>
                <td><%= rs.getString("college_name") %></td>
                <td><%= rs.getString("class_year") %></td>
                <td><%= rs.getDate("enrollment_date") %></td>
                <td>₹<%= rs.getInt("course_fee") %></td>
            </tr>
<%
        }
        if (!hasData) {
%>
            <tr><td colspan="7" class="text-danger">No paid students found!</td></tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='7' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
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
