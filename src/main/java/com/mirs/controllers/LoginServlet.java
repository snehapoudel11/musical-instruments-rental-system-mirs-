package com.mirs.controllers;

import java.io.IOException;

import com.mirs.model.UserModel;
import com.mirs.service.LoginSecurityService;
import com.mirs.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles user authentication for the MIRS system.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in LoginServlet doGet(): " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "An error occurred while loading the login page");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || username.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Please enter both username and password");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                return;
            }

            if (LoginSecurityService.isLocked(username)) {
                long remainingMinutes = LoginSecurityService.getRemainingLockMinutes(username);
                request.setAttribute("errorMessage",
                        "Too many incorrect login attempts. This account is temporarily locked for "
                                + remainingMinutes + " more minute(s).");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                return;
            }

            UserModel user = UserService.authenticateUser(username, password);

            if (user != null && user.isActive()) {
                LoginSecurityService.clearFailedAttempts(username);

                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole());
                session.setMaxInactiveInterval(30 * 60);

                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/member/dashboard");
                }
            } else {
                LoginSecurityService.recordFailedAttempt(username);

                String errorMessage;
                if (LoginSecurityService.isLocked(username)) {
                    errorMessage = "Too many incorrect login attempts. This account has been temporarily locked for 15 minutes.";
                } else {
                    int remainingAttempts = LoginSecurityService.getRemainingAttempts(username);
                    errorMessage = "Invalid username or password. " + remainingAttempts
                            + " attempt(s) remaining before temporary lock.";
                }

                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error in LoginServlet doPost(): " + e.getMessage());
            e.printStackTrace();

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
