<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter, jakarta.servlet.http.HttpSession" %>

<%
    // Ensure student is logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("studentName") == null) {
        response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
        return;
    }

    String studentName = (String) sessionObj.getAttribute("studentName");
    int studentId = (Integer) sessionObj.getAttribute("studentId");
    String enrollmentId = request.getParameter("enrollmentId");

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/cms";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    // Variables to store payment details
    String courseName = "";
    double amountPaid = 0.0;
    LocalDateTime paymentDate = LocalDateTime.now(); // Default to current time

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch payment details
        String query = "SELECT c.course_name, c.fee, ec.enrollment_date " +
                       "FROM enroll_courses ec " +
                       "JOIN course c ON ec.course_id = c.id " +
                       "WHERE ec.enrollment_id = ? AND ec.student_id = ? AND ec.fees = 1";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(enrollmentId));
        stmt.setInt(2, studentId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            courseName = rs.getString("course_name");
            amountPaid = rs.getDouble("fee");
            paymentDate = rs.getTimestamp("enrollment_date").toLocalDateTime();
        } else {
            response.sendRedirect("payFees.jsp?error=No valid payment record found.");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("payFees.jsp?error=Something went wrong.");
        return;
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }

    // Format the date
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
    String formattedDate = paymentDate.format(formatter);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Receipt</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="includes/styles.css">
    <style>
        .container {
            max-width: 600px;
            margin-top: 80px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .receipt-box {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
            background: white;
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
    <h2 class="text-center">Payment Receipt</h2>

    <div class="receipt-box">
        <p><strong>Student Name:</strong> <%= studentName %></p>
        <p><strong>Course Name:</strong> <%= courseName %></p>
        <p><strong>Amount Paid:</strong> ₹<%= amountPaid %></p>
        <p><strong>Payment Date:</strong> <%= formattedDate %></p>
        <p><strong>Status:</strong> ✅ Paid</p>
    </div>

    <button onclick="downloadReceipt()" class="btn btn-primary w-100 mt-3">Download Receipt</button>
    <a href="studentDashboard.jsp" class="btn btn-secondary w-100 mt-2">Back to Dashboard</a>
</div>

<script>
    function downloadReceipt() {
        var element = document.createElement("a");
        var content = "Student Name: <%= studentName %>\\n" +
                      "Course Name: <%= courseName %>\\n" +
                      "Amount Paid: ₹<%= amountPaid %>\\n" +
                      "Payment Date: <%= formattedDate %>\\n" +
                      "Status: ✅ Paid";
        
        var file = new Blob([content], { type: "text/plain" });
        element.href = URL.createObjectURL(file);
        element.download = "Payment_Receipt.txt";
        document.body.appendChild(element);
        element.click();
    }
</script>

<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
