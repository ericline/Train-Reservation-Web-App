<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.security.MessageDigest"%>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
    <%
        // Get form data from the request
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (firstName != null && lastName != null && email != null && username != null && password != null) {
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                // Establish database connection
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();

                if (conn == null) {
                    throw new Exception("Database connection failed.");
                }

                // Hash the password securely
                String hashedPassword = String.format("%064x", 
                    new java.math.BigInteger(1, MessageDigest.getInstance("SHA-256").digest(password.getBytes("UTF-8"))));

                // Prepare and execute the SQL query
                String query = "INSERT INTO Customers (FirstName, LastName, Email, Username, PasswordHash) VALUES (?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(query);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, username);
                ps.setString(5, hashedPassword);
                ps.executeUpdate();

                out.println("<p>Registration successful!</p>");
            } catch (Exception e) {
                // Handle and display any errors
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                // Close resources
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        } else {
            out.println("<p>Invalid input. All fields are required.</p>");
        }
    %>
    <a href="login.jsp">Back to Login</a>
</body>
</html>
