<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/style.css">
    <style>
        /* Wrapper for full-height layout */
        .wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Main content styling */
        .main-content {
            margin-left: 250px; /* Ensure content does not go behind sidebar */
            margin-top: 60px;
            padding: 20px;
            flex-grow: 1;
            background: #f4f4f4;
        }

        /* Footer */
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

<%
    // Retrieve admin name from session
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("../adminLogin.jsp"); // Redirect to login if session expired
        return;
    }
%>

<div class="wrapper">
    <!-- Include Admin Header -->
    <jsp:include page="includes/header.jsp" />

    <div class="d-flex">
        <!-- Include Sidebar -->
        <jsp:include page="includes/sidebar.jsp" />
</div>
        <!-- Main Content -->
        <div class="main-content container-fluid">
            <h2 class="mb-4">Add New Course</h2>

            <div class="row">
                <div class="col-md-10 offset-md-1 bg-white p-4 shadow-sm rounded">
                    <form action="../AddCourseServlet" method="post">
                        <div class="mb-3">
                            <label class="form-label">Course Name:</label>
                            <input type="text" name="course_name" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description:</label>
                            <textarea name="description" class="form-control" rows="3" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Duration:</label>
                            <input type="text" name="duration" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Fee (₹):</label>
                            <input type="number" name="fee" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Assign Teacher:</label>
                            <select name="teacher_id" class="form-select" required>
                                <option value="">-- Select Teacher --</option>
                                <%
                                    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms", "root", "root");
                                         PreparedStatement stmt = conn.prepareStatement("SELECT tid, tname FROM teacher");
                                         ResultSet rs = stmt.executeQuery()) {
                                        
                                        while (rs.next()) {
                                %>
                                <option value="<%= rs.getInt("tid") %>"><%= rs.getString("tname") %></option>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                %>
                                <option value="">Error loading teachers</option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Last Date to Enroll:</label>
                            <input type="date" name="last_date_to_enroll" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Course Start Date:</label>
                            <input type="date" name="start_date" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-primary">Add Course</button>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
