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

@WebServlet("/EditTimetableServlet")
public class EditTimetableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String day_of_week = request.getParameter("day_of_week");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String meetingLink = request.getParameter("meeting_link");

        String jdbcURL = "jdbc:mysql://localhost:3306/cms";
        String dbUser = "root";
        String dbPassword = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String updateQuery = "UPDATE timetable SET day_of_week = ?, start_time = ?, end_time = ?, meeting_link = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, day_of_week);
            stmt.setString(2, startTime);
            stmt.setString(3, endTime);
            stmt.setString(4, meetingLink);
            stmt.setInt(5, Integer.parseInt(id));

            int rowsUpdated = stmt.executeUpdate();
            stmt.close();
            conn.close();

            if (rowsUpdated > 0) {
                response.sendRedirect("admin/viewTimetableAdmin.jsp?message=Timetable updated successfully!");
            } else {
                response.sendRedirect("admin/editTimetable.jsp?id=" + id + "&error=Failed to update timetable.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/editTimetable.jsp?id=" + id + "&error=Something went wrong.");
        }
    }
}
