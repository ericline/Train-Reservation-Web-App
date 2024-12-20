<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Reservations</title>
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
        .form-container {
            text-align: center;
            margin: 20px;
        }
        .button {
            padding: 10px 20px;
            font-size: 16px;
            color: #ffffff;
            background-color: #007BFF;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h2>View Reservations</h2>

    <!-- Form for selecting transit line and date -->
    <div class="form-container">
        <form method="GET">
            <label for="transitLine">Transit Line:</label>
            <select id="transitLine" name="transitLine" required>
                <option value="Northeast Corridor Line">Northeast Corridor Line</option>
                <option value="North Jersey Coast Line">North Jersey Coast Line</option>
                <option value="Pascack Valley Line">Pascack Valley Line</option>
            </select>
            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required />
            <button type="submit" class="button">View Reservations</button>
        </form>
    </div>

    <% 
        // Get the selected transit line and date from the request
        String transitLine = request.getParameter("transitLine");
        String date = request.getParameter("date");

        if (transitLine != null && date != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                // Query to fetch reservations by transit line and date (case-insensitive comparison)
                String query = "SELECT c.FirstName, c.LastName, r.SeatsReserved, ts.DepartureTime, ts.ArrivalTime " +
                               "FROM Reservations r " +
                               "JOIN Customers c ON r.CustomerID = c.CustomerID " +
                               "JOIN TrainSchedules ts ON r.ScheduleID = ts.ScheduleID " +
                               "WHERE LOWER(ts.TransitLine) = LOWER(?) AND DATE(ts.DepartureTime) = ?";

                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, transitLine);  // Use case-insensitive match
                ps.setString(2, date);         // Use the date parameter

                ResultSet rs = ps.executeQuery();

                if (!rs.isBeforeFirst()) {
                    // No data found
                    out.println("<p>No reservations found for the selected transit line and date.</p>");
                } else {
        %>
        <!-- Table to display results -->
        <table>
            <tr>
                <th>Customer Name</th>
                <th>Seats Reserved</th>
                <th>Departure Time</th>
                <th>Arrival Time</th>
            </tr>
            <% 
                    while (rs.next()) {
                        String customerName = rs.getString("FirstName") + " " + rs.getString("LastName");
                        int seatsReserved = rs.getInt("SeatsReserved");
                        Timestamp departureTime = rs.getTimestamp("DepartureTime");
                        Timestamp arrivalTime = rs.getTimestamp("ArrivalTime");

                        // Format the timestamps
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        String departureStr = dateFormat.format(departureTime);
                        String arrivalStr = dateFormat.format(arrivalTime);
            %>
            <tr>
                <td><%= customerName %></td>
                <td><%= seatsReserved %></td>
                <td><%= departureStr %></td>
                <td><%= arrivalStr %></td>
            </tr>
            <% 
                    }
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        } 
    %>
    </table>
    <a href="customerRep.jsp">Back to Search</a>
</body>
</html>
