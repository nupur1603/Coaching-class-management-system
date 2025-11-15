<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*" %>

<%
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
    response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
    return;
}
String adminName = (String) sessionObj.getAttribute("adminName");

String jdbcURL = "jdbc:mysql://localhost:3306/cms";
String dbUser = "root";
String dbPassword = "root";

int studentCount = 0, teacherCount = 0, courseCount = 0, applicationCount = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    PreparedStatement studentStmt = conn.prepareStatement("SELECT COUNT(*) FROM student");
    ResultSet studentRs = studentStmt.executeQuery();
    if (studentRs.next()) {
        studentCount = studentRs.getInt(1);
    }

    PreparedStatement teacherStmt = conn.prepareStatement("SELECT COUNT(*) FROM teacher");
    ResultSet teacherRs = teacherStmt.executeQuery();
    if (teacherRs.next()) {
        teacherCount = teacherRs.getInt(1);
    }

    PreparedStatement courseStmt = conn.prepareStatement("SELECT COUNT(*) FROM course");
    ResultSet courseRs = courseStmt.executeQuery();
    if (courseRs.next()) {
        courseCount = courseRs.getInt(1);
    }

    PreparedStatement applicationStmt = conn.prepareStatement("SELECT COUNT(*) FROM enroll_courses");
    ResultSet applicationRs = applicationStmt.executeQuery();
    if (applicationRs.next()) {
        applicationCount = applicationRs.getInt(1);
    }

    studentRs.close();
    studentStmt.close();
    teacherRs.close();
    teacherStmt.close();
    courseRs.close();
    courseStmt.close();
    applicationRs.close();
    applicationStmt.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Coaching Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/style.css">

    <style>
        /* Main Content */
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 20px;
            flex-grow: 1;
            background: #f4f4f4;
        }

/* Modern Dashboard Card Styles */
.dashboard-cards {
    display: flex;
    justify-content: center;
    gap: 25px;
    margin-top: 50px;
}

.card {
    width: 230px;
    height: 140px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    border-radius: 12px;
    background: #ffffff; /* White background */
    box-shadow: 2px 4px 8px rgba(0, 0, 0, 0.1); /* Soft shadow */
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
}

/* Different Card Colors (Muted & Professional) */
.students { border-top: 5px solid #4A90E2; }
.teachers { border-top: 5px solid #50C878; }
.courses { border-top: 5px solid #FFAA00; }
.applications { border-top: 5px solid #FF6F61; }

/* Hover Effects */
.card:hover {
    transform: translateY(-5px); /* Lift effect */
    box-shadow: 4px 6px 12px rgba(0, 0, 0, 0.2);
}

/* Icon Styling */
.card h3 {
    font-size: 18px;
    color: #333;
    margin-bottom: 8px;
    font-weight: 600;
}

.card p {
    font-size: 24px;
    font-weight: bold;
    color: #333;
    margin: 0;
}

/* Making the number stand out */
.card p:hover {
    color: #007bff;
}

    </style>
</head>
<body>

<%-- Include Admin Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="dashboard-cards">
    <!-- Total Students -->
    <div class="card students" onclick="location.href='manageStudents.jsp'">
        <h3><i class="bi bi-people"></i> Total Students</h3>
        <p><%= studentCount %></p>
    </div>

    <!-- Total Teachers -->
    <div class="card teachers" onclick="location.href='manageTeachers.jsp'">
        <h3><i class="bi bi-person-badge"></i> Total Teachers</h3>
        <p><%= teacherCount %></p>
    </div>

    <!-- Total Courses -->
    <div class="card courses" onclick="location.href='manageCourses.jsp'">
        <h3><i class="bi bi-book"></i> Total Courses</h3>
        <p><%= courseCount %></p>
    </div>

    <!-- Total Applications -->
    <div class="card applications" onclick="location.href='applications.jsp'">
        <h3><i class="bi bi-clipboard-check"></i> Total Applications</h3>
        <p><%= applicationCount %></p>
    </div>
</div>

</div>

<%-- Include Footer --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
