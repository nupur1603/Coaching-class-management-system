<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Check if teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherId") == null) {
        response.sendRedirect("teacherLogin.jsp?error=Please log in first.");
        return;
    }

    String errorMsg = request.getParameter("error");
    String successMsg = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 80px;
            max-width: 450px;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .btn-submit {
            background: #007bff;
            color: white;
            font-weight: bold;
        }
        .btn-submit:hover {
            background: #0056b3;
        }
        .btn-back {
            background: #6c757d;
            color: white;
        }
        .btn-back:hover {
            background: #5a6268;
        }
    </style>

    <script>
        function validateForm() {
            let newPass = document.getElementById("newPassword").value;
            let confirmPass = document.getElementById("confirmPassword").value;

            if (newPass !== confirmPass) {
                alert("New password and Confirm password do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

<div class="container">
    <h2 class="text-center">Change Password</h2>

    <% if (errorMsg != null) { %>
        <div class="alert alert-danger"><%= errorMsg %></div>
    <% } %>

    <% if (successMsg != null) { %>
        <div class="alert alert-success"><%= successMsg %></div>
    <% } %>

    <form action="../ChangeTeacherPasswordServlet" method="post" onsubmit="return validateForm();">
        <div class="mb-3">
            <label class="form-label">Current Password</label>
            <input type="password" name="currentPassword" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">New Password</label>
            <input type="password" id="newPassword" name="newPassword" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-submit w-100">Change Password</button>

        <div class="mt-3 text-center">
            <a href="teacherDashboard.jsp" class="btn btn-back w-100">Back to Dashboard</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
