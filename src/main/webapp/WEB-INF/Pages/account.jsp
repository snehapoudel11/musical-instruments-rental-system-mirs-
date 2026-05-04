<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
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
                    <h1 class="hero-heading">Account information</h1>
                    <p class="hero-copy">View and update the profile details connected to your member account.</p>
                </div>
            </section>

            <div class="dashboard-grid">
                <div class="dashboard-main">
                    <section class="dashboard-panel">
                        <div class="panel-header">
                            <div>
                                <h2 class="panel-title">Edit profile</h2>
                                <p class="panel-subtitle">Keep your contact and address details current.</p>
                            </div>
                        </div>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">
                                <span class="status-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="m5 12 4 4L19 6"/>
                                    </svg>
                                </span>
                                <div class="alert-copy">
                                    <strong>Saved</strong>
                                    <span>${successMessage}</span>
                                </div>
                            </div>
                        </c:if>

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
                                    <strong>Update issue</strong>
                                    <span>${errorMessage}</span>
                                </div>
                            </div>
                        </c:if>

                        <form method="POST" action="${pageContext.request.contextPath}/member/account" id="accountForm">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="form-group">
                                <label for="username">Username <span class="required">*</span></label>
                                <input type="text" id="username" name="username" value="${user.username}" required minlength="3" maxlength="20">
                                <span class="error-message" id="usernameError"></span>
                                <span class="helper-text">Use 3-20 characters with letters, numbers, underscore, or hyphen.</span>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="firstName">First name <span class="required">*</span></label>
                                    <input type="text" id="firstName" name="firstName" value="${user.firstName}" required>
                                    <span class="error-message" id="firstNameError"></span>
                                </div>

                                <div class="form-group">
                                    <label for="lastName">Last name <span class="required">*</span></label>
                                    <input type="text" id="lastName" name="lastName" value="${user.lastName}" required>
                                    <span class="error-message" id="lastNameError"></span>
                                </div>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="email">Email address <span class="required">*</span></label>
                                    <input type="email" id="email" name="email" value="${user.email}" required>
                                    <span class="error-message" id="emailError"></span>
                                </div>

                                <div class="form-group">
                                    <label for="phoneNumber">Phone number <span class="field-note">Optional</span></label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="address">Address <span class="field-note">Optional</span></label>
                                <textarea id="address" name="address" rows="3"><c:out value="${user.address}"/></textarea>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="city">City <span class="field-note">Optional</span></label>
                                    <input type="text" id="city" name="city" value="${user.city}">
                                </div>

                                <div class="form-group">
                                    <label for="state">State <span class="field-note">Optional</span></label>
                                    <input type="text" id="state" name="state" value="${user.state}">
                                </div>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="zipCode">Zip code <span class="field-note">Optional</span></label>
                                    <input type="text" id="zipCode" name="zipCode" value="${user.zipCode}">
                                </div>
                            </div>

                            <div class="action-row">
                                <button type="submit" class="btn btn-primary">Save changes</button>
                                <a href="${pageContext.request.contextPath}/member/dashboard" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </section>
                </div>

                <aside class="dashboard-side">
                    <section class="dashboard-panel">
                        <div class="panel-header">
                            <div>
                                <h2 class="panel-title">Security</h2>
                                <p class="panel-subtitle">Update your account password.</p>
                            </div>
                        </div>

                        <c:if test="${not empty passwordSuccessMessage}">
                            <div class="alert alert-success">
                                <span class="status-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <path d="m5 12 4 4L19 6"/>
                                    </svg>
                                </span>
                                <div class="alert-copy">
                                    <strong>Updated</strong>
                                    <span>${passwordSuccessMessage}</span>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty passwordErrorMessage}">
                            <div class="alert alert-danger">
                                <span class="status-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                        <circle cx="12" cy="12" r="9"/>
                                        <path d="M12 8v5"/>
                                        <path d="M12 16h.01"/>
                                    </svg>
                                </span>
                                <div class="alert-copy">
                                    <strong>Issue</strong>
                                    <span>${passwordErrorMessage}</span>
                                </div>
                            </div>
                        </c:if>

                        <form method="POST" action="${pageContext.request.contextPath}/member/account" id="passwordForm">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="form-group">
                                <label for="currentPassword">Current password <span class="required">*</span></label>
                                <input type="password" id="currentPassword" name="currentPassword" required>
                                <span class="error-message" id="currentPasswordError"></span>
                            </div>

                            <div class="form-group">
                                <label for="newPassword">New password <span class="required">*</span></label>
                                <input type="password" id="newPassword" name="newPassword" required minlength="6">
                                <span class="error-message" id="newPasswordError"></span>
                                <span class="helper-text">At least 6 characters.</span>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Confirm new password <span class="required">*</span></label>
                                <input type="password" id="confirmPassword" name="confirmPassword" required>
                                <span class="error-message" id="confirmPasswordError"></span>
                            </div>

                            <div class="action-row">
                                <button type="submit" class="btn btn-primary">Update password</button>
                            </div>
                        </form>
                    </section>
                </aside>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <p>MIRS member workspace</p>
            <p>Account profile and contact details</p>
        </div>
    </footer>

    <script>
        const form = document.getElementById('accountForm');
        const usernameInput = document.getElementById('username');
        const firstNameInput = document.getElementById('firstName');
        const lastNameInput = document.getElementById('lastName');
        const emailInput = document.getElementById('email');

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function clearFieldError(id) {
            document.getElementById(id).textContent = '';
            document.getElementById(id).classList.remove('show');
        }

        function isValidUsername(username) {
            const usernameRegex = /^[a-zA-Z0-9_-]+$/;
            return usernameRegex.test(username);
        }

        usernameInput.addEventListener('focus', function() { clearFieldError('usernameError'); });
        firstNameInput.addEventListener('focus', function() { clearFieldError('firstNameError'); });
        lastNameInput.addEventListener('focus', function() { clearFieldError('lastNameError'); });
        emailInput.addEventListener('focus', function() { clearFieldError('emailError'); });

        form.addEventListener('submit', function(event) {
            const username = usernameInput.value.trim();
            const firstName = firstNameInput.value.trim();
            const lastName = lastNameInput.value.trim();
            const email = emailInput.value.trim();
            let isValid = true;

            document.querySelectorAll('.error-message').forEach(el => {
                el.textContent = '';
                el.classList.remove('show');
            });

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

            if (email === '') {
                document.getElementById('emailError').textContent = 'Email is required';
                document.getElementById('emailError').classList.add('show');
                isValid = false;
            } else if (!isValidEmail(email)) {
                document.getElementById('emailError').textContent = 'Please enter a valid email address';
                document.getElementById('emailError').classList.add('show');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
