package com.mirs.controllers;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.mirs.config.DBConfig;
import com.mirs.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/fines")
public class AdminFinesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;

        List<Map<String, Object>> fines = fetchFines();
        Map<String, Object> summary = fetchSummary();

        request.setAttribute("user", admin);
        request.setAttribute("fines", fines);
        request.setAttribute("summary", summary);
        request.setAttribute("successMsg", request.getParameter("success"));
        request.setAttribute("errorMsg",   request.getParameter("error"));
        request.getRequestDispatcher("/WEB-INF/Pages/admin_fines.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;
        String action = request.getParameter("action");
        String ctx    = request.getContextPath();
        if ("mark_paid".equals(action)) {
            int rentalId = parseId(request.getParameter("rentalId"));
            if (rentalId > 0) {
                try { markFinePaid(rentalId); response.sendRedirect(ctx + "/admin/fines?success=Fine+marked+as+paid"); }
                catch (Exception e) { response.sendRedirect(ctx + "/admin/fines?error=Could+not+mark+paid"); }
                return;
            }
        }
        response.sendRedirect(ctx + "/admin/fines");
    }

    private List<Map<String, Object>> fetchFines() {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT r.rental_id, u.first_name, u.last_name, i.instrument_name, " +
                "r.return_date, r.actual_return_date, r.fine_amount, r.status, " +
                "CASE WHEN r.actual_return_date IS NOT NULL THEN DATEDIFF(r.actual_return_date, r.return_date) " +
                "     ELSE DATEDIFF(CURDATE(), r.return_date) END AS days_overdue, " +
                "COALESCE((SELECT SUM(pr.amount_paid) FROM payment_records pr " +
                "  WHERE pr.rental_id=r.rental_id AND pr.notes LIKE '%fine%'), 0) AS paid_amount " +
                "FROM rentals r JOIN users u ON r.member_id=u.user_id " +
                "JOIN instruments i ON r.instrument_id=i.instrument_id " +
                "WHERE r.fine_amount > 0 ORDER BY r.fine_amount DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("rentalId",       rs.getInt("rental_id"));
                row.put("memberName",     rs.getString("first_name") + " " + rs.getString("last_name"));
                row.put("instrumentName", rs.getString("instrument_name"));
                row.put("daysOverdue",    Math.max(0, rs.getInt("days_overdue")));
                row.put("fineAmount",     rs.getBigDecimal("fine_amount"));
                row.put("paidAmount",     rs.getBigDecimal("paid_amount"));
                row.put("status",         rs.getString("status"));
                double fine = rs.getDouble("fine_amount");
                double paid = rs.getDouble("paid_amount");
                row.put("isPaid", paid >= fine && fine > 0);
                list.add(row);
            }
        } catch (Exception e) { System.err.println("fetchFines: " + e.getMessage()); }
        finally { closeAll(rs, stmt, conn); }
        return list;
    }

    private Map<String, Object> fetchSummary() {
        Map<String, Object> s = new HashMap<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            stmt = conn.prepareStatement("SELECT SUM(fine_amount) as total FROM rentals WHERE fine_amount > 0");
            rs = stmt.executeQuery();
            if (rs.next()) s.put("totalFines", rs.getDouble("total"));
            rs.close(); stmt.close();
            stmt = conn.prepareStatement(
                "SELECT SUM(amount_paid) as collected FROM payment_records WHERE notes LIKE '%fine%' AND payment_status='completed'");
            rs = stmt.executeQuery();
            if (rs.next()) s.put("collected", rs.getDouble("collected"));
        } catch (Exception e) { System.err.println("fetchSummary: " + e.getMessage()); }
        finally { closeAll(rs, stmt, conn); }
        return s;
    }

    private void markFinePaid(int rentalId) throws Exception {
        Connection conn = DBConfig.getConnection();
        try {
            PreparedStatement sel = conn.prepareStatement("SELECT fine_amount FROM rentals WHERE rental_id=?");
            sel.setInt(1, rentalId);
            ResultSet rs = sel.executeQuery();
            double fine = 0;
            if (rs.next()) fine = rs.getDouble("fine_amount");
            rs.close(); sel.close();
            if (fine <= 0) return;
            PreparedStatement ins = conn.prepareStatement(
                "INSERT INTO payment_records (rental_id, amount_paid, payment_method, payment_status, notes) VALUES (?,?,'cash','completed','fine payment')");
            ins.setInt(1, rentalId); ins.setDouble(2, fine); ins.executeUpdate(); ins.close();
        } finally { conn.close(); }
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
