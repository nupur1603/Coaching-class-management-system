<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*"%>

<%
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("adminName") == null) {
	response.sendRedirect("../adminLogin.jsp?error=Please log in first.");
	return;
}

// Get form data
String tid = request.getParameter("tid");
String tname = request.getParameter("tname");
String tphone = request.getParameter("tphone");
String tmail = request.getParameter("tmail");
String taddr = request.getParameter("taddr");
String tuser = request.getParameter("tuser");
String tpass = request.getParameter("tpass");

// Database credentials
String jdbcURL = "jdbc:mysql://localhost:3306/cms";
String dbUser = "root";
String dbPassword = "root";

Connection conn = null;
PreparedStatement stmt = null;

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

	// Update student details
	String sql = "UPDATE teacher SET tname=?, tphone=?, tmail=?, taddr=?, tuser=?, tpass=? WHERE tid=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, tname);
	stmt.setString(2, tphone);
	stmt.setString(3, tmail);
	stmt.setString(4, taddr);
	stmt.setString(5, tuser);
	stmt.setString(6, tpass);
	stmt.setString(7, tid);

	int rowsUpdated = stmt.executeUpdate();

	if (rowsUpdated > 0) {
		response.sendRedirect("manageTeachers.jsp?success=Teacher details updated successfully");
	} else {
		response.sendRedirect("editTeacher.jsp?tid=" + tid + "&error=Failed to update student details");
	}

} catch (Exception e) {
	e.printStackTrace();
	response.sendRedirect("editTeacher.jsp?tid=" + tid + "&error=Something went wrong");
} finally {
	if (stmt != null) stmt.close();
	if (conn != null) conn.close();
}
%>
