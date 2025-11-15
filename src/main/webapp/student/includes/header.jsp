<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
// Check if student is logged in
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
    response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
    return;
}

String studentName = (String) sessionObj.getAttribute("studentName");

%>
<!-- Header -->
<div class="header">
    <div class="logo">
        <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo" width="40">
        <span style="margin-left: 10px; font-size: 22px;">ABC Coaching Classes</span>
    </div>

    <div class="dropdown">
        <button class="student-dropdown dropdown-toggle" data-bs-toggle="dropdown">
            Welcome, <%= studentName %>
        </button>
        <ul class="dropdown-menu">
            <li><a class="dropdown-item text-danger" href="../logoutServlet">Logout</a></li>
        </ul>
    </div>
</div>

