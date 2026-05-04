package com.mirs.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.mirs.model.UserModel;
import com.mirs.service.UserService;

/**
 * LoginServlet Class
 * Handles user login/authentication for the MIRS system
 * 
 * This servlet follows the MVC architecture:
 * - doGet(): Displays the login form (view layer - login.jsp)
 * - doPost(): Processes login credentials (controller layer)
 * 
 * The servlet uses HttpSession for managing authenticated user sessions.
 * After successful login, user information is stored in session for access
 * throughout the application.
 * 
 * URL Mapping: /login
 * 
 * @author MIRS Development Team
 * @version 1.0
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle HTTP GET requests
     * Displays the login form page
     * 
     * Request Flow:
     * 1. User visits /login (GET request)
     * 2. Servlet forwards request to login.jsp view
     * 3. login.jsp renders login form HTML
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
            // Forward the request to login.jsp view
            // The JSP file will render the login form HTML
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log error and send error response
            System.err.println("Error in LoginServlet doGet(): " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                              "An error occurred while loading the login page");
        }
    }
    
    /**
     * Handle HTTP POST requests
     * Processes login form submission and validates credentials
     * 
     * Request Flow:
     * 1. User submits login form (POST request with username and password)
     * 2. Servlet retrieves credentials from request parameters
     * 3. Validates credentials against database using UserService
     * 4. If valid: Creates session and redirects to dashboard
     * 5. If invalid: Forwards back to login page with error message
     * 
     * Session Management:
     * - Valid login: User object stored in session attribute "user"
     * - Session timeout: 30 minutes (configure in web.xml if needed)
     * 
     * @param request HttpServletRequest containing POST parameters (username, password)
     * @param response HttpServletResponse for sending response to client
     * @throws ServletException if servlet encounters error
     * @throws IOException if I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Step 1: Retrieve login credentials from form submission
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Step 2: Validate input - check that credentials are provided
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                
                // Empty credentials - redirect back to login with error
                request.setAttribute("errorMessage", "Please enter both username and password");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                return;
            }
            
            // Step 3: Authenticate user using UserService
            // UserService queries database and verifies credentials
            UserModel user = UserService.authenticateUser(username, password);
            
            // Step 4: Check authentication result
            if (user != null && user.isActive()) {
                // Authentication successful
                System.out.println("âœ“ Login successful for user: " + username);
                
                // Step 5: Create session and store user information
                HttpSession session = request.getSession(true); // true = create new session if needed
                session.setAttribute("user", user); // Store UserModel in session
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole());
                session.setMaxInactiveInterval(30 * 60); // Session timeout: 30 minutes
                
                // Step 6: Redirect to appropriate dashboard based on user role
                if (user.isAdmin()) {
                    // Admin dashboard
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    // Member dashboard
                    response.sendRedirect(request.getContextPath() + "/member/dashboard");
                }
                
            } else {
                // Authentication failed
                System.out.println("âœ— Login failed for user: " + username);
                
                // Store error message in request for display in JSP
                request.setAttribute("errorMessage", 
                    "Invalid username or password. Please try again.");
                
                // Forward back to login page to display error
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            // Unexpected error occurred
            System.err.println("Error in LoginServlet doPost(): " + e.getMessage());
            e.printStackTrace();
            
            // Send error response
            request.setAttribute("errorMessage", 
                "An error occurred during login. Please try again later.");
            try {
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                                  "An unexpected error occurred");
            }
        }
    }
}
