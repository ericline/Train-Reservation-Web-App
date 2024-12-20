<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Show Revenue</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }
        h2 {
            text-align: center;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <h2>Revenue</h2>

    <% 
        // Get the filter parameter passed from the front end
        String filter = request.getParameter("filter");
        String query = "";

        // Define the query based on the selected filter (By Transit Line or By Customer Name)
        if ("transitLine".equals(filter)) {
            query = "SELECT ts.TransitLine, SUM(r.Price) AS TotalRevenue " +
                    "FROM Reservations r " +
                    "JOIN TrainSchedules ts ON r.ScheduleID = ts.ScheduleID " +
                    "GROUP BY ts.TransitLine";
        } else if ("customerName".equals(filter)) {
            query = "SELECT c.FirstName, c.LastName, SUM(r.Price) AS TotalRevenue " +
                    "FROM Reservations r " +
                    "JOIN Customers c ON r.CustomerID = c.CustomerID " +
                    "GROUP BY c.CustomerID, c.FirstName, c.LastName";
        }

        // Execute the query and fetch the data
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
    %>

    <!-- Display the results in a table -->
    <table>
        <tr>
            <th><%= "transitLine".equals(filter) ? "Transit Line" : "Customer Name" %></th>
            <th>Total Revenue ($)</th>
        </tr>
        <%
            // Iterate through the result set and display each row
            while (rs.next()) {
                if ("transitLine".equals(filter)) {
        %>
        <tr>
            <td><%= rs.getString("TransitLine") %></td>
            <td>$<%= rs.getDouble("TotalRevenue") %></td>
        </tr>
        <%
                } else {
        %>
        <tr>
            <td><%= rs.getString("FirstName") %> <%= rs.getString("LastName") %></td>
            <td>$<%= rs.getDouble("TotalRevenue") %></td>
        </tr>
        <%
                }
            }
            // Close the ResultSet and PreparedStatement
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            // Handle any exceptions that may occur
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>    
    </table>
    <a href="companyDetails.jsp">Back to Details</a>
    
</body>
</html>

