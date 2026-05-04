<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Manage Members</title>
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
            <a href="${pageContext.request.contextPath}/admin/members" class="admin-nav-link active">Members</a>
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
        <div class="page-header">
            <h1>Manage Members</h1>
            <p class="subtitle">View, search, and manage all registered members.</p>
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

        <!-- Search Bar -->
        <div class="dashboard-panel" style="margin-bottom:20px; padding:20px 24px;">
            <form method="get" action="${pageContext.request.contextPath}/admin/members" class="search-bar-row">
                <div class="search-field-wrap">
                    <svg class="search-icon-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                    </svg>
                    <input type="text" id="search" name="search" value="${search}"
                           placeholder="Search by name or email..." class="search-input">
                </div>
                <button type="submit" class="btn btn-primary">Search</button>
                <c:if test="${not empty search}">
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn btn-secondary">Clear</a>
                </c:if>
            </form>
        </div>

        <!-- Members Table -->
        <section class="dashboard-panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">All Members</h2>
                    <p class="panel-subtitle">
                        <c:choose>
                            <c:when test="${not empty search}">Showing results for "<strong>${search}</strong>" - ${members.size()} found</c:when>
                            <c:otherwise>${members.size()} total members</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Member Since</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty members}">
                                <c:forEach var="member" items="${members}">
                                    <tr>
                                        <td><span class="field-note">#${member.userId}</span></td>
                                        <td><strong>${member.firstName} ${member.lastName}</strong></td>
                                        <td>${member.email}</td>
                                        <td>${not empty member.phone ? member.phone : 'Not listed'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${member.isActive}">
                                                    <span class="badge badge-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${member.createdDate}" pattern="dd MMM yyyy"/></td>
                                        <td>
                                            <div class="table-actions">
                                                <!-- Toggle Status -->
                                                <form method="post" action="${pageContext.request.contextPath}/admin/members" style="display:inline;">
                                                    <input type="hidden" name="action" value="toggle_status">
                                                    <input type="hidden" name="memberId" value="${member.userId}">
                                                    <button type="submit" class="btn-action btn-action-warning"
                                                            title="${member.isActive ? 'Deactivate' : 'Activate'}">
                                                        ${member.isActive ? 'Off' : 'On'}
                                                    </button>
                                                </form>
                                                <!-- Delete -->
                                                <form method="post" action="${pageContext.request.contextPath}/admin/members"
                                                      style="display:inline;"
                                                      onsubmit="return confirm('Delete ${member.firstName} ${member.lastName}? This cannot be undone.');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="memberId" value="${member.userId}">
                                                    <button type="submit" class="btn-action btn-action-danger" title="Delete member">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <p><strong>No members found</strong></p>
                                            <c:if test="${not empty search}">
                                                <p class="field-note">Try a different search term.</p>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<footer class="footer">
    <div class="footer-content">
        <p>MIRS administration workspace</p>
    </div>
</footer>
</body>
</html>
