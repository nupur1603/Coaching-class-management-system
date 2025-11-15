<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }
    
    String studentName = (String) sessionObj.getAttribute("studentName");
    int studentId = (Integer) sessionObj.getAttribute("studentId");

    // Database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    int totalCourses = 0;
    int enrolledCourses = 0;
    double totalFeesPending = 0.0; // Amount student still needs to pay

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Get total courses available
        String totalCoursesQuery = "SELECT COUNT(*) FROM course";
        stmt = conn.prepareStatement(totalCoursesQuery);
        rs = stmt.executeQuery();
        if (rs.next()) {
            totalCourses = rs.getInt(1);
        }
        rs.close();
        stmt.close();

        // Get total courses student is enrolled in
        String enrolledQuery = "SELECT COUNT(*) FROM enroll_courses WHERE student_id=?";
        stmt = conn.prepareStatement(enrolledQuery);
        stmt.setInt(1, studentId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            enrolledCourses = rs.getInt(1);
        }
        rs.close();
        stmt.close();
        
        // Get total pending fees
        String feesPendingQuery = "SELECT SUM(c.fee) FROM enroll_courses e JOIN course c ON e.course_id = c.id WHERE e.student_id=? AND e.fees = 0";
        stmt = conn.prepareStatement(feesPendingQuery);
        stmt.setInt(1, studentId);
        rs = stmt.executeQuery();
        if (rs.next() && rs.getDouble(1) > 0) {
            totalFeesPending = rs.getDouble(1);
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
    <title>Student Dashboard - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        .main-content {
            margin-left: 260px;
            margin-top: 80px;
            padding: 20px;
        }

        .dashboard-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .dashboard-card {
            width: 220px;
            height: 180px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            transition: all 0.3s ease-in-out;
            cursor: pointer;
        }

        .card-courses { background: linear-gradient(135deg, #4CAF50, #2E7D32); }
        .card-enrollments { background: linear-gradient(135deg, #2196F3, #1565C0); }
        .card-fees { background: linear-gradient(135deg, #FF9800, #E65100); }
        .card-timetable { background: linear-gradient(135deg, #9C27B0, #6A1B9A); }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.3);
        }

        .dashboard-card i {
            font-size: 40px;
            margin-bottom: 10px;
        }

        .dashboard-card h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .dashboard-card p {
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />
<div class="d-flex">
    <jsp:include page="includes/sidebar.jsp" />
</div>

<div class="main-content">
    <h2>Student Dashboard</h2>

    <div class="dashboard-container">
        <div class="dashboard-card card-courses" onclick="window.location.href='totalCourses.jsp'">
            <i class="bi bi-book"></i>
            <h3>Total Courses</h3>
            <p><%= totalCourses %></p>
        </div>

        <div class="dashboard-card card-enrollments" onclick="window.location.href='viewEnrolledCourses.jsp'">
            <i class="bi bi-list-check"></i>
            <h3>My Enrollments</h3>
            <p><%= enrolledCourses %></p>
        </div>

        <div class="dashboard-card card-fees" onclick="window.location.href='payFees.jsp'">
            <i class="bi bi-cash-stack"></i>
            <h3>Pending Fees</h3>
            <p>₹<%= totalFeesPending %></p>
        </div>
        
        <div class="dashboard-card card-timetable" onclick="window.location.href='viewTimetable.jsp'">
            <i class="bi bi-calendar"></i>
            <h3>Timetable</h3>
            <p>Check Now</p>
        </div>

    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>