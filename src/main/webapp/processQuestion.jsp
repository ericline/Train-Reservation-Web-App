<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Question</title>
</head>
<body>
<%
    // Retrieve session attributes for the current user
    String username = (String) session.getAttribute("username");
    Integer customerID = (Integer) session.getAttribute("userID");

    // Check if the user is logged in
    if (username == null || customerID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the question text from the form submission
    String questionText = request.getParameter("questionText");

    // Check if the question text is valid
    if (questionText == null || questionText.trim().isEmpty()) {
        out.println("<p>Error: Question text cannot be empty.</p>");
        out.println("<a href='sendQuestion.jsp'>Go back to submit a question.</a>");
        return;
    }

    // Database connection and query execution
    ApplicationDB db = new ApplicationDB();
    Connection con = null;
    PreparedStatement ps = null;

    try {
        con = db.getConnection();

        // Insert the question into the database
        String query = "INSERT INTO Questions (CustomerID, QuestionText) VALUES (?, ?)";
        ps = con.prepareStatement(query);
        ps.setInt(1, customerID); // CustomerID from session
        ps.setString(2, questionText); // Question text from form
        ps.executeUpdate();

        out.println("<p>Thank you! Your question has been submitted successfully.</p>");
        out.println("<a href='sendQuestion.jsp'>Submit another question</a> | ");
        out.println("<a href='searchTrains.jsp'>Return to Dashboard</a>");
    } catch (SQLException e) {
        out.println("<p>Error while submitting your question: " + e.getMessage() + "</p>");
        out.println("<a href='sendQuestion.jsp'>Go back to submit a question.</a>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
        if (con != null) try { con.close(); } catch (SQLException ignored) {}
    }
%>
</body>
</html>
