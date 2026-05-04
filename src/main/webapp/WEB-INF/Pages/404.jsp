<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Page Not Found</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <main class="error-shell">
        <section class="error-card">
            <div class="panel-icon center-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <circle cx="12" cy="12" r="9"/>
                    <path d="M9 9h.01"/>
                    <path d="M15 9h.01"/>
                    <path d="M8.5 15c.8-1 1.98-1.5 3.5-1.5 1.52 0 2.7.5 3.5 1.5"/>
                </svg>
            </div>
            <div class="eyebrow center-eyebrow">Error 404</div>
            <div class="error-code">404</div>
            <h1 class="error-title">Page not found</h1>
            <p class="error-copy">The address you requested does not point to an available page in MIRS.</p>

            <% String requestPath = (String) request.getAttribute("jakarta.servlet.forward.request_uri"); %>
            <% if (requestPath != null && !requestPath.isBlank()) { %>
                <div class="resource-info">
                    <strong>Requested resource</strong><br>
                    <span><%= requestPath %></span>
                </div>
            <% } %>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to home</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Open sign in</a>
            </div>
        </section>
    </main>
</body>
</html>
