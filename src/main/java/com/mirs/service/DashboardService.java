package com.mirs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.mirs.config.DBConfig;

/**
 * DashboardService Class
 * Provides business logic for dashboard data retrieval
 * 
 * This service handles:
 * - Admin dashboard statistics (total instruments, users, rentals, revenue)
 * - Member dashboard data (their rentals, available instruments)
 * - Real-time database queries
 * 
 * @author MIRS Development Team
 * @version 1.0
 */
public class DashboardService {
    
    /**
     * Get admin dashboard statistics
     * Returns summary of all system activity
     * 
     * @return Map containing: totalInstruments, totalUsers, totalRentals, activeRentals, totalRevenue
     */
    public static Map<String, Object> getAdminDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConfig.getConnection();
            
            // Total instruments
            String query1 = "SELECT COUNT(*) as total FROM instruments";
            stmt = connection.prepareStatement(query1);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalInstruments", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Total users (members only)
            String query2 = "SELECT COUNT(*) as total FROM users WHERE role = 'member'";
            stmt = connection.prepareStatement(query2);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalMembers", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Total rentals
            String query3 = "SELECT COUNT(*) as total FROM rentals";
            stmt = connection.prepareStatement(query3);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalRentals", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Active rentals
            String query4 = "SELECT COUNT(*) as total FROM rentals WHERE status = 'active'";
            stmt = connection.prepareStatement(query4);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("activeRentals", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Total revenue from payments
            String query5 = "SELECT SUM(amount_paid) as total FROM payment_records WHERE payment_status = 'completed'";
            stmt = connection.prepareStatement(query5);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Double revenue = rs.getDouble("total");
                stats.put("totalRevenue", revenue != null ? revenue : 0.0);
            }
            rs.close();
            stmt.close();
            
            // Overdue rentals
            String query6 = "SELECT COUNT(*) as total FROM rentals WHERE status IN ('active', 'overdue') AND return_date < CURDATE()";
            stmt = connection.prepareStatement(query6);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("overdueRentals", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Low stock instruments (available_quantity < 2)
            String query7 = "SELECT COUNT(*) as total FROM instruments WHERE available_quantity < 2 AND availability_status = 'available'";
            stmt = connection.prepareStatement(query7);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("lowStockInstruments", rs.getInt("total"));
            }
            
            return stats;
            
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching admin dashboard stats: " + e.getMessage());
            e.printStackTrace();
            return stats;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get member/user dashboard statistics
     * Returns data relevant to specific member
     * 
     * @param userId The member's user ID
     * @return Map containing: myRentals, activeRentals, availableInstruments, myOverdueRentals
     */
    public static Map<String, Object> getMemberDashboardStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConfig.getConnection();
            
            // My total rentals
            String query1 = "SELECT COUNT(*) as total FROM rentals WHERE member_id = ?";
            stmt = connection.prepareStatement(query1);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("myTotalRentals", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // My active rentals
            String query2 = "SELECT COUNT(*) as total FROM rentals WHERE member_id = ? AND status = 'active'";
            stmt = connection.prepareStatement(query2);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("myActiveRentals", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // My overdue rentals
            String query3 = "SELECT COUNT(*) as total FROM rentals WHERE member_id = ? AND status IN ('active', 'overdue') AND return_date < CURDATE()";
            stmt = connection.prepareStatement(query3);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("myOverdueRentals", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // My total fines
            String query4 = "SELECT SUM(fine_amount) as total FROM rentals WHERE member_id = ?";
            stmt = connection.prepareStatement(query4);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Double fines = rs.getDouble("total");
                stats.put("myTotalFines", fines != null ? fines : 0.0);
            }
            rs.close();
            stmt.close();
            
            // Available instruments count
            String query5 = "SELECT COUNT(*) as total FROM instruments WHERE availability_status = 'available' AND available_quantity > 0";
            stmt = connection.prepareStatement(query5);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("availableInstruments", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Categories count
            String query6 = "SELECT COUNT(*) as total FROM categories";
            stmt = connection.prepareStatement(query6);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalCategories", rs.getInt("total"));
            }
            
            return stats;
            
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching member dashboard stats: " + e.getMessage());
            e.printStackTrace();
            return stats;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get recent member rentals for dashboard display
     * 
     * @param userId The member's user ID
     * @param limit Number of recent rentals to fetch
     * @return HTML table rows with rental data
     */
    public static String getMemberRecentRentals(int userId, int limit) {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        StringBuilder html = new StringBuilder();
        
        try {
            connection = DBConfig.getConnection();
            String query = "SELECT r.rental_id, i.instrument_name, r.rental_date, r.return_date, r.status, r.fine_amount " +
                          "FROM rentals r " +
                          "JOIN instruments i ON r.instrument_id = i.instrument_id " +
                          "WHERE r.member_id = ? " +
                          "ORDER BY r.rental_date DESC " +
                          "LIMIT ?";
            stmt = connection.prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                String statusClass = getStatusClass(rs.getString("status"));
                html.append("<tr>")
                    .append("<td>").append(rs.getInt("rental_id")).append("</td>")
                    .append("<td>").append(rs.getString("instrument_name")).append("</td>")
                    .append("<td>").append(rs.getString("rental_date")).append("</td>")
                    .append("<td>").append(rs.getString("return_date")).append("</td>")
                    .append("<td><span class='badge ").append(statusClass).append("'>")
                    .append(rs.getString("status").toUpperCase()).append("</span></td>")
                    .append("<td>$").append(String.format("%.2f", rs.getDouble("fine_amount"))).append("</td>")
                    .append("</tr>");
            }
            
            if (html.length() == 0) {
                html.append("<tr><td colspan='6' class='text-center text-muted'>No rentals yet</td></tr>");
            }
            
            return html.toString();
            
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching member rentals: " + e.getMessage());
            return "<tr><td colspan='6' class='text-center text-danger'>Error loading rentals</td></tr>";
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Helper method to get CSS class for rental status badge
     */
    private static String getStatusClass(String status) {
        switch (status.toLowerCase()) {
            case "active": return "badge-primary";
            case "returned": return "badge-success";
            case "overdue": return "badge-danger";
            case "pending": return "badge-warning";
            case "cancelled": return "badge-secondary";
            default: return "badge-secondary";
        }
    }

    /**
     * Get recently added instruments for admin dashboard
     * @param limit number of instruments to fetch
     * @return List of Map objects with instrument data
     */
    public static java.util.List<java.util.Map<String, Object>> getRecentlyAddedInstruments(int limit) {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            connection = DBConfig.getConnection();
            String query = "SELECT i.instrument_id, i.instrument_name, c.category_name, i.brand, " +
                           "i.rental_price_per_day, i.availability_status, i.available_quantity, i.date_added " +
                           "FROM instruments i JOIN categories c ON i.category_id = c.category_id " +
                           "ORDER BY i.date_added DESC LIMIT ?";
            stmt = connection.prepareStatement(query);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();
            while (rs.next()) {
                java.util.Map<String, Object> row = new java.util.HashMap<>();
                row.put("instrumentId",      rs.getInt("instrument_id"));
                row.put("instrumentName",    rs.getString("instrument_name"));
                row.put("categoryName",      rs.getString("category_name"));
                row.put("brand",             rs.getString("brand"));
                row.put("dailyRate",         rs.getBigDecimal("rental_price_per_day"));
                row.put("status",            rs.getString("availability_status"));
                row.put("availableQty",      rs.getInt("available_quantity"));
                row.put("dateAdded",         rs.getTimestamp("date_added"));
                list.add(row);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching recent instruments: " + e.getMessage());
        } finally {
            try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (connection != null) connection.close(); } catch (SQLException ignored) {}
        }
        return list;
    }

    /**
     * Get total fines collected (used in admin dashboard stats)
     * @return total fine amount from all rentals
     */
    public static double getTotalFinesCollected() {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            connection = DBConfig.getConnection();
            stmt = connection.prepareStatement("SELECT SUM(fine_amount) as total FROM rentals WHERE fine_amount > 0");
            rs = stmt.executeQuery();
            if (rs.next()) return rs.getDouble("total");
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching total fines: " + e.getMessage());
        } finally {
            try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (connection != null) connection.close(); } catch (SQLException ignored) {}
        }
        return 0.0;
    }
}
