package com.mirs.controllers;

import java.io.IOException;
import java.sql.*;

import com.mirs.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null
                || !Boolean.TRUE.equals(session.getAttribute("passwordResetVerified"))) {
            response.sendRedirect(request.getContextPath() + "/forgotPassword");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/Pages/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null
                || !Boolean.TRUE.equals(session.getAttribute("passwordResetVerified"))) {
            response.sendRedirect(request.getContextPath() + "/forgotPassword");
            return;
        }

        String email    = (String) session.getAttribute("resetEmail");
        String newPass  = request.getParameter("newPassword");
        String confirm  = request.getParameter("confirmPassword");

        if (newPass == null || newPass.trim().length() < 6) {
            request.setAttribute("errorMsg", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/WEB-INF/Pages/reset_password.jsp").forward(request, response);
            return;
        }
        if (!newPass.equals(confirm)) {
            request.setAttribute("errorMsg", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/Pages/reset_password.jsp").forward(request, response);
            return;
        }

        try {
            updatePassword(email, newPass.trim());
            session.removeAttribute("resetEmail");
            session.removeAttribute("passwordResetOtp");
            session.removeAttribute("passwordResetOtpExpiry");
            session.removeAttribute("passwordResetVerified");
            response.sendRedirect(request.getContextPath() + "/login?reset=success");
        } catch (Exception e) {
            System.err.println("ResetPasswordServlet: " + e.getMessage());
            request.setAttribute("errorMsg", "Password could not be updated. Please try again.");
            request.getRequestDispatcher("/WEB-INF/Pages/reset_password.jsp").forward(request, response);
        }
    }

    private void updatePassword(String email, String newPassword) throws Exception {
        Connection conn = DBConfig.getConnection();
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE users SET password=? WHERE email=?");
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            stmt.executeUpdate();
            stmt.close();
        } finally { conn.close(); }
    }
}
