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
String sid = request.getParameter("sid");
String sname = request.getParameter("sname");
String sphone = request.getParameter("sphone");
String smail = request.getParameter("smail");
String saddr = request.getParameter("saddr");
String suser = request.getParameter("suser");
String spass = request.getParameter("spass");

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
	String sql = "UPDATE student SET sname=?, sphone=?, smail=?, saddr=?, suser=?, spass=? WHERE sid=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, sname);
	stmt.setString(2, sphone);
	stmt.setString(3, smail);
	stmt.setString(4, saddr);
	stmt.setString(5, suser);
	stmt.setString(6, spass);
	stmt.setString(7, sid);

	int rowsUpdated = stmt.executeUpdate();

	if (rowsUpdated > 0) {
		response.sendRedirect("manageStudents.jsp?success=Student details updated successfully");
	} else {
		response.sendRedirect("editStudent.jsp?sid=" + sid + "&error=Failed to update student details");
	}

} catch (Exception e) {
	e.printStackTrace();
	response.sendRedirect("editStudent.jsp?sid=" + sid + "&error=Something went wrong");
} finally {
	if (stmt != null) stmt.close();
	if (conn != null) conn.close();
}
%>
