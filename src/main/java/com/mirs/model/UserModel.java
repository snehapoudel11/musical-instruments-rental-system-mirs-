package com.mirs.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * UserModel Class
 * Represents a user in the MIRS (Musical Instruments Rental System)
 * 
 * This model class encapsulates all user-related data and provides
 * getters/setters for data access and manipulation. It implements Serializable
 * to support session storage and object serialization.
 * 
 * Users can have two roles:
 * - admin: Can manage instruments, members, and rental records
 * - member: Can browse instruments, book/rent them, and view history
 * 
 * @author MIRS Development Team
 * @version 1.0
 */
public class UserModel implements Serializable {
    
    // Serial Version UID for serialization compatibility
    private static final long serialVersionUID = 1L;
    
    // ==================== User Fields ====================
    
    /** Unique identifier for the user (Primary Key in database) */
    private int userId;
    
    /** Username for login (must be unique) */
    private String username;
    
    /** Encrypted password (stored as hash in database) */
    private String password;
    
    /** User's email address (must be unique) */
    private String email;
    
    /** User's first name */
    private String firstName;
    
    /** User's last name */
    private String lastName;
    
    /** User's phone number */
    private String phoneNumber;
    
    /** User's role: 'admin' or 'member' */
    private String role;
    
    /** User's street address */
    private String address;
    
    /** City where user resides */
    private String city;
    
    /** State/Province where user resides */
    private String state;
    
    /** Postal/Zip code */
    private String zipCode;
    
    /** Account active status (true = active, false = inactive/suspended) */
    private boolean isActive;
    
    /** Timestamp when the user account was created */
    private Timestamp createdDate;
    
    /** Timestamp of user's last login */
    private Timestamp lastLogin;
    
    // ==================== Constructors ====================
    
    /**
     * Default constructor
     * Creates an empty UserModel object with all fields initialized to default values
     */
    public UserModel() {
        this.userId = 0;
        this.username = "";
        this.password = "";
        this.email = "";
        this.firstName = "";
        this.lastName = "";
        this.phoneNumber = "";
        this.role = "member"; // Default role is member
        this.address = "";
        this.city = "";
        this.state = "";
        this.zipCode = "";
        this.isActive = true;
        this.createdDate = null;
        this.lastLogin = null;
    }
    
    /**
     * Constructor for login operations
     * Creates a UserModel with minimal required fields for authentication
     * 
     * @param username User's login username
     * @param password User's login password
     */
    public UserModel(String username, String password) {
        this();
        this.username = username;
        this.password = password;
    }
    
    /**
     * Constructor for user registration with essential fields
     * 
     * @param username User's login username
     * @param password User's login password (will be hashed by service layer)
     * @param email User's email address
     * @param firstName User's first name
     * @param lastName User's last name
     * @param phoneNumber User's phone number
     */
    public UserModel(String username, String password, String email, 
                     String firstName, String lastName, String phoneNumber) {
        this();
        this.username = username;
        this.password = password;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phoneNumber = phoneNumber;
        this.role = "member"; // Registered users default to member role
    }
    
    /**
     * Full constructor with all fields
     * Used when retrieving complete user data from database
     * 
     * @param userId Unique user ID
     * @param username Login username
     * @param password Password hash
     * @param email Email address
     * @param firstName First name
     * @param lastName Last name
     * @param phoneNumber Phone number
     * @param role User role (admin/member)
     * @param address Street address
     * @param city City
     * @param state State
     * @param zipCode Postal code
     * @param isActive Account status
     * @param createdDate Account creation timestamp
     * @param lastLogin Last login timestamp
     */
    public UserModel(int userId, String username, String password, String email,
                     String firstName, String lastName, String phoneNumber, String role,
                     String address, String city, String state, String zipCode,
                     boolean isActive, Timestamp createdDate, Timestamp lastLogin) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.address = address;
        this.city = city;
        this.state = state;
        this.zipCode = zipCode;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.lastLogin = lastLogin;
    }
    
    // ==================== Getters ====================
    
    public int getUserId() {
        return userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    /**
     * Returns the full name by combining first and last names
     * 
     * @return Full name as "FirstName LastName"
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public String getRole() {
        return role;
    }
    
    /**
     * Checks if the user has admin role
     * 
     * @return true if user is admin, false otherwise
     */
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(role);
    }
    
    /**
     * Checks if the user has member role
     * 
     * @return true if user is member, false otherwise
     */
    public boolean isMember() {
        return "member".equalsIgnoreCase(role);
    }
    
    public String getAddress() {
        return address;
    }
    
    public String getCity() {
        return city;
    }
    
    public String getState() {
        return state;
    }
    
    public String getZipCode() {
        return zipCode;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public Timestamp getLastLogin() {
        return lastLogin;
    }
    
    // ==================== Setters ====================
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }
    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    // ==================== Utility Methods ====================
    
    /**
     * Returns a string representation of the UserModel object
     * Useful for debugging and logging
     * 
     * @return String representation of user data
     */
    @Override
    public String toString() {
        return "UserModel{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", role='" + role + '\'' +
                ", isActive=" + isActive +
                ", createdDate=" + createdDate +
                '}';
    }
    
    /**
     * Validates that all required fields are populated for registration
     * 
     * @return true if all required fields are non-empty, false otherwise
     */
    public boolean isValidForRegistration() {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty() &&
               email != null && !email.trim().isEmpty() &&
               firstName != null && !firstName.trim().isEmpty() &&
               lastName != null && !lastName.trim().isEmpty();
    }
    
    /**
     * Validates that credentials are present for login
     * 
     * @return true if username and password are non-empty, false otherwise
     */
    public boolean isValidForLogin() {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty();
    }
}
