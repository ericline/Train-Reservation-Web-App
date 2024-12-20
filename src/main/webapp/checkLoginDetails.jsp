<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>

<%

boolean loginSuccess = false;
int userID = -1;
String userRole = null; // Holds the role if the user is an Employee

// Retrieve parameters from the request
String username = request.getParameter("username");
String password = request.getParameter("password");
String role = request.getParameter("role");

try {
    // Get the database connection
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String table = null;
    String idColumn = null;

    // Determine the table and column to query based on role
    if ("Customer".equals(role)) {
        table = "Customers";
        idColumn = "CustomerID";
    } else if ("Admin".equals(role) || "CustomerRep".equals(role)) {
        table = "Employees";
        idColumn = "EmployeeID";
    }

    if (table != null && idColumn != null) {
        // Query the database
        String query = "SELECT " + idColumn + 
                       (table.equals("Employees") ? ", Role" : "") + 
                       " FROM " + table + 
                       " WHERE Username = ? AND PasswordHash = SHA2(?, 256)";

        if ("Admin".equals(role)) {
            query += " AND Role = 'Admin'";
        } else if ("CustomerRep".equals(role)) {
            query += " AND Role = 'CustomerRep'";
        }

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                loginSuccess = true;
                userID = rs.getInt(idColumn); // Retrieve the ID
                if ("Employees".equals(table)) {
                    userRole = rs.getString("Role"); // Retrieve the role if Employee
                }
            }
        }
    } else {
        out.println("<p>Error: Invalid role selected.</p>");
    }
} catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
}

if (loginSuccess) {
    session.setAttribute("username", username);
    session.setAttribute("userID", userID); // Set the CustomerID or EmployeeID as session attribute
	
    if (userRole != null) {
        session.setAttribute("role", userRole); // Set role only for Employees
        if ("Admin".equals(userRole)) {
            response.sendRedirect("adminPage.jsp"); // Redirect to Admin Dashboard
        } else if ("CustomerRep".equals(userRole)) {
            response.sendRedirect("customerRep.jsp"); // Redirect to CustomerRep Dashboard
        }
    } else {
        response.sendRedirect("searchTrains.jsp"); // Redirect to Customer Search Trains page
    }
} else {
    out.println("<p>Invalid username or password. Please try again.</p>");
    out.println("<a href='login.jsp'>Back to Login</a>");
}
%>
