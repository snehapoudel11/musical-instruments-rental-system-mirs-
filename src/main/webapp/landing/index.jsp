<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Musical Instruments Rental System</title>
    <style>
        :root {
            --dark-teal: #0d2b24;
            --deep-teal: #09221d;
            --mid-teal: #1D9E75;
            --amber: #E6A44A;
            --paper: #f7fbf8;
            --muted: #d8ebe4;
            --ink: #10231f;
            --soft: #eff7f3;
            --line: rgba(13, 43, 36, 0.12);
            --shadow: 0 24px 60px rgba(13, 43, 36, 0.15);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--ink);
            background: var(--paper);
            line-height: 1.6;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .container {
            width: min(1160px, calc(100% - 40px));
            margin: 0 auto;
        }

        .navbar {
            position: sticky;
            top: 0;
            z-index: 50;
            background: var(--dark-teal);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .nav-inner {
            min-height: 74px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .logo {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: #fff;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .logo-mark {
            width: 42px;
            height: 42px;
            display: inline-grid;
            place-items: center;
            border-radius: 8px;
            background: var(--mid-teal);
            color: #fff;
        }

        .logo-mark svg,
        .icon svg {
            width: 22px;
            height: 22px;
        }

        .nav-links,
        .nav-actions {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.78);
            font-weight: 600;
            font-size: 0.95rem;
        }

        .nav-links a:hover {
            color: #fff;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 44px;
            padding: 0 20px;
            border-radius: 999px;
            font-weight: 700;
            border: 1px solid transparent;
            transition: transform 180ms ease, background-color 180ms ease, color 180ms ease, border-color 180ms ease;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .btn-primary {
            background: var(--amber);
            color: var(--dark-teal);
        }

        .btn-secondary {
            background: var(--mid-teal);
            color: #fff;
        }

        .btn-outline {
            color: #fff;
            border-color: rgba(255, 255, 255, 0.28);
            background: transparent;
        }

        .hero {
            color: #fff;
            background: linear-gradient(135deg, #0d2b24 0%, #09221d 54%, #0f4f3f 100%);
            padding: 92px 0 72px;
        }

        .hero-grid {
            max-width: 860px;
        }

        .eyebrow {
            color: var(--amber);
            font-size: 0.78rem;
            font-weight: 800;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            margin-bottom: 16px;
        }

        .hero h1 {
            max-width: 780px;
            font-size: 5rem;
            line-height: 0.96;
            letter-spacing: 0;
            margin-bottom: 22px;
        }

        .hero-copy {
            max-width: 680px;
            color: rgba(255, 255, 255, 0.82);
            font-size: 1.18rem;
            margin-bottom: 30px;
        }

        .hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            margin-bottom: 42px;
        }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            max-width: 700px;
        }

        .hero-stat {
            padding: 18px;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.07);
        }

        .hero-stat strong {
            display: block;
            font-size: 2rem;
            line-height: 1;
            color: var(--amber);
        }

        .hero-stat span {
            color: rgba(255, 255, 255, 0.78);
            font-size: 0.94rem;
        }

        .stats-bar {
            background: #fff;
            box-shadow: var(--shadow);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 1px;
        }

        .system-fact {
            padding: 28px 24px;
            border-right: 1px solid var(--line);
        }

        .system-fact:last-child {
            border-right: none;
        }

        .system-fact strong {
            display: block;
            font-size: 1.65rem;
            color: var(--dark-teal);
            margin-bottom: 4px;
        }

        .system-fact span {
            color: #54736a;
            font-weight: 600;
        }

        .section {
            padding: 82px 0;
        }

        .section-heading {
            max-width: 760px;
            margin-bottom: 34px;
        }

        .section-heading h2 {
            color: var(--dark-teal);
            font-size: 3rem;
            line-height: 1.05;
            letter-spacing: 0;
            margin-bottom: 12px;
        }

        .section-heading p {
            color: #58726b;
            font-size: 1.05rem;
        }

        .cards-3,
        .instrument-grid,
        .feature-grid {
            display: grid;
            gap: 22px;
        }

        .cards-3 {
            grid-template-columns: repeat(3, minmax(0, 1fr));
            margin-bottom: 42px;
        }

        .work-card,
        .instrument-card,
        .feature-panel {
            border: 1px solid var(--line);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 18px 50px rgba(13, 43, 36, 0.08);
        }

        .work-card {
            padding: 28px;
        }

        .icon {
            width: 52px;
            height: 52px;
            display: grid;
            place-items: center;
            border-radius: 8px;
            background: rgba(29, 158, 117, 0.12);
            color: var(--mid-teal);
            margin-bottom: 22px;
        }

        .work-card h3,
        .instrument-card h3,
        .feature-panel h3 {
            color: var(--dark-teal);
            font-size: 1.3rem;
            margin-bottom: 8px;
        }

        .work-card p,
        .instrument-card p,
        .feature-panel li {
            color: #58726b;
        }

        .instruments {
            background: var(--soft);
        }

        .instrument-grid {
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .instrument-card {
            overflow: hidden;
        }

        .instrument-top {
            min-height: 150px;
            display: grid;
            place-items: center;
            background:
                linear-gradient(150deg, rgba(13, 43, 36, 0.9), rgba(29, 158, 117, 0.78)),
                linear-gradient(45deg, rgba(230, 164, 74, 0.32), transparent);
            color: #fff;
        }

        .instrument-top svg {
            width: 76px;
            height: 76px;
        }

        .instrument-body {
            padding: 22px;
        }

        .instrument-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            justify-content: space-between;
            margin-top: 18px;
        }

        .price {
            color: var(--dark-teal);
            font-weight: 800;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            min-height: 30px;
            padding: 0 12px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 800;
            text-transform: capitalize;
        }

        .badge.available {
            color: #0d6b4f;
            background: rgba(29, 158, 117, 0.16);
        }

        .badge.unavailable {
            color: #935f12;
            background: rgba(230, 164, 74, 0.18);
        }

        .badge.discontinued {
            color: #8f3434;
            background: rgba(143, 52, 52, 0.12);
        }

        .empty-state {
            grid-column: 1 / -1;
            padding: 32px;
            border: 1px dashed rgba(13, 43, 36, 0.24);
            border-radius: 8px;
            background: #fff;
            color: #58726b;
        }

        .feature-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .feature-panel {
            padding: 34px;
        }

        .feature-panel.member {
            border-top: 6px solid var(--mid-teal);
        }

        .feature-panel.admin {
            border-top: 6px solid var(--amber);
        }

        .feature-panel ul {
            display: grid;
            gap: 14px;
            list-style: none;
            margin-top: 22px;
        }

        .feature-panel li {
            display: flex;
            gap: 12px;
        }

        .feature-panel li::before {
            content: "";
            width: 9px;
            height: 9px;
            border-radius: 50%;
            margin-top: 8px;
            background: var(--mid-teal);
            flex: 0 0 auto;
        }

        .feature-panel.admin li::before {
            background: var(--amber);
        }

        .quote-band {
            background: var(--mid-teal);
            color: #fff;
            padding: 70px 0;
        }

        .quote-box {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 28px;
            align-items: center;
        }

        .quote-box blockquote {
            font-size: 2.4rem;
            line-height: 1.18;
            font-weight: 800;
            letter-spacing: 0;
        }

        .quote-box p {
            color: rgba(255, 255, 255, 0.82);
            font-weight: 700;
            margin-top: 16px;
        }

        .quote-mark {
            width: 120px;
            height: 120px;
            display: grid;
            place-items: center;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.15);
            font-size: 5rem;
            font-family: Georgia, serif;
            line-height: 1;
        }

        .footer {
            background: var(--dark-teal);
            color: rgba(255, 255, 255, 0.76);
            padding: 42px 0;
        }

        .footer-grid {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .footer strong {
            display: block;
            color: #fff;
            margin-bottom: 4px;
        }

        .footer-links {
            display: flex;
            gap: 18px;
        }

        .footer-links a {
            color: #fff;
            font-weight: 700;
        }

        @media (max-width: 980px) {
            .nav-inner,
            .quote-box {
                grid-template-columns: 1fr;
            }

            .nav-inner {
                padding: 16px 0;
                align-items: flex-start;
                flex-direction: column;
            }

            .nav-links,
            .nav-actions {
                flex-wrap: wrap;
            }

            .hero h1 {
                font-size: 3.8rem;
            }

            .section-heading h2 {
                font-size: 2.5rem;
            }

            .quote-box blockquote {
                font-size: 2rem;
            }

            .stats-grid,
            .instrument-grid,
            .cards-3,
            .feature-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .container {
                width: min(100% - 28px, 1160px);
            }

            .hero {
                padding: 60px 0;
            }

            .hero h1 {
                font-size: 2.75rem;
            }

            .hero-copy {
                font-size: 1.05rem;
            }

            .section-heading h2 {
                font-size: 2rem;
            }

            .quote-box blockquote {
                font-size: 1.55rem;
            }

            .section {
                padding: 58px 0;
            }

            .hero-stats,
            .stats-grid,
            .instrument-grid,
            .cards-3,
            .feature-grid {
                grid-template-columns: 1fr;
            }

            .nav-actions,
            .hero-actions,
            .footer-grid {
                align-items: stretch;
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .system-fact {
                border-right: none;
                border-bottom: 1px solid var(--line);
            }

            .system-fact:last-child {
                border-bottom: none;
            }

            .quote-mark {
                width: 90px;
                height: 90px;
                font-size: 4rem;
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
                <a href="${pageContext.request.contextPath}/instruments">Instruments</a>
                <a href="${pageContext.request.contextPath}/about">About</a>
                <a href="${pageContext.request.contextPath}/contact">Contact</a>
            </nav>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign in</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
            </div>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="container hero-grid">
                <div>
                    <div class="eyebrow">Musical Instruments Rental System</div>
                    <h1>Rent the instrument of your choice with ease.</h1>
                    <p class="hero-copy">Browse available instruments, create an account, and request the right instrument for your practice, class, or performance.</p>

                    <div class="hero-actions">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Sign in</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Create account</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="section" id="how">
            <div class="container">
                <div class="section-heading">
                    <div class="eyebrow">Start renting</div>
                    <h2>Choose, request, and play.</h2>
                    <p>MIRS gives members a simple path to find an instrument and request it for practice, lessons, or performances.</p>
                </div>

                <div class="cards-3">
                    <article class="work-card">
                        <span class="icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9">
                                <path d="M4 7h16"/>
                                <path d="M7 4v16"/>
                                <path d="M17 4v16"/>
                            </svg>
                        </span>
                        <h3>Browse inventory</h3>
                        <p>Explore the instruments page to compare categories, rates, and rental options.</p>
                    </article>

                    <article class="work-card">
                        <span class="icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9">
                                <rect x="4" y="5" width="16" height="15" rx="3"/>
                                <path d="M8 3v4M16 3v4M4 10h16"/>
                            </svg>
                        </span>
                        <h3>Create an account</h3>
                        <p>Register as a member so your rental requests and returns stay connected to your profile.</p>
                    </article>

                    <article class="work-card">
                        <span class="icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9">
                                <path d="M12 1v22"/>
                                <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                            </svg>
                        </span>
                        <h3>Request your instrument</h3>
                        <p>Sign in, pick the instrument you need, and follow your rental from your member workspace.</p>
                    </article>
                </div>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/instruments" class="btn btn-secondary">View instruments</a>
                    <a href="${pageContext.request.contextPath}/about" class="btn btn-primary">About MIRS</a>
                </div>
            </div>
        </section>

        <section class="quote-band">
            <div class="container quote-box">
                <div>
                    <blockquote>"MIRS turns instrument rentals from scattered records into a clear, reliable workflow."</blockquote>
                    <p>Designed for music programs that need calm, accurate rental management.</p>
                </div>
                <div class="quote-mark" aria-hidden="true">"</div>
            </div>
        </section>
    </main>

    <footer class="footer" id="footer">
        <div class="container footer-grid">
            <div>
                <strong>MIRS</strong>
                <span>Musical Instruments Rental System</span>
            </div>
            <nav class="footer-links" aria-label="Footer navigation">
                <a href="${pageContext.request.contextPath}/instruments">Instruments</a>
                <a href="${pageContext.request.contextPath}/about">About</a>
                <a href="${pageContext.request.contextPath}/contact">Contact</a>
                <a href="${pageContext.request.contextPath}/login">Sign in</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </nav>
        </div>
    </footer>
</body>
</html>
