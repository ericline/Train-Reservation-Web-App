<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<%
    // Retrieve session attributes
    String user = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Ensure the user is logged in and has the 'CustomerRep' role
    if (user == null || !("CustomerRep".equals(role))) {
    	response.sendRedirect("login.jsp"); // Redirect unauthorized users to the login page
        return;
    }

    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection();
%>
<html>
<head>
    <title>Customer Representative Dashboard</title>
</head>
<body>
    <h1>Welcome, <%= user %>!</h1>
    <h2>Customer Representative Dashboard</h2>

    <form action="logout.jsp" method="GET" style="margin-top: 20px;">
        <button type="submit">Logout</button>
    </form><br>

    <!-- Manage Train Schedules -->
    <h3>Manage Train Schedules</h3>

    <!-- Sorting Options -->
    <form method="GET">
        <label for="sort">Sort By:</label>
        <select name="sort" id="sort">
            <option value="">--Select--</option>
            <option value="departure">Departure Time</option>
            <option value="arrival">Arrival Time</option>
            <option value="transitLine">Transit Line</option>
            <option value="fare">Total Fare</option>
        </select>
        <button type="submit">Sort</button>
    </form>

    <table border="1">
        <tr>
            <th>Schedule ID</th>
            <th>Transit Line</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
            <th>Fare</th>
            <th>Actions</th>
        </tr>
        <%
            String sortOption = request.getParameter("sort");
            String orderByClause = "";

            if ("departure".equals(sortOption)) {
                orderByClause = "ORDER BY DepartureTime";
            } else if ("arrival".equals(sortOption)) {
                orderByClause = "ORDER BY ArrivalTime";
            } else if ("transitLine".equals(sortOption)) {
                orderByClause = "ORDER BY TransitLine";
            } else if ("fare".equals(sortOption)) {
                orderByClause = "ORDER BY Fare DESC";
            }

            String query = "SELECT ScheduleID, TransitLine, DepartureTime, ArrivalTime, Fare " +
                    "FROM TrainSchedules " + orderByClause;

            try (Statement stmt = con.createStatement()) {
                ResultSet rs = stmt.executeQuery(query);

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("ScheduleID") %></td>
            <td><%= rs.getString("TransitLine") %></td>
            <td><%= rs.getTimestamp("DepartureTime") %></td>
            <td><%= rs.getTimestamp("ArrivalTime") %></td>
            <td><%= rs.getDouble("Fare") %></td>
            <td>
                <form action="editSchedule.jsp" method="POST" style="display:inline;">
                    <input type="hidden" name="scheduleID" value="<%= rs.getInt("ScheduleID") %>">
                    <button type="submit">Edit</button>
                </form>
                <form action="deleteSchedule.jsp" method="POST" style="display:inline;">
                    <input type="hidden" name="scheduleID" value="<%= rs.getInt("ScheduleID") %>">
                    <button type="submit">Delete</button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                out.println("<p>Error fetching train schedules: " + e.getMessage() + "</p>");
            }
        %>
    </table>
    
<h3>Open Questions</h3>
<form method="GET">
    <label for="search">Search:</label>
    <input type="text" id="search" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
    <button type="submit">Search</button>
    <button type="button" onclick="location.href='customerRep.jsp';">Clear</button>
</form>

<table border="1">
    <tr>
        <th>Question ID</th>
        <th>Customer Name</th>
        <th>Question</th>
        <th>Reply</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <%
        String searchKeyword = request.getParameter("search");
        String question_query = "SELECT q.QuestionID, cu.FirstName AS CustomerName, cu.LastName AS CustomerLastName, " +
                                "q.QuestionText, q.ReplyText, q.Status " +
                                "FROM Questions q " +
                                "JOIN Customers cu ON q.CustomerID = cu.CustomerID " +
                                "WHERE q.Status = 'Unresolved'";

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            question_query += " AND (cu.FirstName LIKE '%" + searchKeyword + "%' " +
                              "OR cu.LastName LIKE '%" + searchKeyword + "%' " +
                              "OR q.QuestionText LIKE '%" + searchKeyword + "%')";
        }

        try (Statement stmt = con.createStatement()) {
            ResultSet rs = stmt.executeQuery(question_query);

            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("QuestionID") %></td>
        <td><%= rs.getString("CustomerName") + " " + rs.getString("CustomerLastName") %></td>
        <td><%= rs.getString("QuestionText") != null ? rs.getString("QuestionText") : "No question text provided" %></td>
        <td><%= rs.getString("ReplyText") != null ? rs.getString("ReplyText") : "No reply yet" %></td>
        <td><%= rs.getString("Status") %></td>
        <td>
            <form action="customerMsg.jsp" method="GET" style="display:inline;">
                <input type="hidden" name="questionID" value="<%= rs.getInt("QuestionID") %>">
                <button type="submit">View</button>
            </form>
            <form action="closeMsg.jsp" method="POST" style="display:inline;">
                <input type="hidden" name="questionID" value="<%= rs.getInt("QuestionID") %>">
                <button type="submit">Close</button>
            </form>
        </td>
    </tr>
    <%
            }
        } catch (SQLException e) {
            out.println("<p>Error fetching questions: " + e.getMessage() + "</p>");
        }
    %>
</table>
<br>


<h3>Other Actions</h3>
<form action="viewStationSchedule.jsp" method="GET">
    <button type="submit">View Schedules for Station</button>
</form>
<form action="viewReservations.jsp" method="GET">
    <button type="submit">View Customers with Reservations</button>
</form>
</body>
</html>
