<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS â€” Forgot Password</title>
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
            <span>MIRS</span>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="error-shell" style="min-height:auto; padding:60px 0;">
        <div class="auth-shell" style="width:min(480px, calc(100% - 48px)); padding:0;">
            <div class="auth-card" style="padding:40px 36px;">

                <!-- Icon -->
                <div style="text-align:center; margin-bottom:24px;">
                    <div class="brand-mark" style="margin:0 auto; width:56px; height:56px; border-radius:18px;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" style="width:26px; height:26px;">
                            <rect x="3" y="11" width="18" height="11" rx="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </div>
                </div>

                <h2 style="font-family:var(--font-display); font-size:1.9rem; letter-spacing:-0.02em; text-align:center; margin-bottom:8px;">
                    Forgot Password
                </h2>
                <p class="subtitle" style="text-align:center; margin-bottom:28px;">
                    Enter your registered email address and we'll verify your account.
                </p>

                <!-- Success -->
                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success" style="margin-bottom:20px;">
                        <span class="status-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="m5 12 4 4L19 6"/>
                            </svg>
                        </span>
                        <div class="alert-copy">
                            <strong>Email Verified</strong>
                            <span>${successMsg}</span>
                        </div>
                    </div>
                    <c:if test="${showResetLink}">
                        <a href="${pageContext.request.contextPath}/resetPassword"
                           class="btn btn-primary" style="width:100%; min-height:50px; margin-top:8px;">
                            Proceed to Reset Password â†’
                        </a>
                    </c:if>
                </c:if>

                <!-- Error -->
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger" style="margin-bottom:20px;">
                        <div class="alert-copy"><strong>Not Found</strong><span>${errorMsg}</span></div>
                    </div>
                </c:if>

                <!-- Form (hide after success) -->
                <c:if test="${empty showResetLink}">
                <form method="post" action="${pageContext.request.contextPath}/forgotPassword">
                    <div class="form-group">
                        <label for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" required
                               placeholder="your@email.com" style="min-height:50px;">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%; min-height:50px; margin-top:8px;">
                        Verify Email
                    </button>
                </form>
                </c:if>

                <div class="form-footer" style="margin-top:24px;">
                    <p>Remember your password? <a href="${pageContext.request.contextPath}/login" style="color:var(--brand-700); font-weight:600;">Sign in</a></p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="footer-content"><p>MIRS - Musical Instruments Rental System</p></div>
</footer>
</body>
</html>
