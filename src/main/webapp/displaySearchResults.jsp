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
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String date = request.getParameter("date");
    String sortBy = request.getParameter("sortBy");

    // Default sorting order
    String orderClause = "TS.DepartureTime";

    if ("arrival".equalsIgnoreCase(sortBy)) {
        orderClause = "TS.ArrivalTime";
    } else if ("fare".equalsIgnoreCase(sortBy)) {
        orderClause = "TS.Fare";
    }

    try {
        // Get database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String query = "SELECT TS.TrainID, TS.DepartureTime, TS.ArrivalTime, TS.Fare " +
                       "FROM TrainSchedules TS " +
                       "JOIN Stations OS ON TS.OriginStationID = OS.StationID " +
                       "JOIN Stations DS ON TS.DestinationStationID = DS.StationID " +
                       "WHERE OS.Name = ? AND DS.Name = ? AND DATE(TS.DepartureTime) = ? " +
                       "ORDER BY " + orderClause;

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, origin);
            ps.setString(2, destination);
            ps.setString(3, date);
            ResultSet rs = ps.executeQuery();
            
            // Time formatters
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd ");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

            out.println("<h2>Search Results</h2>");
            out.println("<div style='margin-bottom: 20px;'>");
            out.println("<form method='GET' style='display: inline-block;'>");
            out.println("<input type='hidden' name='origin' value='" + origin + "'/>");
            out.println("<input type='hidden' name='destination' value='" + destination + "'/>");
            out.println("<input type='hidden' name='date' value='" + date + "'/>");
            
         	// Sort by button
            out.println("<label for='sortBy'>Sort By:</label>");
            out.println("<select name='sortBy' id='sortBy' style='margin-right: 10px;'>");
            out.println("<option value='departure'" + ("departure".equals(sortBy) || sortBy == null ? " selected" : "") + ">Departure Time</option>");
            out.println("<option value='arrival'" + ("arrival".equals(sortBy) ? " selected" : "") + ">Arrival Time</option>");
            out.println("<option value='fare'" + ("fare".equals(sortBy) ? " selected" : "") + ">Fare</option>");
            out.println("</select>");
            out.println("<button type='submit' style='padding: 8px 12px; background-color: #007BFF; color: #ffffff; border: none; border-radius: 4px; cursor: pointer;'>Sort By</button>");
            out.println("</form>");
            out.println("</div>");


            while (rs.next()) {
                int trainID = rs.getInt("TrainID");
                
                // Split time into date and time
                Timestamp departureTimestamp = rs.getTimestamp("DepartureTime");
                Timestamp arrivalTimestamp = rs.getTimestamp("ArrivalTime");
                LocalDateTime departure = departureTimestamp.toLocalDateTime();
                LocalDateTime arrival = arrivalTimestamp.toLocalDateTime();
                
                String fare = rs.getBigDecimal("Fare").toString();

                // Format date and time for output
                String departureDate = departure.format(dateFormatter);
                String departureTime = departure.format(timeFormatter);
                String arrivalDate = arrival.format(dateFormatter);
                String arrivalTime = arrival.format(timeFormatter);

                out.println("<p>Train ID: " + trainID + "</p>");
                out.println("<p>Departure: " + departureDate + " | " + departureTime + "</p>");
                out.println("<p>Arrival: " + arrivalDate + " | " + arrivalTime + "</p>");
                out.println("<p>Fare: $" + fare + "</p>");

                // Button to viewScheduleDetails.jsp
                out.println("<div style='display: inline-block;'>");
                out.println("<form action='viewScheduleDetails.jsp' method='GET' style='display: inline;'>");
                out.println("<input type='hidden' name='trainID' value='" + trainID + "'/>");
                out.println("<input type='submit' value='View Details' style='padding: 8px 12px; background-color: #007BFF; color: #ffffff; border: none; border-radius: 4px; cursor: pointer;'/>");
                out.println("</form>");

                out.println("<form action='reserve.jsp' method='GET' style='display: inline; margin-left: 10px;'>");
                out.println("<input type='hidden' name='trainID' value='" + trainID + "'/>");
                out.println("<input type='submit' value='Reserve' style='padding: 8px 12px; background-color: #28a745; color: #ffffff; border: none; border-radius: 4px; cursor: pointer;'/>");
                out.println("</form>");
                out.println("</div>");
                out.println("<hr/>");

            }
        }
        con.close();
    }
    catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="searchTrains.jsp">Back to Search</a>
