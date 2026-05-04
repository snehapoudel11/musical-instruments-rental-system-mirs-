package com.mirs.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mirs.config.DBConfig;
import com.mirs.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * AdminMembersServlet
 * Handles admin member management: list, search, delete, toggle status.
 * URL: /admin/members
 */
@WebServlet("/admin/members")
public class AdminMembersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;

        String search = request.getParameter("search");
        if (search == null) search = "";
        String successMsg = request.getParameter("success");
        String errorMsg   = request.getParameter("error");

        List<Map<String, Object>> members = fetchMembers(search);

        request.setAttribute("user", admin);
        request.setAttribute("members", members);
        request.setAttribute("search", search);
        request.setAttribute("successMsg", successMsg);
        request.setAttribute("errorMsg", errorMsg);
        request.getRequestDispatcher("/WEB-INF/Pages/admin_members.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int memberId = parseId(request.getParameter("memberId"));
            if (memberId > 0) {
                try {
                    deleteMember(memberId);
                    response.sendRedirect(request.getContextPath() + "/admin/members?success=Member+deleted+successfully");
                } catch (Exception e) {
                    System.err.println("Error deleting member: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/admin/members?error=Could+not+delete+member");
                }
                return;
            }
        } else if ("toggle_status".equals(action)) {
            int memberId = parseId(request.getParameter("memberId"));
            if (memberId > 0) {
                try {
                    toggleMemberStatus(memberId);
                    response.sendRedirect(request.getContextPath() + "/admin/members?success=Member+status+updated");
                } catch (Exception e) {
                    System.err.println("Error toggling status: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/admin/members?error=Could+not+update+status");
                }
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/members");
    }

    // ---------------------------------------------------------------
    //  DB helpers
    // ---------------------------------------------------------------

    private List<Map<String, Object>> fetchMembers(String search) {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConfig.getConnection();
            String sql;
            if (search != null && !search.trim().isEmpty()) {
                sql = "SELECT user_id, first_name, last_name, email, phone_number, is_active, created_date "
                    + "FROM users WHERE role = 'member' "
                    + "AND (LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?) "
                    + "ORDER BY created_date DESC";
                stmt = conn.prepareStatement(sql);
                String like = "%" + search.toLowerCase() + "%";
                stmt.setString(1, like);
                stmt.setString(2, like);
                stmt.setString(3, like);
            } else {
                sql = "SELECT user_id, first_name, last_name, email, phone_number, is_active, created_date "
                    + "FROM users WHERE role = 'member' ORDER BY created_date DESC";
                stmt = conn.prepareStatement(sql);
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("userId",      rs.getInt("user_id"));
                row.put("firstName",   rs.getString("first_name"));
                row.put("lastName",    rs.getString("last_name"));
                row.put("email",       rs.getString("email"));
                row.put("phone",       rs.getString("phone_number"));
                row.put("isActive",    rs.getBoolean("is_active"));
                row.put("createdDate", rs.getTimestamp("created_date"));
                list.add(row);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching members: " + e.getMessage());
        } finally {
            closeAll(rs, stmt, conn);
        }
        return list;
    }

    private void deleteMember(int memberId) throws SQLException, ClassNotFoundException {
        Connection conn = DBConfig.getConnection();
        try {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE user_id = ? AND role = 'member'");
            stmt.setInt(1, memberId);
            stmt.executeUpdate();
            stmt.close();
        } finally {
            conn.close();
        }
    }

    private void toggleMemberStatus(int memberId) throws SQLException, ClassNotFoundException {
        Connection conn = DBConfig.getConnection();
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE users SET is_active = NOT is_active WHERE user_id = ? AND role = 'member'");
            stmt.setInt(1, memberId);
            stmt.executeUpdate();
            stmt.close();
        } finally {
            conn.close();
        }
    }

    // ---------------------------------------------------------------
    //  Utilities
    // ---------------------------------------------------------------

    private UserModel getAuthenticatedAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return null;
        }
        Object obj = session.getAttribute("user");
        if (!(obj instanceof UserModel)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return null;
        }
        UserModel user = (UserModel) obj;
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/error?reason=unauthorized");
            return null;
        }
        return user;
    }

    private int parseId(String val) {
        try { return Integer.parseInt(val); } catch (Exception e) { return 0; }
    }

    private void closeAll(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
}
