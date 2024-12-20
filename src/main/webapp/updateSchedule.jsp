<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*, java.util.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Train Schedule</title>
</head>
<body>
<%
    // Retrieve the schedule ID from the request
    String scheduleID = request.getParameter("scheduleID");
    boolean errorOccurred = false;

    // Validate the schedule ID
    if (scheduleID == null || scheduleID.isEmpty()) {
        out.println("<h2>Invalid Schedule ID. <a href='customerRep.jsp'>Go back</a></h2>");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    try {
        con.setAutoCommit(false); // Start a transaction

        // Loop through the request parameters to process each stop update
        for (String paramName : request.getParameterMap().keySet()) {
            if (paramName.startsWith("arrivalTime_")) {
                String stopID = paramName.substring("arrivalTime_".length());
                String arrivalTime = request.getParameter("arrivalTime_" + stopID);
                String departureTime = request.getParameter("departureTime_" + stopID);

                // Ensure both arrival and departure times are provided
                if (arrivalTime == null || departureTime == null || arrivalTime.isEmpty() || departureTime.isEmpty()) {
                    errorOccurred = true;
                    break;
                }

                try {
                    // Prepare the update query
                    PreparedStatement stmt = con.prepareStatement(
                        "UPDATE TrainStops SET ArrivalTime = ?, DepartureTime = ? WHERE StopID = ?"
                    );
                    stmt.setString(1, arrivalTime.replace("T", " "));
                    stmt.setString(2, departureTime.replace("T", " "));
                    stmt.setInt(3, Integer.parseInt(stopID));

                    // Execute the update
                    if (stmt.executeUpdate() == 0) {
                        errorOccurred = true;
                        break;
                    }
                } catch (SQLException e) {
                    errorOccurred = true;
                    out.println("<p>Error updating stop ID " + stopID + ": " + e.getMessage() + "</p>");
                    break;
                }
            }
        }

        // Commit or rollback the transaction based on success or failure
        if (errorOccurred) {
            con.rollback();
            out.println("<h2>Invalid input. Please try again. <a href='editSchedule.jsp?scheduleID=" + scheduleID + "'>Go back</a></h2>");
        } else {
            con.commit();
            out.println("<h2>Schedule updated successfully! <a href='customerRep.jsp'>Go back</a></h2>");
        }
    } catch (SQLException e) {
        try {
            con.rollback(); // Ensure rollback if an exception occurs
        } catch (SQLException rollbackEx) {
            out.println("<p>Error rolling back changes: " + rollbackEx.getMessage() + "</p>");
        }
        out.println("<p>Error updating schedule: " + e.getMessage() + "</p>");
    } finally {
        // Reset auto-commit and close the connection
        try {
            con.setAutoCommit(true);
            con.close();
        } catch (SQLException e) {
            out.println("<p>Error closing the connection: " + e.getMessage() + "</p>");
        }
    }
%>
</body>
</html>
