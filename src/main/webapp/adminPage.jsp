<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Controls</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }
        h2 {
            text-align: center;
        }
        form {
            margin-bottom: 20px;
            background-color: #fff;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 400px;
            margin: 0 auto;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        form div {
            margin-bottom: 15px;
        }
        form label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        form input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        form button {
            padding: 10px 15px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        form button:hover {
            background-color: #0056b3;
        }
        .top-buttons {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 10px;
        }
        .top-buttons a {
            text-decoration: none;
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border-radius: 5px;
            font-size: 16px;
        }
        .top-buttons a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <!-- Top Navigation Buttons -->
    <div class="top-buttons">
        <a href="companyDetails.jsp">Company Details</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>Admin Controls</h2>

    <!-- Add Customer Representative -->
    <form action="addCustomerRep.jsp" method="POST">
        <h3>Add Customer Representative</h3>
        <div>
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" required />
        </div>
        <div>
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" required />
        </div>
        <div>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required />
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required />
        </div>
        <button type="submit">Add Customer Rep</button>
    </form>

    <!-- Delete Customer Representative -->
    <form action="deleteCustomerRep.jsp" method="POST">
        <h3>Delete Customer Representative</h3>
        <div>
            <label for="deleteUsername">Username:</label>
            <input type="text" id="deleteUsername" name="username" required />
        </div>
        <button type="submit">Delete Customer Rep</button>
    </form>

    <!-- Edit Customer Representative -->
    <form action="editCustomerRep.jsp" method="POST">
        <h3>Edit Customer Representative</h3>
        <div>
            <label for="editUsername">Username:</label>
            <input type="text" id="editUsername" name="username" required />
        </div>
        <div>
            <label for="newPassword">New Password:</label>
            <input type="password" id="newPassword" name="newPassword" required />
        </div>
        <button type="submit">Update Password</button>
    </form>
</body>
</html>
