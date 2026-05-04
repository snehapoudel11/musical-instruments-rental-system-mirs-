package com.mirs.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.mirs.config.DBConfig;
import com.mirs.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/member/rentals")
public class MyRentalsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        UserModel user = getAuthenticatedMember(request, response);
        if (user == null) {
            return;
        }

        if ("booking_created".equals(request.getParameter("success"))) {
            request.setAttribute("successMessage", "Booking confirmed. Your rental request was saved.");
        } else if ("returned".equals(request.getParameter("success"))) {
            request.setAttribute("successMessage", "Instrument returned successfully.");
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/Pages/my_rentals.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        UserModel user = getAuthenticatedMember(request, response);
        if (user == null) {
            return;
        }

        if (!"return".equals(request.getParameter("action"))) {
            response.sendRedirect(request.getContextPath() + "/member/rentals");
            return;
        }

        int rentalId = parseId(request.getParameter("rentalId"));
        if (rentalId <= 0) {
            response.sendRedirect(request.getContextPath() + "/member/rentals?error=invalid_rental");
            return;
        }

        try {
            returnRental(user.getUserId(), rentalId);
            response.sendRedirect(request.getContextPath() + "/member/rentals?success=returned");
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error returning rental: " + e.getMessage());
            request.setAttribute("errorMessage", "The rental could not be returned right now.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/Pages/my_rentals.jsp").forward(request, response);
        }
    }

    private void returnRental(int memberId, int rentalId) throws SQLException, ClassNotFoundException {
        Connection connection = null;
        PreparedStatement selectStatement = null;
        PreparedStatement rentalStatement = null;
        PreparedStatement instrumentStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConfig.getConnection();
            connection.setAutoCommit(false);

            String selectQuery = "SELECT instrument_id, GREATEST(DATEDIFF(CURDATE(), return_date), 0) AS overdue_days "
                    + "FROM rentals "
                    + "WHERE rental_id = ? AND member_id = ? AND status IN ('active', 'overdue', 'pending') "
                    + "FOR UPDATE";
            selectStatement = connection.prepareStatement(selectQuery);
            selectStatement.setInt(1, rentalId);
            selectStatement.setInt(2, memberId);
            resultSet = selectStatement.executeQuery();

            if (!resultSet.next()) {
                connection.rollback();
                return;
            }

            int instrumentId = resultSet.getInt("instrument_id");
            int overdueDays = resultSet.getInt("overdue_days");
            BigDecimal fine = BigDecimal.valueOf(overdueDays).multiply(BigDecimal.valueOf(0.50));

            String updateRental = "UPDATE rentals "
                    + "SET status = 'returned', actual_return_date = CURDATE(), fine_amount = ? "
                    + "WHERE rental_id = ? AND member_id = ?";
            rentalStatement = connection.prepareStatement(updateRental);
            rentalStatement.setBigDecimal(1, fine);
            rentalStatement.setInt(2, rentalId);
            rentalStatement.setInt(3, memberId);
            rentalStatement.executeUpdate();

            String updateInstrument = "UPDATE instruments "
                    + "SET available_quantity = available_quantity + 1, "
                    + "availability_status = CASE WHEN availability_status = 'discontinued' THEN availability_status ELSE 'available' END "
                    + "WHERE instrument_id = ?";
            instrumentStatement = connection.prepareStatement(updateInstrument);
            instrumentStatement.setInt(1, instrumentId);
            instrumentStatement.executeUpdate();

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
            if (rentalStatement != null) {
                rentalStatement.close();
            }
            if (instrumentStatement != null) {
                instrumentStatement.close();
            }
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
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
}
