<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.mirs.config.DBConfig" %>
<%@ page import="com.mirs.model.UserModel" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String displayStatus(String status, int overdueDays) {
        if ("returned".equalsIgnoreCase(status)) {
            return "Returned";
        }
        if (overdueDays > 0) {
            return "Overdue";
        }
        return "Active";
    }

    private String statusClass(String displayStatus) {
        if ("Returned".equals(displayStatus)) {
            return "rental-status returned";
        }
        if ("Overdue".equals(displayStatus)) {
            return "rental-status overdue";
        }
        return "rental-status active";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - My Rentals</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
    <style>
        .rentals-table-wrap {
            overflow-x: auto;
            border-radius: 8px;
            border: 1px solid var(--line-soft);
            background: rgba(255, 255, 255, 0.62);
        }

        .rentals-table {
            width: 100%;
            min-width: 760px;
            border-collapse: collapse;
        }

        .rentals-table th {
            padding: 16px 18px;
            text-align: left;
            color: var(--ink-500);
            background: rgba(255, 255, 255, 0.7);
            border-bottom: 1px solid var(--line-soft);
            font-size: 0.8rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .rentals-table td {
            padding: 16px 18px;
            border-bottom: 1px solid rgba(22, 32, 42, 0.07);
            color: var(--ink-700);
        }

        .rentals-table tr:last-child td {
            border-bottom: none;
        }

        .rentals-table tr.is-overdue {
            background: rgba(166, 70, 70, 0.1);
        }

        .rental-status {
            display: inline-flex;
            align-items: center;
            min-height: 30px;
            padding: 0 12px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 800;
        }

        .rental-status.active {
            color: var(--brand-700);
            background: var(--brand-100);
        }

        .rental-status.overdue {
            color: var(--danger-700);
            background: var(--danger-100);
        }

        .rental-status.returned {
            color: var(--success-700);
            background: var(--success-100);
        }

        .inline-return-form {
            margin: 0;
        }

        .fine-amount {
            font-weight: 800;
            color: var(--danger-700);
        }

        @media (max-width: 700px) {
            .user-info {
                flex-wrap: wrap;
                justify-content: flex-end;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="${pageContext.request.contextPath}/member/dashboard" class="logo">
                <span class="brand-mark">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M12 3v18"/>
                        <path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/>
                        <path d="M8.5 5.5h7"/>
                    </svg>
                </span>
                <span>MIRS Member</span>
            </a>
            <div class="user-info">
                <div class="user-meta">
                    <span class="field-note">Signed in as</span>
                    <strong>${user.firstName}</strong>
                </div>
                <a href="${pageContext.request.contextPath}/member/dashboard" class="btn btn-secondary">Home</a>
                <a href="${pageContext.request.contextPath}/member/instruments" class="btn btn-secondary">Instruments</a>
                <a href="${pageContext.request.contextPath}/member/rentals" class="btn btn-secondary">My rentals</a>
                <a href="${pageContext.request.contextPath}/member/account" class="btn btn-secondary">Account</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Sign out</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="container">
            <section class="hero-panel">
                <div>
                    <h1 class="hero-heading">My rentals</h1>
                    <p class="hero-copy">Review your saved rental requests and current rental history.</p>
                </div>
            </section>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <span class="status-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="m5 12 4 4L19 6"/>
                        </svg>
                    </span>
                    <div class="alert-copy">
                        <strong>Success</strong>
                        <span>${successMessage}</span>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <span class="status-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <circle cx="12" cy="12" r="9"/>
                            <path d="M12 8v5"/>
                            <path d="M12 16h.01"/>
                        </svg>
                    </span>
                    <div class="alert-copy">
                        <strong>Return issue</strong>
                        <span>${errorMessage}</span>
                    </div>
                </div>
            </c:if>

            <section class="dashboard-panel">
                <div class="panel-header">
                    <div>
                        <h2 class="panel-title">Rental records</h2>
                        <p class="panel-subtitle">Newest rentals appear first.</p>
                    </div>
                </div>

                <div class="rentals-table-wrap">
                    <table class="rentals-table">
                        <thead>
                            <tr>
                                <th>Instrument</th>
                                <th>Start date</th>
                                <th>End date</th>
                                <th>Status</th>
                                <th>Fine</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                UserModel currentUser = (UserModel) request.getAttribute("user");
                                Connection connection = null;
                                PreparedStatement statement = null;
                                ResultSet resultSet = null;
                                boolean hasRentals = false;

                                try {
                                    connection = DBConfig.getConnection();
                                    String query = "SELECT r.rental_id, i.instrument_name, r.rental_date, r.return_date, "
                                            + "r.status, r.fine_amount, "
                                            + "CASE WHEN r.status <> 'returned' AND r.return_date < CURDATE() "
                                            + "THEN DATEDIFF(CURDATE(), r.return_date) ELSE 0 END AS overdue_days "
                                            + "FROM rentals r "
                                            + "JOIN instruments i ON r.instrument_id = i.instrument_id "
                                            + "WHERE r.member_id = ? "
                                            + "ORDER BY r.created_date DESC, r.rental_id DESC";
                                    statement = connection.prepareStatement(query);
                                    statement.setInt(1, currentUser.getUserId());
                                    resultSet = statement.executeQuery();

                                    while (resultSet.next()) {
                                        hasRentals = true;
                                        int rentalId = resultSet.getInt("rental_id");
                                        String status = resultSet.getString("status");
                                        int overdueDays = resultSet.getInt("overdue_days");
                                        String displayStatus = displayStatus(status, overdueDays);
                                        double calculatedFine = "Returned".equals(displayStatus)
                                                ? resultSet.getDouble("fine_amount")
                                                : overdueDays * 0.50;
                                        boolean canReturn = "Active".equals(displayStatus) || "Overdue".equals(displayStatus);
                            %>
                            <tr class="<%= "Overdue".equals(displayStatus) ? "is-overdue" : "" %>">
                                <td><%= escapeHtml(resultSet.getString("instrument_name")) %></td>
                                <td><%= resultSet.getDate("rental_date") %></td>
                                <td><%= resultSet.getDate("return_date") %></td>
                                <td><span class="<%= statusClass(displayStatus) %>"><%= displayStatus %></span></td>
                                <td><span class="<%= calculatedFine > 0 ? "fine-amount" : "" %>">Rs. <%= String.format("%.2f", calculatedFine) %></span></td>
                                <td>
                                    <% if (canReturn) { %>
                                        <form method="POST" action="${pageContext.request.contextPath}/member/rentals" class="inline-return-form">
                                            <input type="hidden" name="action" value="return">
                                            <input type="hidden" name="rentalId" value="<%= rentalId %>">
                                            <button type="submit" class="btn btn-primary">Return</button>
                                        </form>
                                    <% } else { %>
                                        <span class="field-note">Complete</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (SQLException | ClassNotFoundException e) {
                                    hasRentals = true;
                            %>
                            <tr>
                                <td colspan="6">Could not load rentals from the database.</td>
                            </tr>
                            <%
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

                                if (!hasRentals) {
                            %>
                            <tr>
                                <td colspan="6">No rentals yet.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</body>
</html>
