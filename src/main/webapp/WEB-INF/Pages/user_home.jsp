<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Member Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
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
            <section class="hero-panel">
                <div>
                    <h1 class="hero-heading">Welcome back, ${user.firstName}.</h1>
                    <p class="hero-copy">Review your rentals, see what is available, and track your member activity from one clean workspace.</p>
                </div>
            </section>

            <div class="dashboard-main">
                    <section class="dashboard-panel">
                        <div class="panel-header">
                            <div>
                                <h2 class="panel-title">My overview</h2>
                                <p class="panel-subtitle">A summary of your current rentals, availability, and account usage.</p>
                            </div>
                        </div>

                        <div class="metric-grid">
                            <article class="metric-card tone-brand">
                                <span class="metric-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <rect x="3" y="5" width="18" height="14" rx="3"/>
                                        <path d="M7 10h10M7 14h6"/>
                                    </svg>
                                </span>
                                <div class="metric-content">
                                    <div class="metric-label">My total rentals</div>
                                    <div class="metric-value">${stats.myTotalRentals}</div>
                                </div>
                            </article>

                            <article class="metric-card">
                                <span class="metric-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M5 12h14"/>
                                        <path d="m12 5 7 7-7 7"/>
                                    </svg>
                                </span>
                                <div class="metric-content">
                                    <div class="metric-label">Active rentals</div>
                                    <div class="metric-value">${stats.myActiveRentals}</div>
                                </div>
                            </article>

                            <article class="metric-card ${stats.myOverdueRentals > 0 ? 'tone-danger' : 'tone-accent'}">
                                <span class="metric-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M12 9v4"/>
                                        <path d="M12 16h.01"/>
                                        <path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z"/>
                                    </svg>
                                </span>
                                <div class="metric-content">
                                    <div class="metric-label">Overdue rentals</div>
                                    <div class="metric-value">${stats.myOverdueRentals}</div>
                                </div>
                            </article>

                            <article class="metric-card tone-accent">
                                <span class="metric-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M12 1v22"/>
                                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                                    </svg>
                                </span>
                                <div class="metric-content">
                                    <div class="metric-label">My fines</div>
                                    <div class="metric-value">Rs. <fmt:formatNumber value="${stats.myTotalFines}" pattern="0.00"/></div>
                                </div>
                            </article>

                            <article class="metric-card tone-brand">
                                <span class="metric-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M4 19h16"/>
                                        <path d="M8 15V9"/>
                                        <path d="M12 15V6"/>
                                        <path d="M16 15v-3"/>
                                    </svg>
                                </span>
                                <div class="metric-content">
                                    <div class="metric-label">Available instruments</div>
                                    <div class="metric-value">${stats.availableInstruments}</div>
                                </div>
                            </article>

                            <article class="metric-card">
                                <span class="metric-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="M4 7h16"/>
                                        <path d="M7 4v16"/>
                                        <path d="M17 4v16"/>
                                    </svg>
                                </span>
                                <div class="metric-content">
                                    <div class="metric-label">Categories</div>
                                    <div class="metric-value">${stats.totalCategories}</div>
                                </div>
                            </article>
                        </div>
                    </section>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <p>MIRS member workspace</p>
            <p>Rental access and profile overview</p>
        </div>
    </footer>
</body>
</html>
