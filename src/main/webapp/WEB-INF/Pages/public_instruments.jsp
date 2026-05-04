<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Instruments</title>
    <meta name="description" content="Browse instrument rental options in MIRS.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
    <style>
        .public-instrument-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .public-instrument-card {
            overflow: hidden;
        }

        .instrument-art {
            min-height: 150px;
            display: grid;
            place-items: center;
            background: linear-gradient(145deg, rgba(31, 93, 87, 0.92), rgba(59, 139, 130, 0.76));
            color: #fff;
        }

        .instrument-art svg {
            width: 72px;
            height: 72px;
        }

        .instrument-copy {
            padding: 22px;
        }

        .instrument-meta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
            align-items: center;
            margin-top: 16px;
        }

        @media (max-width: 960px) {
            .public-instrument-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .public-instrument-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
            <a href="${pageContext.request.contextPath}/instruments" class="active">Instruments</a>
            <a href="${pageContext.request.contextPath}/about">About</a>
            <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </nav>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign in</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
        </div>
    </div>
</header>

<main class="main-content">
    <section class="public-hero">
        <div class="container">
            <div class="eyebrow">Instrument Rentals</div>
            <h1 class="hero-heading">Find an instrument that fits your music.</h1>
            <p class="subtitle">Browse common rental options below. Members can sign in to check live availability, request an instrument, and track rental status.</p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Create Account</a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Sign In to Rent</a>
            </div>
        </div>
    </section>

    <section class="public-section">
        <div class="container">
        <section class="public-instrument-grid" aria-label="Instrument list">
            <article class="dashboard-panel public-instrument-card">
                <div class="instrument-art">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7">
                        <path d="M12 3v18"/><path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/><path d="M8.5 5.5h7"/>
                    </svg>
                </div>
                <div class="instrument-copy">
                    <h2 class="panel-title">Acoustic Guitar</h2>
                    <p class="panel-subtitle">A flexible choice for beginners, practice sessions, and small performances.</p>
                    <div class="instrument-meta-row">

                        <strong>Rs. 8.00/day</strong>
                    </div>
                </div>
            </article>

            <article class="dashboard-panel public-instrument-card">
                <div class="instrument-art">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7">
                        <rect x="5" y="4" width="14" height="16" rx="2"/><path d="M8 8h8M8 12h8M8 16h8"/>
                    </svg>
                </div>
                <div class="instrument-copy">
                    <h2 class="panel-title">Digital Piano</h2>
                    <p class="panel-subtitle">Useful for lessons, recitals, and structured keyboard practice.</p>
                    <div class="instrument-meta-row">

                        <strong>Rs. 15.00/day</strong>
                    </div>
                </div>
            </article>

            <article class="dashboard-panel public-instrument-card">
                <div class="instrument-art">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7">
                        <path d="M7 4h10"/><path d="M9 4v10a3 3 0 1 0 6 0V4"/><path d="M6 20h12"/>
                    </svg>
                </div>
                <div class="instrument-copy">
                    <h2 class="panel-title">Student Violin</h2>
                    <p class="panel-subtitle">Sized for learners and maintained for classroom use.</p>
                    <div class="instrument-meta-row">

                        <strong>Rs. 6.00/day</strong>
                    </div>
                </div>
            </article>

            <article class="dashboard-panel public-instrument-card">
                <div class="instrument-art">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7">
                        <path d="M4 10h10"/><path d="M14 7v6"/><path d="M14 10l6-4v8z"/><path d="M7 10v8"/>
                    </svg>
                </div>
                <div class="instrument-copy">
                    <h2 class="panel-title">Trumpet</h2>
                    <p class="panel-subtitle">A bright brass option for band practice and performances.</p>
                    <div class="instrument-meta-row">

                        <strong>Rs. 10.00/day</strong>
                    </div>
                </div>
            </article>

            <article class="dashboard-panel public-instrument-card">
                <div class="instrument-art">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7">
                        <circle cx="12" cy="12" r="7"/><circle cx="12" cy="12" r="3"/><path d="M12 5v14M5 12h14"/>
                    </svg>
                </div>
                <div class="instrument-copy">
                    <h2 class="panel-title">Drum Kit</h2>
                    <p class="panel-subtitle">Good for rhythm practice, ensemble work, and studio sessions.</p>
                    <div class="instrument-meta-row">

                        <strong>Rs. 18.00/day</strong>
                    </div>
                </div>
            </article>

            <article class="dashboard-panel public-instrument-card">
                <div class="instrument-art">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7">
                        <path d="M5 17c4-7 10-7 14 0"/><path d="M7 17v3M17 17v3"/><path d="M9 10h6"/><path d="M10 7h4"/>
                    </svg>
                </div>
                <div class="instrument-copy">
                    <h2 class="panel-title">Clarinet</h2>
                    <p class="panel-subtitle">A dependable woodwind choice for students and ensemble players.</p>
                    <div class="instrument-meta-row">

                        <strong>Rs. 7.00/day</strong>
                    </div>
                </div>
            </article>
        </section>
        </div>
    </section>
</main>

<footer class="footer">
    <div class="footer-content">
        <p>MIRS - Musical Instruments Rental System</p>
        <p><a href="${pageContext.request.contextPath}/contact">Ask about rentals</a></p>
    </div>
</footer>
</body>
</html>
