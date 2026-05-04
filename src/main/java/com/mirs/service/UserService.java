package com.mirs.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.mirs.config.DBConfig;
import com.mirs.model.UserModel;

/**
 * UserService Class
 * Business logic layer for user-related operations.
 */
public class UserService {

    public static class RegistrationResult {
        private final boolean success;
        private final String message;

        public RegistrationResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }
    }

    public static UserModel authenticateUser(String username, String password) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        UserModel user = null;

        try {
            connection = DBConfig.getConnection();

            String query = "SELECT user_id, username, password, email, first_name, last_name, "
                    + "phone_number, role, address, city, state, zip_code, is_active, "
                    + "created_date, last_login FROM users WHERE username = ? AND is_active = TRUE";

            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String storedPassword = resultSet.getString("password");

                if (storedPassword.equals(password)) {
                    user = new UserModel(
                            resultSet.getInt("user_id"),
                            resultSet.getString("username"),
                            resultSet.getString("password"),
                            resultSet.getString("email"),
                            resultSet.getString("first_name"),
                            resultSet.getString("last_name"),
                            resultSet.getString("phone_number"),
                            resultSet.getString("role"),
                            resultSet.getString("address"),
                            resultSet.getString("city"),
                            resultSet.getString("state"),
                            resultSet.getString("zip_code"),
                            resultSet.getBoolean("is_active"),
                            resultSet.getTimestamp("created_date"),
                            resultSet.getTimestamp("last_login"));

                    String updateQuery = "UPDATE users SET last_login = NOW() WHERE user_id = ?";
                    PreparedStatement updateStmt = connection.prepareStatement(updateQuery);
                    updateStmt.setInt(1, user.getUserId());
                    updateStmt.executeUpdate();
                    updateStmt.close();

                    System.out.println("User '" + username + "' authenticated successfully");
                    return user;
                }
            }

            System.out.println("Authentication failed for user: " + username);
            return null;

        } catch (SQLException e) {
            System.err.println("Database error during authentication: " + e.getMessage());
            return null;
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            return null;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    public static RegistrationResult registerUser(UserModel user) {
        Connection connection = null;
        PreparedStatement duplicateStatement = null;
        PreparedStatement insertStatement = null;
        ResultSet duplicateResultSet = null;

        try {
            connection = DBConfig.getConnection();

            String duplicateQuery = "SELECT username, email FROM users WHERE username = ? OR email = ?";
            duplicateStatement = connection.prepareStatement(duplicateQuery);
            duplicateStatement.setString(1, user.getUsername());
            duplicateStatement.setString(2, user.getEmail());
            duplicateResultSet = duplicateStatement.executeQuery();

            while (duplicateResultSet.next()) {
                String existingUsername = duplicateResultSet.getString("username");
                String existingEmail = duplicateResultSet.getString("email");

                if (existingUsername != null && existingUsername.equalsIgnoreCase(user.getUsername())) {
                    return new RegistrationResult(false,
                            "That username is already taken. Please choose a different one.");
                }
                if (existingEmail != null && existingEmail.equalsIgnoreCase(user.getEmail())) {
                    return new RegistrationResult(false,
                            "That email address is already registered. Try signing in instead.");
                }
            }

            String insertQuery = "INSERT INTO users (username, password, email, first_name, "
                    + "last_name, phone_number, role, is_active, created_date) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, TRUE, NOW())";

            insertStatement = connection.prepareStatement(insertQuery);
            insertStatement.setString(1, user.getUsername());
            insertStatement.setString(2, user.getPassword());
            insertStatement.setString(3, user.getEmail());
            insertStatement.setString(4, user.getFirstName());
            insertStatement.setString(5, user.getLastName());
            insertStatement.setString(6, user.getPhoneNumber());
            insertStatement.setString(7, user.getRole() != null ? user.getRole() : "member");

            int result = insertStatement.executeUpdate();
            if (result > 0) {
                System.out.println("User '" + user.getUsername() + "' registered successfully");
                return new RegistrationResult(true, "Registration successful.");
            }

            return new RegistrationResult(false,
                    "Registration could not be completed. Please try again.");

        } catch (SQLException e) {
            System.err.println("Database error during registration: " + e.getMessage());
            return new RegistrationResult(false, buildRegistrationErrorMessage(e));
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            return new RegistrationResult(false,
                    "The database driver is missing. Make sure the MySQL connector is available to Tomcat.");
        } finally {
            try {
                if (duplicateResultSet != null) {
                    duplicateResultSet.close();
                }
                if (duplicateStatement != null) {
                    duplicateStatement.close();
                }
                if (insertStatement != null) {
                    insertStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    private static String buildRegistrationErrorMessage(SQLException e) {
        String message = e.getMessage() == null ? "" : e.getMessage().toLowerCase();

        if (message.contains("access denied")) {
            return "Database login failed. Update the MySQL username/password in DBConfig.java.";
        }
        if (message.contains("communications link failure")
                || message.contains("connection refused")
                || message.contains("failed to connect")) {
            return "Could not connect to MySQL. Make sure the MySQL server is running.";
        }
        if (message.contains("duplicate entry")) {
            return "That username or email is already in use.";
        }

        return "Database error: " + e.getMessage();
    }

    public static boolean isUsernameTaken(String username) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            String query = "SELECT COUNT(*) as count FROM users WHERE username = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("count") > 0;
            }
            return false;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking username: " + e.getMessage());
            return false;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    public static boolean isEmailTaken(String email) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            String query = "SELECT COUNT(*) as count FROM users WHERE email = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("count") > 0;
            }
            return false;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking email: " + e.getMessage());
            return false;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    public static boolean isUsernameTakenByOtherUser(String username, int userId) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            String query = "SELECT COUNT(*) as count FROM users WHERE username = ? AND user_id <> ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            preparedStatement.setInt(2, userId);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("count") > 0;
            }
            return false;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking username for profile update: " + e.getMessage());
            return true;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    public static boolean isEmailTakenByOtherUser(String email, int userId) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            String query = "SELECT COUNT(*) as count FROM users WHERE email = ? AND user_id <> ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setInt(2, userId);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("count") > 0;
            }
            return false;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error checking email for profile update: " + e.getMessage());
            return true;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    public static RegistrationResult updateUserProfile(UserModel user) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            connection = DBConfig.getConnection();
            String query = "UPDATE users SET username = ?, email = ?, first_name = ?, last_name = ?, "
                    + "phone_number = ?, address = ?, city = ?, state = ?, zip_code = ? "
                    + "WHERE user_id = ? AND is_active = TRUE";

            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getFirstName());
            preparedStatement.setString(4, user.getLastName());
            preparedStatement.setString(5, user.getPhoneNumber());
            preparedStatement.setString(6, user.getAddress());
            preparedStatement.setString(7, user.getCity());
            preparedStatement.setString(8, user.getState());
            preparedStatement.setString(9, user.getZipCode());
            preparedStatement.setInt(10, user.getUserId());

            int result = preparedStatement.executeUpdate();
            if (result > 0) {
                return new RegistrationResult(true, "Account information updated.");
            }

            return new RegistrationResult(false,
                    "Your account could not be updated. Please sign in again and retry.");

        } catch (SQLException e) {
            System.err.println("Database error during profile update: " + e.getMessage());
            return new RegistrationResult(false, buildRegistrationErrorMessage(e));
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            return new RegistrationResult(false,
                    "The database driver is missing. Make sure the MySQL connector is available to Tomcat.");
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }

    public static UserModel getUserById(int userId) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            String query = "SELECT * FROM users WHERE user_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, userId);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return new UserModel(
                        resultSet.getInt("user_id"),
                        resultSet.getString("username"),
                        resultSet.getString("password"),
                        resultSet.getString("email"),
                        resultSet.getString("first_name"),
                        resultSet.getString("last_name"),
                        resultSet.getString("phone_number"),
                        resultSet.getString("role"),
                        resultSet.getString("address"),
                        resultSet.getString("city"),
                        resultSet.getString("state"),
                        resultSet.getString("zip_code"),
                        resultSet.getBoolean("is_active"),
                        resultSet.getTimestamp("created_date"),
                        resultSet.getTimestamp("last_login"));
            }
            return null;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error retrieving user: " + e.getMessage());
            return null;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }
    public static RegistrationResult changePassword(int userId, String currentPassword, String newPassword) {
        Connection connection = null;
        PreparedStatement checkStatement = null;
        PreparedStatement updateStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();

            // First, verify current password
            String checkQuery = "SELECT password FROM users WHERE user_id = ? AND is_active = TRUE";
            checkStatement = connection.prepareStatement(checkQuery);
            checkStatement.setInt(1, userId);
            resultSet = checkStatement.executeQuery();

            if (resultSet.next()) {
                String storedPassword = resultSet.getString("password");
                if (!storedPassword.equals(currentPassword)) {
                    return new RegistrationResult(false, "The current password you entered is incorrect.");
                }
            } else {
                return new RegistrationResult(false, "User account not found or inactive.");
            }

            // Update with new password
            String updateQuery = "UPDATE users SET password = ? WHERE user_id = ?";
            updateStatement = connection.prepareStatement(updateQuery);
            updateStatement.setString(1, newPassword);
            updateStatement.setInt(2, userId);

            int result = updateStatement.executeUpdate();
            if (result > 0) {
                return new RegistrationResult(true, "Your password has been changed successfully.");
            }

            return new RegistrationResult(false, "Could not update password. Please try again.");

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database error during password change: " + e.getMessage());
            return new RegistrationResult(false, "A database error occurred. Please try again later.");
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (checkStatement != null) checkStatement.close();
                if (updateStatement != null) updateStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }
}
