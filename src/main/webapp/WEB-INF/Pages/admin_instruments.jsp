<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MIRS - Manage Instruments</title>
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
            <span>MIRS Admin</span>
        </div>
        <nav class="admin-top-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/members" class="admin-nav-link">Members</a>
            <a href="${pageContext.request.contextPath}/admin/instruments" class="admin-nav-link active">Instruments</a>
            <a href="${pageContext.request.contextPath}/admin/rentals" class="admin-nav-link">Rentals</a>
            <a href="${pageContext.request.contextPath}/admin/fines" class="admin-nav-link">Fines</a>
            <a href="${pageContext.request.contextPath}/admin/settings" class="admin-nav-link">Settings</a>
        </nav>
        <div class="user-info">
            <div class="user-meta">
                <span class="field-note">Administrator</span>
                <strong>${user.firstName} ${user.lastName}</strong>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Sign out</a>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <div class="page-header">
            <h1>Manage Instruments</h1>
            <p class="subtitle">Add, edit, or remove instruments from the catalogue.</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success" style="margin-bottom:20px;">
                <div class="alert-copy"><strong>Success</strong><span>${successMsg}</span></div>
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger" style="margin-bottom:20px;">
                <div class="alert-copy"><strong>Error</strong><span>${errorMsg}</span></div>
            </div>
        </c:if>

        <!-- Add / Edit Form (toggled by JS) -->
        <div id="instrumentFormPanel" class="dashboard-panel form-panel" style="display:none; margin-bottom:20px;">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title" id="formTitle">Add New Instrument</h2>
                    <p class="panel-subtitle">Fill in the details below and save.</p>
                </div>
                <button type="button" class="btn btn-secondary" onclick="closeForm()">Cancel</button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/instruments" id="instrumentForm" enctype="multipart/form-data">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="instrumentId" id="formInstrumentId" value="">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="instrumentName">Instrument Name <span class="required">*</span></label>
                        <input type="text" id="instrumentName" name="instrumentName" required placeholder="e.g. Acoustic Guitar">
                    </div>
                    <div class="form-group">
                        <label for="categoryId">Category <span class="required">*</span></label>
                        <select id="categoryId" name="categoryId" required>
                            <option value="">Select category...</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}">${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="brand">Brand</label>
                        <input type="text" id="brand" name="brand" placeholder="e.g. Yamaha">
                    </div>
                    <div class="form-group">
                        <label for="dailyRate">Daily Rate (Rs.) <span class="required">*</span></label>
                        <input type="number" id="dailyRate" name="dailyRate" step="0.01" min="0" required placeholder="0.00">
                    </div>
                    <div class="form-group">
                        <label for="quantity">Total Quantity <span class="required">*</span></label>
                        <input type="number" id="quantity" name="quantity" min="1" value="1" required>
                    </div>
                    <div class="form-group">
                        <label for="availableQuantity">Available Quantity</label>
                        <input type="number" id="availableQuantity" name="availableQuantity" min="0" value="1">
                    </div>
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="available">Available</option>
                            <option value="unavailable">Unavailable</option>
                            <option value="discontinued">Discontinued</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Brief description of the instrument..."></textarea>
                </div>
                <div class="form-group">
                    <label for="image">Instrument Image</label>
                    <input type="file" id="image" name="image" accept="image/*">
                    <p class="field-note">Leave empty to keep existing image when editing.</p>
                </div>
                <div style="display:flex; gap:12px; margin-top:8px;">
                    <button type="submit" class="btn btn-primary" id="formSubmitBtn">Add Instrument</button>
                    <button type="button" class="btn btn-secondary" onclick="closeForm()">Cancel</button>
                </div>
            </form>
        </div>

        <!-- Search + Add Button Bar -->
        <div class="dashboard-panel" style="margin-bottom:20px; padding:20px 24px;">
            <form method="get" action="${pageContext.request.contextPath}/admin/instruments" class="search-bar-row">
                <div class="search-field-wrap">
                    <svg class="search-icon-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                    </svg>
                    <input type="text" name="search" value="${search}" placeholder="Search by name or category..." class="search-input">
                </div>
                <button type="submit" class="btn btn-primary">Search</button>
                <c:if test="${not empty search}">
                    <a href="${pageContext.request.contextPath}/admin/instruments" class="btn btn-secondary">Clear</a>
                </c:if>
            </form>
            <div style="margin-top:12px;">
                <button type="button" class="btn btn-primary" onclick="showAddForm()">+ Add Instrument</button>
            </div>
        </div>

        <!-- Instruments Table -->
        <section class="dashboard-panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">All Instruments</h2>
                    <p class="panel-subtitle">${instruments.size()} instrument(s) found
                        <c:if test="${not empty search}"> for "<strong>${search}</strong>"</c:if>
                    </p>
                </div>
            </div>
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Brand</th>
                            <th>Daily Rate</th>
                            <th>Stock</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty instruments}">
                                <c:forEach var="inst" items="${instruments}">
                                    <tr>
                                        <td><span class="field-note">#${inst.instrumentId}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty inst.imagePath}">
                                                    <img src="${pageContext.request.contextPath}${inst.imagePath}" alt="${inst.instrumentName}" style="width: 48px; height: 48px; object-fit: cover; border-radius: 4px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="display:inline-block; width:48px; height:48px; background:#f1f5f9; border-radius:4px; text-align:center; line-height:48px; color:#94a3b8; font-size:10px;">None</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><strong>${inst.instrumentName}</strong></td>
                                        <td>${inst.categoryName}</td>
                                        <td>${not empty inst.brand ? inst.brand : 'Not listed'}</td>
                                        <td>Rs. <fmt:formatNumber value="${inst.dailyRate}" pattern="0.00"/>/day</td>
                                        <td>${inst.availableQuantity} / ${inst.quantity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${inst.status == 'available'}"><span class="badge badge-success">Available</span></c:when>
                                                <c:when test="${inst.status == 'unavailable'}"><span class="badge badge-danger">Unavailable</span></c:when>
                                                <c:otherwise><span class="badge badge-secondary">${inst.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <button type="button" class="btn-action btn-action-info"
                                                    onclick="showEditForm(${inst.instrumentId},'${inst.instrumentName}',${inst.categoryId},'${inst.brand}',${inst.dailyRate},${inst.quantity},${inst.availableQuantity},'${inst.status}','${inst.description}')"
                                                    title="Edit">Edit</button>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/instruments"
                                                      style="display:inline;"
                                                      onsubmit="return confirm('Delete ${inst.instrumentName}? This cannot be undone.');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="instrumentId" value="${inst.instrumentId}">
                                                    <button type="submit" class="btn-action btn-action-danger" title="Delete">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="9"><div class="empty-state"><p><strong>No instruments found</strong></p></div></td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<footer class="footer">
    <div class="footer-content"><p>MIRS administration workspace</p></div>
</footer>

<script>
function showAddForm() {
    document.getElementById('formTitle').textContent = 'Add New Instrument';
    document.getElementById('formAction').value = 'add';
    document.getElementById('formInstrumentId').value = '';
    document.getElementById('formSubmitBtn').textContent = 'Add Instrument';
    document.getElementById('instrumentForm').reset();
    document.getElementById('instrumentFormPanel').style.display = 'block';
    document.getElementById('instrumentFormPanel').scrollIntoView({behavior:'smooth'});
}
function showEditForm(id, name, catId, brand, rate, qty, availQty, status, desc) {
    document.getElementById('formTitle').textContent = 'Edit Instrument';
    document.getElementById('formAction').value = 'edit';
    document.getElementById('formInstrumentId').value = id;
    document.getElementById('formSubmitBtn').textContent = 'Save Changes';
    document.getElementById('instrumentName').value = name;
    document.getElementById('categoryId').value = catId;
    document.getElementById('brand').value = brand === 'null' ? '' : brand;
    document.getElementById('dailyRate').value = rate;
    document.getElementById('quantity').value = qty;
    document.getElementById('availableQuantity').value = availQty;
    document.getElementById('status').value = status;
    document.getElementById('description').value = desc === 'null' ? '' : desc;
    document.getElementById('image').value = '';
    document.getElementById('instrumentFormPanel').style.display = 'block';
    document.getElementById('instrumentFormPanel').scrollIntoView({behavior:'smooth'});
}
function closeForm() {
    document.getElementById('instrumentFormPanel').style.display = 'none';
}
</script>
</body>
</html>
