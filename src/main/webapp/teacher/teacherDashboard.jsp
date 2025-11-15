<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherName") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }
    
    String teacherName = (String) sessionObj.getAttribute("teacherName");
    int teacherId = (Integer) sessionObj.getAttribute("teacherId");

    // Database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    int courseCount = 0;
    int studentCount = 0;
    int testCount = 0;  // New variable for test count
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Get the number of courses assigned to the teacher
        String courseQuery = "SELECT COUNT(*) FROM course WHERE teacher_id=?";
        stmt = conn.prepareStatement(courseQuery);
        stmt.setInt(1, teacherId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            courseCount = rs.getInt(1);
        }
        rs.close();
        stmt.close();
        
        // Get the number of students enrolled in the teacher's courses
        String studentQuery = "SELECT COUNT(DISTINCT e.student_id) " +
                      "FROM enroll_courses e " +
                      "JOIN course c ON e.course_id = c.id " +
                      "WHERE c.teacher_id = ?";

        stmt = conn.prepareStatement(studentQuery);
        stmt.setInt(1, teacherId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            studentCount = rs.getInt(1);
        }
        rs.close();
        stmt.close();
        
        // Get the number of tests scheduled by the teacher
        String testQuery = "SELECT COUNT(*) FROM test WHERE teacher_id=?";
        stmt = conn.prepareStatement(testQuery);
        stmt.setInt(1, teacherId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            testCount = rs.getInt(1);
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
    <title>Teacher Dashboard - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
   <style>
    /* Main Content */
    .main-content {
        margin-left: 260px;
        margin-top: 80px;
        padding: 20px;
    }

    /* Dashboard Container */
    .dashboard-container {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
        margin-top: 20px;
    }

    /* Modern Dashboard Cards */
    .dashboard-card {
        background: white;
        width: 220px;
        height: 140px;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 2px 4px 8px rgba(0, 0, 0, 0.1);
        text-align: center;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        cursor: pointer;
    }

    /* Card Borders for Differentiation */
    .courses-card { border-top: 5px solid #4A90E2; } /* Blue */
    .students-card { border-top: 5px solid #50C878; } /* Green */
    .tests-card { border-top: 5px solid #FFAA00; } /* Orange */

    /* Hover Effects */
    .dashboard-card:hover {
        transform: translateY(-5px);
        box-shadow: 4px 6px 12px rgba(0, 0, 0, 0.2);
    }

    .dashboard-card h3 {
        color: #333;
        font-size: 18px;
        margin-bottom: 8px;
        font-weight: 600;
    }

    .dashboard-card p {
        font-size: 24px;
        font-weight: bold;
        color: #333;
        margin: 0;
    }

    /* Number Highlight on Hover */
    .dashboard-card p:hover {
        color: #007bff;
    }
</style>

</head>
<body>

<%-- Include Teacher Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<!-- Main Content -->
<div class="main-content">
    <h2>Teacher Dashboard</h2>

    <div class="dashboard-container">
        <!-- Total Courses Assigned -->
        <div class="dashboard-card courses-card" onclick="location.href='teacherCourses.jsp'">
            <h3><i class="bi bi-book"></i> Total Assigned Courses</h3>
            <p><%= courseCount %></p>
        </div>

        <!-- Total Students Enrolled -->
        <div class="dashboard-card students-card" onclick="location.href='teacherStudents.jsp'">
            <h3><i class="bi bi-people"></i> Total Students Enrolled</h3>
            <p><%= studentCount %></p>
        </div>

        <!-- Total Tests Scheduled -->
        <div class="dashboard-card tests-card" onclick="location.href='manageTest.jsp'">
            <h3><i class="bi bi-clipboard-check"></i> Total Tests Scheduled</h3>
            <p><%= testCount %></p>
        </div>
    </div>
</div>

<%-- Include Footer --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
