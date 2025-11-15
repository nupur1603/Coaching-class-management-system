<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Coaching Management System</title>
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

        /* Registration Form */
        .register-container {
            width: 50%;
            margin: 50px auto;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        .register-container h2 {
            color: #007bff;
            margin-bottom: 20px;
            text-align: center;
        }

        .form-control {
            margin-bottom: 15px;
            font-size: 18px;
            padding: 10px;
        }

        .btn-register {
            background: #007bff;
            color: white;
            font-weight: bold;
            width: 100%;
            padding: 12px;
            font-size: 18px;
            border-radius: 5px;
        }

        .btn-register:hover {
            background: #0056b3;
        }

        /* Error Message */
        .error {
            color: red;
            font-size: 14px;
            margin-bottom: 10px;
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

   <script>
    function validateForm() {
        let password = document.getElementById("password").value;
        let confirmPassword = document.getElementById("confirmPassword").value;
        let phone = document.getElementById("phone").value;
        let errorDiv = document.getElementById("error-message");

        // Password validation
        if (password !== confirmPassword) {
            errorDiv.innerHTML = "Passwords do not match!";
            return false;
        } 
        
        // Phone number validation
        if (!/^\d{10}$/.test(phone)) {
            errorDiv.innerHTML = "Phone number must be exactly 10 digits!";
            return false;
        }

        errorDiv.innerHTML = ""; // Clear error message if everything is valid
        return true;
    }

    function validatePhoneInput(event) {
        let input = event.target;
        input.value = input.value.replace(/\D/g, ''); // Remove non-numeric characters
        
        if (input.value.length > 10) {
            input.value = input.value.slice(0, 10); // Limit to 10 digits
        }
    }
</script>


</head>
<body>

    <!-- Header -->
    <div class="header">
        <div class="logo">
            <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo">
            ABC Coaching Classes
        </div>
    </div>

    <!-- Student Registration Section -->
    <div class="register-container">
        <h2>Student Registration</h2>

        <%-- Show error/success messages if available --%>
        <% String message = request.getParameter("message"); %>
        <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>

        <form action="StudentRegisterServlet" method="post" onsubmit="return validateForm()">
            <input type="text" name="name" class="form-control" placeholder="Full Name" required>
            <input type="text" name="phone" class="form-control" placeholder="Phone Number" required oninput="validatePhoneInput(event)">
            <input type="email" name="email" class="form-control" placeholder="Email ID" required>
            <input type="text" name="address" class="form-control" placeholder="Address" required>
            <input type="text" name="username" class="form-control" placeholder="Choose a Username" required>
            <input type="password" id="password" name="password" class="form-control" placeholder="Create a Password" required>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
            
            <div id="error-message" class="error"></div>
            
            <button type="submit" class="btn btn-register">Register</button>
        </form>
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
