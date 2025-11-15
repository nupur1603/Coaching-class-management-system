<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Check if student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    String studentName = (String) sessionObj.getAttribute("studentName");
    int studentId = (Integer) sessionObj.getAttribute("studentId");

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
    <title>Pay Fees - ABC Coaching</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    <style>
        .container {
            max-width: 600px;
            margin-top: 100px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>

<%-- Include Student Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />
</div>

<div class="container">
    <h2 class="text-center">Pay Fees</h2>

    <%
        // Fetch courses where fees is unpaid (fees = 0)
        String query = "SELECT ec.enrollment_id, c.course_name, c.fee FROM enroll_courses ec " +
                       "JOIN course c ON ec.course_id = c.id " +
                       "WHERE ec.student_id = ? AND ec.fees = 0";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            if (rs.isBeforeFirst()) { // Check if results exist
    %>

    <form action="processPayment.jsp" method="post">
        <div class="mb-3">
            <label for="course" class="form-label">Select Course to Pay</label>
            <select class="form-control" id="course" name="enrollmentId" required>
                <option value="">-- Select Course --</option>
                <%
                    while (rs.next()) {
                        int enrollmentId = rs.getInt("enrollment_id");
                        String courseName = rs.getString("course_name");
                        double feeAmount = rs.getDouble("fee");
                %>
                <option value="<%= enrollmentId %>" data-fee="<%= feeAmount %>">
                    <%= courseName %> - ₹<%= feeAmount %>
                </option>
                <% } %>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Amount to Pay (₹)</label>
            <input type="text" class="form-control" id="amount" name="amount" readonly>
        </div>

        <button type="submit" class="btn btn-primary w-100">Pay Now</button>
    </form>

    <%
            } else {
    %>
        <div class="alert alert-success text-center mt-3">
            No pending fees to pay. 🎉
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

</div>

<script>
    document.getElementById("course").addEventListener("change", function() {
        var selectedOption = this.options[this.selectedIndex];
        var amount = selectedOption.getAttribute("data-fee");
        document.getElementById("amount").value = amount;
    });
</script>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
