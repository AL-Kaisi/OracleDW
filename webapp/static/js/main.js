// Main JavaScript file for Green Care Provider Temps

// Show loading indicator
function showLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = '<div class="loading"></div> Loading...';
    }
}

// Hide loading indicator
function hideLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = '';
    }
}

// Format numbers with commas
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Generic error handler
function handleError(error, elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = `<div class="alert alert-danger">Error: ${error.message || error}</div>`;
    }
    console.error('Error:', error);
}

// Confirm action
function confirmAction(message) {
    return confirm(message);
}

// Update metric cards
function updateMetricCard(cardId, value) {
    const element = document.querySelector(`#${cardId} .card-title`);
    if (element) {
        element.textContent = formatNumber(value);
    }
}

// Initialise tooltips
function initTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Document ready
document.addEventListener('DOMContentLoaded', function() {
    initTooltips();
    
    // Add active class to current nav item
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
    });
});

// Refresh dashboard metrics
function refreshDashboard() {
    showLoading('metrics-loading');
    
    fetch('/api/dashboard-metrics')
        .then(response => response.json())
        .then(data => {
            updateMetricCard('total-temps', data.total_temps);
            updateMetricCard('total-councils', data.total_councils);
            updateMetricCard('total-sessions', data.total_sessions);
            updateMetricCard('active-requests', data.active_requests);
            hideLoading('metrics-loading');
        })
        .catch(error => {
            handleError(error, 'metrics-loading');
        });
}

// Filter table
function filterTable(inputId, tableId) {
    const input = document.getElementById(inputId);
    const filter = input.value.toUpperCase();
    const table = document.getElementById(tableId);
    const rows = table.getElementsByTagName('tr');
    
    for (let i = 0; i < rows.length; i++) {
        const cells = rows[i].getElementsByTagName('td');
        let textContent = '';
        
        for (let j = 0; j < cells.length; j++) {
            textContent += cells[j].textContent || cells[j].innerText;
        }
        
        if (textContent.toUpperCase().indexOf(filter) > -1) {
            rows[i].style.display = '';
        } else {
            rows[i].style.display = 'none';
        }
    }
}

// Export table to CSV
function exportTableToCSV(tableId, filename) {
    const table = document.getElementById(tableId);
    const rows = Array.from(table.querySelectorAll('tr'));
    
    const csv = rows.map(row => {
        const cells = Array.from(row.querySelectorAll('th, td'));
        return cells.map(cell => `"${cell.textContent}"`).join(',');
    }).join('\n');
    
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename;
    link.click();
}

// Add keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + K for search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        const searchInput = document.querySelector('#search-input');
        if (searchInput) {
            searchInput.focus();
        }
    }
});

// Health check
async function checkHealth() {
    try {
        const response = await fetch('/health');
        const data = await response.json();
        return data.status === 'healthy';
    } catch (error) {
        console.error('Health check failed:', error);
        return false;
    }
}