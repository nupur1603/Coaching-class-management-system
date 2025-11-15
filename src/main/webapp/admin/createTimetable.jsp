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

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Timetable - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/style.css">
    <style>
        .container {
            max-width: 600px;
            margin: auto;
            margin-top: 100px;
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
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
        <h2 class="text-center">Create Timetable</h2>

        <%-- Show success or error message --%>
        <% String message = request.getParameter("message"); %>
        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>

        <form action="CreateTimetableServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Select Course</label>
                <select name="course_id" class="form-select" required onchange="fetchTeacherId(this)">
                    <option value="">-- Select Course --</option>
                    <%
                        try {
                            String courseQuery = "SELECT id, course_name, teacher_id FROM course";
                            stmt = conn.prepareStatement(courseQuery);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id") %>" data-teacher="<%= rs.getInt("teacher_id") %>">
                        <%= rs.getString("course_name") %>
                    </option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                        }
                    %>
                </select>
            </div>

            <!-- Hidden Teacher ID Field (Auto-filled) -->
            <input type="hidden" name="teacher_id" id="teacher_id">

            <div class="mb-3">
                <label class="form-label">Day</label>
                <select name="day_of_week" class="form-select" required>
                    <option value="Monday">Monday</option>
                    <option value="Tuesday">Tuesday</option>
                    <option value="Wednesday">Wednesday</option>
                    <option value="Thursday">Thursday</option>
                    <option value="Friday">Friday</option>
                    <option value="Saturday">Saturday</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Start Time</label>
                <input type="time" name="start_time" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">End Time</label>
                <input type="time" name="end_time" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Zoom Meeting Link</label>
                <input type="url" name="meeting_link" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary w-100">Create Timetable</button>
        </form>

        <script>
            function fetchTeacherId(select) {
                var selectedCourse = select.options[select.selectedIndex];
                if (selectedCourse) {
                    document.getElementById("teacher_id").value = selectedCourse.getAttribute("data-teacher");
                }
            }
        </script>

    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

<%
    if (conn != null) conn.close();
%>
