<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherId") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }

    int teacherId = (Integer) sessionObj.getAttribute("teacherId");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Test</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    
    <style>
        .main-content {
            margin-left: 250px; /* Adjust based on sidebar width */
            padding: 20px;
            width: calc(100% - 250px);
            margin-top: 80px;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <jsp:include page="includes/sidebar.jsp" />

    <div class="main-content">
        <h2 class="text-center">Schedule a Test</h2>

        <!-- Show success/error messages -->
        <% String message = request.getParameter("message"); %>
        <% if (message != null) { %>
            <div class="alert alert-success"><%= message %></div>
        <% } %>
        
        <% String error = request.getParameter("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="../ScheduleTestServlet" method="POST">
            <div class="mb-3">
                <label class="form-label">Select Course:</label>
                <select name="courseId" class="form-control" required>
                    <option value="">-- Select Course --</option>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                            String query = "SELECT id, course_name FROM course WHERE teacher_id=?";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            stmt.setInt(1, teacherId);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id") %>"><%= rs.getString("course_name") %></option>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Test Topic:</label>
                <input type="text" name="topic" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Test Date:</label>
                <input type="date" name="testDate" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Test Time:</label>
                <input type="time" name="testTime" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Total Marks:</label>
                <input type="number" name="marks" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary">Schedule Test</button>
        </form>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
