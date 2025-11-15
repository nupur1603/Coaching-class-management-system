package com.coaching;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        int testId = Integer.parseInt(request.getParameter("testId"));
        String questionText = request.getParameter("questionText"); // Matches DB field
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption"); // Matches DB field
        int marks = Integer.parseInt(request.getParameter("marks")); // Adding marks

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            // Insert question into the test_questions table
            String sql = "INSERT INTO test_questions (test_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, testId);
            stmt.setString(2, questionText);
            stmt.setString(3, optionA);
            stmt.setString(4, optionB);
            stmt.setString(5, optionC);
            stmt.setString(6, optionD);
            stmt.setString(7, correctOption);
            stmt.setInt(8, marks); // Added marks

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("teacher/manageQuestions.jsp?testId=" + testId + "&message=Question added successfully!");
            } else {
                response.sendRedirect("teacher/manageQuestions.jsp?testId=" + testId + "&error=Failed to add question!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacher/manageQuestions.jsp?testId=" + testId + "&error=Database error!");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
