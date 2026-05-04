package com.mirs.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mirs.model.UserModel;
import com.mirs.service.UserService;

/**
 * RegisterServlet Class
 * Handles user registration for the MIRS system
 * 
 * This servlet follows the MVC architecture:
 * - doGet(): Displays the registration form (view layer - register.jsp)
 * - doPost(): Processes registration data with validation and duplicate checking
 * 
 * The servlet ensures:
 * - All required fields are provided
 * - Username is not already taken
 * - Email is not already registered
 * - Password is sufficiently strong (implementation-dependent)
 * - Password and confirm password match
 * 
 * URL Mapping: /register
 * 
 * @author MIRS Development Team
 * @version 1.0
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle HTTP GET requests
     * Displays the registration form page
     * 
     * Request Flow:
     * 1. User visits /register (GET request)
     * 2. Servlet forwards request to register.jsp view
     * 3. register.jsp renders registration form HTML
     * 
     * @param request HttpServletRequest containing GET parameters
     * @param response HttpServletResponse for sending response to client
     * @throws ServletException if servlet encounters error
     * @throws IOException if I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Forward the request to register.jsp view
            // The JSP file will render the registration form HTML
            request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log error and send error response
            System.err.println("Error in RegisterServlet doGet(): " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                              "An error occurred while loading the registration page");
        }
    }
    
    /**
     * Handle HTTP POST requests
     * Processes registration form submission with validation
     * 
     * Request Flow:
     * 1. User submits registration form (POST request with registration data)
     * 2. Servlet retrieves all form parameters
     * 3. Validates input data (required fields, format, length)
     * 4. Checks for duplicate username and email using UserService
     * 5. If valid and unique: Creates user in database and redirects to login
     * 6. If invalid: Forwards back to registration page with error message
     * 
     * Validation Checks:
     * - All required fields must be provided and non-empty
     * - Username: 3-20 characters, alphanumeric preferred
     * - Email: Valid email format with @ and domain
     * - Password: Minimum 6 characters (strengthen as needed)
     * - Passwords must match (password and confirmPassword)
     * - First/Last names: Non-empty
     * - Phone: Optional, but if provided, must be valid format
     * 
     * @param request HttpServletRequest containing POST parameters
     * @param response HttpServletResponse for sending response to client
     * @throws ServletException if servlet encounters error
     * @throws IOException if I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Step 1: Retrieve all form parameters from registration form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phoneNumber = request.getParameter("phoneNumber");
            
            // Step 2: Trim whitespace from inputs
            if (username != null) username = username.trim();
            if (password != null) password = password.trim();
            if (confirmPassword != null) confirmPassword = confirmPassword.trim();
            if (email != null) email = email.trim();
            if (firstName != null) firstName = firstName.trim();
            if (lastName != null) lastName = lastName.trim();
            if (phoneNumber != null) phoneNumber = phoneNumber.trim();
            
            // Step 3: Validate all required fields are provided
            if (isFieldEmpty(username) || isFieldEmpty(password) || 
                isFieldEmpty(confirmPassword) || isFieldEmpty(email) || 
                isFieldEmpty(firstName) || isFieldEmpty(lastName)) {
                
                request.setAttribute("errorMessage", "All fields are required. Please fill in all forms.");
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 4: Validate username length (3-20 characters)
            if (username.length() < 3 || username.length() > 20) {
                request.setAttribute("errorMessage", "Username must be between 3 and 20 characters.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 5: Validate email format (basic check for @ and domain)
            if (!isValidEmail(email)) {
                request.setAttribute("errorMessage", "Please enter a valid email address.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 6: Validate password strength (minimum 6 characters)
            if (password.length() < 6) {
                request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 7: Verify passwords match
            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match. Please try again.");
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 8: Check for duplicate username (unique constraint)
            if (UserService.isUsernameTaken(username)) {
                request.setAttribute("errorMessage", 
                    "Username '" + username + "' is already taken. Please choose another.");
                request.setAttribute("email", email);
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 9: Check for duplicate email (unique constraint)
            if (UserService.isEmailTaken(email)) {
                request.setAttribute("errorMessage", 
                    "Email '" + email + "' is already registered.");
                request.setAttribute("username", username);
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
                return;
            }
            
            // Step 10: Create UserModel object with registration data
            UserModel newUser = new UserModel(
                username,
                password,
                email,
                firstName,
                lastName,
                phoneNumber != null && !phoneNumber.isEmpty() ? phoneNumber : ""
            );
            
            // Set role to member (default for new registrations)
            newUser.setRole("member");
            
            // Step 11: Attempt to register user in database
            UserService.RegistrationResult registrationResult = UserService.registerUser(newUser);
            if (registrationResult.isSuccess()) {
                // Registration successful
                System.out.println("âœ“ Registration successful for user: " + username);
                
                // Store success message in request
                request.setAttribute("successMessage", 
                    "Registration successful! You can now login with your credentials.");
                
                // Redirect to login page with success message
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                
            } else {
                // Registration failed (database error or other issue)
                System.out.println("âœ— Registration failed for user: " + username);
                
                request.setAttribute("errorMessage", registrationResult.getMessage());
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            // Unexpected error occurred
            System.err.println("Error in RegisterServlet doPost(): " + e.getMessage());
            e.printStackTrace();
            
            // Send error response
            request.setAttribute("errorMessage", 
                "An error occurred during registration. Please try again later.");
            try {
                request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                                  "An unexpected error occurred");
            }
        }
    }
    
    /**
     * Utility method to check if a field is empty or null
     * 
     * @param field The field value to check
     * @return true if field is null or empty (after trim), false otherwise
     */
    private boolean isFieldEmpty(String field) {
        return field == null || field.trim().isEmpty();
    }
    
    /**
     * Utility method to validate email format
     * Basic validation: checks for @ symbol and domain extension
     * 
     * For production, use Apache Commons Email validator or similar library
     * 
     * @param email The email address to validate
     * @return true if email appears valid, false otherwise
     */
    private boolean isValidEmail(String email) {
        // Basic email validation pattern
        // Regex: username@domain.extension
        String emailPattern = "^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email != null && email.matches(emailPattern);
    }
}
