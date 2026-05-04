<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Book Instrument</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
    <style>
        .booking-layout {
            display: grid;
            grid-template-columns: minmax(0, 0.85fr) minmax(320px, 1.15fr);
            gap: 24px;
        }

        .booking-summary {
            display: grid;
            gap: 16px;
            color: var(--ink-700);
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--line-soft);
        }

        .summary-line strong {
            color: var(--ink-900);
        }

        .estimate-box {
            padding: 18px;
            border-radius: 8px;
            background: var(--brand-100);
            color: var(--brand-700);
            margin-bottom: 18px;
        }

        .estimate-box strong {
            display: block;
            font-family: var(--font-display);
            font-size: 2rem;
            line-height: 1;
            margin-top: 4px;
        }

        @media (max-width: 900px) {
            .booking-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
                <a href="${pageContext.request.contextPath}/member/instruments" class="btn btn-secondary">Instruments</a>
                <a href="${pageContext.request.contextPath}/member/rentals" class="btn btn-secondary">My rentals</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Sign out</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="container">
            <section class="hero-panel">
                <div>
                    <h1 class="hero-heading">Confirm booking</h1>
                    <p class="hero-copy">Choose your rental dates and review the estimated total before saving the rental request.</p>
                </div>
            </section>

            <div class="booking-layout">
                <section class="dashboard-panel">
                    <div class="panel-header">
                        <div>
                            <h2 class="panel-title">${instrumentName}</h2>
                            <p class="panel-subtitle">${categoryName}</p>
                        </div>
                    </div>

                    <div class="booking-summary">
                        <div class="summary-line">
                            <span>Daily rate</span>
                            <strong>Rs. <fmt:formatNumber value="${dailyRate}" pattern="0.00"/></strong>
                        </div>
                        <div class="summary-line">
                            <span>Available units</span>
                            <strong>${availableQuantity}</strong>
                        </div>
                        <div class="summary-line">
                            <span>Status</span>
                            <strong>${availabilityStatus}</strong>
                        </div>
                    </div>
                </section>

                <section class="dashboard-panel">
                    <div class="panel-header">
                        <div>
                            <h2 class="panel-title">Rental dates</h2>
                            <p class="panel-subtitle">End date must be after the start date.</p>
                        </div>
                    </div>

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
                                <strong>Booking issue</strong>
                                <span>${errorMessage}</span>
                            </div>
                        </div>
                    </c:if>

                    <div class="estimate-box">
                        Estimated total
                        <strong id="estimatedTotal">Rs. 0.00</strong>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/member/book" id="bookingForm">
                        <input type="hidden" name="instrumentId" value="${instrumentId}">
                        <input type="hidden" id="dailyRate" value="${dailyRate}">

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="startDate">Start date <span class="required">*</span></label>
                                <input type="date" id="startDate" name="startDate" required>
                                <span class="error-message" id="startDateError"></span>
                            </div>

                            <div class="form-group">
                                <label for="endDate">End date <span class="required">*</span></label>
                                <input type="date" id="endDate" name="endDate" required>
                                <span class="error-message" id="endDateError"></span>
                            </div>
                        </div>

                        <div class="action-row">
                            <button type="submit" class="btn btn-primary">Confirm booking</button>
                            <a href="${pageContext.request.contextPath}/member/instruments" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </section>
            </div>
        </div>
    </main>

    <script>
        const form = document.getElementById('bookingForm');
        const startInput = document.getElementById('startDate');
        const endInput = document.getElementById('endDate');
        const totalOutput = document.getElementById('estimatedTotal');
        const dailyRate = Number(document.getElementById('dailyRate').value);
        const today = new Date().toISOString().split('T')[0];

        startInput.min = today;
        endInput.min = today;

        function clearErrors() {
            document.querySelectorAll('.error-message').forEach(el => {
                el.textContent = '';
                el.classList.remove('show');
            });
        }

        function daysBetween(start, end) {
            const startDate = new Date(start + 'T00:00:00');
            const endDate = new Date(end + 'T00:00:00');
            return Math.round((endDate - startDate) / 86400000);
        }

        function updateEstimate() {
            clearErrors();
            if (!startInput.value || !endInput.value) {
                totalOutput.textContent = 'Rs. 0.00';
                return true;
            }

            const days = daysBetween(startInput.value, endInput.value);
            if (startInput.value < today) {
                document.getElementById('startDateError').textContent = 'Start date cannot be in the past';
                document.getElementById('startDateError').classList.add('show');
                totalOutput.textContent = 'Rs. 0.00';
                return false;
            }

            if (days <= 0) {
                document.getElementById('endDateError').textContent = 'End date must be after start date';
                document.getElementById('endDateError').classList.add('show');
                totalOutput.textContent = 'Rs. 0.00';
                return false;
            }

            totalOutput.textContent = 'Rs. ' + (days * dailyRate).toFixed(2);
            return true;
        }

        startInput.addEventListener('change', function() {
            endInput.min = startInput.value || today;
            updateEstimate();
        });
        endInput.addEventListener('change', updateEstimate);

        form.addEventListener('submit', function(event) {
            if (!updateEstimate()) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
