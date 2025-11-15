<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    int studentId = (Integer) sessionObj.getAttribute("studentId");
    String enrollmentId = request.getParameter("enrollmentId");
    String amount = request.getParameter("amount");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Update payment status to paid (fees = 1)
        String updateQuery = "UPDATE enroll_courses SET fees = 1 WHERE enrollment_id = ? AND student_id = ?";
        stmt = conn.prepareStatement(updateQuery);
        stmt.setInt(1, Integer.parseInt(enrollmentId));
        stmt.setInt(2, studentId);
        int rowsUpdated = stmt.executeUpdate();

        if (rowsUpdated > 0) {
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Success</title>
   <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    <style>
        .container {
    max-width: 600px;
    margin: auto;
    margin-top: 150px !important; /* Add !important to force override */
    background: #f8f9fa;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    text-align: center;
}


        .btn-primary {
            background-color: #007bff;
            border: none;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
    
</head>
<body>

<%-- Include Student Header --%>
<jsp:include page="includes/header.jsp" />

<div class="d-flex">
    <%-- Include Sidebar --%>
    <jsp:include page="includes/sidebar.jsp" />

<div class="container mt-5 text-center">
    <h2 class="text-success">Payment Successful ✅</h2>
    <p>You have successfully paid ₹<%= amount %> for your course.</p>
    <a href="generateReceipt.jsp?enrollmentId=<%= enrollmentId %>" class="btn btn-primary">Download Receipt</a>
    <br><br>
    <a href="studentDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
</div>
</div>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%
        } else {
            response.sendRedirect("payFees.jsp?error=Payment failed. Please try again.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("payFees.jsp?error=Something went wrong.");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
