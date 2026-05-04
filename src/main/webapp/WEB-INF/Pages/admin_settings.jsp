<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Admin Settings</title>
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
            <a href="${pageContext.request.contextPath}/admin/fines" class="admin-nav-link">Fines</a>
            <a href="${pageContext.request.contextPath}/admin/settings" class="admin-nav-link active">Settings</a>
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
            <h1>Settings</h1>
            <p class="subtitle">Update your admin profile, contact information, and password.</p>
        </div>

        <div class="dashboard-grid">
            <div class="dashboard-main">
                <section class="dashboard-panel">
                    <div class="panel-header">
                        <div>
                            <h2 class="panel-title">Profile details</h2>
                            <p class="panel-subtitle">These details appear across the admin workspace.</p>
                        </div>
                    </div>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <div class="alert-copy"><strong>Saved</strong><span>${successMessage}</span></div>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            <div class="alert-copy"><strong>Update issue</strong><span>${errorMessage}</span></div>
                        </div>
                    </c:if>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/settings" id="settingsForm">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="form-group">
                            <label for="username">Username <span class="required">*</span></label>
                            <input type="text" id="username" name="username" value="${user.username}" required minlength="3" maxlength="20">
                            <span class="helper-text">Use 3-20 characters with letters, numbers, underscore, or hyphen.</span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="firstName">First name <span class="required">*</span></label>
                                <input type="text" id="firstName" name="firstName" value="${user.firstName}" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last name <span class="required">*</span></label>
                                <input type="text" id="lastName" name="lastName" value="${user.lastName}" required>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="email">Email address <span class="required">*</span></label>
                                <input type="email" id="email" name="email" value="${user.email}" required>
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber">Phone number <span class="field-note">Optional</span></label>
                                <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address">Address <span class="field-note">Optional</span></label>
                            <textarea id="address" name="address" rows="3"><c:out value="${user.address}"/></textarea>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="city">City <span class="field-note">Optional</span></label>
                                <input type="text" id="city" name="city" value="${user.city}">
                            </div>
                            <div class="form-group">
                                <label for="state">State <span class="field-note">Optional</span></label>
                                <input type="text" id="state" name="state" value="${user.state}">
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="zipCode">Zip code <span class="field-note">Optional</span></label>
                                <input type="text" id="zipCode" name="zipCode" value="${user.zipCode}">
                            </div>
                        </div>

                        <div class="action-row">
                            <button type="submit" class="btn btn-primary">Save profile</button>
                        </div>
                    </form>
                </section>
            </div>

            <aside class="dashboard-side">
                <section class="dashboard-panel">
                    <div class="panel-header">
                        <div>
                            <h2 class="panel-title">Password</h2>
                            <p class="panel-subtitle">Change the password for this admin account.</p>
                        </div>
                    </div>

                    <c:if test="${not empty passwordSuccessMessage}">
                        <div class="alert alert-success">
                            <div class="alert-copy"><strong>Updated</strong><span>${passwordSuccessMessage}</span></div>
                        </div>
                    </c:if>

                    <c:if test="${not empty passwordErrorMessage}">
                        <div class="alert alert-danger">
                            <div class="alert-copy"><strong>Issue</strong><span>${passwordErrorMessage}</span></div>
                        </div>
                    </c:if>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/settings">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="form-group">
                            <label for="currentPassword">Current password <span class="required">*</span></label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">New password <span class="required">*</span></label>
                            <input type="password" id="newPassword" name="newPassword" required minlength="6">
                            <span class="helper-text">At least 6 characters.</span>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm new password <span class="required">*</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>

                        <div class="action-row">
                            <button type="submit" class="btn btn-primary">Update password</button>
                        </div>
                    </form>
                </section>
            </aside>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="footer-content">
        <p>MIRS administration workspace</p>
        <p>Admin profile and account security</p>
    </div>
</footer>
</body>
</html>
