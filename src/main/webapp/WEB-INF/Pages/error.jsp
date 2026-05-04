<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS â€” Access Denied</title>
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
    <div class="error-shell">
        <div class="error-card" style="text-align:center; padding:56px 48px;">

            <!-- Icon -->
            <div style="margin:0 auto 28px; width:80px; height:80px; border-radius:24px;
                        background:var(--danger-100); border:1px solid rgba(166,70,70,0.2);
                        display:flex; align-items:center; justify-content:center;">
                <svg viewBox="0 0 24 24" fill="none" stroke="var(--danger-700)" stroke-width="1.6"
                     style="width:40px; height:40px;">
                    <rect x="3" y="11" width="18" height="11" rx="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    <path d="M12 15v2"/>
                </svg>
            </div>

            <!-- Error Code -->
            <div class="eyebrow" style="color:var(--danger-700); margin-bottom:12px;">
                <c:choose>
                    <c:when test="${reason == 'unauthorized'}">403 â€” Forbidden</c:when>
                    <c:when test="${reason == 'session_expired'}">Session Expired</c:when>
                    <c:otherwise>Access Denied</c:otherwise>
                </c:choose>
            </div>

            <h1 class="error-title" style="font-size:clamp(1.8rem,3vw,2.8rem); margin-bottom:16px;">
                You're not authorized to view this page.
            </h1>

            <p style="color:var(--ink-700); max-width:48ch; margin:0 auto 32px;">
                <c:choose>
                    <c:when test="${reason == 'session_expired'}">
                        Your session has expired. Please sign in again to continue.
                    </c:when>
                    <c:otherwise>
                        This page requires admin privileges, or your session may have expired.
                        Please sign in with an authorized account.
                    </c:otherwise>
                </c:choose>
            </p>

            <!-- Actions -->
            <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                    â†’ Sign In
                </a>
                <a href="javascript:history.back()" class="btn btn-secondary">
                    â† Go Back
                </a>
            </div>

            <!-- Tip -->
            <div class="alert alert-info" style="margin-top:32px; text-align:left;">
                <div class="alert-copy">
                    <strong>Need access?</strong>
                    <span>If you believe this is a mistake, please <a href="${pageContext.request.contextPath}/contact" style="color:var(--brand-700);">contact support</a>.</span>
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
