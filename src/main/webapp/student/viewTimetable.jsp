<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    int studentId = (Integer) sessionObj.getAttribute("studentId");

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
    <title>View Timetable - Student</title>

    <%-- Bootstrap and Styles --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        .main-content {
    margin-left: 250px; /* Adjust based on sidebar width */
    padding: 20px;
    width: calc(100% - 250px);
    overflow-x: auto; /* Enable scrolling if content overflows */
    margin-top: 70px; /* Add margin to push content below the header */
}


        /* Fix table responsiveness */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        thead {
            background-color: #343a40;
            color: white;
        }
    </style>
</head>
<body>

<%-- Include Header --%>
<jsp:include page="includes/header.jsp" />

<div class="container-fluid">
    <div class="row">

        <%-- Sidebar Section (Left Side) --%>
        <div class="col-md-2 sidebar">
            <jsp:include page="includes/sidebar.jsp" />
        </div>

        <%-- Main Content Section (Right Side) --%>
        <div class="main-content">
            <h2 class="text-center">My Timetable</h2>

            <div class="table-responsive">
                <table class="table table-bordered text-center">
                    <thead class="table-dark">
                        <tr>
                            <th>Course Name</th>
                            <th>Day</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Meeting Link</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                                String query = "SELECT c.course_name, t.day_of_week, t.start_time, t.end_time, t.meeting_link " +
                                               "FROM enroll_courses e " +
                                               "JOIN timetable t ON e.course_id = t.course_id " +
                                               "JOIN course c ON t.course_id = c.id " +
                                               "WHERE e.student_id = ?";

                                stmt = conn.prepareStatement(query);
                                stmt.setInt(1, studentId);
                                rs = stmt.executeQuery();

                                boolean hasTimetable = false;
                                while (rs.next()) {
                                    hasTimetable = true;
                        %>
                        <tr>
                            <td><%= rs.getString("course_name") %></td>
                            <td><%= rs.getString("day_of_week") %></td>
                            <td><%= rs.getString("start_time") %></td>
                            <td><%= rs.getString("end_time") %></td>
                            <td><a href="<%= rs.getString("meeting_link") %>" target="_blank">Join Meeting</a></td>
                        </tr>
                        <%
                                }
                                if (!hasTimetable) {
                        %>
                        <tr>
                            <td colspan="5" class="text-danger">No timetable available.</td>
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
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
