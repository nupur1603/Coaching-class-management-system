package com.coaching;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SubmitTestServlet")
public class SubmitTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/cms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("../studentLogin.jsp?error=Please log in first.");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        int testId = Integer.parseInt(request.getParameter("testId"));

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        int totalMarksObtained = 0;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            // ✅ Step 1: Check if the student has already attempted the test
            String checkQuery = "SELECT COUNT(*) FROM student_test_results WHERE student_id=? AND test_id=?";
            stmt = conn.prepareStatement(checkQuery);
            stmt.setInt(1, studentId);
            stmt.setInt(2, testId);
            rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("student/testResult.jsp?testId=" + testId + "&error=You have already attempted this test.");
                return;
            }
            rs.close();
            stmt.close();

            // ✅ Step 2: Fetch test questions and evaluate responses
            String questionQuery = "SELECT id, correct_option, marks FROM test_questions WHERE test_id=?";
            stmt = conn.prepareStatement(questionQuery);
            stmt.setInt(1, testId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int questionId = rs.getInt("id");
                String correctAnswer = rs.getString("correct_option");
                int questionMarks = rs.getInt("marks");

                // Get student's selected answer
                String studentAnswer = request.getParameter("answer_" + questionId);
                boolean isCorrect = studentAnswer != null && studentAnswer.equals(correctAnswer);

                // Calculate obtained marks
                int obtainedMarks = isCorrect ? questionMarks : 0;
                totalMarksObtained += obtainedMarks;

                // ✅ Step 3: Store each attempt in `student_attempts`
                String insertAttempt = "INSERT INTO student_attempts (student_id, test_id, question_id, selected_option, is_correct, marks_obtained) " +
                        "VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement attemptStmt = conn.prepareStatement(insertAttempt);
                attemptStmt.setInt(1, studentId);
                attemptStmt.setInt(2, testId);
                attemptStmt.setInt(3, questionId);
                attemptStmt.setString(4, studentAnswer);
                attemptStmt.setBoolean(5, isCorrect);
                attemptStmt.setInt(6, obtainedMarks);
                attemptStmt.executeUpdate();
                attemptStmt.close();
            }
            rs.close();
            stmt.close();

            // ✅ Step 4: Store final result in `student_test_results`
            String insertResult = "INSERT INTO student_test_results (student_id, test_id, total_marks_obtained) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(insertResult);
            stmt.setInt(1, studentId);
            stmt.setInt(2, testId);
            stmt.setInt(3, totalMarksObtained); // Student's obtained marks
            stmt.executeUpdate();
            stmt.close();

            // ✅ Redirect to test result page
            response.sendRedirect("student/testResult.jsp?testId=" + testId + "&score=" + totalMarksObtained);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student/viewTests.jsp?error=Database error occurred.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
