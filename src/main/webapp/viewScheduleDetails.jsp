<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import ="java.time.LocalDateTime" %>
<%@ page import ="java.time.format.DateTimeFormatter" %>

<%
    try {
        // Get database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
		
        int trainID = Integer.parseInt(request.getParameter("trainID"));
		
        // Query to fetch schedule details based on TrainID
        String query = "SELECT TS.ScheduleID, TS.TrainID, " +
                       "OS.Name AS OriginStation, OS.City AS OriginCity, OS.State AS OriginState, " +
                       "TS.DepartureTime, " +
                       "DS.Name AS DestinationStation, DS.City AS DestinationCity, DS.State AS DestinationState, " +
                       "TS.ArrivalTime, TS.Fare " +
                       "FROM TrainSchedules TS " +
                       "JOIN Stations OS ON TS.OriginStationID = OS.StationID " +
                       "JOIN Stations DS ON TS.DestinationStationID = DS.StationID " +
                       "WHERE TS.TrainID = ?";

        // Query to fetch stops based on TrainID
        String stopsQuery = "SELECT S.Name AS StopStation, S.City AS StopCity, S.State AS StopState, " +
                            "TS.StopOrder " +
                            "FROM TrainStops TS " +
                            "JOIN Stations S ON TS.StationID = S.StationID " +
                            "WHERE TS.ScheduleID = ? " + // TS.ScheduleID refers to TrainID in TrainSchedules
                            "ORDER BY TS.StopOrder";

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, trainID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

                // Format departure and arrival times
                LocalDateTime departureTime = rs.getTimestamp("DepartureTime").toLocalDateTime();
                LocalDateTime arrivalTime = rs.getTimestamp("ArrivalTime").toLocalDateTime();

                out.println("<h2>Schedule Details</h2>");
                out.println("<p><strong>Train ID:</strong> " + trainID + "</p>");
                out.println("<p><strong>Origin Station:</strong> " + rs.getString("OriginStation") + "</p>");
                out.println("<p><strong>Departure Time:</strong> " + departureTime.format(dateFormatter) + " | " + departureTime.format(timeFormatter) + "</p>");
                out.println("<p><strong>Destination Station:</strong> " + rs.getString("DestinationStation") + "</p>");
                out.println("<p><strong>Arrival Time:</strong> " + arrivalTime.format(dateFormatter) + " | " + arrivalTime.format(timeFormatter) + "</p>");
                out.println("<p><strong>Fare:</strong> $" + rs.getBigDecimal("Fare") + "</p>");

                // Fetch and display stops
                try (PreparedStatement stopsPs = con.prepareStatement(stopsQuery)) {
                    stopsPs.setInt(1, trainID);
                    ResultSet stopsRs = stopsPs.executeQuery();

                    if (!stopsRs.isBeforeFirst()) { // Check if result set is empty
                        out.println("<p>No stops found for this train.</p>");
                    } else {
                        out.println("<h3>Stops</h3>");
                        out.println("<ol>");
                        out.println("<li>" + rs.getString("OriginStation") + " (" + rs.getString("OriginCity") + ", " + rs.getString("OriginState") + ")</li>");
                        while (stopsRs.next()) {
                            String stopStation = stopsRs.getString("StopStation");
                            String stopCity = stopsRs.getString("StopCity");
                            String stopState = stopsRs.getString("StopState");

                            out.println("<li>" + stopStation + " (" + stopCity + ", " + stopState + ")</li>");
                        }
                        out.println("<li>" + rs.getString("DestinationStation") + " (" + rs.getString("DestinationCity") + ", " + rs.getString("DestinationState") + ")</li>");
                        out.println("</ol>");
                    }
                }
            } else {
                out.println("<p>No schedule found for the given Train ID.</p>");
            }
        }
        con.close();

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="searchTrains.jsp">Back to Search</a>
