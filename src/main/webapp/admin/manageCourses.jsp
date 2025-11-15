<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Courses - Admin Dashboard</title>

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
        
        /* Add Course Button */
        .add-course-btn {
            margin-bottom: 20px;
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
        <h2>Manage Courses</h2>

        <!-- Add Course Button -->
        <a href="addCourse.jsp" class="btn btn-primary add-course-btn">
            <i class="bi bi-plus-circle"></i> Add Course
        </a>

        <!-- Course Table -->
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Course Name</th>
                    <th>Description</th>
                    <th>Duration</th>
                    <th>Fee</th>
                    <th>Teacher</th>
                    <th>Last Date to Enroll</th>
                    <th>Start Date</th> <!-- New Column -->
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <%
                // Database connection
                String jdbcURL = "jdbc:mysql://localhost:3306/cms";
                String dbUser = "root";
                String dbPassword = "root";

                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                    // Fetch courses with teacher name, last date to enroll, and start date
                    String sql = "SELECT c.course_name, c.description, c.duration, c.fee, c.last_date_to_enroll, c.start_date, " +
                                 "t.tname AS teacher_name, c.id FROM course c " +
                                 "LEFT JOIN teacher t ON c.teacher_id = t.tid";

                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getString("duration") %></td>
                    <td>₹<%= rs.getDouble("fee") %></td>
                    <td><%= (rs.getString("teacher_name") != null) ? rs.getString("teacher_name") : "Not Assigned" %></td>
                    <td><%= rs.getDate("last_date_to_enroll") %></td> <!-- Display Last Date to Enroll -->
                    <td><%= rs.getDate("start_date") %></td> <!-- Display Start Date -->
                    <td><a href="editCourse.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm"><i class="bi bi-pencil"></i></a></td>
                    <td><a href="deleteCourse.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this course?');">
                        <i class="bi bi-trash"></i>
                    </a></td>
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
    <%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
