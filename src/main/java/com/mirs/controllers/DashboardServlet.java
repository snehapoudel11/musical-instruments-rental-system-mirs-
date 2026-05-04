package com.mirs.controllers;

import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.mirs.model.UserModel;
import com.mirs.service.DashboardService;

/**
 * DashboardServlet - routes users to role-appropriate dashboard.
 * URLs: /dashboard, /admin/dashboard, /member/dashboard
 */
@WebServlet({"/dashboard", "/admin/dashboard", "/member/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            HttpSession session = request.getSession(false);

            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
                return;
            }

            UserModel user = (UserModel) session.getAttribute("user");

            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
                return;
            }

            if (!user.isActive()) {
                session.invalidate();
                request.setAttribute("errorMessage", "Your account has been deactivated.");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                return;
            }

            if (user.isAdmin()) {
                Map<String, Object> adminStats = DashboardService.getAdminDashboardStats();
                adminStats.put("totalFinesCollected", DashboardService.getTotalFinesCollected());

                request.setAttribute("stats", adminStats);
                request.setAttribute("user", user);
                request.setAttribute("recentInstruments", DashboardService.getRecentlyAddedInstruments(5));

                request.getRequestDispatcher("/WEB-INF/Pages/admin_dashboard.jsp").forward(request, response);

            } else if (user.isMember()) {
                Map<String, Object> memberStats = DashboardService.getMemberDashboardStats(user.getUserId());
                String recentRentals = DashboardService.getMemberRecentRentals(user.getUserId(), 5);

                request.setAttribute("stats", memberStats);
                request.setAttribute("user", user);
                request.setAttribute("recentRentals", recentRentals);

                request.getRequestDispatcher("/WEB-INF/Pages/user_home.jsp").forward(request, response);

            } else {
                session.invalidate();
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid user role");
            }

        } catch (Exception e) {
            System.err.println("Error in DashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading the dashboard.");
            request.setAttribute("exception", e);
            request.getRequestDispatcher("/WEB-INF/Pages/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
