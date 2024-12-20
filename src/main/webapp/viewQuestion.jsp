<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Question Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
        }
        .details {
            margin-bottom: 20px;
        }
        .details p {
            margin: 10px 0;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
        }
        .button-container form {
            margin: 0;
        }
        button {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
<%
    // Retrieve the question ID from the request
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

        // Query to retrieve the question details
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
    <div class="details">
        <p><strong>Customer Name:</strong> <%= rs.getString("CustomerName") + " " + rs.getString("CustomerLastName") %></p>
        <p><strong>Question:</strong> <%= rs.getString("QuestionText") %></p>
        <p><strong>Reply:</strong> <%= rs.getString("ReplyText") != null ? rs.getString("ReplyText") : "No reply yet" %></p>
        <p><strong>Status:</strong> <%= rs.getString("Status") %></p>
    </div>

    <div class="button-container">
        <!-- Button to navigate back -->
        <form action="customerRep.jsp" method="GET">
            <button type="submit">Back to Dashboard</button>
        </form>
    </div>
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
%>
</div>
</body>
</html>