<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure teacher is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherId") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }

    int teacherId = (Integer) sessionObj.getAttribute("teacherId");

    // Database connection details
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
    <title>Manage Tests</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    <style>
        .main-content {
            margin-left: 250px; /* Adjust based on sidebar width */
            padding: 20px;
            width: calc(100% - 250px);
            margin-top: 80px; /* Fix header overlap */
        }
        .table th, .table td {
            vertical-align: middle;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <jsp:include page="includes/sidebar.jsp" />

    <div class="main-content">
        <h2 class="text-center mb-4">Manage Tests</h2>

        <!-- Schedule Test Button -->
        <div class="text-end mb-3">
            <a href="scheduleTest.jsp" class="btn btn-primary">
                ➕ Schedule Test
            </a>
        </div>

        <table class="table table-bordered text-center">
            <thead class="table-dark">
                <tr>
                    <th>Course Name</th>
                    <th>Test Topic</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Marks</th>
                    <th>Actions</th> <!-- ✅ Added column for Edit/Delete -->
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                        String query = "SELECT t.id, c.course_name, t.topic, t.test_date, t.test_time, t.marks " +
                                       "FROM test t " +
                                       "JOIN course c ON t.course_id = c.id " +
                                       "WHERE t.teacher_id = ?";
                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, teacherId);
                        rs = stmt.executeQuery();

                        boolean hasTests = false;
                        while (rs.next()) {
                            hasTests = true;
                %>
                <tr>
                    <td><%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("topic") %></td>
                    <td><%= rs.getDate("test_date") %></td>
                    <td><%= rs.getTime("test_time") %></td>
                    <td><%= rs.getInt("marks") %></td>
                    <td>
                        <a href="editTest.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm">
                            <i class="bi bi-pencil"></i> Edit
                        </a>
                       <a href="../DeleteTestServlet?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm" 
                       onclick="return confirm('Are you sure you want to delete this test?');">Delete
                       </a>

                    </td>
                </tr>
                <%
                        }
                        if (!hasTests) {
                %>
                <tr>
                    <td colspan="6" class="text-danger">No tests scheduled yet.</td>
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
