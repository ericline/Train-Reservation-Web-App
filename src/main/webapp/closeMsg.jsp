<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.sql.*" %>
<%
    // Retrieve the conversation ID from the request
    int questionID = 0;
    try {
        questionID = Integer.parseInt(request.getParameter("questionID"));
    } catch (NumberFormatException e) {
        out.println("<p>Invalid Question ID. Please try again.</p>");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection con = null;

    try {
        // Establish a connection to the database
        con = db.getConnection();

        // Prepare and execute the SQL statement to close the conversation
        String closeQuery = "UPDATE Questions SET Status = 'Resolved' WHERE QuestionID = ?";
        try (PreparedStatement ps = con.prepareStatement(closeQuery)) {
            ps.setInt(1, questionID);
            ps.executeUpdate();

            // Redirect to the representative dashboard after successful closure
            response.sendRedirect("customerRep.jsp");
        }
    } catch (SQLException e) {
        // Display an error message in case of SQL issues
        out.println("<p>Error occurred while closing the conversation: " + e.getMessage() + "</p>");
    } finally {
        // Ensure the connection is closed properly
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ignored) {
                out.println("<p>Failed to close the database connection.</p>");
            }
        }
    }
%>
