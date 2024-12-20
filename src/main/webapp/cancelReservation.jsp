<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, com.cs336.pkg.ApplicationDB" %>

<%
    // Get the reservation ID from the request
    int reservationID = Integer.parseInt(request.getParameter("reservationID"));

    // Cancel the reservation in the database
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    String query = "UPDATE Reservations SET ReservationStatus = 'Cancelled' WHERE ReservationID = ?";
    PreparedStatement ps = con.prepareStatement(query);
    ps.setInt(1, reservationID);

    int result = ps.executeUpdate();

    // Clean up
    ps.close();
    con.close();

    if (result > 0) {
        // Redirect back to viewReservations.jsp
        response.sendRedirect("currentReservations.jsp");
    } else {
        out.println("<p>Failed to cancel the reservation. Please try again.</p>");
        out.println("<a href='viewReservations.jsp'>Back to Reservations</a>");
    }
%>
