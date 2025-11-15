<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if admin is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }
    String adminName = (String) sessionObj.getAttribute("adminName");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    // Handle form submission
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword.equals(confirmPassword)) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                // Verify current password
                String sql = "SELECT password FROM admin WHERE username=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, adminName);
                rs = stmt.executeQuery();

                if (rs.next() && rs.getString("password").equals(currentPassword)) {
                    // Update the password
                    String updateSql = "UPDATE admin SET password=? WHERE username=?";
                    stmt = conn.prepareStatement(updateSql);
                    stmt.setString(1, newPassword);
                    stmt.setString(2, adminName);
                    int updated = stmt.executeUpdate();

                    if (updated > 0) {
                        message = "<div class='alert alert-success'>Password updated successfully!</div>";
                    } else {
                        message = "<div class='alert alert-danger'>Failed to update password.</div>";
                    }
                } else {
                    message = "<div class='alert alert-danger'>Current password is incorrect.</div>";
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "<div class='alert alert-danger'>An error occurred.</div>";
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        } else {
            message = "<div class='alert alert-danger'>New passwords do not match!</div>";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="includes/style.css">
    
</head>
<body>

<%-- Include Admin Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<div class="container mt-5 pt-5">

    <h2 class="text-center">Change Password</h2>
    
    <%= message %>

    <form action="changeAdminPassword.jsp" method="post" class="w-50 mx-auto">
        <div class="mb-3">
            <label class="form-label">Current Password</label>
            <input type="password" name="currentPassword" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">New Password</label>
            <input type="password" name="newPassword" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Confirm New Password</label>
            <input type="password" name="confirmPassword" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Change Password</button>
    </form>
    
    <div class="text-center mt-3">
        <a href="adminDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</div>
<%-- Include Admin Header --%>
<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
