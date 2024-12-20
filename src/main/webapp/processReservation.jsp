<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Process Reservation</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        Integer customerID = (Integer) session.getAttribute("userID");
        int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
        int seats = Integer.parseInt(request.getParameter("seats"));

        // Get the discount parameter
        String discountParam = request.getParameter("discount");
        double discount = (discountParam != null && !discountParam.isEmpty()) ? Double.parseDouble(discountParam) : 1.0;

        // Get the trip type parameter
        String tripTypeParam = request.getParameter("tripType");
        boolean isRoundTrip = "roundTrip".equalsIgnoreCase(tripTypeParam); // Check if it's a round trip
        int multiplier = isRoundTrip ? 2 : 1; // Multiplier for round trip vs one-way

        // Retrieve the fare from the TrainSchedules table
        String fareQuery = "SELECT Fare FROM TrainSchedules WHERE ScheduleID = ?";
        PreparedStatement fareStmt = con.prepareStatement(fareQuery);
        fareStmt.setInt(1, scheduleID);
        ResultSet fareResult = fareStmt.executeQuery();

        double fare = 0;
        if (fareResult.next()) {
            fare = fareResult.getDouble("Fare");
        }
        fareResult.close();
        fareStmt.close();

        double price = seats * fare * discount * multiplier;

        String insert = "INSERT INTO Reservations (CustomerID, ScheduleID, SeatsReserved, ReservationStatus, Price) " +
                        "VALUES (?, ?, ?, 'Confirmed', ?)";
        PreparedStatement ps = con.prepareStatement(insert);

        ps.setInt(1, customerID);  
        ps.setInt(2, scheduleID);   
        ps.setInt(3, seats);       
        ps.setDouble(4, price);

        int result = ps.executeUpdate();
        ps.close();
        con.close();

        if (result > 0) {
            out.print("<h2>Reservation Successful!</h2>");
            out.print("<p>Your reservation has been confirmed. The total price is: $" + price + "</p>");
            out.print("<a href='searchTrains.jsp'>Back to Train Search</a>");
        } else {
            out.print("<h2>Reservation Failed</h2>");
            out.print("<p>Unable to add the reservation. Please try again.</p>");
            out.print("<a href='searchTrains.jsp'>Back to Train Search</a>");
        }
    } catch (SQLException ex) {
        out.print("<h2>Error</h2>");
        out.print("<p>There was an issue adding the reservation: " + ex.getMessage() + "</p>");
        out.print("<a href='searchTrains.jsp'>Back to Train Search</a>");
    } catch (NumberFormatException ex) {
        out.print("<h2>Invalid Input</h2>");
        out.print("<p>Please ensure all fields are filled correctly: " + ex.getMessage() + "</p>");
        out.print("<a href='searchTrains.jsp'>Back to Train Search</a>");
    } catch (Exception ex) {
        out.print("<h2>Unexpected Error</h2>");
        out.print("<p>Something went wrong: " + ex.getMessage() + "</p>");
        out.print("<a href='searchTrains.jsp'>Back to Train Search</a>");
    }
%>
</body>
</html>
