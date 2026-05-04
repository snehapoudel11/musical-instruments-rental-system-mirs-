package com.mirs.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import com.mirs.config.DBConfig;
import com.mirs.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/member/book")
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        UserModel user = getAuthenticatedMember(request, response);
        if (user == null) {
            return;
        }

        int instrumentId = parseId(request.getParameter("instrumentId"));
        if (instrumentId <= 0 || !loadInstrument(request, instrumentId)) {
            response.sendRedirect(request.getContextPath() + "/member/instruments");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/Pages/booking.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        UserModel user = getAuthenticatedMember(request, response);
        if (user == null) {
            return;
        }

        int instrumentId = parseId(request.getParameter("instrumentId"));
        String startDateValue = request.getParameter("startDate");
        String endDateValue = request.getParameter("endDate");

        LocalDate startDate = parseDate(startDateValue);
        LocalDate endDate = parseDate(endDateValue);

        if (instrumentId <= 0 || startDate == null || endDate == null) {
            forwardWithError(request, response, user, instrumentId, "Please choose a valid instrument and rental dates.");
            return;
        }

        LocalDate today = LocalDate.now();
        if (startDate.isBefore(today)) {
            forwardWithError(request, response, user, instrumentId, "Rental start date cannot be in the past.");
            return;
        }

        if (!endDate.isAfter(startDate)) {
            forwardWithError(request, response, user, instrumentId, "Rental end date must be after the start date.");
            return;
        }

        try {
            createRental(user.getUserId(), instrumentId, startDate, endDate);
            response.sendRedirect(request.getContextPath() + "/member/rentals?success=booking_created");
        } catch (IllegalStateException e) {
            forwardWithError(request, response, user, instrumentId, e.getMessage());
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error creating booking: " + e.getMessage());
            forwardWithError(request, response, user, instrumentId,
                    "Booking could not be saved because of a database error.");
        }
    }

    private void createRental(int memberId, int instrumentId, LocalDate startDate, LocalDate endDate)
            throws SQLException, ClassNotFoundException {

        Connection connection = null;
        PreparedStatement selectStatement = null;
        PreparedStatement insertStatement = null;
        PreparedStatement updateStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            connection.setAutoCommit(false);

            String selectQuery = "SELECT rental_price_per_day, available_quantity, availability_status "
                    + "FROM instruments WHERE instrument_id = ? FOR UPDATE";
            selectStatement = connection.prepareStatement(selectQuery);
            selectStatement.setInt(1, instrumentId);
            resultSet = selectStatement.executeQuery();

            if (!resultSet.next()) {
                throw new IllegalStateException("Selected instrument could not be found.");
            }

            int availableQuantity = resultSet.getInt("available_quantity");
            String status = resultSet.getString("availability_status");
            if (!"available".equalsIgnoreCase(status) || availableQuantity <= 0) {
                throw new IllegalStateException("This instrument is no longer available for booking.");
            }

            BigDecimal rate = resultSet.getBigDecimal("rental_price_per_day");
            long days = ChronoUnit.DAYS.between(startDate, endDate);
            BigDecimal totalCost = rate.multiply(BigDecimal.valueOf(days));

            String insertQuery = "INSERT INTO rentals (member_id, instrument_id, rental_date, return_date, "
                    + "actual_return_date, status, fine_amount, total_rental_cost, notes, created_date) "
                    + "VALUES (?, ?, ?, ?, NULL, 'pending', 0.00, ?, ?, NOW())";
            insertStatement = connection.prepareStatement(insertQuery);
            insertStatement.setInt(1, memberId);
            insertStatement.setInt(2, instrumentId);
            insertStatement.setDate(3, Date.valueOf(startDate));
            insertStatement.setDate(4, Date.valueOf(endDate));
            insertStatement.setBigDecimal(5, totalCost);
            insertStatement.setString(6, "Member booking request");
            insertStatement.executeUpdate();

            String updateQuery = "UPDATE instruments "
                    + "SET available_quantity = available_quantity - 1, "
                    + "availability_status = CASE WHEN available_quantity - 1 > 0 THEN availability_status ELSE 'unavailable' END "
                    + "WHERE instrument_id = ?";
            updateStatement = connection.prepareStatement(updateQuery);
            updateStatement.setInt(1, instrumentId);
            updateStatement.executeUpdate();

            connection.commit();
        } catch (SQLException | RuntimeException e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (selectStatement != null) {
                selectStatement.close();
            }
            if (insertStatement != null) {
                insertStatement.close();
            }
            if (updateStatement != null) {
                updateStatement.close();
            }
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
            UserModel user, int instrumentId, String message) throws ServletException, IOException {
        request.setAttribute("user", user);
        request.setAttribute("errorMessage", message);
        loadInstrument(request, instrumentId);
        request.getRequestDispatcher("/WEB-INF/Pages/booking.jsp").forward(request, response);
    }

    private boolean loadInstrument(HttpServletRequest request, int instrumentId) {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            String query = "SELECT i.instrument_id, i.instrument_name, i.rental_price_per_day, "
                    + "i.available_quantity, i.availability_status, c.category_name "
                    + "FROM instruments i JOIN categories c ON i.category_id = c.category_id "
                    + "WHERE i.instrument_id = ?";
            statement = connection.prepareStatement(query);
            statement.setInt(1, instrumentId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                request.setAttribute("instrumentId", resultSet.getInt("instrument_id"));
                request.setAttribute("instrumentName", resultSet.getString("instrument_name"));
                request.setAttribute("categoryName", resultSet.getString("category_name"));
                request.setAttribute("dailyRate", resultSet.getBigDecimal("rental_price_per_day"));
                request.setAttribute("availableQuantity", resultSet.getInt("available_quantity"));
                request.setAttribute("availabilityStatus", resultSet.getString("availability_status"));
                return true;
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error loading instrument for booking: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }

        return false;
    }

    private UserModel getAuthenticatedMember(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return null;
        }

        Object userObject = session.getAttribute("user");
        if (!(userObject instanceof UserModel)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return null;
        }

        UserModel user = (UserModel) userObject;
        if (!user.isActive() || !user.isMember()) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_session");
            return null;
        }

        return user;
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private LocalDate parseDate(String value) {
        try {
            return LocalDate.parse(value);
        } catch (Exception e) {
            return null;
        }
    }
}
