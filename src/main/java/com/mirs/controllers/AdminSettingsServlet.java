package com.mirs.controllers;

import java.io.IOException;

import com.mirs.model.UserModel;
import com.mirs.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/settings")
public class AdminSettingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        UserModel sessionUser = getAuthenticatedAdmin(session);

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        UserModel user = UserService.getUserById(sessionUser.getUserId());
        if (user == null || !user.isActive() || !user.isAdmin()) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return;
        }

        session.setAttribute("user", user);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/Pages/admin_settings.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        UserModel sessionUser = getAuthenticatedAdmin(session);

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        String action = clean(request.getParameter("action"));
        if ("changePassword".equals(action)) {
            handlePasswordChange(request, response, sessionUser);
        } else {
            handleProfileUpdate(request, response, sessionUser);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, UserModel sessionUser)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = UserService.getUserById(sessionUser.getUserId());
        if (user == null || !user.isActive() || !user.isAdmin()) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return;
        }

        user.setUsername(clean(request.getParameter("username")));
        user.setFirstName(clean(request.getParameter("firstName")));
        user.setLastName(clean(request.getParameter("lastName")));
        user.setEmail(clean(request.getParameter("email")));
        user.setPhoneNumber(clean(request.getParameter("phoneNumber")));
        user.setAddress(clean(request.getParameter("address")));
        user.setCity(clean(request.getParameter("city")));
        user.setState(clean(request.getParameter("state")));
        user.setZipCode(clean(request.getParameter("zipCode")));

        if (isFieldEmpty(user.getUsername()) || isFieldEmpty(user.getFirstName())
                || isFieldEmpty(user.getLastName()) || isFieldEmpty(user.getEmail())) {
            forwardWithError(request, response, user, "Username, first name, last name, and email are required.");
            return;
        }

        if (user.getUsername().length() < 3 || user.getUsername().length() > 20 || !isValidUsername(user.getUsername())) {
            forwardWithError(request, response, user,
                    "Username must be 3-20 characters and use only letters, numbers, underscore, or hyphen.");
            return;
        }

        if (!isValidEmail(user.getEmail())) {
            forwardWithError(request, response, user, "Please enter a valid email address.");
            return;
        }

        if (UserService.isUsernameTakenByOtherUser(user.getUsername(), user.getUserId())) {
            forwardWithError(request, response, user, "That username is already used by another account.");
            return;
        }

        if (UserService.isEmailTakenByOtherUser(user.getEmail(), user.getUserId())) {
            forwardWithError(request, response, user, "That email address is already used by another account.");
            return;
        }

        UserService.RegistrationResult result = UserService.updateUserProfile(user);
        if (result.isSuccess()) {
            UserModel updatedUser = UserService.getUserById(user.getUserId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
                session.setAttribute("username", updatedUser.getUsername());
                session.setAttribute("userRole", updatedUser.getRole());
                request.setAttribute("user", updatedUser);
            } else {
                request.setAttribute("user", user);
            }
            request.setAttribute("successMessage", result.getMessage());
        } else {
            request.setAttribute("user", user);
            request.setAttribute("errorMessage", result.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/Pages/admin_settings.jsp").forward(request, response);
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, UserModel sessionUser)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isFieldEmpty(currentPassword) || isFieldEmpty(newPassword) || isFieldEmpty(confirmPassword)) {
            request.setAttribute("passwordErrorMessage", "All password fields are required.");
        } else if (newPassword.length() < 6) {
            request.setAttribute("passwordErrorMessage", "New password must be at least 6 characters.");
        } else if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passwordErrorMessage", "New password and confirmation do not match.");
        } else {
            UserService.RegistrationResult result = UserService.changePassword(sessionUser.getUserId(), currentPassword, newPassword);
            if (result.isSuccess()) {
                request.setAttribute("passwordSuccessMessage", result.getMessage());
            } else {
                request.setAttribute("passwordErrorMessage", result.getMessage());
            }
        }

        UserModel user = UserService.getUserById(sessionUser.getUserId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/Pages/admin_settings.jsp").forward(request, response);
    }

    private UserModel getAuthenticatedAdmin(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object userObject = session.getAttribute("user");
        if (!(userObject instanceof UserModel)) {
            return null;
        }

        UserModel user = (UserModel) userObject;
        if (!user.isActive() || !user.isAdmin()) {
            return null;
        }

        return user;
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
            UserModel user, String message) throws ServletException, IOException {
        request.setAttribute("user", user);
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/WEB-INF/Pages/admin_settings.jsp").forward(request, response);
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isFieldEmpty(String field) {
        return field == null || field.trim().isEmpty();
    }

    private boolean isValidEmail(String email) {
        String emailPattern = "^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email != null && email.matches(emailPattern);
    }

    private boolean isValidUsername(String username) {
        String usernamePattern = "^[a-zA-Z0-9_-]+$";
        return username != null && username.matches(usernamePattern);
    }
}
