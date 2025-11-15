<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        .container {
            width: 400px;
            margin: 100px auto;
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
        input[type="password"] {
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
        <h2>Change Password</h2>
        <form action="ChangePasswordServlet" method="post">
            <label for="spass">New Password:</label>
            <input type="password" id="spass" name="spass" required>

            <label for="confirm_spass">Confirm Password:</label>
            <input type="password" id="confirm_spass" name="confirm_spass" required>

            <div class="buttons">
                <input type="submit" value="Change Password">
                <a href="student/dashboard.jsp">Back to Dashboard</a>
            </div>
        </form>
    </div>
</body>
</html>
