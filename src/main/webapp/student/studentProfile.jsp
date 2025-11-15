<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e6f7ff;
        }
        .container {
            width: 500px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
        }
        label {
            display: block;
            margin-top: 15px;
        }
        input[type="text"], input[type="email"], input[type="tel"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }
        .buttons {
            margin-top: 20px;
            text-align: center;
        }
        .buttons input, .buttons a {
            padding: 10px 20px;
            margin: 5px;
            text-decoration: none;
            color: #fff;
            background-color: #4CAF50;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .buttons a {
            background-color: #2196F3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Student Profile</h2>
        <form action="UpdateProfileServlet" method="post">
            <label for="sid">Student ID:</label>
            <input type="text" id="sid" name="sid" value="<%= session.getAttribute("sid") %>" readonly>

            <label for="sname">Name:</label>
            <input type="text" id="sname" name="sname" value="<%= session.getAttribute("sname") %>" required>

            <label for="sphone">Phone:</label>
            <input type="tel" id="sphone" name="sphone" value="<%= session.getAttribute("sphone") %>" required>

            <label for="smail">Email:</label>
            <input type="email" id="smail" name="smail" value="<%= session.getAttribute("smail") %>" required>

            <label for="saddr">Address:</label>
            <input type="text" id="saddr" name="saddr" value="<%= session.getAttribute("saddr") %>" required>

            <label for="suser">Username:</label>
            <input type="text" id="suser" name="suser" value="<%= session.getAttribute("suser") %>" readonly>

            <div class="buttons">
                <input type="submit" value="Update Profile">
                <a href="student/studentDashboard.jsp">Back to Dashboard</a>
            </div>
        </form>
    </div>
</body>
</html>
