<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Contact Us</title>
    <meta name="description" content="Contact the MIRS support team.">
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
            <a href="${pageContext.request.contextPath}/about">About</a>
            <a href="${pageContext.request.contextPath}/contact" class="active">Contact</a>
        </nav>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign in</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <div class="page-header" style="text-align:center; max-width:680px; margin:0 auto 40px;">
            <div class="eyebrow">Contact Us</div>
            <h1>How can we help?</h1>
            <p class="subtitle">Send a question about rentals, accounts, instrument availability, returns, or support. We will get back to you as soon as possible.</p>
        </div>

        <div class="contact-layout">
            <aside class="contact-details-side">
                <div class="dashboard-panel">
                    <h2 class="panel-title">Support Details</h2>
                    <p class="panel-subtitle" style="margin-bottom:24px;">Use the form for general questions or reach us directly during support hours.</p>

                    <div class="contact-detail-item">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M4 4h16v16H4z"/><path d="m4 7 8 6 8-6"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Email</strong>
                            <p>support@mirs.edu</p>
                        </div>
                    </div>

                    <div class="contact-detail-item">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.8 19.8 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.12 4.18 2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.12.9.32 1.78.59 2.63a2 2 0 0 1-.45 2.11L8 9.71a16 16 0 0 0 6.29 6.29l1.25-1.25a2 2 0 0 1 2.11-.45c.85.27 1.73.47 2.63.59A2 2 0 0 1 22 16.92z"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Phone</strong>
                            <p>+1 (555) 012-3456</p>
                        </div>
                    </div>

                    <div class="contact-detail-item">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M12 21s7-5.1 7-11a7 7 0 1 0-14 0c0 5.9 7 11 7 11z"/><circle cx="12" cy="10" r="2.5"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Address</strong>
                            <p>Kathmandu, Nepal</p>
                        </div>
                    </div>

                    <div class="contact-detail-item">
                        <span class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Support Hours</strong>
                            <p>Monday to Friday<br>8:00 AM to 5:00 PM</p>
                        </div>
                    </div>
                </div>
            </aside>

            <section class="contact-form-side">
                <div class="dashboard-panel">
                    <h2 class="panel-title">Send a Message</h2>
                    <p class="panel-subtitle" style="margin-bottom:24px;">All fields marked with an asterisk are required.</p>

                    <% if (request.getAttribute("successMsg") != null) { %>
                        <div class="alert alert-success">
                            <div class="alert-copy">
                                <strong>Message sent</strong>
                                <span><%= request.getAttribute("successMsg") %></span>
                            </div>
                        </div>
                    <% } %>

                    <% if (request.getAttribute("errorMsg") != null) { %>
                        <div class="alert alert-danger">
                            <div class="alert-copy">
                                <strong>Please check the form</strong>
                                <span><%= request.getAttribute("errorMsg") %></span>
                            </div>
                        </div>
                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/contact">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="fullName">Full Name <span class="required">*</span></label>
                                <input type="text" id="fullName" name="fullName" required placeholder="Your full name">
                            </div>
                            <div class="form-group">
                                <label for="email">Email Address <span class="required">*</span></label>
                                <input type="email" id="email" name="email" required placeholder="name@example.com">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="subject">Subject <span class="required">*</span></label>
                            <input type="text" id="subject" name="subject" required placeholder="Instrument availability, account help, rental question...">
                        </div>
                        <div class="form-group">
                            <label for="message">Message <span class="required">*</span></label>
                            <textarea id="message" name="message" rows="7" required placeholder="Write your message here"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width:100%; min-height:50px;">Send Message</button>
                    </form>
                </div>
            </section>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="footer-content">
        <p>MIRS - Musical Instruments Rental System</p>
        <p><a href="${pageContext.request.contextPath}/about">About</a></p>
    </div>
</footer>
</body>
</html>
