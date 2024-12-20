<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Trains</title>
    <style>
        /* Center the form on the page */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 100vh;
            background-color: #f9f9f9;
        }
        form {
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px 30px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        label, select, input {
            display: block;
            width: 100%;
            margin-bottom: 15px;
            font-size: 16px;
        }
        select, input[type="date"] {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            color: #ffffff;
            background-color: #007BFF;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .action-btn {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            color: #ffffff;
            background-color: #28a745;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        .action-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<%
    // Fetch station names from the database
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement stmt = con.createStatement();
    String stationQuery = "SELECT Name FROM Stations";
    ResultSet stationResult = stmt.executeQuery(stationQuery);

    // Store station names in a list and sort them alphabetically
    List<String> stationNames = new ArrayList<>();
    while (stationResult.next()) {
        stationNames.add(stationResult.getString("Name"));
    }
    // Sort alphabetically
    stationNames.sort(new Comparator<String>() {
        @Override
        public int compare(String s1, String s2) {
            return s1.compareToIgnoreCase(s2);
        }
    });

    stationResult.close();
    stmt.close();
    con.close();
%>
    <form action="displaySearchResults.jsp" method="GET">
        <h2>Search Trains</h2>

        <!-- Origin -->
        <label for="origin">Origin:</label>
        <select id="origin" name="origin" required>
            <option value="" disabled selected>Choose Origin</option>
            <% for (String station : stationNames) { %>
                <option value="<%= station %>"><%= station %></option>
            <% } %>
        </select>

        <!-- Destination -->
        <label for="destination">Destination:</label>
        <select id="destination" name="destination" required>
            <option value="" disabled selected>Choose Destination</option>
            <% for (String station : stationNames) { %>
                <option value="<%= station %>"><%= station %></option>
            <% } %>
        </select>

        <!-- Date -->
        <label for="date">Date:</label>
        <input type="date" id="date" name="date" required/>
        
        <input type="submit" value="Search"/>
        
        <script>
            // Get today's date in YYYY-MM-DD format
            const today = new Date().toISOString().split('T')[0];
            // Set the default value of the date input to today's date
            document.getElementById('date').value = today;
        </script>
    </form>

    <!-- Logout Button -->
    <form action="logout.jsp" method="POST">
        <input type="submit" value="Logout"/>
    </form>

    <!-- Current Reservations Button -->
    <form action="currentReservations.jsp" method="GET">
        <input type="submit" value="Current Reservations" class="action-btn"/>
    </form>

    <!-- Past Reservations Button -->
    <form action="pastReservations.jsp" method="GET">
        <input type="submit" value="Past Reservations" class="action-btn"/>
    </form>
    
    <!-- Send Question to Representative Button -->
	<form action="sendQuestion.jsp" method="GET">
	    <input type="submit" value="Send a Question to a Representative" class="action-btn"/>
	</form>
</body>
</html>
