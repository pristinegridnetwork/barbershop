<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= e($appName) ?> | Social Media SaaS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="assets/css/app.css">
</head>
<body>
<div class="app-shell">
    <aside class="sidebar">
        <div>
            <div class="brand">
                <div class="brand-mark">SF</div>
                <div>
                    <strong>SocialFlow</strong>
                    <p>Enterprise social ops</p>
                </div>
            </div>
            <nav class="nav">
                <a href="#overview" class="active">Overview</a>
                <a href="#scheduler">Scheduler</a>
                <a href="#inbox">Inbox</a>
                <a href="#analytics">Analytics</a>
                <a href="#pricing">Pricing</a>
                <a href="#billing">Billing</a>
                <a href="#security">Security</a>
            </nav>
        </div>
        <div class="sidebar-footer">
            <p>Built for XAMPP-ready local deployment.</p>
            <span>Mock APIs enabled</span>
        </div>
    </aside>

    <main class="content">
        <section class="hero" id="overview">
            <div>
                <span class="badge">Social media marketing + billing SaaS MVP</span>
                <h1>Manage publishing, conversations, analytics, and subscriptions from one modular PHP platform.</h1>
                <p>Deliver scheduling, inbox management, AI-assisted automation, listening, review management, billing, and enterprise governance in a single responsive dashboard.</p>
                <div class="hero-actions">
                    <a class="btn primary" href="#pricing">Compare plans</a>
                    <a class="btn secondary" href="#setup">Setup guide</a>
                </div>
                <div class="hero-panels">
                    <div class="panel stat-grid">
                        <?php foreach ($dashboard['kpis'] as $kpi): ?>
                            <article>
                                <p><?= e($kpi['label']) ?></p>
                                <strong><?= e((string) $kpi['value']) ?></strong>
                                <span><?= e($kpi['delta']) ?></span>
                            </article>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
            <div class="panel feature-stack">
                <h2>Platform modules</h2>
                <ul>
                    <li>User, team, and SSO-ready access control</li>
                    <li>Social account token storage and profile limits</li>
                    <li>Bulk scheduling and cron queue simulation</li>
                    <li>Unified inbox with routing, tags, and saved replies</li>
                    <li>Analytics, listening, reviews, and competitor benchmarking</li>
                    <li>Pricing plans, trials, invoices, renewals, coupons, referrals</li>
                </ul>
            </div>
        </section>

        <section class="card-grid" id="scheduler">
            <article class="panel wide">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">Post scheduler</p>
                        <h2>Queue simulation</h2>
                    </div>
                    <button class="btn secondary" data-action="refresh-schedule">Refresh</button>
                </div>
                <div class="table-list">
                    <?php foreach ($dashboard['posts'] as $post): ?>
                        <div class="table-row">
                            <div>
                                <strong><?= e($post['platform']) ?></strong>
                                <p><?= e($post['content']) ?></p>
                            </div>
                            <span><?= e($post['time']) ?></span>
                        </div>
                    <?php endforeach; ?>
                </div>
                <div class="suggestions">
                    <h3>Smart scheduling suggestions</h3>
                    <?php foreach ($suggestions as $suggestion): ?>
                        <div class="pill-row">
                            <span class="pill"><?= e($suggestion['time']) ?></span>
                            <p><?= e($suggestion['reason']) ?></p>
                        </div>
                    <?php endforeach; ?>
                </div>
            </article>

            <article class="panel" id="inbox">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">Unified inbox</p>
                        <h2>Priority routing</h2>
                    </div>
                </div>
                <?php foreach ($dashboard['messages'] as $message): ?>
                    <div class="message-card">
                        <strong><?= e($message['contact']) ?></strong>
                        <p><?= e($message['platform']) ?> · <?= e($message['tag']) ?></p>
                        <span class="sentiment <?= strtolower($message['sentiment']) ?>"><?= e($message['sentiment']) ?></span>
                    </div>
                <?php endforeach; ?>
                <form id="ai-reply-form" class="ai-form">
                    <label for="message">AI auto-response preview</label>
                    <textarea id="message" name="message" rows="4">Can you share enterprise pricing and onboarding details?</textarea>
                    <input type="hidden" name="_csrf" value="<?= e($csrf) ?>">
                    <button class="btn primary" type="submit">Generate reply</button>
                    <div id="ai-reply-result" class="ai-result"></div>
                </form>
            </article>
        </section>

        <section class="card-grid" id="analytics">
            <article class="panel wide">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">Analytics dashboard</p>
                        <h2>Engagement and mention tracking</h2>
                    </div>
                </div>
                <canvas id="engagementChart" height="120"></canvas>
            </article>
            <article class="panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">Sentiment mix</p>
                        <h2>Listening insights</h2>
                    </div>
                </div>
                <canvas id="sentimentChart" height="220"></canvas>
            </article>
        </section>

        <section class="panel" id="pricing">
            <div class="panel-header">
                <div>
                    <p class="eyebrow">Pricing & subscriptions</p>
                    <h2>Affordable Sprout-style SaaS plans</h2>
                </div>
                <span class="discount-pill">Yearly billing saves 18%</span>
            </div>
            <div class="pricing-grid">
                <?php foreach ($plans as $plan): ?>
                    <article class="price-card <?= !empty($plan['custom']) ? 'enterprise' : '' ?>">
                        <h3><?= e($plan['name']) ?></h3>
                        <p class="price"><?= !empty($plan['custom']) ? 'Custom' : money((float) $plan['price_monthly']) ?><span><?= empty($plan['custom']) ? '/month' : ' pricing' ?></span></p>
                        <p class="muted"><?= empty($plan['custom']) ? money((float) $plan['price_yearly']) . ' billed yearly' : 'Talk to sales for custom onboarding and support.' ?></p>
                        <ul>
                            <li><?= e((string) $plan['profiles']) ?> social profiles</li>
                            <li><?= e((string) $plan['posts']) ?> scheduled posts</li>
                            <li><?= e($plan['analytics']) ?></li>
                            <?php foreach ($plan['features'] as $feature): ?>
                                <li><?= e($feature) ?></li>
                            <?php endforeach; ?>
                        </ul>
                        <button class="btn <?= !empty($plan['custom']) ? 'secondary' : 'primary' ?>"><?= !empty($plan['custom']) ? 'Contact sales' : 'Start 14-day trial' ?></button>
                    </article>
                <?php endforeach; ?>
            </div>
            <div class="comparison-table">
                <div><strong>Feature gate</strong><strong>Standard</strong><strong>Professional</strong><strong>Advanced</strong><strong>Enterprise</strong></div>
                <div><span>Social profiles</span><span>5</span><span>15</span><span>Unlimited</span><span>Unlimited</span></div>
                <div><span>Bulk scheduling</span><span>100</span><span>350</span><span>Unlimited</span><span>Unlimited</span></div>
                <div><span>Competitors</span><span>—</span><span>10</span><span>20</span><span>20+</span></div>
                <div><span>Listening + sentiment</span><span>—</span><span>Partial</span><span>Full</span><span>Full</span></div>
                <div><span>SSO + enterprise integrations</span><span>—</span><span>—</span><span>—</span><span>Included</span></div>
            </div>
        </section>

        <section class="card-grid" id="billing">
            <article class="panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">Billing dashboard</p>
                        <h2><?= e($dashboard['billing']['plan']) ?></h2>
                    </div>
                </div>
                <p class="muted">Renewal date: <?= e($dashboard['billing']['renewal_date']) ?></p>
                <?php foreach ($dashboard['billing']['usage'] as $usage): ?>
                    <div class="usage-row">
                        <span><?= e($usage['label']) ?></span>
                        <strong><?= e($usage['value']) ?></strong>
                    </div>
                <?php endforeach; ?>
                <div class="billing-actions">
                    <button class="btn primary">Upgrade plan</button>
                    <button class="btn secondary">Apply coupon</button>
                </div>
            </article>

            <article class="panel" id="security">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">Security + enterprise controls</p>
                        <h2>Production-minded safeguards</h2>
                    </div>
                </div>
                <ul class="security-list">
                    <li>Password hashing via <code>password_hash</code> and demo authentication service.</li>
                    <li>PDO-ready database layer with prepared statement compatibility.</li>
                    <li>CSRF tokens, hardened session cookies, and audit logs.</li>
                    <li>Plan-based feature gating for profiles, analytics, and enterprise modules.</li>
                    <li>Mock Salesforce, Proofpoint, SSO, and payment gateway integration hooks.</li>
                </ul>
            </article>
        </section>

        <section class="panel" id="setup">
            <div class="panel-header">
                <div>
                    <p class="eyebrow">Setup instructions</p>
                    <h2>Local runbook</h2>
                </div>
            </div>
            <ol class="setup-list">
                <li>Create a MySQL database and import <code>database/sql/schema.sql</code>.</li>
                <li>Update <code>app/Config/config.php</code> with your MySQL credentials.</li>
                <li>Serve the project from XAMPP or with <code>php -S localhost:8000</code>.</li>
                <li>Open <code>index.php</code> to explore pricing, dashboard, and AJAX widgets.</li>
                <li>Use the demo credentials from the README for sample account access.</li>
            </ol>
        </section>
    </main>
</div>
<script>
    window.socialFlowAnalytics = <?= json_encode($analytics, JSON_UNESCAPED_SLASHES) ?>;
</script>
<script src="assets/js/app.js"></script>
</body>
</html>
