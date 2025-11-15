<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if the teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherName") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }

    Integer teacherId = (Integer) sessionObj.getAttribute("teacherId");

    if (teacherId == null) {
        out.println("<p style='color: red;'>Error: Teacher ID not found in session!</p>");
        return;
    }

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
    <title>Teacher Courses - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        /* Adjusting layout */
        .main-content {
            margin-left: 260px;
            margin-top: 80px;
            padding: 20px;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

       /* Table Styling */
.table-container {
    max-height: 500px;
    overflow-y: auto;
    border-radius: 10px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
}

table {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 🔥 Gradient Header */
thead th {
    background: linear-gradient(90deg, #333, #000); /* Black Gradient */
    color: white !important ;
    font-weight: bold;
    text-align: center;
    padding: 12px;
    font-color: white;
    font-size: 16px;
}

/* Cell Styling */
td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid #ddd;
}

/* Alternate Row Colors */
tbody tr:nth-child(even) {
    background-color: #f8f9fa;
}

tbody tr:nth-child(odd) {
    background-color: #ffffff;
}

/* Hover Effect */
tbody tr:hover {
    background-color: #ffe6cc;
    transition: 0.3s;
}

/* Rounded Borders for Table */
.table-responsive {
    border-radius: 10px;
    overflow: hidden;
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
        <h2 class="text-center text-primary">Courses Assigned to You</h2>

        <div class="table-responsive table-container">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Course Name</th>
                        <th>Description</th>
                        <th>Duration</th>
                        <th>Fee</th>
                        <th>Created At</th>
                        <th>Last Date to Enroll</th>
                        <th>Start Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            // Establish database connection
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                            // Query to fetch teacher's courses
                            String sql = "SELECT id, course_name, description, duration, fee, created_at, last_date_to_enroll, start_date FROM course WHERE teacher_id=?";
                            stmt = conn.prepareStatement(sql);
                            stmt.setInt(1, teacherId);
                            rs = stmt.executeQuery();

                            // Check if there are any courses assigned
                            boolean hasCourses = false;
                            while (rs.next()) {
                                hasCourses = true;
                    %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td><%= rs.getString("course_name") %></td>
                                    <td><%= rs.getString("description") %></td>
                                    <td><%= rs.getString("duration") %></td>
                                    <td>₹<%= rs.getDouble("fee") %></td>
                                    <td><%= rs.getString("created_at") %></td>
                                    <td><%= rs.getString("last_date_to_enroll") %></td>
                                    <td><%= rs.getString("start_date") %></td>
                                </tr>
                    <%
                            }
                            if (!hasCourses) {
                    %>
                                <tr>
                                    <td colspan="8" class="text-center text-danger">No courses found!</td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                            <tr>
                                <td colspan="8" class="text-danger">Error fetching course data!</td>
                            </tr>
                    <%
                        } finally {
                            // Close resources
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
