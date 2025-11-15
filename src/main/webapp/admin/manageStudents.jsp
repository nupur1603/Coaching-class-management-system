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

// Database Connection Details
String jdbcURL = "jdbc:mysql://localhost:3306/cms";
String dbUser = "root";
String dbPassword = "root";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

	// Fetch All Students
	String sql = "SELECT * FROM student";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
} catch (Exception e) {
	e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Students - ABC Coaching</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="includes/style.css">

<style>
body {
    font-family: Arial, sans-serif;
    height: 100vh;
    margin: 0;
    display: flex;
    flex-direction: column;
}

/* Header */
.header {
    background: #007bff;
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 60px;
    z-index: 1000;
}
.logo img {
    max-width: 150px;  /* Adjust width */
    max-height: 50px;  /* Adjust height */
    object-fit: contain;
}


/* Sidebar */
.sidebar {
    width: 250px;
    background: #343a40;
    color: white;
    height: calc(100vh - 60px);
    position: fixed;
    top: 60px;
    left: 0;
    padding-top: 20px;
}

.sidebar a {
    color: white;
    text-decoration: none;
    display: flex;
    align-items: center;
    padding: 12px 20px;
    font-size: 16px;
}

.sidebar a i {
    margin-right: 10px;
    font-size: 18px;
}

.sidebar a:hover {
    background: #007bff;
}

/* Main Content */
.main-content {
    margin-left: 250px;
    margin-top: 60px;
    padding: 20px;
    flex-grow: 1;
    background: #f4f4f4;
}

/* Table Styling */
.table-container {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    margin-top: 20px;
}

.table {
    width: 100%;
    border-collapse: collapse;
}

.table th {
    background: #007bff;
    color: white;
    padding: 10px;
    text-align: center;
    font-size: 16px;
}

.table td {
    padding: 10px;
    text-align: center;
    font-size: 14px;
    border-bottom: 1px solid #ddd;
}

.table tr:hover {
    background: #f8f9fa;
}

/* Action Buttons */
.action-btns {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.edit-btn, .delete-btn {
    padding: 6px 12px;
    border: none;
    border-radius: 5px;
    text-decoration: none;
    font-weight: bold;
    transition: 0.3s;
}

.edit-btn {
    background: #ffc107;
    color: black;
}

.edit-btn:hover {
    background: #e0a800;
}

.delete-btn {
    background: #dc3545;
    color: white;
}

.delete-btn:hover {
    background: #c82333;
}

/* Footer */
.footer {
    background: #222;
    color: white;
    text-align: center;
    padding: 8px;
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    font-size: 14px;
}

/* Admin Dropdown */
.admin-dropdown {
    background: white;
    color: #007bff;
    font-weight: bold;
    border: 2px solid #007bff;
    padding: 10px 15px;
    cursor: pointer;
    border-radius: 5px;
    transition: 0.3s;
}

.admin-dropdown:hover {
    background: #007bff;
    color: white;
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
    <div class="container table-container">
        <h2 class="text-center mb-4">Manage Students</h2>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Username</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("sid") %></td>
                    <td><%= rs.getString("sname") %></td>
                    <td><%= rs.getString("sphone") %></td>
                    <td><%= rs.getString("smail") %></td>
                    <td><%= rs.getString("saddr") %></td>
                    <td><%= rs.getString("suser") %></td>
                    <td>
                        <a href="editStudent.jsp?sid=<%= rs.getInt("sid") %>" class="edit-btn">Edit</a>
                    </td>
                    <td>
                        <a href="deleteStudent.jsp?sid=<%= rs.getInt("sid") %>" class="delete-btn" 
                           onclick="return confirm('Are you sure you want to delete this student?')">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Footer -->
<%-- Include Footer --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

<% 
// Close connections
if (rs != null) rs.close();
if (stmt != null) stmt.close();
if (conn != null) conn.close();
%>
