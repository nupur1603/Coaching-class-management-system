<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page import="java.time.LocalDate" %>

<%
    // Check if student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }
    
    String studentName = (String) sessionObj.getAttribute("studentName");
    Integer studentId = (Integer) session.getAttribute("studentId");

    // Database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Student Data
    String name = "", email = "", phone = "", address = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch Student Details
        String studentQuery = "SELECT sname, smail, sphone, saddr FROM student WHERE sid = ?";
        stmt = conn.prepareStatement(studentQuery);
        stmt.setInt(1, studentId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("sname");
            email = rs.getString("smail");
            phone = rs.getString("sphone");
            address = rs.getString("saddr");
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
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
            margin-left: 250px;
            margin-top: 60px;
            padding: 20px;
            flex-grow: 1;
            background: #f4f4f4;
        }

        .container {
            margin-left: 260px;
            padding: 20px;
        }
        
    </style>
    <script>
        function fetchCourseDetails() {
            var selectedOption = document.getElementById("courseDropdown").selectedOptions[0];
            document.getElementById("fee").value = selectedOption.getAttribute("data-fee");
            document.getElementById("start_date").value = selectedOption.getAttribute("data-start-date");
            document.getElementById("teacher").value = selectedOption.getAttribute("data-teacher");
        }
    </script>

</head>
<body>

<%-- Include Admin Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>
<!-- Main Content -->
<div class="container mt-5 mb-5 pb-5">

        <h2 class="text-center text-primary">Course Enrollment</h2>
        
        <form action="enrollProcess.jsp" method="post">
            <!-- Hidden Field for Student ID -->
            <input type="hidden" name="student_id" value="<%= studentId %>">
            
            <!-- Student Details (Auto-filled) -->
            <div class="mb-3">
                <label>Name</label>
                <input type="text" class="form-control" value="<%= name %>" readonly>
            </div>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" class="form-control" value="<%= email %>" readonly>
            </div>
            <div class="mb-3">
                <label>Phone</label>
                <input type="text" class="form-control" value="<%= phone %>" readonly>
            </div>
            <div class="mb-3">
                <label>Address</label>
                <textarea class="form-control" readonly><%= address %></textarea>
            </div>

            <!-- College & Class Details (User Input) -->
            <div class="mb-3">
                <label>College Name</label>
                <input type="text" class="form-control" name="college_name" required>
            </div>
            <div class="mb-3">
                <label>Year of Study</label>
                <select class="form-control" name="class_year" required>
                    <option value="1st Year">1st Year</option>
                    <option value="2nd Year">2nd Year</option>
                    <option value="3rd Year">3rd Year</option>
                </select>
            </div>

            <!-- Course Selection -->
            <div class="mb-3">
                <label>Select Course</label>
                <select class="form-control" id="courseDropdown" name="course_id" onchange="fetchCourseDetails()" required>
                    <option value="">-- Select Course --</option>
                    <%
                        try {
                            String courseQuery = "SELECT id, course_name, fee, start_date, teacher_id, last_date_to_enroll, (SELECT tname FROM teacher WHERE tid = course.teacher_id) AS teacher_name FROM course WHERE last_date_to_enroll >= ?";
                            stmt = conn.prepareStatement(courseQuery);
                            stmt.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
                            rs = stmt.executeQuery();
                            
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id") %>"
                        data-fee="<%= rs.getDouble("fee") %>"
                        data-start-date="<%= rs.getDate("start_date") %>"
                        data-teacher="<%= rs.getString("teacher_name") %>">
                        <%= rs.getString("course_name") %> (Last Date: <%= rs.getDate("last_date_to_enroll") %>)
                    </option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>

            <!-- Auto-filled Course Details -->
            <div class="mb-3">
                <label>Course Fee (₹)</label>
                <input type="text" class="form-control" id="fee" readonly>
            </div>
            <div class="mb-3">
                <label>Start Date</label>
                <input type="text" class="form-control" id="start_date" readonly>
            </div>
            <div class="mb-3">
                <label>Teacher</label>
                <input type="text" class="form-control" id="teacher" readonly>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100">Enroll</button>
        </form>
    </div>


<%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
