<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession"%>

<%
    // Check if admin is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }
    
    String adminName = (String) sessionObj.getAttribute("adminName");
    String courseId = request.getParameter("id");

    if (courseId == null || courseId.trim().isEmpty()) {
        response.sendRedirect("manageCourses.jsp?error=Invalid course ID");
        return;
    }

    // Database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Variables to store course details
    String courseName = "", description = "", duration = "", lastDateToEnroll = "", startDate = "";
    double fee = 0.0;
    int teacherId = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch course details
        String sql = "SELECT * FROM course WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(courseId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            courseName = rs.getString("course_name");
            description = rs.getString("description");
            duration = rs.getString("duration");
            fee = rs.getDouble("fee");
            teacherId = rs.getInt("teacher_id");
            lastDateToEnroll = rs.getString("last_date_to_enroll");
            startDate = rs.getString("start_date"); // Fetch start date
        } else {
            response.sendRedirect("manageCourses.jsp?error=Course not found");
            return;
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageCourses.jsp?error=Something went wrong");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Course</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/style.css">
    <style>
        /* Wrapper ensures the full height layout */
        .wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Main content styling */
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 20px;
            flex-grow: 1;
            background: #f4f4f4;
        }

        /* Footer sticks at the bottom */
        .footer {
            background: #222;
            color: white;
            text-align: center;
            padding: 10px;
            font-size: 14px;
            width: 100%;
            margin-top: auto;
        }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- Include Admin Header -->
    <jsp:include page="includes/header.jsp" />

    <div class="d-flex">
        <!-- Include Sidebar -->
        <jsp:include page="includes/sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content container-fluid">
            <h2 class="mb-4">Edit Course</h2>

            <div class="row">
                <div class="col-md-10 offset-md-1 bg-white p-4 shadow-sm rounded">
                    <form action="../UpdateCourseServlet" method="post">
                        <input type="hidden" name="id" value="<%= courseId %>">

                        <div class="mb-3">
                            <label class="form-label">Course Name:</label>
                            <input type="text" name="course_name" class="form-control" value="<%= courseName %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description:</label>
                            <textarea name="description" class="form-control" rows="3" required><%= description %></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Duration:</label>
                            <input type="text" name="duration" class="form-control" value="<%= duration %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Fee (₹):</label>
                            <input type="number" step="0.01" name="fee" class="form-control" value="<%= fee %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Assign Teacher:</label>
                            <select name="teacher_id" class="form-select" required>
                                <option value="">-- Select Teacher --</option>
                                <%
                                    Connection conn2 = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                                    String teacherQuery = "SELECT tid, tname FROM teacher";
                                    PreparedStatement stmt2 = conn2.prepareStatement(teacherQuery);
                                    ResultSet rs2 = stmt2.executeQuery();

                                    while (rs2.next()) {
                                        int tid = rs2.getInt("tid");
                                        String tname = rs2.getString("tname");
                                %>
                                <option value="<%= tid %>" <%= (tid == teacherId) ? "selected" : "" %>><%= tname %></option>
                                <%
                                    }
                                    rs2.close();
                                    stmt2.close();
                                    conn2.close();
                                %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Last Date to Enroll:</label>
                            <input type="date" name="last_date_to_enroll" class="form-control" value="<%= lastDateToEnroll %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Start Date:</label>
                            <input type="date" name="start_date" class="form-control" value="<%= startDate %>" required>
                        </div>

                        <button type="submit" class="btn btn-primary">Update Course</button>
                        <a href="manageCourses.jsp" class="btn btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        © 2024 ABC Coaching Classes. All rights reserved.
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
