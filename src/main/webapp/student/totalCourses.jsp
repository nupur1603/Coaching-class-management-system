<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>All Courses - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        .main-content {
            margin-left: 260px; /* Matches sidebar width */
            margin-top: 80px; /* Matches header height */
            padding: 20px;
        }
    </style>
</head>
<body>

    <%-- Include Header --%>
    <jsp:include page="includes/header.jsp" />

    <div class="d-flex">
        <%-- Include Sidebar --%>
        <jsp:include page="includes/sidebar.jsp" />

        <%-- Main Content Section --%>
        <div class="main-content container">
            <h2 class="text-center">All Courses</h2>

            <table class="table table-bordered text-center">
                <thead class="table-dark">
                    <tr>
                        <th>Course Name</th>
                        <th>Description</th>
                        <th>Duration</th>
                        <th>Fee</th>
                        <th>Teacher</th>
                        <th>Last Date to Enroll</th>
                        <th>Start Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                            String query = "SELECT c.course_name, c.description, c.duration, c.fee, t.tname AS teacher_name, " +
                                           "c.last_date_to_enroll, c.start_date " +
                                           "FROM course c " +
                                           "JOIN teacher t ON c.teacher_id = t.tid";

                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("course_name") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td><%= rs.getString("duration") %></td>
                        <td>₹<%= rs.getDouble("fee") %></td>
                        <td><%= rs.getString("teacher_name") %></td>
                        <td><%= rs.getDate("last_date_to_enroll") %></td>
                        <td><%= rs.getDate("start_date") %></td>
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
