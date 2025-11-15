<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession"%>

<%
    // Check if student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    String studentName = (String) sessionObj.getAttribute("studentName");
    int studentId = (Integer) sessionObj.getAttribute("studentId");

    // ✅ Declare variables outside try block
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Enrolled Courses - ABC Coaching</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
<style>

.main-container {
    display: flex;
    justify-content: center; /* Centers horizontally */
    align-items: center; /* Centers vertically */
    height: calc(100vh - 80px); /* Adjust height to fit under the header */
    margin-left: 260px; /* Ensures it does not go behind the sidebar */
    padding: 20px;
}

/* Centering the container */
.container {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    max-width: 1100px;
    width: 100%;
    text-align: center; /* Centers the text inside */
}


table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

table, th, td {
	border: 1px solid #ddd;
}

th, td {
	padding: 10px;
	text-align: center;
}

th {
	background: #007bff;
	color: white;
}

.unenroll {
	background: #dc3545;
	padding: 8px 12px;
	border-radius: 5px;
	color: white;
	text-decoration: none;
}

.unenroll:hover {
	background: #a71d2a;
}

</style>
</head>
<body>

	<%-- Include Student Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>
	<!-- Main Content -->
	<div class="main-container">
	  <div class="container">
		<h2>📚 My Enrolled Courses</h2>

		<table>
			<tr>
				<th>Course Name</th>
				<th>Description</th>
				<th>Duration</th>
				<th>Fee (₹)</th>
				<th>Start Date</th>
				<th>Teacher</th>
				<th>College</th>
				<th>Class Year</th>
				<th>Action</th>
			</tr>

			<%
            try {
                // ✅ Connect to the database
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms", "root", "root");
                String sql = "SELECT c.course_name, c.description, c.duration, c.fee, c.start_date, " +
                             "(SELECT tname FROM teacher WHERE tid = c.teacher_id) AS teacher_name, " +
                             "e.college_name, e.class_year, e.course_id " +
                             "FROM enroll_courses e " +
                             "INNER JOIN course c ON e.course_id = c.id " +
                             "WHERE e.student_id = ?";
                             
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, studentId);
                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
			<tr>
				<td><%= rs.getString("course_name") %></td>
				<td><%= rs.getString("description") %></td>
				<td><%= rs.getString("duration") %></td>
				<td>₹<%= rs.getDouble("fee") %></td>
				<td><%= rs.getDate("start_date") %></td>
				<td><%= rs.getString("teacher_name") %></td>
				<td><%= rs.getString("college_name") %></td>
				<td><%= rs.getString("class_year") %></td>
				<td><a
					href="unenroll.jsp?course_id=<%= rs.getInt("course_id") %>"
					class="unenroll">Unenroll</a></td>
			</tr>
			<%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
		</table>
		</div>
	</div>

	<%-- Include Footer --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
