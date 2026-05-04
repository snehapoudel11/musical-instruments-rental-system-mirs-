package com.mirs.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LogoutServlet Class
 * Handles user logout and session termination
 * 
 * This servlet:
 * - Invalidates the user's session
 * - Clears all session data
 * - Redirects to login page with logout message
 * 
 * URL Mapping: /logout
 * 
 * @author MIRS Development Team
 * @version 1.0
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle HTTP GET requests for logout
     * 
     * Process:
     * 1. Get the user's current session (without creating a new one)
     * 2. If session exists, invalidate it (clear all data)
     * 3. Log the logout event
     * 4. Redirect to login page with success message
     * 
     * @param request HttpServletRequest containing session info
     * @param response HttpServletResponse for sending response
     * @throws ServletException if servlet error occurs
     * @throws IOException if I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Step 1: Get session (false = don't create new session)
            HttpSession session = request.getSession(false);
            
            // Step 2: Get user info before invalidating (for logging)
            String username = "Unknown User";
            if (session != null) {
                Object userObj = session.getAttribute("user");
                if (userObj != null) {
                    com.mirs.model.UserModel user = (com.mirs.model.UserModel) userObj;
                    username = user.getUsername();
                }
            }
            
            // Step 3: Invalidate session to clear all data
            if (session != null) {
                session.invalidate();
                System.out.println("âœ“ User logged out: " + username);
            }
            
            // Step 4: Redirect to login page with message
            response.sendRedirect(request.getContextPath() + "/login?logout=success");
            
        } catch (Exception e) {
            System.err.println("Error in LogoutServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Even if error occurs, try to invalidate session and redirect
            HttpSession session = request.getSession(false);
            if (session != null) {
                try {
                    session.invalidate();
                } catch (Exception ex) {
                    // Ignore exception during cleanup
                }
            }
            
            // Redirect to login anyway
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    /**
     * Handle HTTP POST requests (redirect to GET)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
