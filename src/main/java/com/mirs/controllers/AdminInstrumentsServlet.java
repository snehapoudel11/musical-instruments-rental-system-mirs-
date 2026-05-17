package com.mirs.controllers;

import java.io.IOException;
import java.math.BigDecimal;
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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * AdminInstrumentsServlet
 * Handles admin instrument management: list, search, add, edit, delete.
 * URL: /admin/instruments
 */
@WebServlet("/admin/instruments")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 25
)
public class AdminInstrumentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;

        String search = request.getParameter("search");
        if (search == null) search = "";
        int editId = parseId(request.getParameter("editId"));

        List<Map<String, Object>> instruments = fetchInstruments(search);
        List<Map<String, Object>> categories  = fetchCategories();
        Map<String, Object> selectedInstrument = editId > 0 ? fetchInstrumentById(editId) : null;

        request.setAttribute("user", admin);
        request.setAttribute("instruments", instruments);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedInstrument", selectedInstrument);
        request.setAttribute("search", search);
        request.setAttribute("successMsg", request.getParameter("success"));
        request.setAttribute("errorMsg",   request.getParameter("error"));
        request.getRequestDispatcher("/WEB-INF/Pages/admin_instruments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel admin = getAuthenticatedAdmin(request, response);
        if (admin == null) return;

        String action = request.getParameter("action");
        String ctx    = request.getContextPath();

        try {
            switch (action == null ? "" : action) {
                case "add":
                    addInstrument(request);
                    response.sendRedirect(ctx + "/admin/instruments?success=Instrument+added+successfully");
                    break;
                case "edit":
                    editInstrument(request);
                    response.sendRedirect(ctx + "/admin/instruments?success=Instrument+updated+successfully");
                    break;
                case "delete":
                    deleteInstrument(parseId(request.getParameter("instrumentId")));
                    response.sendRedirect(ctx + "/admin/instruments?success=Instrument+deleted+successfully");
                    break;
                default:
                    response.sendRedirect(ctx + "/admin/instruments");
            }
        } catch (Exception e) {
            System.err.println("AdminInstrumentsServlet error: " + e.getMessage());
            response.sendRedirect(ctx + "/admin/instruments?error=Operation+failed:+" + encode(e.getMessage()));
        }
    }

    // ---------------------------------------------------------------
    //  DB helpers
    // ---------------------------------------------------------------

    private List<Map<String, Object>> fetchInstruments(String search) {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql;
            if (search != null && !search.trim().isEmpty()) {
                sql = "SELECT i.instrument_id, i.instrument_name, c.category_name, i.brand, "
                    + "i.quantity, i.available_quantity, i.rental_price_per_day, "
                    + "i.availability_status, i.`condition`, i.description, i.image_path, i.date_added, i.category_id "
                    + "FROM instruments i JOIN categories c ON i.category_id = c.category_id "
                    + "WHERE LOWER(i.instrument_name) LIKE ? OR LOWER(c.category_name) LIKE ? "
                    + "ORDER BY i.date_added DESC";
                stmt = conn.prepareStatement(sql);
                String like = "%" + search.toLowerCase() + "%";
                stmt.setString(1, like); stmt.setString(2, like);
            } else {
                sql = "SELECT i.instrument_id, i.instrument_name, c.category_name, i.brand, "
                    + "i.quantity, i.available_quantity, i.rental_price_per_day, "
                    + "i.availability_status, i.`condition`, i.description, i.image_path, i.date_added, i.category_id "
                    + "FROM instruments i JOIN categories c ON i.category_id = c.category_id "
                    + "ORDER BY i.date_added DESC";
                stmt = conn.prepareStatement(sql);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("instrumentId",       rs.getInt("instrument_id"));
                row.put("instrumentName",     rs.getString("instrument_name"));
                row.put("categoryName",       rs.getString("category_name"));
                row.put("categoryId",         rs.getInt("category_id"));
                row.put("brand",              rs.getString("brand"));
                row.put("quantity",           rs.getInt("quantity"));
                row.put("availableQuantity",  rs.getInt("available_quantity"));
                row.put("dailyRate",          rs.getBigDecimal("rental_price_per_day"));
                row.put("status",             rs.getString("availability_status"));
                row.put("condition",          rs.getString("condition"));
                row.put("description",        rs.getString("description"));
                row.put("imagePath",          rs.getString("image_path"));
                row.put("dateAdded",          rs.getTimestamp("date_added"));
                list.add(row);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("fetchInstruments: " + e.getMessage());
        } finally { closeAll(rs, stmt, conn); }
        return list;
    }

    // ---------------------------------------------------------------
	//  DB helpers
	// ---------------------------------------------------------------
	
	private List<Map<String, Object>> fetchInstruments(String search) {
	    List<Map<String, Object>> list = new ArrayList<>();
	    Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
	    try {
	        conn = DBConfig.getConnection();
	        String sql;
	        if (search != null && !search.trim().isEmpty()) {
	            sql = "SELECT i.instrument_id, i.instrument_name, c.category_name, i.brand, "
	                + "i.quantity, i.available_quantity, i.rental_price_per_day, "
	                + "i.availability_status, i.`condition`, i.description, i.image_path, i.date_added, i.category_id "
	                + "FROM instruments i JOIN categories c ON i.category_id = c.category_id "
	                + "WHERE LOWER(i.instrument_name) LIKE ? OR LOWER(c.category_name) LIKE ? "
	                + "ORDER BY i.date_added DESC";
	            stmt = conn.prepareStatement(sql);
	            String like = "%" + search.toLowerCase() + "%";
	            stmt.setString(1, like); stmt.setString(2, like);
	        } else {
	            sql = "SELECT i.instrument_id, i.instrument_name, c.category_name, i.brand, "
	                + "i.quantity, i.available_quantity, i.rental_price_per_day, "
	                + "i.availability_status, i.`condition`, i.description, i.image_path, i.date_added, i.category_id "
	                + "FROM instruments i JOIN categories c ON i.category_id = c.category_id "
	                + "ORDER BY i.date_added DESC";
	            stmt = conn.prepareStatement(sql);
	        }
	        rs = stmt.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> row = new HashMap<>();
	            row.put("instrumentId",       rs.getInt("instrument_id"));
	            row.put("instrumentName",     rs.getString("instrument_name"));
	            row.put("categoryName",       rs.getString("category_name"));
	            row.put("categoryId",         rs.getInt("category_id"));
	            row.put("brand",              rs.getString("brand"));
	            row.put("quantity",           rs.getInt("quantity"));
	            row.put("availableQuantity",  rs.getInt("available_quantity"));
	            row.put("dailyRate",          rs.getBigDecimal("rental_price_per_day"));
	            row.put("status",             rs.getString("availability_status"));
	            row.put("condition",          rs.getString("condition"));
	            row.put("description",        rs.getString("description"));
	            row.put("imagePath",          rs.getString("image_path"));
	            row.put("dateAdded",          rs.getTimestamp("date_added"));
	            list.add(row);
	        }
	    } catch (SQLException | ClassNotFoundException e) {
	        System.err.println("fetchInstruments: " + e.getMessage());
	    } finally { closeAll(rs, stmt, conn); }
	    return list;
	}

	private List<Map<String, Object>> fetchCategories() {
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            stmt = conn.prepareStatement("SELECT category_id, category_name FROM categories ORDER BY category_name");
            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("categoryId",   rs.getInt("category_id"));
                row.put("categoryName", rs.getString("category_name"));
                list.add(row);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("fetchCategories: " + e.getMessage());
        } finally { closeAll(rs, stmt, conn); }
        return list;
    }

    private Map<String, Object> fetchInstrumentById(int instrumentId) {
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            stmt = conn.prepareStatement(
                "SELECT instrument_id, instrument_name, category_id, brand, quantity, available_quantity, "
              + "rental_price_per_day, availability_status, description "
              + "FROM instruments WHERE instrument_id = ?"
            );
            stmt.setInt(1, instrumentId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("instrumentId", rs.getInt("instrument_id"));
                row.put("instrumentName", rs.getString("instrument_name"));
                row.put("categoryId", rs.getInt("category_id"));
                row.put("brand", rs.getString("brand"));
                row.put("quantity", rs.getInt("quantity"));
                row.put("availableQuantity", rs.getInt("available_quantity"));
                row.put("dailyRate", rs.getBigDecimal("rental_price_per_day"));
                row.put("status", rs.getString("availability_status"));
                row.put("description", rs.getString("description"));
                return row;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("fetchInstrumentById: " + e.getMessage());
        } finally {
            closeAll(rs, stmt, conn);
        }
        return null;
    }

    private void addInstrument(HttpServletRequest req) throws Exception {
        String imagePath = processImageUpload(req);
        Connection conn = DBConfig.getConnection();
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO instruments (instrument_name, category_id, brand, quantity, available_quantity, "
              + "availability_status, rental_price_per_day, description, image_path) "
              + "VALUES (?, ?, ?, ?, ?, 'available', ?, ?, ?)");
            int qty = parseId(req.getParameter("quantity"));
            if (qty < 1) qty = 1;
            stmt.setString(1, req.getParameter("instrumentName"));
            stmt.setInt(2,    parseId(req.getParameter("categoryId")));
            stmt.setString(3, req.getParameter("brand"));
            stmt.setInt(4,    qty);
            stmt.setInt(5,    qty);
            stmt.setBigDecimal(6, parseBigDecimal(req.getParameter("dailyRate")));
            stmt.setString(7, req.getParameter("description"));
            stmt.setString(8, imagePath);
            stmt.executeUpdate();
            stmt.close();
        } finally { conn.close(); }
    }

    private void editInstrument(HttpServletRequest req) throws Exception {
        String newImagePath = processImageUpload(req);
        Connection conn = DBConfig.getConnection();
        try {
            String sql = "UPDATE instruments SET instrument_name=?, category_id=?, brand=?, "
              + "quantity=?, available_quantity=?, rental_price_per_day=?, availability_status=?, description=? ";
            if (newImagePath != null && !newImagePath.isEmpty()) {
                sql += ", image_path=? ";
            }
            sql += "WHERE instrument_id=?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, req.getParameter("instrumentName"));
            stmt.setInt(2,    parseId(req.getParameter("categoryId")));
            stmt.setString(3, req.getParameter("brand"));
            stmt.setInt(4,    parseId(req.getParameter("quantity")));
            stmt.setInt(5,    parseId(req.getParameter("availableQuantity")));
            stmt.setBigDecimal(6, parseBigDecimal(req.getParameter("dailyRate")));
            stmt.setString(7, req.getParameter("status"));
            stmt.setString(8, req.getParameter("description"));
            
            if (newImagePath != null && !newImagePath.isEmpty()) {
                stmt.setString(9, newImagePath);
                stmt.setInt(10,   parseId(req.getParameter("instrumentId")));
            } else {
                stmt.setInt(9,    parseId(req.getParameter("instrumentId")));
            }
            
            stmt.executeUpdate();
            stmt.close();
        } finally { conn.close(); }
    }

    private void deleteInstrument(int id) throws SQLException, ClassNotFoundException {
        Connection conn = DBConfig.getConnection();
        try {
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM instruments WHERE instrument_id=?");
            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
        } finally { conn.close(); }
    }

    // ---------------------------------------------------------------
    //  Utilities
    // ---------------------------------------------------------------

    private UserModel getAuthenticatedAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) { response.sendRedirect(request.getContextPath() + "/login?error=session_expired"); return null; }
        Object obj = session.getAttribute("user");
        if (!(obj instanceof UserModel)) { session.invalidate(); response.sendRedirect(request.getContextPath() + "/login"); return null; }
        UserModel user = (UserModel) obj;
        if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/error?reason=unauthorized"); return null; }
        return user;
    }

    private int parseId(String val) { try { return Integer.parseInt(val); } catch (Exception e) { return 0; } }
    private BigDecimal parseBigDecimal(String val) { try { return new BigDecimal(val); } catch (Exception e) { return BigDecimal.ZERO; } }
    private String encode(String s) { return s == null ? "" : s.replace(" ", "+"); }
    private void closeAll(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
    
    private String processImageUpload(HttpServletRequest request) throws Exception {
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            String fullPath = uploadPath + File.separator + fileName;
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, new File(fullPath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            return "/images/" + fileName;
        }
        return null;
    }
    
    private String getFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "uploaded_image.jpg";
    }
}
