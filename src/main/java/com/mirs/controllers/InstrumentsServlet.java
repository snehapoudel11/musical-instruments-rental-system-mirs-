package com.mirs.controllers;

import java.io.IOException;

import com.mirs.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/member/instruments")
public class InstrumentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        Object userObject = session.getAttribute("user");
        if (!(userObject instanceof UserModel)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return;
        }

        UserModel user = (UserModel) userObject;
        if (!user.isActive() || !user.isMember()) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/Pages/instruments.jsp").forward(request, response);
    }
}
