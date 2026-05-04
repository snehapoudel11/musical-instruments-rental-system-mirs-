<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS â€” Reset Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header class="header">
    <div class="header-container">
        <div class="logo">
            <span class="brand-mark">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M12 3v18"/><path d="M6 8.5V14a6 6 0 0 0 12 0V8.5"/><path d="M8.5 5.5h7"/>
                </svg>
            </span>
            <span>MIRS</span>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="error-shell" style="min-height:auto; padding:60px 0;">
        <div class="auth-shell" style="width:min(480px, calc(100% - 48px)); padding:0;">
            <div class="auth-card" style="padding:40px 36px;">

                <!-- Icon -->
                <div style="text-align:center; margin-bottom:24px;">
                    <div class="brand-mark" style="margin:0 auto; width:56px; height:56px; border-radius:18px; background:linear-gradient(145deg,rgba(31,93,87,0.18),rgba(255,255,255,0.8));">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" style="width:26px; height:26px; color:var(--brand-700);">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        </svg>
                    </div>
                </div>

                <h2 style="font-family:var(--font-display); font-size:1.9rem; letter-spacing:-0.02em; text-align:center; margin-bottom:8px;">
                    Reset Password
                </h2>
                <p class="subtitle" style="text-align:center; margin-bottom:28px;">
                    Choose a new strong password for your account.
                </p>

                <!-- Error -->
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger" style="margin-bottom:20px;">
                        <div class="alert-copy"><strong>Error</strong><span>${errorMsg}</span></div>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/resetPassword"
                      id="resetForm" onsubmit="return validateReset()">

                    <div class="form-group">
                        <label for="newPassword">New Password <span class="required">*</span></label>
                        <input type="password" id="newPassword" name="newPassword" required
                               minlength="6" placeholder="At least 6 characters" style="min-height:50px;">
                        <span class="helper-text">Minimum 6 characters.</span>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                               placeholder="Re-enter your new password" style="min-height:50px;">
                        <span id="matchError" class="error-message"></span>
                    </div>

                    <!-- Password strength bar -->
                    <div style="margin-bottom:20px;">
                        <div style="height:4px; background:var(--line-soft); border-radius:4px; overflow:hidden;">
                            <div id="strengthBar" style="height:100%; width:0%; background:var(--danger-700); transition:width 300ms ease, background 300ms ease;"></div>
                        </div>
                        <span id="strengthLabel" class="field-note" style="font-size:0.75rem;"></span>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width:100%; min-height:50px;">
                        Set New Password
                    </button>
                </form>

                <div class="form-footer" style="margin-top:24px;">
                    <p><a href="${pageContext.request.contextPath}/login" style="color:var(--brand-700); font-weight:600;">â† Back to Sign In</a></p>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="footer-content"><p>MIRS - Musical Instruments Rental System</p></div>
</footer>

<script>
document.getElementById('newPassword').addEventListener('input', function() {
    const val  = this.value;
    const bar  = document.getElementById('strengthBar');
    const lbl  = document.getElementById('strengthLabel');
    let strength = 0;
    if (val.length >= 6)  strength++;
    if (val.length >= 10) strength++;
    if (/[A-Z]/.test(val)) strength++;
    if (/[0-9]/.test(val)) strength++;
    if (/[^A-Za-z0-9]/.test(val)) strength++;
    const map = [
        {w:'0%',   c:'var(--danger-700)',  t:''},
        {w:'25%',  c:'var(--danger-700)',  t:'Weak'},
        {w:'50%',  c:'var(--warning-700)', t:'Fair'},
        {w:'75%',  c:'var(--accent-600)',  t:'Good'},
        {w:'100%', c:'var(--success-700)', t:'Strong'}
    ];
    const s = map[Math.min(strength, 4)];
    bar.style.width      = s.w;
    bar.style.background = s.c;
    lbl.textContent      = s.t;
});

function validateReset() {
    const p1  = document.getElementById('newPassword').value;
    const p2  = document.getElementById('confirmPassword').value;
    const err = document.getElementById('matchError');
    if (p1 !== p2) {
        err.textContent = 'Passwords do not match.';
        err.classList.add('show');
        return false;
    }
    err.classList.remove('show');
    return true;
}
</script>
</body>
</html>
