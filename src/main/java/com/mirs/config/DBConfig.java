package com.mirs.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Configuration Class  
 * Handles MySQL JDBC connection for the MIRS (Musical Instruments Rental System)
 * 
 * This class provides a centralized point for database connection management
 * using JDBC with proper error handling and resource management.
 * 
 * @author MIRS Development Team
 * @version 1.0
 */
public class DBConfig {
    
    // Database Configuration Constants
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_NAME = "mims_db";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/" + DB_NAME + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // Change this to your MySQL password
    
    /**
     * Establishes and returns a MySQL database connection
     * 
     * This method:
     * 1. Loads the MySQL JDBC driver
     * 2. Establishes connection using credentials and URL
     * 3. Returns the active connection for database operations
     * 
     * @return Connection object for database operations
     * @throws SQLException if database connection fails or driver cannot be loaded
     * @throws ClassNotFoundException if MySQL JDBC driver is not found in classpath
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            // Load MySQL JDBC Driver
            // The com.mysql.cj.jdbc.Driver class must be available in the classpath
            // Add mysql-connector-java JAR file to your project's lib folder
            Class.forName(DB_DRIVER);
            
            // Establish and return database connection
            // DriverManager.getConnection() creates a new connection using URL and credentials
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Return the active connection
            return connection;
            
        } catch (ClassNotFoundException e) {
            // Thrown if MySQL JDBC driver is not in classpath
            System.err.println("MySQL JDBC Driver not found. Please add mysql-connector-java.jar to your classpath.");
            throw new ClassNotFoundException("Driver not found: " + DB_DRIVER, e);
            
        } catch (SQLException e) {
            // Thrown if connection to database fails
            System.err.println("Database connection failed. Check URL, username, and password.");
            System.err.println("Error: " + e.getMessage());
            throw new SQLException("Failed to connect to database at " + DB_URL, e);
        }
    }
    
    /**
     * Closes a database connection safely
     * 
     * This utility method ensures proper resource cleanup by closing the connection
     * and handling any SQLException that may occur.
     * 
     * @param connection The Connection object to close (can be null)
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed successfully.");
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Test method to verify database connectivity
     * Run this main method to test if your database configuration is correct
     * 
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {
        Connection connection = null;
        try {
            connection = getConnection();
            if (connection != null && !connection.isClosed()) {
                System.out.println("âœ“ Database connection successful!");
                System.out.println("âœ“ Connected to: " + DB_URL);
                System.out.println("âœ“ User: " + DB_USER);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("âœ— Database connection failed!");
            System.out.println("âœ— Error: " + e.getMessage());
        } finally {
            closeConnection(connection);
        }
    }
}
