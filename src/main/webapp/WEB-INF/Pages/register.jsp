<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Create Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <main class="auth-shell">
        <section class="auth-layout">
            <aside class="glass-card auth-aside">
                <div class="eyebrow">Create Account</div>
                <h1>Join the rental workspace.</h1>

                <div class="feature-list">
                    <div class="feature-item">
                        <span class="feature-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <rect x="4" y="5" width="16" height="14" rx="3"/>
                                <path d="M8 10h8M8 14h5"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Simple onboarding</strong>
                        </div>
                    </div>
                    <div class="feature-item">
                        <span class="feature-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M6 12h12"/>
                                <path d="M12 6v12"/>
                                <circle cx="12" cy="12" r="9"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Member-first flow</strong>
                        </div>
                    </div>
                    <div class="feature-item">
                        <span class="feature-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M12 4 5 7v5c0 4.2 2.8 8 7 9 4.2-1 7-4.8 7-9V7l-7-3Z"/>
                                <path d="m9.5 12 1.7 1.7 3.6-3.9"/>
                            </svg>
                        </span>
                        <div>
                            <strong>Reliable account data</strong>
                        </div>
                    </div>
                </div>
            </aside>

            <section class="auth-card">
                <div class="eyebrow">MIRS</div>
                <h2>Create account</h2>
                <p class="subtitle">Set up your member profile to access rentals, bookings, and account history.</p>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <span class="status-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <circle cx="12" cy="12" r="9"/>
                                <path d="M12 8v5"/>
                                <path d="M12 16h.01"/>
                            </svg>
                        </span>
                        <div class="alert-copy">
                            <strong>Registration issue</strong>
                            <span>${errorMessage}</span>
                        </div>
                    </div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/register" id="registerForm">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="firstName">First name <span class="required">*</span></label>
                            <input type="text" id="firstName" name="firstName" placeholder="First name" value="${firstName}" required>
                            <span class="error-message" id="firstNameError"></span>
                        </div>

                        <div class="form-group">
                            <label for="lastName">Last name <span class="required">*</span></label>
                            <input type="text" id="lastName" name="lastName" placeholder="Last name" value="${lastName}" required>
                            <span class="error-message" id="lastNameError"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="username">Username <span class="required">*</span></label>
                        <input type="text" id="username" name="username" placeholder="Choose a unique username" value="${username}" required minlength="3" maxlength="20">
                        <span class="error-message" id="usernameError"></span>
                        <span class="helper-text">Use 3-20 characters with letters, numbers, underscore, or hyphen.</span>
                    </div>

                    <div class="form-group">
                        <label for="email">Email address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" placeholder="your.email@example.com" value="${email}" required>
                        <span class="error-message" id="emailError"></span>
                    </div>

                    <div class="form-group">
                        <label for="phoneNumber">Phone number <span class="field-note">Optional</span></label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" placeholder="(123) 456-7890" value="${phoneNumber}">
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="password">Password <span class="required">*</span></label>
                            <input type="password" id="password" name="password" placeholder="Create a password" required minlength="6">
                            <span class="error-message" id="passwordError"></span>
                            <span class="helper-text">Minimum 6 characters.</span>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm password <span class="required">*</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter your password" required minlength="6">
                            <span class="error-message" id="confirmPasswordError"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Create account</button>
                    </div>
                </form>

                <div class="form-divider"></div>

                <div class="form-footer">
                    <p>Already registered?</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-link">Return to sign in</a>
                </div>
            </section>
        </section>
    </main>

    <script>
        const form = document.getElementById('registerForm');
        const firstNameInput = document.getElementById('firstName');
        const lastNameInput = document.getElementById('lastName');
        const usernameInput = document.getElementById('username');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function isValidUsername(username) {
            const usernameRegex = /^[a-zA-Z0-9_-]+$/;
            return usernameRegex.test(username);
        }

        function clearFieldError(id) {
            document.getElementById(id).textContent = '';
            document.getElementById(id).classList.remove('show');
        }

        firstNameInput.addEventListener('focus', function() { clearFieldError('firstNameError'); });
        lastNameInput.addEventListener('focus', function() { clearFieldError('lastNameError'); });
        usernameInput.addEventListener('focus', function() { clearFieldError('usernameError'); });
        emailInput.addEventListener('focus', function() { clearFieldError('emailError'); });
        passwordInput.addEventListener('focus', function() { clearFieldError('passwordError'); });
        confirmPasswordInput.addEventListener('focus', function() { clearFieldError('confirmPasswordError'); });

        form.addEventListener('submit', function(event) {
            const firstName = firstNameInput.value.trim();
            const lastName = lastNameInput.value.trim();
            const username = usernameInput.value.trim();
            const email = emailInput.value.trim();
            const password = passwordInput.value.trim();
            const confirmPassword = confirmPasswordInput.value.trim();

            let isValid = true;

            document.querySelectorAll('.error-message').forEach(el => {
                el.textContent = '';
                el.classList.remove('show');
            });

            if (firstName === '') {
                document.getElementById('firstNameError').textContent = 'First name is required';
                document.getElementById('firstNameError').classList.add('show');
                isValid = false;
            }

            if (lastName === '') {
                document.getElementById('lastNameError').textContent = 'Last name is required';
                document.getElementById('lastNameError').classList.add('show');
                isValid = false;
            }

            if (username === '') {
                document.getElementById('usernameError').textContent = 'Username is required';
                document.getElementById('usernameError').classList.add('show');
                isValid = false;
            } else if (username.length < 3 || username.length > 20) {
                document.getElementById('usernameError').textContent = 'Username must be 3-20 characters';
                document.getElementById('usernameError').classList.add('show');
                isValid = false;
            } else if (!isValidUsername(username)) {
                document.getElementById('usernameError').textContent = 'Use only letters, numbers, underscore, and hyphen';
                document.getElementById('usernameError').classList.add('show');
                isValid = false;
            }

            if (email === '') {
                document.getElementById('emailError').textContent = 'Email is required';
                document.getElementById('emailError').classList.add('show');
                isValid = false;
            } else if (!isValidEmail(email)) {
                document.getElementById('emailError').textContent = 'Please enter a valid email address';
                document.getElementById('emailError').classList.add('show');
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

            if (confirmPassword === '') {
                document.getElementById('confirmPasswordError').textContent = 'Please confirm your password';
                document.getElementById('confirmPasswordError').classList.add('show');
                isValid = false;
            } else if (password !== confirmPassword) {
                document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
                document.getElementById('confirmPasswordError').classList.add('show');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
