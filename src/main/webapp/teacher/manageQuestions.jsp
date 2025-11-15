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
    <title>Manage Test Questions</title>
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
        .form-container {
            margin-top: 20px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            background: white;
        }
        .form-control {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp" />
<div class="d-flex">
    <jsp:include page="includes/sidebar.jsp" />
</div>

<!-- Main Content -->
<div class="main-content">
    <h2>Manage Test Questions</h2>

    <!-- Select Test Dropdown -->
    <form method="GET">
        <label for="testId" class="form-label">Select Test:</label>
        <select name="testId" class="form-control" onchange="this.form.submit()">
            <option value="">-- Select a Test --</option>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                    String testQuery = "SELECT id, topic, test_date FROM test WHERE teacher_id=?";
                    stmt = conn.prepareStatement(testQuery);
                    stmt.setInt(1, teacherId);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int testId = rs.getInt("id");
                        String topic = rs.getString("topic");
                        String testDate = rs.getString("test_date");
            %>
            <option value="<%= testId %>" <%= request.getParameter("testId") != null && Integer.parseInt(request.getParameter("testId")) == testId ? "selected" : "" %>>
                <%= topic %> - <%= testDate %>
            </option>
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
        </select>
    </form>

    <% 
        int selectedTestId = request.getParameter("testId") != null ? Integer.parseInt(request.getParameter("testId")) : 0;
        if (selectedTestId > 0) {
    %>

    <!-- Add Question Form -->
    <div class="form-container">
        <h4>Add Question</h4>
        <form action="../AddQuestionServlet" method="POST">
            <input type="hidden" name="testId" value="<%= selectedTestId %>">
            <label>Question:</label>
            <textarea name="questionText" class="form-control" required></textarea>
            <label>Option A:</label>
            <input type="text" name="optionA" class="form-control" required>
            <label>Option B:</label>
            <input type="text" name="optionB" class="form-control" required>
            <label>Option C:</label>
            <input type="text" name="optionC" class="form-control" required>
            <label>Option D:</label>
            <input type="text" name="optionD" class="form-control" required>
            <label>Correct Option:</label>
            <select name="correctOption" class="form-control" required>
                <option value="A">Option A</option>
                <option value="B">Option B</option>
                <option value="C">Option C</option>
                <option value="D">Option D</option>
            </select>
            <label>Marks:</label>
            <input type="number" name="marks" class="form-control" min="1" required>
            <button type="submit" class="btn btn-success mt-2">Add Question</button>
        </form>
    </div>

    <!-- Display Questions -->
    <div class="table-container">
        <h4>Questions for Selected Test</h4>
        <table class="table table-bordered text-center">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Question</th>
                    <th>Option A</th>
                    <th>Option B</th>
                    <th>Option C</th>
                    <th>Option D</th>
                    <th>Correct Answer</th>
                    <th>Marks</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                        String questionQuery = "SELECT * FROM test_questions WHERE test_id=?";
                        stmt = conn.prepareStatement(questionQuery);
                        stmt.setInt(1, selectedTestId);
                        rs = stmt.executeQuery();

                        boolean hasQuestions = false;
                        while (rs.next()) {
                            hasQuestions = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("question_text") %></td>
                    <td><%= rs.getString("option_a") %></td>
                    <td><%= rs.getString("option_b") %></td>
                    <td><%= rs.getString("option_c") %></td>
                    <td><%= rs.getString("option_d") %></td>
                    <td><%= rs.getString("correct_option") %></td>
                    <td><%= rs.getInt("marks") %></td>
                    <td>
                        <a href="editQuestion.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm">Edit</a>
                        <a href="deleteQuestion.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
                </tr>
                <%
                        }
                        if (!hasQuestions) {
                %>
                <tr>
                    <td colspan="9" class="text-danger">No questions added yet!</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    </div>

    <% } %>

</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
