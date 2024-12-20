<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Show Reservations</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }
        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
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
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>

<h2>Reservations</h2>

<%
    // Get the filter parameter from the request
    String filter = request.getParameter("filter");
    String query = "";
    

    // Check if filter is "transitLine" or "customerName" and create query accordingly
    if ("transitLine".equals(filter)) {
        query = "SELECT ts.TransitLine, COUNT(r.ReservationID) AS TotalReservations " +
                "FROM Reservations r " +
                "JOIN TrainSchedules ts ON r.ScheduleID = ts.ScheduleID " +
                "GROUP BY ts.TransitLine";
    } else if ("customerName".equals(filter)) {
        query = "SELECT c.FirstName, c.LastName, COUNT(r.ReservationID) AS TotalReservations " +
                "FROM Reservations r " +
                "JOIN Customers c ON r.CustomerID = c.CustomerID " +
                "GROUP BY c.CustomerID, c.FirstName, c.LastName";
    }

    // Handle the case where query is empty (invalid filter)
    if (query.isEmpty()) {
        out.println("<p class='error'>Error: No valid filter selected. Please choose a filter.</p>");
    } else {
        try {
            // Set up database connection and query execution
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
%>

<!-- Display the results in a table -->
<table>
    <tr>
        <th><%= "transitLine".equals(filter) ? "Transit Line" : "Customer Name" %></th>
        <th>Total Reservations</th>
    </tr>

<%
            // Process result set and display data in table rows
            while (rs.next()) {
                if ("transitLine".equals(filter)) {
%>
    <tr>
        <td><%= rs.getString("TransitLine") %></td>
        <td><%= rs.getInt("TotalReservations") %></td>
    </tr>
<%
                } else {
%>
    <tr>
        <td><%= rs.getString("FirstName") %> <%= rs.getString("LastName") %></td>
        <td><%= rs.getInt("TotalReservations") %></td>
    </tr>
<%
                }
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        }
    }
%>
</table>
<a href="companyDetails.jsp">Back to Details</a>
</body>
</html>
