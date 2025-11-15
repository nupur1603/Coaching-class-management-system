<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherId") == null) {
        response.sendRedirect("teacherLogin.jsp?error=Please log in first.");
        return;
    }

    int teacherId = (Integer) sessionObj.getAttribute("teacherId");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String tname = "", tphone = "", tmail = "", taddr = "", tuser = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch teacher details
        String query = "SELECT tname, tphone, tmail, taddr, tuser FROM teacher WHERE tid=?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, teacherId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            tname = rs.getString("tname");
            tphone = rs.getString("tphone");
            tmail = rs.getString("tmail");
            taddr = rs.getString("taddr");
            tuser = rs.getString("tuser");
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
    <title>Teacher Profile - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 80px;
            max-width: 600px;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .info-box {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        .btn-dashboard {
            background: #28a745;
            color: white;
            font-weight: bold;
        }
        .btn-dashboard:hover {
            background: #218838;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="text-center">Teacher Profile</h2>

    <div class="info-box">
        <strong>Name:</strong> <%= tname %>
    </div>

    <div class="info-box">
        <strong>Phone:</strong> <%= tphone %>
    </div>

    <div class="info-box">
        <strong>Email:</strong> <%= tmail %>
    </div>

    <div class="info-box">
        <strong>Address:</strong> <%= taddr %>
    </div>

    <div class="info-box">
        <strong>Username:</strong> <%= tuser %>
    </div>

    <div class="mt-3 text-center">
        <a href="teacherDashboard.jsp" class="btn btn-dashboard w-100">Back to Dashboard</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
