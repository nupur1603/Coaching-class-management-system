<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
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
    <title>View Timetable - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/style.css">
     <style>
        /* Ensure the content is correctly positioned */
        /* Main Content */
.main-content {
    margin-left: 250px;
    margin-top: 60px;
    padding: 20px;
    flex-grow: 1;
    background: #f4f4f4;
}

    </style>
</head>
<body>

<div class="d-flex">

<%-- Include Admin Header --%>
<jsp:include page="includes/header.jsp" />

    
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
    
<div class="main-content container">
    <h2 class="text-center">Timetable Management</h2>

    <!-- Create Timetable Button -->
    <div class="text-end mb-3">
        <a href="createTimetable.jsp" class="btn btn-primary">
            ➕ Create Timetable
        </a>
    </div>

    <table class="table table-bordered text-center">
        <thead class="table-dark">
            <tr>
                <th>Course Name</th>
                <th>Teacher</th>
                <th>Day</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Meeting Link</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                    String query = "SELECT t.id, c.course_name, tr.tname, t.day_of_week, t.start_time, t.end_time, t.meeting_link " +
                                   "FROM timetable t " +
                                   "JOIN course c ON t.course_id = c.id " +
                                   "JOIN teacher tr ON t.teacher_id = tr.tid";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("course_name") %></td>
                <td><%= rs.getString("tname") %></td>
                <td><%= rs.getString("day_of_week") %></td>
                <td><%= rs.getString("start_time") %></td>
                <td><%= rs.getString("end_time") %></td>
                <td><a href="<%= rs.getString("meeting_link") %>" target="_blank">Join Meeting</a></td>
                <td>
                    <a href="editTimetable.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="deleteTimetable.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
                </td>
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
