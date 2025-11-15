<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentId") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    int studentId = (Integer) sessionObj.getAttribute("studentId");

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
    <title>My Test Results</title>
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
    <h2 class="text-center">My Test Results</h2>

    <div class="table-container">
        <table class="table table-bordered text-center">
            <thead class="table-dark">
                <tr>
                    <th>Test Name</th>
                    <th>Total Marks</th>
                    <th>Marks Obtained</th>
                    <th>Result Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                        String query = "SELECT t.topic, r.total_marks_obtained, " +
                                       "(SELECT SUM(marks) FROM test_questions WHERE test_id = r.test_id) AS total_marks " +
                                       "FROM student_test_results r " +
                                       "JOIN test t ON r.test_id = t.id " +
                                       "WHERE r.student_id = ?";

                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, studentId);
                        rs = stmt.executeQuery();

                        boolean hasResults = false;
                        while (rs.next()) {
                            hasResults = true;
                            int totalMarks = rs.getInt("total_marks");  // Dynamically calculated
                            int marksObtained = rs.getInt("total_marks_obtained");
                            String status = (marksObtained >= (totalMarks / 2)) ? "<span class='text-success'>Passed</span>" : "<span class='text-danger'>Failed</span>";
                %>
                <tr>
                    <td><%= rs.getString("topic") %></td>
                    <td><%= totalMarks %></td>
                    <td><%= marksObtained %></td>
                    <td><%= status %></td>
                </tr>
                <%
                        }
                        if (!hasResults) {
                %>
                <tr>
                    <td colspan="4" class="no-results">No test results available yet.</td>
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
