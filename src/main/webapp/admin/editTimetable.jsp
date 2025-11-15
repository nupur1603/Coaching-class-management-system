<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Get the timetable ID from the request
    String timetableId = request.getParameter("id");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String courseName = "", teacherName = "", day_of_week = "", startTime = "", endTime = "", meetingLink = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch timetable details
        String query = "SELECT t.id, c.course_name, tr.tname, t.day_of_week, t.start_time, t.end_time, t.meeting_link " +
                       "FROM timetable t " +
                       "JOIN course c ON t.course_id = c.id " +
                       "JOIN teacher tr ON t.teacher_id = tr.tid " +
                       "WHERE t.id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(timetableId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            courseName = rs.getString("course_name");
            teacherName = rs.getString("tname");
            day_of_week = rs.getString("day_of_week");
            startTime = rs.getString("start_time");
            endTime = rs.getString("end_time");
            meetingLink = rs.getString("meeting_link");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Timetable - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/style.css">
    <style>
        .container {
            max-width: 600px;
            margin: auto;
            margin-top: 80px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />

    <div class="container">
        <h2 class="text-center">Edit Timetable</h2>

        <form action="../EditTimetableServlet" method="post">
            <input type="hidden" name="id" value="<%= timetableId %>">

            <div class="mb-3">
                <label class="form-label">Course Name</label>
                <input type="text" class="form-control" value="<%= courseName %>" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label">Teacher Name</label>
                <input type="text" class="form-control" value="<%= teacherName %>" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label">Day</label>
                <select name="day_of_week" class="form-select" required>
                    <option value="Monday" <%= day_of_week.equals("Monday") ? "selected" : "" %>>Monday</option>
                    <option value="Tuesday" <%= day_of_week.equals("Tuesday") ? "selected" : "" %>>Tuesday</option>
                    <option value="Wednesday" <%= day_of_week.equals("Wednesday") ? "selected" : "" %>>Wednesday</option>
                    <option value="Thursday" <%= day_of_week.equals("Thursday") ? "selected" : "" %>>Thursday</option>
                    <option value="Friday" <%= day_of_week.equals("Friday") ? "selected" : "" %>>Friday</option>
                    <option value="Saturday" <%= day_of_week.equals("Saturday") ? "selected" : "" %>>Saturday</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Start Time</label>
                <input type="time" name="start_time" class="form-control" value="<%= startTime %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">End Time</label>
                <input type="time" name="end_time" class="form-control" value="<%= endTime %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Zoom Meeting Link</label>
                <input type="url" name="meeting_link" class="form-control" value="<%= meetingLink %>" required>
            </div>

            <button type="submit" class="btn btn-success">Update Timetable</button>
            <a href="viewTimetableAdmin.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
