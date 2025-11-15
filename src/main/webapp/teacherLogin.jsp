<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Login - Coaching Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
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

        .dropdown button {
            background: white;
            color: #007bff;
            font-weight: bold;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            border-radius: 5px;
        }

        .dropdown button:hover {
            background: #e0e0e0;
        }

        /* Login Section */
        .login-container {
            width: 40%;
            margin: 100px auto;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .login-container h2 {
            color: #007bff;
            margin-bottom: 20px;
        }

        .form-control {
            margin-bottom: 15px;
            font-size: 18px;
            padding: 10px;
        }

        .btn-login {
            background: #007bff;
            color: white;
            font-weight: bold;
            width: 100%;
            padding: 12px;
            font-size: 18px;
            border-radius: 5px;
        }

        .btn-login:hover {
            background: #0056b3;
        }

        /* Footer */
        .footer {
            background: #222;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }

        .footer p {
            margin: 5px;
            font-size: 14px;
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
            <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo"> ABC Coaching Classes
        </div>
        <div class="dropdown">
            <button class="dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Login As</button>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="adminLogin.jsp">Admin</a></li>
                <li><a class="dropdown-item" href="teacherLogin.jsp">Teacher</a></li>
                <li><a class="dropdown-item" href="studentLogin.jsp">Student</a></li>
            </ul>
        </div>
    </div>

    <!-- Teacher Login Section -->
    <div class="login-container">
        <h2>Teacher Login</h2>

        <%-- Show error message if login fails --%>
        <% String error = request.getParameter("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="TeacherLoginServlet" method="post">
            <input type="text" name="tuser" class="form-control" placeholder="Enter Username" required>
            <input type="password" name="tpass" class="form-control" placeholder="Enter Password" required>
            <button type="submit" class="btn btn-login">Login</button>
        </form>
        <div class="register-link">
            <p>Not registered? <a href="teacherRegister.jsp">Sign up here</a></p>
        </div>
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
