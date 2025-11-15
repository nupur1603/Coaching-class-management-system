<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*"%>

<%
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
    response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
    return;
}
String adminName = (String) sessionObj.getAttribute("adminName");

String sid = request.getParameter("sid");

String jdbcURL = "jdbc:mysql://localhost:3306/cms";
String dbUser = "root";
String dbPassword = "root";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String sname = "", sphone = "", smail = "", saddr = "", suser = "", spass = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

    String sql = "SELECT * FROM student WHERE sid = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, sid);
    rs = stmt.executeQuery();

    if (rs.next()) {
        sname = rs.getString("sname");
        sphone = rs.getString("sphone");
        smail = rs.getString("smail");
        saddr = rs.getString("saddr");
        suser = rs.getString("suser");  // Added Username
        spass = rs.getString("spass");  // Added Password
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
<title>Edit Student - ABC Coaching</title>
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
<div class="container mt-5">
<div class="card">
    <h2 class="text-center">Edit Student Details</h2>
    
    <form action="updateStudent.jsp" method="POST">
        <input type="hidden" name="sid" value="<%= sid %>">
        
        <div class="mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="sname" class="form-control" value="<%= sname %>" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" name="sphone" class="form-control" value="<%= sphone %>" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="smail" class="form-control" value="<%= smail %>" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Address</label>
            <input type="text" name="saddr" class="form-control" value="<%= saddr %>" required>
        </div>

        <!-- ✅ Added Username Field -->
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="suser" class="form-control" value="<%= suser %>" required>
        </div>

        <!-- ✅ Added Password Field -->
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="spass" class="form-control" value="<%= spass %>" required>
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="manageStudents.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
    </div>
</div>

<%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
