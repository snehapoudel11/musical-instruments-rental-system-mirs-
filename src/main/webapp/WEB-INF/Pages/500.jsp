<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <main class="error-shell">
        <section class="error-card">
            <div class="panel-icon center-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M12 9v4"/>
                    <path d="M12 16h.01"/>
                    <path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z"/>
                </svg>
            </div>
            <div class="eyebrow center-eyebrow">Error 500</div>
            <div class="error-code">500</div>
            <h1 class="error-title">Server error</h1>
            <p class="error-copy">Something interrupted the request. Try again after a moment or return to a safe page.</p>

            <div class="alert alert-info">
                <span class="status-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <circle cx="12" cy="12" r="9"/>
                        <path d="M12 8h.01"/>
                        <path d="M11 12h1v4h1"/>
                    </svg>
                </span>
                <div class="alert-copy">
                    <strong>What to do</strong>
                    <span>Refresh the page, clear stale browser data if needed, and retry after a short pause.</span>
                </div>
            </div>

            <%
                Throwable exception = (Throwable) request.getAttribute("exception");
                if (exception != null) {
            %>
            <div class="error-details">
                <strong>Error details</strong><br>
                <code><%= exception.getMessage() %></code>
            </div>
            <% } %>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to home</a>
                <a href="javascript:history.back()" class="btn btn-secondary">Go back</a>
            </div>
        </section>
    </main>
</body>
</html>
