<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Current Reservations</title>
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
            margin: 0 auto;
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
        .logout-btn {
            display: block;
            width: 150px;
            margin: 20px auto;
            padding: 10px;
            text-align: center;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .logout-btn:hover {
            background-color: #0056b3;
        }
        .cancel-btn {
            padding: 5px 10px;
            font-size: 14px;
            color: white;
            background-color: #FF0000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .cancel-btn:hover {
            background-color: #CC0000;
        }
    </style>
</head>
<body>
    <h2>Your Current Reservations</h2>

    <% 
        // Get the user ID from the session
        Integer customerID = (Integer) session.getAttribute("userID");

        if (customerID == null) {
            // Redirect to login if no user is logged in
            response.sendRedirect("login.jsp");
        } else {
            // Fetch current reservations for the customer (i.e., where the status is "Confirmed")
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String query = "SELECT r.ReservationID, r.ScheduleID, r.SeatsReserved, r.ReservationStatus, " +
                           "r.Price, ts.OriginStationID, ts.DestinationStationID, ts.DepartureTime, ts.ArrivalTime " +
                           "FROM Reservations r " +
                           "JOIN TrainSchedules ts ON r.ScheduleID = ts.ScheduleID " +
                           "WHERE r.CustomerID = ? AND r.ReservationStatus = 'Confirmed'";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, customerID);

            ResultSet rs = ps.executeQuery();
    %>

    <!-- Display current reservations in a table -->
    <table>
        <tr>
            <th>Reservation ID</th>
            <th>Train Schedule ID</th>
            <th>Origin Station</th>
            <th>Destination Station</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
            <th>Seats Reserved</th>
            <th>Price</th> <!-- New column for Price -->
            <th>Status</th>
            <th>Action</th>
        </tr>
        <% 
            while (rs.next()) { 
                // Get data from the result set
                int reservationID = rs.getInt("ReservationID");
                int scheduleID = rs.getInt("ScheduleID");
                int originStationID = rs.getInt("OriginStationID");
                int destinationStationID = rs.getInt("DestinationStationID");
                String departureTime = rs.getString("DepartureTime");
                String arrivalTime = rs.getString("ArrivalTime");
                int seatsReserved = rs.getInt("SeatsReserved");
                double price = rs.getDouble("Price");  // Fetch the price
                String status = rs.getString("ReservationStatus");
        %>
        <tr>
            <td><%= reservationID %></td>
            <td><%= scheduleID %></td>
            <td><%= originStationID %></td>
            <td><%= destinationStationID %></td>
            <td><%= departureTime %></td>
            <td><%= arrivalTime %></td>
            <td><%= seatsReserved %></td>
            <td>$<%= price %></td> <!-- Display the price -->
            <td><%= status %></td>
            <td>
                <% if (!"Cancelled".equalsIgnoreCase(status)) { %>
                    <form action="cancelReservation.jsp" method="POST" style="margin: 0;">
                        <input type="hidden" name="reservationID" value="<%= reservationID %>" />
                        <input type="submit" value="Cancel" class="cancel-btn" />
                    </form>
                <% } else { %>
                    Cancelled
                <% } %>
            </td>
        </tr>
        <% 
            } 
            // Close connections
            rs.close();
            ps.close();
            con.close();
        }
        %>
    </table>

    <a class="logout-btn" href="logout.jsp">Logout</a>
    <form action="searchTrains.jsp" method="GET">
        <input type="submit" value="Back" />
    </form>
</body>
</html>
