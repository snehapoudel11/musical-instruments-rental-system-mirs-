<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Fine Management</title>
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/members" class="admin-nav-link">Members</a>
            <a href="${pageContext.request.contextPath}/admin/instruments" class="admin-nav-link">Instruments</a>
            <a href="${pageContext.request.contextPath}/admin/rentals" class="admin-nav-link">Rentals</a>
            <a href="${pageContext.request.contextPath}/admin/fines" class="admin-nav-link active">Fines</a>
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
        <div class="page-header">
            <h1>Fine Management</h1>
            <p class="subtitle">Track overdue fines, mark payments, and review revenue from penalties.</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success" style="margin-bottom:20px;">
                <div class="alert-copy"><strong>Success</strong><span>${successMsg}</span></div>
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger" style="margin-bottom:20px;">
                <div class="alert-copy"><strong>Error</strong><span>${errorMsg}</span></div>
            </div>
        </c:if>

        <!-- Summary Cards -->
        <div class="summary-card-row">
            <div class="summary-stat-card tone-danger">
                <div class="summary-stat-label">Total Fines Issued</div>
                <div class="summary-stat-value">
                    Rs. <fmt:formatNumber value="${not empty summary.totalFines ? summary.totalFines : 0}" pattern="0.00"/>
                </div>
                <div class="summary-stat-sub">Across all overdue rentals</div>
            </div>
            <div class="summary-stat-card tone-accent">
                <div class="summary-stat-label">Total Fines Collected</div>
                <div class="summary-stat-value">
                    Rs. <fmt:formatNumber value="${not empty summary.collected ? summary.collected : 0}" pattern="0.00"/>
                </div>
                <div class="summary-stat-sub">Payments marked as received</div>
            </div>
            <div class="summary-stat-card tone-brand">
                <div class="summary-stat-label">Outstanding Balance</div>
                <div class="summary-stat-value">
                    <c:set var="outstanding" value="${(not empty summary.totalFines ? summary.totalFines : 0) - (not empty summary.collected ? summary.collected : 0)}"/>
                    Rs. <fmt:formatNumber value="${outstanding < 0 ? 0 : outstanding}" pattern="0.00"/>
                </div>
                <div class="summary-stat-sub">Still unpaid</div>
            </div>
        </div>

        <!-- Fines Table -->
        <section class="dashboard-panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">All Fines</h2>
                    <p class="panel-subtitle">Fine rate: Rs. 0.50 per day overdue.</p>
                </div>
            </div>
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>Rental #</th>
                            <th>Member</th>
                            <th>Instrument</th>
                            <th>Days Overdue</th>
                            <th>Fine Amount</th>
                            <th>Payment Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty fines}">
                                <c:forEach var="fine" items="${fines}">
                                    <tr class="${fine.isPaid ? '' : 'overdue-row'}">
                                        <td><span class="field-note">#${fine.rentalId}</span></td>
                                        <td><strong>${fine.memberName}</strong></td>
                                        <td>${fine.instrumentName}</td>
                                        <td>${fine.daysOverdue} day(s)</td>
                                        <td>
                                            <strong style="color:var(--danger-700);">
                                                Rs. <fmt:formatNumber value="${fine.fineAmount}" pattern="0.00"/>
                                            </strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fine.isPaid}">
                                                    <span class="badge badge-success">Paid</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Unpaid</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${!fine.isPaid}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/fines"
                                                      onsubmit="return confirm('Mark fine for rental #${fine.rentalId} as paid?');">
                                                    <input type="hidden" name="action" value="mark_paid">
                                                    <input type="hidden" name="rentalId" value="${fine.rentalId}">
                                                    <button type="submit" class="btn-action btn-action-success">Mark Paid</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${fine.isPaid}">
                                                <span class="field-note">Settled</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="7">
                                    <div class="empty-state">
                                        <p><strong>No fines on record</strong></p>
                                        <p class="field-note">All rentals have been returned on time.</p>
                                    </div>
                                </td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<footer class="footer">
    <div class="footer-content"><p>MIRS administration workspace</p></div>
</footer>
</body>
</html>
