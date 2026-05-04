package com.mirs.controllers;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.mirs.config.DBConfig;
import com.mirs.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/rentals")
public class AdminRentalsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;

        String statusFilter = request.getParameter("status");
        if (statusFilter == null) statusFilter = "all";

        List<Map<String, Object>> rentals = fetchRentals(statusFilter);
        request.setAttribute("user", admin);
        request.setAttribute("rentals", rentals);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("successMsg", request.getParameter("success"));
        request.setAttribute("errorMsg",   request.getParameter("error"));
        request.getRequestDispatcher("/WEB-INF/Pages/admin_rentals.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;
        String action = request.getParameter("action");
        String ctx    = request.getContextPath();
        if ("mark_returned".equals(action)) {
            int rentalId = parseId(request.getParameter("rentalId"));
            if (rentalId > 0) {
                try { markReturned(rentalId); response.sendRedirect(ctx + "/admin/rentals?success=Rental+marked+as+returned"); }
                catch (Exception e) { response.sendRedirect(ctx + "/admin/rentals?error=Could+not+update+rental"); }
                return;
            }
        }
        response.sendRedirect(ctx + "/admin/rentals");
    }

    private List<Map<String, Object>> fetchRentals(String sf) {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT r.rental_id, u.first_name, u.last_name, i.instrument_name, " +
                "r.rental_date, r.return_date, r.actual_return_date, r.status, " +
                "r.fine_amount, r.total_rental_cost, r.instrument_id " +
                "FROM rentals r JOIN users u ON r.member_id=u.user_id " +
                "JOIN instruments i ON r.instrument_id=i.instrument_id ");
            boolean useParam = false;
            if (!"all".equalsIgnoreCase(sf)) {
                if ("overdue".equalsIgnoreCase(sf)) {
                    sql.append("WHERE (r.status='overdue' OR (r.status='active' AND r.return_date < CURDATE())) ");
                } else {
                    sql.append("WHERE r.status=? ");
                    useParam = true;
                }
            }
            sql.append("ORDER BY r.rental_date DESC");
            stmt = conn.prepareStatement(sql.toString());
            if (useParam) stmt.setString(1, sf.toLowerCase());
            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("rentalId",       rs.getInt("rental_id"));
                row.put("memberName",     rs.getString("first_name") + " " + rs.getString("last_name"));
                row.put("instrumentName", rs.getString("instrument_name"));
                row.put("rentalDate",     rs.getDate("rental_date"));
                row.put("returnDate",     rs.getDate("return_date"));
                row.put("status",         rs.getString("status"));
                row.put("fineAmount",     rs.getBigDecimal("fine_amount"));
                row.put("totalCost",      rs.getBigDecimal("total_rental_cost"));
                java.sql.Date retD = rs.getDate("return_date");
                String stat = rs.getString("status");
                boolean ov = ("active".equals(stat)||"overdue".equals(stat)) && retD != null && retD.before(new java.util.Date());
                row.put("isOverdue", ov);
                list.add(row);
            }
        } catch (Exception e) { System.err.println("fetchRentals: " + e.getMessage()); }
        finally { closeAll(rs, stmt, conn); }
        return list;
    }

    private void markReturned(int rentalId) throws Exception {
        Connection conn = DBConfig.getConnection();
        try {
            conn.setAutoCommit(false);
            PreparedStatement sel = conn.prepareStatement(
                "SELECT return_date, instrument_id FROM rentals WHERE rental_id=?");
            sel.setInt(1, rentalId);
            ResultSet rs = sel.executeQuery();
            double fine = 0.0; int instrumentId = 0;
            if (rs.next()) {
                java.sql.Date retDate = rs.getDate("return_date");
                instrumentId = rs.getInt("instrument_id");
                if (retDate != null && retDate.before(new java.util.Date())) {
                    long days = (new java.util.Date().getTime() - retDate.getTime()) / 86400000L;
                    fine = days * 0.50;
                }
            }
            rs.close(); sel.close();
            PreparedStatement upd = conn.prepareStatement(
                "UPDATE rentals SET status='returned', actual_return_date=CURDATE(), fine_amount=? WHERE rental_id=?");
            upd.setDouble(1, fine); upd.setInt(2, rentalId); upd.executeUpdate(); upd.close();
            if (instrumentId > 0) {
                PreparedStatement updI = conn.prepareStatement(
                    "UPDATE instruments SET available_quantity=available_quantity+1, availability_status='available' WHERE instrument_id=?");
                updI.setInt(1, instrumentId); updI.executeUpdate(); updI.close();
            }
            conn.commit();
        } catch (Exception e) { conn.rollback(); throw e; }
        finally { conn.setAutoCommit(true); conn.close(); }
    }

    private UserModel getAuthenticatedAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null) { res.sendRedirect(req.getContextPath() + "/login?error=session_expired"); return null; }
        Object obj = s.getAttribute("user");
        if (!(obj instanceof UserModel)) { s.invalidate(); res.sendRedirect(req.getContextPath() + "/login"); return null; }
        UserModel u = (UserModel) obj;
        if (!u.isAdmin()) { res.sendRedirect(req.getContextPath() + "/error?reason=unauthorized"); return null; }
        return u;
    }
    private int parseId(String v) { try { return Integer.parseInt(v); } catch (Exception e) { return 0; } }
    private void closeAll(ResultSet rs, PreparedStatement s, Connection c) {
        try { if (rs!=null) rs.close(); } catch (Exception ignored) {}
        try { if (s!=null)  s.close();  } catch (Exception ignored) {}
        try { if (c!=null)  c.close();  } catch (Exception ignored) {}
    }
}
