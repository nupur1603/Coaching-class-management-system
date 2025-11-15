<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Enrollment Successful</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 50px;
            background-color: #f4f4f4;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin: auto;
        }
        h2 {
            color: green;
        }
        a {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 15px;
            text-decoration: none;
            background: #007bff;
            color: white;
            border-radius: 5px;
        }
        a:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>🎉 Enrollment Successful!</h2>
        <p>You have successfully enrolled in the course.</p>
        <a href="viewEnrolledCourses.jsp">View My Courses</a>
        <a href="courseList.jsp" style="background: #28a745;">Enroll in Another Course</a>
    </div>

</body>
</html>
