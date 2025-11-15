<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherName") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }
    String teacherName = (String) sessionObj.getAttribute("teacherName");
%>
 <!-- Header -->
<div class="header">
    <div class="logo">
        <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo">
        <span style="margin-left: 10px; font-size: 22px;">ABC Coaching Classes</span>
    </div>

    <div class="dropdown">
        <button class="admin-dropdown dropdown-toggle" data-bs-toggle="dropdown">
            Welcome, <%=teacherName%>
        </button>
        <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="changeTeacherPassword.jsp">Change Password</a></li>
            <li><a class="dropdown-item" href="teacherProfile.jsp">Show Details</a></li>
            <li><a class="dropdown-item text-danger" href="../logoutServlet">Logout</a></li>
        </ul>
    </div>
</div>

