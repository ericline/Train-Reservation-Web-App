<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Station Schedule</title>
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
    <h2>View Station Schedule</h2>

    <!-- Form for selecting station and date -->
    <div class="form-container">
        <form method="GET">
            <label for="station">Select Station:</label>
            <select id="station" name="station" required>
                <option value="New York Penn Station">New York Penn Station</option>
                <option value="New Brunswick Station">New Brunswick Station</option>
                <option value="Trenton Station">Trenton Station</option>
                <option value="Princeton Junction">Princeton Junction</option>
                <option value="Philadelphia 30th Street Station">Philadelphia 30th Street Station</option>
                <option value="Metropark Station">Metropark Station</option>
                <option value="Rahway Station">Rahway Station</option>
                <option value="Newark Penn Station">Newark Penn Station</option>
            </select>

            <label for="role">Select Role:</label>
            <select id="role" name="role" required>
                <option value="origin">Origin</option>
                <option value="destination">Destination</option>
            </select>

            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required />

            <button type="submit" class="button">View Schedules</button>
        </form>
    </div>

    <% 
        // Get the selected station, role (origin/destination), and date from the request
        String station = request.getParameter("station");
        String role = request.getParameter("role");
        String date = request.getParameter("date");

        if (station != null && role != null && date != null) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                // Construct the query based on whether the station is an origin or destination
                String query = "";
                if ("origin".equals(role)) {
                    query = "SELECT ts.ScheduleID, ts.TrainID, os.Name AS OriginStation, ds.Name AS DestinationStation, " +
                            "ts.DepartureTime, ts.ArrivalTime, ts.Fare " +
                            "FROM TrainSchedules ts " +
                            "JOIN Stations os ON ts.OriginStationID = os.StationID " +
                            "JOIN Stations ds ON ts.DestinationStationID = ds.StationID " +
                            "WHERE os.Name = ? AND DATE(ts.DepartureTime) = ?";
                } else if ("destination".equals(role)) {
                    query = "SELECT ts.ScheduleID, ts.TrainID, os.Name AS OriginStation, ds.Name AS DestinationStation, " +
                            "ts.DepartureTime, ts.ArrivalTime, ts.Fare " +
                            "FROM TrainSchedules ts " +
                            "JOIN Stations os ON ts.OriginStationID = os.StationID " +
                            "JOIN Stations ds ON ts.DestinationStationID = ds.StationID " +
                            "WHERE ds.Name = ? AND DATE(ts.DepartureTime) = ?";
                }

                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, station);  // Set the station name
                ps.setString(2, date);     // Set the selected date

                ResultSet rs = ps.executeQuery();

                if (!rs.isBeforeFirst()) {
                    // No data found
                    out.println("<p>No train schedules found for the selected station and date.</p>");
                } else {
        %>
        <!-- Table to display results -->
        <table>
            <tr>
                <th>Train ID</th>
                <th>Origin Station</th>
                <th>Destination Station</th>
                <th>Departure Time</th>
                <th>Arrival Time</th>
                <th>Fare</th>
            </tr>
            <% 
                    while (rs.next()) {
                        int trainID = rs.getInt("TrainID");
                        String originStation = rs.getString("OriginStation");
                        String destinationStation = rs.getString("DestinationStation");
                        Timestamp departureTime = rs.getTimestamp("DepartureTime");
                        Timestamp arrivalTime = rs.getTimestamp("ArrivalTime");
                        double fare = rs.getDouble("Fare");

                        // Format the timestamps
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        String departureStr = dateFormat.format(departureTime);
                        String arrivalStr = dateFormat.format(arrivalTime);
            %>
            <tr>
                <td><%= trainID %></td>
                <td><%= originStation %></td>
                <td><%= destinationStation %></td>
                <td><%= departureStr %></td>
                <td><%= arrivalStr %></td>
                <td>$<%= fare %></td>
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
