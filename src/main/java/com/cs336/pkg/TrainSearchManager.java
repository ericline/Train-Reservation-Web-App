package com.cs336.pkg;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainSearchManager {
    public static List<String[]> searchTrains(String origin, String destination, String date) throws SQLException {
        String query = "SELECT TS.ScheduleID, TS.DepartureTime, TS.ArrivalTime, TS.Fare " +
                       "FROM TrainSchedules TS " +
                       "JOIN Stations OS ON TS.OriginStationID = OS.StationID " +
                       "JOIN Stations DS ON TS.DestinationStationID = DS.StationID " +
                       "WHERE OS.Name = ? AND DS.Name = ? AND DATE(TS.DepartureTime) = ?";
        List<String[]> results = new ArrayList<>();
        ApplicationDB DatabaseConnection = new ApplicationDB(); // Create an instance of ApplicationDB
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, origin);
            ps.setString(2, destination);
            ps.setString(3, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                results.add(new String[]{
                    rs.getString("ScheduleID"),
                    rs.getString("DepartureTime"),
                    rs.getString("ArrivalTime"),
                    rs.getString("Fare")
                });
            }
        }
        return results;
    }
}
