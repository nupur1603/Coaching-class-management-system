<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherId") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }

    int teacherId = (Integer) sessionObj.getAttribute("teacherId");

    // Database Connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - View Test Results</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        .main-content {
            margin-left: 260px; 
            margin-top: 80px;
            padding: 20px;
        }
        .table-container {
            margin-top: 20px;
        }
        .table thead {
            background-color: #007bff;
            color: white;
        }
        .no-results {
            color: red;
            font-size: 18px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<!-- Main Content -->
<div class="main-content">
    <h2 class="text-center">Students' Test Results</h2>

    <div class="table-container">
        <table class="table table-bordered text-center">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Student Name</th>
                    <th>Test Name</th>
                    <th>Total Marks Obtained</th>
                    <th>Attempt Time</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                        String query = "SELECT str.id, s.sname AS student_name, t.topic AS test_name, " +
                                       "str.total_marks_obtained, str.attempt_time " +
                                       "FROM student_test_results str " +
                                       "JOIN student s ON str.student_id = s.sid " +
                                       "JOIN test t ON str.test_id = t.id " +
                                       "WHERE t.teacher_id = ?";

                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, teacherId);
                        rs = stmt.executeQuery();

                        boolean hasResults = false;
                        while (rs.next()) {
                            hasResults = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("student_name") %></td>
                    <td><%= rs.getString("test_name") %></td>
                    <td><%= rs.getInt("total_marks_obtained") %></td>
                    <td><%= rs.getTimestamp("attempt_time") %></td>
                </tr>
                <%
                        }
                        if (!hasResults) {
                %>
                <tr>
                    <td colspan="5" class="no-results">No students have attempted tests yet.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
