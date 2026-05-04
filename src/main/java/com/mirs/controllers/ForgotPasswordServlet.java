package com.mirs.controllers;

import java.io.IOException;
import java.sql.*;

import com.mirs.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Please enter your email address.");
            request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
            return;
        }
        email = email.trim();
        if (emailExistsInDB(email)) {
            // Store email in session so reset page can use it
            HttpSession session = request.getSession(true);
            session.setAttribute("resetEmail", email);
            request.setAttribute("successMsg", "Email found! Proceed to reset your password.");
            request.setAttribute("showResetLink", true);
        } else {
            request.setAttribute("errorMsg", "No account found with that email address.");
        }
        request.getRequestDispatcher("/WEB-INF/Pages/forgot_password.jsp").forward(request, response);
    }

    private boolean emailExistsInDB(String email) {
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            stmt = conn.prepareStatement("SELECT user_id FROM users WHERE email=?");
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) { return false; }
        finally {
            try { if (rs!=null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt!=null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn!=null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
