<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentId") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    int studentId = (Integer) sessionObj.getAttribute("studentId");
    int testId = request.getParameter("testId") != null ? Integer.parseInt(request.getParameter("testId")) : 0;

    // Database Connection
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    boolean testAvailable = false;
    boolean hasAttempted = false;
    String testTopic = "";
    LocalDateTime testDateTime = null;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Check if student has already attempted the test
        String attemptQuery = "SELECT COUNT(*) FROM student_test_results WHERE student_id=? AND test_id=?";
        stmt = conn.prepareStatement(attemptQuery);
        stmt.setInt(1, studentId);
        stmt.setInt(2, testId);
        rs = stmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            hasAttempted = true;
        }
        rs.close();
        stmt.close();

        // Fetch Test Details
        String testQuery = "SELECT topic, CONCAT(test_date, ' ', test_time) AS test_datetime FROM test WHERE id=?";
        stmt = conn.prepareStatement(testQuery);
        stmt.setInt(1, testId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            testTopic = rs.getString("topic");
            testDateTime = LocalDateTime.parse(rs.getString("test_datetime"), formatter);

            // Get Current Date & Time
            LocalDateTime now = LocalDateTime.now();

            // Test should be visible **only if current time >= test time**
            if (!now.isBefore(testDateTime) && !hasAttempted) {
                testAvailable = true;
            }
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Start Test</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">

    <style>
        .main-content {
            margin-left: 260px;
            margin-top: 80px;
            padding: 20px;
        }
    </style>

    <script>
        // Test Timer (1 hour)
        function startTimer(duration, display) {
            let timer = duration, minutes, seconds;
            setInterval(function () {
                minutes = parseInt(timer / 60, 10);
                seconds = parseInt(timer % 60, 10);

                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                display.textContent = minutes + ":" + seconds;

                if (--timer < 0) {
                    document.getElementById("testForm").submit();  // Auto-submit when time is up
                }
            }, 1000);
        }

        window.onload = function () {
            let timeLimit = 60 * 60;  // 1 hour
            let display = document.querySelector("#time");
            startTimer(timeLimit, display);
        };
    </script>
</head>
<body>

<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<!-- Main Content -->
<div class="main-content">
    <h2 class="text-center">Test: <%= testTopic %></h2>

    <% if (hasAttempted) { %>
        <h4 class="text-danger text-center">You have already attempted this test. You cannot retake it.</h4>
    <% } else if (!testAvailable) { %>
        <h4 class="text-danger text-center">Test is not yet available.</h4>
    <% } else { %>
        <h5 class="text-center text-danger">Time Left: <span id="time">60:00</span></h5>

        <form action="../SubmitTestServlet" method="POST" id="testForm">
            <input type="hidden" name="testId" value="<%= testId %>">

            <%
                try {
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                    String questionQuery = "SELECT * FROM test_questions WHERE test_id=?";
                    stmt = conn.prepareStatement(questionQuery);
                    stmt.setInt(1, testId);
                    rs = stmt.executeQuery();

                    int questionNumber = 1;
                    while (rs.next()) {
                        int questionId = rs.getInt("id");
            %>
                        <div class="card mb-3 p-3">
                            <h5><%= questionNumber++ %>. <%= rs.getString("question_text") %></h5>
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="answer_<%= questionId %>" value="A" required>
                                <label class="form-check-label"><%= rs.getString("option_a") %></label>
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="answer_<%= questionId %>" value="B">
                                <label class="form-check-label"><%= rs.getString("option_b") %></label>
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="answer_<%= questionId %>" value="C">
                                <label class="form-check-label"><%= rs.getString("option_c") %></label>
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="answer_<%= questionId %>" value="D">
                                <label class="form-check-label"><%= rs.getString("option_d") %></label>
                            </div>
                        </div>
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

            <div class="text-center">
                <button type="submit" class="btn btn-primary">Submit Test</button>
            </div>
        </form>
    <% } %>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
