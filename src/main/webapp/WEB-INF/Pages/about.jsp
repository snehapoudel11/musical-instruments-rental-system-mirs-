<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - About Us</title>
    <meta name="description" content="About the Musical Instruments Rental System.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>
<header class="navbar">
    <div class="container nav-inner">
        <a href="${pageContext.request.contextPath}/landing/" class="logo">
            <span class="logo-mark">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9">
                    <path d="M12 3v18"/>
                    <path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/>
                    <path d="M8.5 5.5h7"/>
                </svg>
            </span>
            <span>MIRS</span>
        </a>

        <nav class="nav-links" aria-label="Primary navigation">
            <a href="${pageContext.request.contextPath}/instruments">Instruments</a>
            <a href="${pageContext.request.contextPath}/about" class="active">About</a>
            <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </nav>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign in</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
        </div>
    </div>
</header>

<main class="main-content">
    <section class="about-hero">
        <div class="container">
            <div class="eyebrow">About MIRS</div>
            <h1 class="hero-heading">Making instrument rental simple for students and music programs.</h1>
            <p class="hero-copy">
                MIRS, the Musical Instruments Rental System, helps users find instruments they can rent and gives staff a clear way to manage availability, rental records, returns, and fines.
            </p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/instruments" class="btn btn-primary">Browse Instruments</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-secondary">Contact Us</a>
            </div>
        </div>
    </section>

    <section class="about-section">
        <div class="container">
            <div class="about-two-col">
                <div>
                    <div class="eyebrow">What We Do</div>
                    <h2 class="panel-title" style="font-size:clamp(1.8rem,3vw,2.5rem);">A better way to rent musical instruments.</h2>
                    <p class="section-intro">
                        Instead of asking students to visit the office just to check availability, MIRS lets them browse instruments, understand rental details, and request what they need from one place.
                    </p>
                    <p class="section-intro" style="margin-top:16px;">
                        Administrators can keep instrument records organized, monitor active rentals, and support members with accurate information.
                    </p>
                </div>
                <div class="about-features-side">
                    <div class="about-feature-card">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M4 7h16"/><path d="M7 4v16"/><path d="M17 4v16"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Instrument catalog</strong>
                            <p>Users can explore instruments by type, condition, availability, and daily rental price.</p>
                        </div>
                    </div>
                    <div class="about-feature-card">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <rect x="4" y="5" width="16" height="15" rx="3"/><path d="M8 3v4M16 3v4M4 10h16"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Rental tracking</strong>
                            <p>Members and staff can follow rental dates, returns, and overdue status more clearly.</p>
                        </div>
                    </div>
                    <div class="about-feature-card">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M16 21v-2a4 4 0 0 0-8 0v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Member workspace</strong>
                            <p>Each member gets a personal area for account details, bookings, and rental history.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="about-section about-section-tinted">
        <div class="container">
            <div class="about-two-col" style="align-items:center;">
                <div class="dashboard-panel">
                    <h2 class="panel-title">Who it is for</h2>
                    <p class="panel-subtitle">MIRS is designed for music schools, academies, and rental desks that need a clean system for sharing instruments with learners and performers.</p>
                </div>
                <div class="dashboard-panel">
                    <h2 class="panel-title">Our goal</h2>
                    <p class="panel-subtitle">Help users spend less time worrying about availability and more time practicing, learning, and performing.</p>
                </div>
            </div>
        </div>
    </section>
</main>

<footer class="footer">
    <div class="footer-content">
        <p>MIRS - Musical Instruments Rental System</p>
        <p><a href="${pageContext.request.contextPath}/contact">Contact Us</a></p>
    </div>
</footer>
</body>
</html>
