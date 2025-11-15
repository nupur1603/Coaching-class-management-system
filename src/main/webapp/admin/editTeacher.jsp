<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*"%>

<%
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
	response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
	return;
}
String adminName = (String) sessionObj.getAttribute("adminName");

String tid = request.getParameter("tid");

String jdbcURL = "jdbc:mysql://localhost:3306/cms";
String dbUser = "root";
String dbPassword = "root";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String tname = "", tphone = "", tmail = "", taddr = "", tuser = "", tpass = "";

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

	// FIX: Ensure table name is correct (lowercase `teacher`)
	String sql = "SELECT * FROM teacher WHERE tid = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, tid);
	rs = stmt.executeQuery();

	if (rs.next()) {
		tname = rs.getString("tname");
		tphone = rs.getString("tphone");
		tmail = rs.getString("tmail");
		taddr = rs.getString("taddr");
		tuser = rs.getString("tuser");
		tpass = rs.getString("tpass");
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
<title>Edit Teacher - ABC Coaching</title>
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

/* Form Container */
.card {
	background: white;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
	margin-top: 20px;
}

.card h2 {
	color: #007bff;
}

/* Input Fields */
.form-control {
	border-radius: 5px;
}

/* Buttons */
.btn-primary {
	background: #007bff;
	border: none;
}

.btn-primary:hover {
	background: #0056b3;
}

.btn-secondary {
	background: #6c757d;
	border: none;
}

.btn-secondary:hover {
	background: #545b62;
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
		<div class="card">
			<div class="container mt-5">
				<div class="card">
					<h2 class="text-center">Edit Teacher Details</h2>
					<form action="updateTeacher.jsp" method="POST">
						<!-- FIX: Ensure tid is properly passed in the form -->
						<input type="hidden" name="tid" value="<%= tid %>">

						<div class="mb-3">
							<label class="form-label">Name</label> <input type="text"
								name="tname" class="form-control" value="<%= tname %>" required>
						</div>

						<div class="mb-3">
							<label class="form-label">Phone</label> <input type="text"
								name="tphone" class="form-control" value="<%= tphone %>"
								required>
						</div>

						<div class="mb-3">
							<label class="form-label">Email</label> <input type="email"
								name="tmail" class="form-control" value="<%= tmail %>" required>
						</div>

						<div class="mb-3">
							<label class="form-label">Address</label> <input type="text"
								name="taddr" class="form-control" value="<%= taddr %>" required>
						</div>

						<div class="mb-3">
							<label class="form-label">Username</label> <input type="text"
								name="tuser" class="form-control" value="<%= tuser %>" required>
						</div>

						<div class="mb-3">
							<label class="form-label">Password</label> <input type="password"
								name="tpass" class="form-control" value="<%= tpass %>" required>
						</div>

						<button type="submit" class="btn btn-primary">Update</button>
						<a href="manageTeachers.jsp" class="btn btn-secondary">Cancel</a>
					</form>
				</div>

			</div>
		</div>
	</div>
	>

	<%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
