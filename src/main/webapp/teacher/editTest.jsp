<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("teacherId") == null) {
        response.sendRedirect("../teacherLogin.jsp?error=Please log in first.");
        return;
    }

    int teacherId = (Integer) sessionObj.getAttribute("teacherId");
    String testIdStr = request.getParameter("id");

    if (testIdStr == null) {
        response.sendRedirect("manageTest.jsp?error=Invalid test ID.");
        return;
    }

    int testId = Integer.parseInt(testIdStr);
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String topic = "", testDate = "", testTime = "";
    int marks = 0, courseId = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        String query = "SELECT * FROM test WHERE id = ? AND teacher_id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, testId);
        stmt.setInt(2, teacherId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            courseId = rs.getInt("course_id");
            topic = rs.getString("topic");
            testDate = rs.getString("test_date");
            testTime = rs.getString("test_time");
            marks = rs.getInt("marks");
        } else {
            response.sendRedirect("manageTest.jsp?error=Test not found.");
            return;
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
<html>
<head>
        <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Test</title>
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    
    <style>
        .main-content {
            margin-left: 250px; /* Adjust based on sidebar width */
            padding: 20px;
            width: calc(100% - 250px);
            margin-top: 80px;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <jsp:include page="includes/sidebar.jsp" />

    <div class="main-content">
        <h2 class="text-center">Edit Test</h2>

        <form action="../EditTestServlet" method="POST">
            <input type="hidden" name="testId" value="<%= testId %>">
            <input type="hidden" name="courseId" value="<%= courseId %>">

            <div class="mb-3">
                <label class="form-label">Topic:</label>
                <input type="text" name="topic" class="form-control" value="<%= topic %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Test Date:</label>
                <input type="date" name="testDate" class="form-control" value="<%= testDate %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Test Time:</label>
                <input type="time" name="testTime" class="form-control" value="<%= testTime %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Marks:</label>
                <input type="number" name="marks" class="form-control" value="<%= marks %>" required>
            </div>

            <button type="submit" class="btn btn-primary">Update Test</button>
        </form>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
