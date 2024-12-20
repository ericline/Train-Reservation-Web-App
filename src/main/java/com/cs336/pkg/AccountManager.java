package com.cs336.pkg;

import java.sql.*;

public class AccountManager {
    public static boolean validateLogin(String username, String password, String role) throws SQLException {
        String query = role.equals("Customer") ? "SELECT * FROM Customers WHERE Username = ? AND PasswordHash = ?" 
                                                 : "SELECT * FROM Employees WHERE Username = ? AND PasswordHash = ?";
        ApplicationDB DatabaseConnection = new ApplicationDB(); // Create an instance of ApplicationDB
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public static void registerCustomer(String firstName, String lastName, String email, String username, String password) throws SQLException {
        String query = "INSERT INTO Customers (FirstName, LastName, Email, Username, PasswordHash) VALUES (?, ?, ?, ?, ?)";
        ApplicationDB DatabaseConnection = new ApplicationDB(); // Create an instance of ApplicationDB
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, username);
            ps.setString(5, password);  // You should hash the password here before storing
            ps.executeUpdate();
        }
    }
}
