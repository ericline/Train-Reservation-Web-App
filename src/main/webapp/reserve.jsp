<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,
    java.time.*,
    java.time.format.DateTimeFormatter,
    com.cs336.pkg.*"%>

<%
    Integer userID = (Integer) session.getAttribute("userID");

    int trainID = Integer.parseInt(request.getParameter("trainID")); 
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String query = "SELECT TS.ScheduleID, TS.TrainID, TS.DepartureTime, TS.ArrivalTime, TS.Fare, " +
                       "OS.Name AS OriginStation, DS.Name AS DestinationStation " +
                       "FROM TrainSchedules TS " +
                       "JOIN Stations OS ON TS.OriginStationID = OS.StationID " +
                       "JOIN Stations DS ON TS.DestinationStationID = DS.StationID " +
                       "WHERE TS.TrainID = ?";

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, trainID); 
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int scheduleID = rs.getInt("ScheduleID");
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

                LocalDateTime departureTime = rs.getTimestamp("DepartureTime").toLocalDateTime();
                LocalDateTime arrivalTime = rs.getTimestamp("ArrivalTime").toLocalDateTime();
%>
                <h2>Reserve Your Ticket</h2>
                <p><strong>Train Schedule:</strong></p>
                <p>From: <%= rs.getString("OriginStation") %></p>
                <p>To: <%= rs.getString("DestinationStation") %></p>
                <p>Departure Time: <%= departureTime.format(dateFormatter) %> | <%= departureTime.format(timeFormatter) %></p>
                <p>Arrival Time: <%= arrivalTime.format(dateFormatter) %> | <%= arrivalTime.format(timeFormatter) %></p>
                <p>Fare: $<%= rs.getBigDecimal("Fare") %></p>

                <form action="processReservation.jsp" method="POST">
                    <input type="hidden" name="customerID" value="<%= userID %>"/>
                    <input type="hidden" name="scheduleID" value="<%= scheduleID %>"/> 

                    <label for="seats">Number of Tickets:</label>
                    <input type="number" name="seats" min="1" value="1" required/>

                    <label for="discount">Discount:</label>
                    <select name="discount" id="discount">
                        <option value="1">None</option>
                        <option value="0.75">Child (25%)</option>
                        <option value="0.65">Senior (35%)</option>
                        <option value="0.50">Disabled (50%)</option>
                    </select>

                    <label for="tripType">Trip Type:</label>
                    <select name="tripType" id="tripType">
                        <option value="oneWay">One-Way</option>
                        <option value="roundTrip">Round Trip</option>
                    </select>

                    <br/><br/>
                    <input type="submit" value="Confirm Reservation" 
                           style="padding: 8px 12px; background-color: #007BFF; color: #ffffff; border: none; border-radius: 4px; cursor: pointer;"/>
                </form>
<%
            } else {
%>
                <p>No schedule found for the given Train ID.</p>
<%
            }
        }
        con.close();
    } catch (Exception e) {
%>
        <p>Error: <%= e.getMessage() %></p>
<%
    }
%>
<a href="searchTrains.jsp">Back to Search</a>
