<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <title>Question Details</title>
</head>
<body>
    <%
        // Retrieve session attributes for the current user
        Integer userID = (Integer) session.getAttribute("userID");
        String role = (String) session.getAttribute("userRole");

        // Redirect to login page if the user is not authenticated or unauthorized
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch the question ID from the request
        int questionID = 0;
        try {
            questionID = Integer.parseInt(request.getParameter("questionID"));
        } catch (NumberFormatException e) {
            out.println("<p>Invalid question ID provided.</p>");
            return;
        }

        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = db.getConnection();

            // Query to retrieve the details of the specified question
            String query = "SELECT q.QuestionText, q.ReplyText, q.Status, cu.FirstName AS CustomerName, cu.LastName AS CustomerLastName " +
                           "FROM Questions q " +
                           "JOIN Customers cu ON q.CustomerID = cu.CustomerID " +
                           "WHERE q.QuestionID = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, questionID);
            rs = ps.executeQuery();

            if (rs.next()) {
    %>
    <h1>Question Details</h1>
    <p><strong>Customer Name:</strong> <%= rs.getString("CustomerName") + " " + rs.getString("CustomerLastName") %></p>
    <p><strong>Question:</strong> <%= rs.getString("QuestionText") %></p>
    <p><strong>Reply:</strong> <%= rs.getString("ReplyText") != null ? rs.getString("ReplyText") : "No reply yet" %></p>
    <p><strong>Status:</strong> <%= rs.getString("Status") %></p>

    <!-- Section to send a reply -->
    <h2>Send a Reply</h2>
    <form method="POST">
        <textarea name="replyMessage" rows="4" cols="50" placeholder="Write your reply here..." required></textarea><br>
        <button type="submit">Submit Reply</button>
    </form>

    <!-- Button to navigate back to the appropriate dashboard -->
    <br>
    <form action="<%= "CustomerRep".equals(role) ? "searchTrains.jsp" : "customerRep.jsp" %>" method="GET">
        <button type="submit">Return to <%= "CustomerRep".equals(role) ? "Customer Dashboard" : "CustomerRep Dashboard" %></button>
    </form>

    <%
            } else {
                out.println("<p>Question not found.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Error while retrieving the question: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            if (con != null) try { con.close(); } catch (SQLException ignored) {}
        }

        // Handle reply submission logic
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String replyMessage = request.getParameter("replyMessage");

            try {
                con = db.getConnection();

                // Update the reply text and status in the Questions table
                String updateQuery = "UPDATE Questions SET ReplyText = ?, Status = 'Resolved' WHERE QuestionID = ?";
                ps = con.prepareStatement(updateQuery);
                ps.setString(1, replyMessage);
                ps.setInt(2, questionID);
                ps.executeUpdate();

                out.println("<p>Reply sent successfully. <a href='viewQuestion.jsp?questionID=" + questionID + "'>View Question</a></p>");
            } catch (SQLException e) {
                out.println("<p>Error while sending the reply: " + e.getMessage() + "</p>");
            } finally {
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (con != null) try { con.close(); } catch (SQLException ignored) {}
            }
        }
    %>
</body>
</html>
