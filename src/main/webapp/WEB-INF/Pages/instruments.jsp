<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.mirs.config.DBConfig" %>
<%!
    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

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
%>
<%
    String search = clean(request.getParameter("search"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Browse Instruments</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .catalog-hero {
            grid-template-columns: 1fr;
            padding: 22px 24px;
            margin-bottom: 16px;
            border-radius: 18px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.88), rgba(59, 139, 130, 0.1));
            box-shadow: 0 14px 34px rgba(15, 23, 42, 0.07);
        }

        .catalog-hero .hero-heading {
            font-size: clamp(1.85rem, 3vw, 2.5rem);
            margin-bottom: 8px;
        }

        .catalog-hero .hero-copy {
            margin-bottom: 0;
        }

        .catalog-panel {
            padding: 18px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.66);
            box-shadow: 0 16px 42px rgba(15, 23, 42, 0.08);
        }

        .browse-toolbar {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto auto;
            gap: 10px;
            align-items: end;
            margin-bottom: 18px;
            padding-bottom: 18px;
            border-bottom: 1px solid rgba(22, 32, 42, 0.08);
        }

        .browse-toolbar .form-group {
            margin-bottom: 0;
        }

        .browse-toolbar label {
            font-size: 0.78rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--ink-500);
        }

        .browse-toolbar input[type="search"] {
            min-height: 42px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.92);
        }

        .browse-toolbar .btn {
            min-height: 42px;
            border-radius: 12px;
            padding: 0 18px;
        }

        .instrument-card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(255px, 1fr));
            gap: 14px;
        }

        .browse-card {
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 250px;
            padding: 18px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(22, 32, 42, 0.1);
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
            transition: transform var(--transition), border-color var(--transition), box-shadow var(--transition);
        }

        .browse-card:hover {
            transform: translateY(-3px);
            border-color: rgba(31, 93, 87, 0.22);
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.1);
        }

        .browse-card::before {
            content: "";
            position: absolute;
            inset: 0 0 auto;
            height: 3px;
            background: linear-gradient(90deg, var(--brand-700), var(--accent-600));
        }

        .browse-card-top {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .instrument-avatar {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 8px;
            color: #1f5d57;
            background: rgba(59, 139, 130, 0.12);
            flex: 0 0 auto;
        }

        .instrument-avatar svg {
            width: 22px;
            height: 22px;
        }

        .browse-card h2 {
            font-family: var(--font-display);
            font-size: 1.16rem;
            letter-spacing: 0;
            color: var(--ink-900);
            line-height: 1.18;
            margin-bottom: 6px;
        }

        .instrument-category {
            color: var(--ink-700);
            font-weight: 600;
            font-size: 0.92rem;
        }

        .instrument-detail-list {
            display: grid;
            gap: 7px;
            margin: 10px 0 18px;
            color: var(--ink-700);
        }

        .instrument-detail-list span {
            display: flex;
            justify-content: space-between;
            gap: 12px;
        }

        .instrument-detail-list strong {
            color: var(--ink-900);
            text-align: right;
        }

        .instrument-card-footer {
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
        }

        .availability-badge {
            display: inline-flex;
            align-items: center;
            min-height: 28px;
            padding: 0 11px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 800;
        }

        .availability-badge.available {
            color: var(--success-700);
            background: var(--success-100);
        }

        .availability-badge.rented {
            color: var(--danger-700);
            background: var(--danger-100);
        }

        .btn[disabled] {
            cursor: not-allowed;
            opacity: 0.58;
            transform: none;
            box-shadow: none;
        }

        .instrument-card-footer .btn {
            min-height: 40px;
            padding: 0 18px;
            border-radius: 12px;
        }

        .empty-results {
            padding: 28px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.72);
            border: 1px dashed rgba(22, 32, 42, 0.2);
            color: var(--ink-700);
            grid-column: 1 / -1;
        }

        @media (max-width: 700px) {
            .browse-toolbar {
                grid-template-columns: 1fr;
            }

            .instrument-card-footer {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body class="member-catalog">
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
            <section class="hero-panel catalog-hero">
                <div>
                    <h1 class="hero-heading">Browse instruments</h1>
                    <p class="hero-copy">Search the live catalog by instrument name, category, or type before starting a booking.</p>
                </div>
            </section>

            <section class="dashboard-panel catalog-panel">
                <form method="GET" action="${pageContext.request.contextPath}/member/instruments" class="browse-toolbar">
                    <div class="form-group">
                        <label for="search">Search instruments</label>
                        <input type="search" id="search" name="search" placeholder="Search by name, category, or type" value="<%= escapeHtml(search) %>">
                    </div>
                    <button type="submit" class="btn btn-primary">Search</button>
                    <a href="${pageContext.request.contextPath}/member/instruments" class="btn btn-secondary">Clear</a>
                </form>

                <div class="instrument-card-grid">
                    <%
                        Connection connection = null;
                        PreparedStatement statement = null;
                        ResultSet resultSet = null;
                        boolean hasResults = false;
                        String loadError = null;

                        try {
                            connection = DBConfig.getConnection();
                            String query = "SELECT i.instrument_id, i.instrument_name, c.category_name, "
                                    + "i.brand, i.available_quantity, i.availability_status, "
                                    + "i.rental_price_per_day, i.`condition` "
                                    + "FROM instruments i "
                                    + "JOIN categories c ON i.category_id = c.category_id ";

                            if (!search.isEmpty()) {
                                query += "WHERE i.instrument_name LIKE ? "
                                        + "OR c.category_name LIKE ? "
                                        + "OR i.`condition` LIKE ? "
                                        + "OR i.brand LIKE ? ";
                            }

                            query += "ORDER BY c.category_name, i.instrument_name";
                            statement = connection.prepareStatement(query);

                            if (!search.isEmpty()) {
                                String pattern = "%" + search + "%";
                                statement.setString(1, pattern);
                                statement.setString(2, pattern);
                                statement.setString(3, pattern);
                                statement.setString(4, pattern);
                            }

                            resultSet = statement.executeQuery();

                            while (resultSet.next()) {
                                hasResults = true;
                                int instrumentId = resultSet.getInt("instrument_id");
                                String name = resultSet.getString("instrument_name");
                                String category = resultSet.getString("category_name");
                                String brand = resultSet.getString("brand");
                                String condition = resultSet.getString("condition");
                                String status = resultSet.getString("availability_status");
                                int availableQuantity = resultSet.getInt("available_quantity");
                                double rate = resultSet.getDouble("rental_price_per_day");
                                boolean available = "available".equalsIgnoreCase(status) && availableQuantity > 0;
                    %>
                    <article class="browse-card">
                        <div class="browse-card-top">
                            <div>
                                <h2><%= escapeHtml(name) %></h2>
                                <p class="instrument-category"><%= escapeHtml(category) %></p>
                            </div>
                            <span class="instrument-avatar">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                    <path d="M12 3v18"/>
                                    <path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/>
                                    <path d="M8.5 5.5h7"/>
                                </svg>
                            </span>
                        </div>

                        <div class="instrument-detail-list">
                            <span>Type <strong><%= escapeHtml(condition) %></strong></span>
                            <span>Brand <strong><%= brand == null || brand.isEmpty() ? "Not listed" : escapeHtml(brand) %></strong></span>
                            <span>Daily rate <strong>Rs. <%= String.format("%.2f", rate) %></strong></span>
                        </div>

                        <div class="instrument-card-footer">
                            <span class="availability-badge <%= available ? "available" : "rented" %>">
                                <%= available ? "Available" : "Rented" %>
                            </span>
                            <% if (available) { %>
                                <a href="${pageContext.request.contextPath}/member/book?instrumentId=<%= instrumentId %>" class="btn btn-primary">Book</a>
                            <% } else { %>
                                <button type="button" class="btn btn-primary" disabled>Book</button>
                            <% } %>
                        </div>
                    </article>
                    <%
                            }
                        } catch (SQLException | ClassNotFoundException e) {
                            loadError = e.getMessage();
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
                                loadError = e.getMessage();
                            }
                        }

                        if (!hasResults) {
                    %>
                    <div class="empty-results">
                        <strong>No instruments found.</strong>
                        <p><%= loadError == null ? "Try another search term or clear the search." : "Could not load instruments from the database right now." %></p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </section>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <p>MIRS member workspace</p>
            <p>Instrument catalog and booking access</p>
        </div>
    </footer>
</body>
</html>
