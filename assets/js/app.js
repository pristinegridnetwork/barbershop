const analytics = window.socialFlowAnalytics || {};

const engagementCtx = document.getElementById('engagementChart');
if (engagementCtx && analytics.labels) {
    new Chart(engagementCtx, {
        type: 'line',
        data: {
            labels: analytics.labels,
            datasets: [
                {
                    label: 'Engagement',
                    data: analytics.engagement,
                    borderColor: '#8b5cf6',
                    backgroundColor: 'rgba(139, 92, 246, 0.18)',
                    fill: true,
                    tension: 0.35,
                },
                {
                    label: 'Mentions',
                    data: analytics.mentions,
                    borderColor: '#14b8a6',
                    backgroundColor: 'rgba(20, 184, 166, 0.12)',
                    fill: true,
                    tension: 0.35,
                },
            ],
        },
        options: {
            plugins: { legend: { labels: { color: '#cbd5e1' } } },
            scales: {
                x: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(148,163,184,0.08)' } },
                y: { ticks: { color: '#94a3b8' }, grid: { color: 'rgba(148,163,184,0.08)' } },
            },
        },
    });
}

const sentimentCtx = document.getElementById('sentimentChart');
if (sentimentCtx && analytics.sentiment) {
    new Chart(sentimentCtx, {
        type: 'doughnut',
        data: {
            labels: ['Positive', 'Neutral', 'Negative'],
            datasets: [{
                data: [analytics.sentiment.positive, analytics.sentiment.neutral, analytics.sentiment.negative],
                backgroundColor: ['#22c55e', '#f59e0b', '#ef4444'],
                borderWidth: 0,
            }],
        },
        options: {
            plugins: { legend: { labels: { color: '#cbd5e1' } } },
        },
    });
}

const aiForm = document.getElementById('ai-reply-form');
if (aiForm) {
    aiForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        const result = document.getElementById('ai-reply-result');
        result.textContent = 'Generating reply...';

        const formData = new FormData(aiForm);
        const response = await fetch('api/dashboard.php?action=ai-reply', {
            method: 'POST',
            body: formData,
        });
        const payload = await response.json();
        result.textContent = payload?.data?.reply || 'Unable to generate a reply.';
    });
}

const refreshButton = document.querySelector('[data-action="refresh-schedule"]');
if (refreshButton) {
    refreshButton.addEventListener('click', async () => {
        refreshButton.textContent = 'Refreshing...';
        await fetch('api/dashboard.php?action=snapshot');
        window.setTimeout(() => {
            refreshButton.textContent = 'Refresh';
        }, 600);
    });
}
