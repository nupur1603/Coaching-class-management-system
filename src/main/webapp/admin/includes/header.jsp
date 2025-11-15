<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
        response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
        return;
    }
    String adminName = (String) sessionObj.getAttribute("adminName");
%>
 <!-- Header -->
<div class="header">
    <div class="logo">
        <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo">
        <span style="margin-left: 10px; font-size: 22px;">ABC Coaching Classes</span>
    </div>

    <div class="dropdown">
        <button class="admin-dropdown dropdown-toggle" data-bs-toggle="dropdown">
            Welcome, <%=adminName%>
        </button>
        <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="changeAdminPassword.jsp">Change Password</a></li>
            <li><a class="dropdown-item" href="adminDetails.jsp">Show Admin Details</a></li>
            <li><a class="dropdown-item text-danger" href="../logoutServlet">Logout</a></li>
        </ul>
    </div>
</div>

