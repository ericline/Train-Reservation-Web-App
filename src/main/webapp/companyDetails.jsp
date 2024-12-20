<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Details</title>
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
        .toggle-btn {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 10px;
            text-align: center;
            background-color: #007BFF;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
        }
        .toggle-btn:hover {
            background-color: #0056b3;
        }
        .hidden {
            display: none;
        }
        .dropdown-container {
            text-align: center;
            margin: 20px;
        }
        select {
            padding: 10px;
            font-size: 16px;
        }
        .button {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 10px;
            text-align: center;
            background-color: #007BFF;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        function toggleSection(sectionId) {
            const section = document.getElementById(sectionId);
            if (section.classList.contains('hidden')) {
                section.classList.remove('hidden');
            } else {
                section.classList.add('hidden');
            }
        }

        function showReservations() {
            const filter = document.getElementById('filterOption').value;  // Get the filter value from the dropdown
            if (!filter) {
                alert("Please select a filter option.");
                return;  // Exit the function if no filter is selected
            }

            document.getElementById('filterForm').filter.value = filter;  // Set the filter value in the hidden form
            document.getElementById('filterForm').action = 'showReservations.jsp';  // Set the form action to showReservations.jsp
            document.getElementById('filterForm').submit();  // Submit the form to send the data
        }

        function showRevenue() {
            const filter = document.getElementById('filterOption').value;  // Get the filter value from the dropdown
            if (!filter) {
                alert("Please select a filter option.");
                return;  // Exit the function if no filter is selected
            }

            document.getElementById('filterForm').filter.value = filter;  // Set the filter value in the hidden form
            document.getElementById('filterForm').action = 'showRevenue.jsp';  // Set the form action to showRevenue.jsp
            document.getElementById('filterForm').submit();  // Submit the form to send the data
        }

    </script>
</head>
<body>
    <h2>Company Details</h2>

    <!-- Sales Report Button -->
    <div>
        <a class="toggle-btn" onclick="toggleSection('salesReport')">Toggle Sales Report</a>
    </div>

    <!-- Sales Report Section -->
    <div id="salesReport" class="hidden">
        <h3>Sales Report Per Month</h3>
        <table>
            <tr>
                <th>Month</th>
                <th>Total Sales ($)</th>
            </tr>
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();

                    String query = "SELECT MONTH(ts.DepartureTime) AS Month, SUM(r.Price) AS TotalSales " +
                                   "FROM Reservations r " +
                                   "JOIN TrainSchedules ts ON r.ScheduleID = ts.ScheduleID " +
                                   "WHERE YEAR(ts.DepartureTime) = YEAR(CURDATE()) " +
                                   "GROUP BY MONTH(ts.DepartureTime) " +
                                   "ORDER BY MONTH(ts.DepartureTime)";
                    PreparedStatement ps = con.prepareStatement(query);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int month = rs.getInt("Month");
                        double totalSales = rs.getDouble("TotalSales");
            %>
            <tr>
                <td><%= new java.text.DateFormatSymbols().getMonths()[month - 1] %></td>
                <td>$<%= totalSales %></td>
            </tr>
            <%
                    }
                    rs.close();
                    ps.close();
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <!-- Best Customer Button -->
    <div>
        <a class="toggle-btn" onclick="toggleSection('bestCustomer')">Toggle Best Customer</a>
    </div>

    <!-- Best Customer Section -->
    <div id="bestCustomer" class="hidden">
        <h3>Best Customer</h3>
        <table>
            <tr>
                <th>Customer Name</th>
                <th>Total Spent ($)</th>
            </tr>
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();

                    String query = "SELECT c.FirstName, c.LastName, SUM(r.Price) AS TotalSpent " +
                                   "FROM Reservations r " +
                                   "JOIN Customers c ON r.CustomerID = c.CustomerID " +
                                   "GROUP BY c.CustomerID, c.FirstName, c.LastName " +
                                   "ORDER BY TotalSpent DESC " +
                                   "LIMIT 1";
                    PreparedStatement ps = con.prepareStatement(query);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String firstName = rs.getString("FirstName");
                        String lastName = rs.getString("LastName");
                        double totalSpent = rs.getDouble("TotalSpent");
            %>
            <tr>
                <td><%= firstName %> <%= lastName %></td>
                <td>$<%= totalSpent %></td>
            </tr>
            <%
                    } else {
                        out.println("<tr><td colspan='2'>No data available</td></tr>");
                    }
                    rs.close();
                    ps.close();
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <!-- Best 5 Transit Lines Button -->
    <div>
        <a class="toggle-btn" onclick="toggleSection('bestTransitLines')">Toggle Best 5 Transit Lines</a>
    </div>

    <!-- Best 5 Most Active Transit Lines Section -->
    <div id="bestTransitLines" class="hidden">
        <h3>Best 5 Most Active Transit Lines</h3>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Total Reservations</th>
            </tr>
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();

                    String query = "SELECT ts.TransitLine, COUNT(r.ReservationID) AS TotalReservations " +
                                   "FROM Reservations r " +
                                   "JOIN TrainSchedules ts ON r.ScheduleID = ts.ScheduleID " +
                                   "GROUP BY ts.TransitLine " +
                                   "ORDER BY TotalReservations DESC " +
                                   "LIMIT 5";
                    PreparedStatement ps = con.prepareStatement(query);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        String transitLine = rs.getString("TransitLine");
                        int totalReservations = rs.getInt("TotalReservations");
            %>
            <tr>
                <td><%= transitLine %></td>
                <td><%= totalReservations %></td>
            </tr>
            <%
                    }
                    rs.close();
                    ps.close();
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <!-- Dropdown for selecting filter option -->
	<div class="dropdown-container">
	    <label for="filterOption">Select Filter:</label>
	    <select id="filterOption">
	        <option value="">-- Select --</option>
	        <option value="transitLine">By Transit Line</option>
	        <option value="customerName">By Customer Name</option>
	    </select>
	</div>

    <!-- Hidden form for passing the filter -->
    <form id="filterForm" method="POST" style="display:none;">
        <input type="hidden" name="filter" id="filter" />
    </form>

    <!-- Buttons for showing reservations and revenue -->
    <div>
        <a class="button" onclick="showReservations()">Show Reservations</a>
        <a class="button" onclick="showRevenue()">Show Revenue</a>
    </div>

    <!-- Section for displaying dynamic results -->
    <div id="displaySection">
        <!-- Results will be dynamically inserted here -->
    </div>
</body>
<a href="adminPage.jsp">Back to Admin Controls</a>

</html>
