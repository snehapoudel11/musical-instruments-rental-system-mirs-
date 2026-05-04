package com.mirs.controllers;

import java.io.IOException;
import java.sql.*;

import com.mirs.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        // Create contact_inquiries table if it doesn't exist
        try (Connection conn = DBConfig.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(
                "CREATE TABLE IF NOT EXISTS contact_inquiries (" +
                "  inquiry_id INT AUTO_INCREMENT PRIMARY KEY," +
                "  full_name VARCHAR(100) NOT NULL," +
                "  email VARCHAR(100) NOT NULL," +
                "  subject VARCHAR(200) NOT NULL," +
                "  message TEXT NOT NULL," +
                "  submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  status ENUM('new','read','replied') DEFAULT 'new'" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
            );
        } catch (Exception e) {
            System.err.println("ContactServlet.init: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String name    = trim(request.getParameter("fullName"));
        String email   = trim(request.getParameter("email"));
        String subject = trim(request.getParameter("subject"));
        String message = trim(request.getParameter("message"));

        if (name.isEmpty() || email.isEmpty() || subject.isEmpty() || message.isEmpty()) {
            request.setAttribute("errorMsg", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
            return;
        }

        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("errorMsg", "Please enter a valid email address.");
            request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO contact_inquiries (full_name, email, subject, message) VALUES (?,?,?,?)")) {
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, subject);
            stmt.setString(4, message);
            stmt.executeUpdate();
            request.setAttribute("successMsg", "Thank you! Your message has been received. We'll get back to you within 1-2 business days.");
        } catch (Exception e) {
            System.err.println("ContactServlet.doPost: " + e.getMessage());
            request.setAttribute("errorMsg", "Sorry, your message could not be sent. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
