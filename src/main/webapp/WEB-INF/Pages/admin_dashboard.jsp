<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header class="header">
    <div class="header-container">
        <div class="logo">
            <span class="brand-mark">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M12 3v18"/><path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/><path d="M8.5 5.5h7"/>
                </svg>
            </span>
            <span>MIRS Admin</span>
        </div>
        <nav class="admin-top-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/members" class="admin-nav-link">Members</a>
            <a href="${pageContext.request.contextPath}/admin/instruments" class="admin-nav-link">Instruments</a>
            <a href="${pageContext.request.contextPath}/admin/rentals" class="admin-nav-link">Rentals</a>
            <a href="${pageContext.request.contextPath}/admin/fines" class="admin-nav-link">Fines</a>
            <a href="${pageContext.request.contextPath}/admin/settings" class="admin-nav-link">Settings</a>
        </nav>
        <div class="user-info">
            <div class="user-meta">
                <span class="field-note">Administrator</span>
                <strong>${user.firstName} ${user.lastName}</strong>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Sign out</a>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <!-- Hero Panel -->
        <section class="hero-panel">
            <div>
                <h1 class="hero-heading">A quieter view of the whole inventory system.</h1>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/admin/instruments" class="btn btn-primary">Manage instruments</a>
                    <a href="${pageContext.request.contextPath}/admin/rentals" class="btn btn-secondary">Review rentals</a>
                </div>
            </div>
        </section>

        <!-- Stat Cards -->
        <div class="metric-grid" style="margin-bottom: 24px;">
            <article class="metric-card tone-brand">
                <span class="metric-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="10" cy="7" r="4"/>
                        <path d="M20 8v6"/><path d="M23 11h-6"/>
                    </svg>
                </span>
                <div class="metric-content">
                    <div class="metric-label">Total Members</div>
                    <div class="metric-value">${stats.totalMembers}</div>
                </div>
            </article>

            <article class="metric-card">
                <span class="metric-icon">
                    <span class="metric-glyph" aria-hidden="true">|||</span>
                </span>
                <div class="metric-content">
                    <div class="metric-label">Total Instruments</div>
                    <div class="metric-value">${stats.totalInstruments}</div>
                </div>
            </article>

            <article class="metric-card tone-brand">
                <span class="metric-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="3" y="5" width="18" height="14" rx="3"/><path d="M7 10h10M7 14h6"/>
                    </svg>
                </span>
                <div class="metric-content">
                    <div class="metric-label">Active Rentals</div>
                    <div class="metric-value">${stats.activeRentals}</div>
                </div>
            </article>

            <article class="metric-card tone-danger">
                <span class="metric-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M12 9v4"/><path d="M12 17h.01"/>
                        <path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z"/>
                    </svg>
                </span>
                <div class="metric-content">
                    <div class="metric-label">Overdue Rentals</div>
                    <div class="metric-value">${stats.overdueRentals}</div>
                </div>
            </article>

            <article class="metric-card tone-accent">
                <span class="metric-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M12 1v22"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                    </svg>
                </span>
                <div class="metric-content">
                    <div class="metric-label">Total Fines Collected</div>
                    <div class="metric-value">Rs. <fmt:formatNumber value="${stats.totalFinesCollected}" pattern="0.00"/></div>
                </div>
            </article>
        </div>

        <div class="dashboard-main">
                <!-- System Summary -->
                <section class="dashboard-panel">
                    <div class="panel-header">
                        <div>
                            <h2 class="panel-title">Inventory summary</h2>
                        </div>
                    </div>
                    <div class="table-card">
                        <table>
                            <tr><th>Area</th><th>What to check</th><th>Action</th></tr>
                            <tr>
                                <td><strong>Stock attention</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stats.lowStockInstruments > 0}">
                                            ${stats.lowStockInstruments} instrument(s) have fewer than 2 available units.
                                        </c:when>
                                        <c:otherwise>Stock levels look healthy right now.</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><a href="${pageContext.request.contextPath}/admin/instruments" class="btn btn-secondary">Review stock</a></td>
                            </tr>
                            <tr>
                                <td><strong>Overdue follow-up</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stats.overdueRentals > 0}">
                                            ${stats.overdueRentals} rental(s) need follow-up.
                                        </c:when>
                                        <c:otherwise>No overdue rentals right now.</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><a href="${pageContext.request.contextPath}/admin/rentals?status=overdue" class="btn btn-secondary">Open overdue</a></td>
                            </tr>
                            <tr>
                                <td><strong>Active rentals</strong></td>
                                <td>${stats.activeRentals} rental(s) are currently out with members.</td>
                                <td><a href="${pageContext.request.contextPath}/admin/rentals?status=active" class="btn btn-secondary">Review active</a></td>
                            </tr>
                            <tr>
                                <td><strong>Catalog maintenance</strong></td>
                                <td>Add new instruments, update daily rates, and correct availability.</td>
                                <td><a href="${pageContext.request.contextPath}/admin/instruments" class="btn btn-primary">Manage catalog</a></td>
                            </tr>
                        </table>
                    </div>
                </section>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="footer-content">
        <p>MIRS administration workspace</p>
        <p>Musical Instruments Rental System</p>
    </div>
</footer>
</body>
</html>
