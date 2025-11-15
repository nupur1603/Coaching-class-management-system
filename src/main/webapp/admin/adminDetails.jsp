<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession"%>

<%
    // Check if admin is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }
    String adminUsername = (String) sessionObj.getAttribute("adminName");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    // Variables to store admin details
    int adminId = 0;
    String adminName = "";
    String adminPhone = "";
    String adminEmail = "";
    String username = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch admin details
        String sql = "SELECT id, aname, phno, email, username FROM admin WHERE username=?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, adminUsername);
        rs = stmt.executeQuery();

        if (rs.next()) {
            adminId = rs.getInt("id");
            adminName = rs.getString("aname");
            adminPhone = rs.getString("phno");
            adminEmail = rs.getString("email");
            username = rs.getString("username");
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
<title>Admin Dashboard - Coaching Management System</title>
<link rel="stylesheet"href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet"href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="includes/style.css">
<style>

/* Main Content */
.main-content {
    margin-left: 260px; /* Adjust based on sidebar width */
    margin-top: 80px; /* Space for fixed header */
    display: flex;
    justify-content: center; /* Horizontally center */
    align-items: center; /* Vertically center */
    height: calc(100vh - 80px); /* Adjust height based on viewport */
    padding: 20px;
}


/* Increase admin-card size */
.admin-card {
    width: 100%;
    max-width: 500px;
    background: white;
    border-radius: 10px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    text-align: center;
}


.admin-card-header {
	background: #007bff;
	color: white;
	padding: 15px;
	text-align: center;
	font-size: 20px;
	font-weight: bold;
}

.admin-card-body {
	padding: 20px;
}

.admin-detail {
	font-size: 16px;
	margin-bottom: 10px;
	border-bottom: 1px solid #ddd;
	padding-bottom: 8px;
}

.admin-detail strong {
	color: #007bff;
}

.back-btn {
	display: block;
	width: 100%;
	background: #007bff;
	color: white;
	border: none;
	padding: 10px;
	text-align: center;
	font-size: 16px;
	border-radius: 0 0 10px 10px;
	transition: 0.3s;
}

.back-btn:hover {
	background: #0056b3;
}
/* Footer */
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
    <div class="admin-card">
        <div class="admin-card-header">Admin Details</div>
        <div class="admin-card-body">
            <p class="admin-detail"><strong>Admin ID:</strong> <%= adminId %></p>
            <p class="admin-detail"><strong>Name:</strong> <%= adminName %></p>
            <p class="admin-detail"><strong>Phone:</strong> <%= adminPhone %></p>
            <p class="admin-detail"><strong>Email:</strong> <%= adminEmail %></p>
            <p class="admin-detail"><strong>Username:</strong> <%= username %></p>
        </div>
        <a href="adminDashboard.jsp" class="back-btn">Back to Dashboard</a>
    </div>
</div>
<%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
