package com.mirs.controllers;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mirs.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int OTP_EXPIRY_SECONDS = 10 * 60;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session != null
                && session.getAttribute("resetEmail") != null
                && session.getAttribute("passwordResetOtp") != null
                && !Boolean.TRUE.equals(session.getAttribute("passwordResetVerified"))) {
            request.setAttribute("showOtpForm", true);
            request.setAttribute("emailValue", session.getAttribute("resetEmail"));
        }
        request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if ("verifyOtp".equals(action)) {
            verifyOtp(request, response);
            return;
        }

        sendOtp(request, response);
    }

    private void sendOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Please enter your email address.");
            request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        if (!emailExistsInDB(email)) {
            request.setAttribute("errorMsg", "No account found with that email address.");
            request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
            return;
        }

        String otp = generateOtp();
        HttpSession session = request.getSession(true);
        session.setAttribute("resetEmail", email);
        session.setAttribute("passwordResetOtp", otp);
        session.setAttribute("passwordResetOtpExpiry", System.currentTimeMillis() + (OTP_EXPIRY_SECONDS * 1000L));
        session.removeAttribute("passwordResetVerified");
        System.out.println("[MIRS] Password reset OTP for " + email + ": " + otp);
        request.setAttribute("emailValue", email);
        request.setAttribute("successMsg", "OTP generated successfully. Check the server terminal and enter the OTP below.");
        request.setAttribute("showOtpForm", true);

        request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
    }

    private void verifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/forgotPassword");
            return;
        }

        String enteredOtp = valueOrEmpty(request.getParameter("otp"));
        String expectedOtp = valueOrEmpty((String) session.getAttribute("passwordResetOtp"));
        Long expiry = (Long) session.getAttribute("passwordResetOtpExpiry");

        request.setAttribute("showOtpForm", true);
        request.setAttribute("emailValue", session.getAttribute("resetEmail"));

        if (enteredOtp.isEmpty()) {
            request.setAttribute("errorMsg", "Please enter the OTP shown in the server terminal.");
            request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
            return;
        }

        if (expiry == null || System.currentTimeMillis() > expiry) {
            session.removeAttribute("passwordResetOtp");
            session.removeAttribute("passwordResetOtpExpiry");
            request.setAttribute("errorMsg", "OTP expired. Please request a new one.");
            request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
            return;
        }

        if (!expectedOtp.equals(enteredOtp)) {
            request.setAttribute("errorMsg", "The OTP you entered is incorrect.");
            request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
            return;
        }

        session.setAttribute("passwordResetVerified", Boolean.TRUE);
        response.sendRedirect(request.getContextPath() + "/resetPassword");
    }

    private boolean emailExistsInDB(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            stmt = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?");
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }

    private String generateOtp() {
        int value = 100000 + RANDOM.nextInt(900000);
        return Integer.toString(value);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
