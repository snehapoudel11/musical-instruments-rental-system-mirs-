<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Sign In</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <main class="auth-shell">
        <section class="auth-layout">
            <aside class="glass-card auth-aside">
                <div class="eyebrow">Member Access</div>
                <h1>Instrument management, simplified.</h1>

                <div class="feature-list">
                    <div class="feature-item">
                        <span class="feature-icon">
                            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M12 3v18"/>
                                <path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/>
                                <path d="M8.5 5.5h7"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Live rental overview</strong>
                        </div>
                    </div>
                    <div class="feature-item">
                        <span class="feature-icon">
                            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <rect x="4" y="5" width="16" height="14" rx="3"/>
                                <path d="M8 10h8M8 14h5"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Clear account actions</strong>
                        </div>
                    </div>
                    <div class="feature-item">
                        <span class="feature-icon">
                            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M12 4 5 7v5c0 4.2 2.8 8 7 9 4.2-1 7-4.8 7-9V7l-7-3Z"/>
                                <path d="m9.5 12 1.7 1.7 3.6-3.9"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Consistent and secure</strong>
                        </div>
                    </div>
                </div>
            </aside>

            <section class="auth-card">
                <div class="eyebrow">MIRS</div>
                <h2>Sign in</h2>

                <c:if test="${param.logout == 'success'}">
                    <div class="alert alert-success">
                        <span class="status-icon">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="m5 12 4 4L19 6"/>
                            </svg>
                        </span>
                        <div class="alert-copy">
                            <strong>Signed out</strong>
                            <span>You have been logged out successfully.</span>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <span class="status-icon">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="m5 12 4 4L19 6"/>
                            </svg>
                        </span>
                        <div class="alert-copy">
                            <strong>Account ready</strong>
                            <span>${successMessage}</span>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <span class="status-icon">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8">
                                <circle cx="12" cy="12" r="9"/>
                                <path d="M12 8v5"/>
                                <path d="M12 16h.01"/>
                            </svg>
                        </span>
                        <div class="alert-copy">
                            <strong>Unable to sign in</strong>
                            <span>${errorMessage}</span>
                        </div>
                    </div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/login" id="loginForm">
                    <div class="form-group">
                        <label for="username">Username <span class="required">*</span></label>
                        <input type="text"
                               id="username"
                               name="username"
                               placeholder="Enter your username"
                               required
                               autofocus
                               autocomplete="username">
                        <span class="error-message" id="usernameError"></span>
                    </div>

                    <div class="form-group">
                        <label for="password">Password <span class="required">*</span></label>
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter your password"
                               required
                               autocomplete="current-password">
                        <span class="error-message" id="passwordError"></span>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Sign in</button>
                    </div>
                </form>

                <div class="form-divider"></div>

                <div class="form-footer">
                    <p>New to MIRS?</p>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-link">Create an account</a>
                </div>

            </section>
        </section>
    </main>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(event) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            let isValid = true;

            document.getElementById('usernameError').textContent = '';
            document.getElementById('usernameError').classList.remove('show');
            document.getElementById('passwordError').textContent = '';
            document.getElementById('passwordError').classList.remove('show');

            if (username === '') {
                document.getElementById('usernameError').textContent = 'Username is required';
                document.getElementById('usernameError').classList.add('show');
                isValid = false;
            } else if (username.length < 3) {
                document.getElementById('usernameError').textContent = 'Username must be at least 3 characters';
                document.getElementById('usernameError').classList.add('show');
                isValid = false;
            }

            if (password === '') {
                document.getElementById('passwordError').textContent = 'Password is required';
                document.getElementById('passwordError').classList.add('show');
                isValid = false;
            } else if (password.length < 6) {
                document.getElementById('passwordError').textContent = 'Password must be at least 6 characters';
                document.getElementById('passwordError').classList.add('show');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
