<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Manage Rentals</title>
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
            <a href="${pageContext.request.contextPath}/admin/rentals" class="admin-nav-link active">Rentals</a>
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
        <div class="page-header">
            <h1>Manage Rentals</h1>
            <p class="subtitle">View all rental records, filter by status, and mark instruments as returned.</p>
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

        <!-- Filter Bar -->
        <div class="dashboard-panel" style="margin-bottom:20px; padding:20px 24px;">
            <div class="filter-bar">
                <span class="field-note" style="font-weight:600;">Filter by status:</span>
                <a href="${pageContext.request.contextPath}/admin/rentals?status=all"
                   class="filter-btn ${statusFilter == 'all' ? 'filter-btn-active' : ''}">All</a>
                <a href="${pageContext.request.contextPath}/admin/rentals?status=active"
                   class="filter-btn ${statusFilter == 'active' ? 'filter-btn-active' : ''}">Active</a>
                <a href="${pageContext.request.contextPath}/admin/rentals?status=overdue"
                   class="filter-btn ${statusFilter == 'overdue' ? 'filter-btn-active' : ''}">Overdue</a>
                <a href="${pageContext.request.contextPath}/admin/rentals?status=returned"
                   class="filter-btn ${statusFilter == 'returned' ? 'filter-btn-active' : ''}">Returned</a>
                <a href="${pageContext.request.contextPath}/admin/rentals?status=pending"
                   class="filter-btn ${statusFilter == 'pending' ? 'filter-btn-active' : ''}">Pending</a>
            </div>
        </div>

        <!-- Rentals Table -->
        <section class="dashboard-panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">Rental Records</h2>
                    <p class="panel-subtitle">${rentals.size()} record(s) - filter: <strong>${statusFilter}</strong></p>
                </div>
            </div>
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Member</th>
                            <th>Instrument</th>
                            <th>Start Date</th>
                            <th>Due Date</th>
                            <th>Status</th>
                            <th>Fine</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty rentals}">
                                <c:forEach var="rental" items="${rentals}">
                                    <tr class="${rental.isOverdue ? 'overdue-row' : ''}">
                                        <td><span class="field-note">#${rental.rentalId}</span></td>
                                        <td><strong>${rental.memberName}</strong></td>
                                        <td>${rental.instrumentName}</td>
                                        <td><fmt:formatDate value="${rental.rentalDate}" pattern="dd MMM yyyy"/></td>
                                        <td>
                                            <fmt:formatDate value="${rental.returnDate}" pattern="dd MMM yyyy"/>
                                            <c:if test="${rental.isOverdue}">
                                                <span class="badge badge-danger" style="margin-left:6px;">OVERDUE</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${rental.status == 'active'}"><span class="badge badge-primary">Active</span></c:when>
                                                <c:when test="${rental.status == 'returned'}"><span class="badge badge-success">Returned</span></c:when>
                                                <c:when test="${rental.status == 'overdue'}"><span class="badge badge-danger">Overdue</span></c:when>
                                                <c:when test="${rental.status == 'pending'}"><span class="badge badge-warning">Pending</span></c:when>
                                                <c:otherwise><span class="badge badge-secondary">${rental.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${rental.fineAmount > 0}">
                                                    <span style="color:var(--danger-700); font-weight:600;">
                                                        Rs. <fmt:formatNumber value="${rental.fineAmount}" pattern="0.00"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="field-note">None</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${rental.status == 'active' || rental.status == 'pending' || rental.status == 'overdue'}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/rentals"
                                                      onsubmit="return confirm('Mark rental #${rental.rentalId} as returned?');">
                                                    <input type="hidden" name="action" value="mark_returned">
                                                    <input type="hidden" name="rentalId" value="${rental.rentalId}">
                                                    <button type="submit" class="btn-action btn-action-success" title="Mark Returned">Return</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${rental.status == 'returned'}">
                                                <span class="field-note">Completed</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8">
                                    <div class="empty-state"><p><strong>No rental records found</strong></p></div>
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
