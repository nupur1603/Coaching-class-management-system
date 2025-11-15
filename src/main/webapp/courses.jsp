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
    <title>Courses | ABC Coaching Classes</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <style>
        /* Global Styles */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background: #f4f4f4;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Header */
        .header {
            background: #007bff;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .logo img {
            width: 40px;
            margin-right: 10px;
        }

        .header-buttons a {
            margin-left: 10px;
        }

        /* Course Section */
        .courses-section {
            width: 90%;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        .courses-section h2 {
            color: #007bff;
            text-align: center;
            margin-bottom: 20px;
        }

        .table {
            width: 100%;
            margin-top: 20px;
        }

        /* Footer */
        .footer {
            background: #222;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }

        .footer a {
            color: #00bfff;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <div class="header">
        <div class="logo">
            <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo">
            ABC Coaching Classes
        </div>
        <div class="header-buttons">
            <a href="index.jsp" class="btn btn-light">🏠 Home</a>
            <a href="adminLogin.jsp" class="btn btn-light">Admin Login</a>
            <a href="teacherLogin.jsp" class="btn btn-light">Teacher Login</a>
            <a href="studentLogin.jsp" class="btn btn-light">Student Login</a>
        </div>
    </div>

    <!-- Courses Section -->
    <div class="courses-section">
        <h2>Available Courses</h2>
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Course Name</th>
                    <th>Description</th>
                    <th>Duration</th>
                    <th>Fee (₹)</th>
                    <th>Teacher</th>
                    <th>Last Date to Enroll</th> <!-- New Column -->
                    <th>Start Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                        // Fetch courses with teacher names & last date to enroll
                        String sql = "SELECT c.id, c.course_name, c.description, c.duration, c.fee, c.last_date_to_enroll, c.start_date,"+ 
                        	       "t.tname AS teacher_name "+
                        	       "FROM course c "+
                        	       "LEFT JOIN teacher t ON c.teacher_id = t.tid";
                        stmt = conn.prepareStatement(sql);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getString("duration") %></td>
                    <td>₹<%= rs.getDouble("fee") %></td>
                    <td><%= (rs.getString("teacher_name") != null) ? rs.getString("teacher_name") : "Not Assigned" %></td>
                    <td><%= rs.getDate("last_date_to_enroll") %></td>
                    <td><%= rs.getDate("start_date") %></td>  <!-- Display last date -->
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

    <!-- Footer -->
    <div class="footer">
        <p>📍 Address: 123, Main Street, City, Country</p>
        <p>📞 Phone: +123-456-7890 | ✉️ Email: <a href="mailto:info@coachingclass.com">info@coachingclass.com</a></p>
        <p>&copy; 2024 ABC Coaching Classes. All rights reserved.</p>
    </div>

    <!-- Bootstrap Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
