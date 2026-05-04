package com.mirs.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/error")
public class ErrorPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String reason = request.getParameter("reason");
        request.setAttribute("reason", reason != null ? reason : "unauthorized");
        request.getRequestDispatcher("/WEB-INF/Pages/error.jsp").forward(request, response);
    }
}
