CREATE DATABASE IF NOT EXISTS socialflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE socialflow;

CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    tier ENUM('standard','professional','advanced','enterprise') NOT NULL DEFAULT 'standard',
    industry VARCHAR(120) NULL,
    timezone VARCHAR(64) NOT NULL DEFAULT 'UTC',
    sso_enabled TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_accounts_tier (tier)
);

CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('active','invited','suspended') NOT NULL DEFAULT 'active',
    last_login_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id),
    INDEX idx_users_account_role (account_id, role_id),
    INDEX idx_users_status (status)
);

CREATE TABLE permissions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(80) NOT NULL UNIQUE,
    label VARCHAR(120) NOT NULL
);

CREATE TABLE role_permissions (
    role_id BIGINT UNSIGNED NOT NULL,
    permission_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

CREATE TABLE plans (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    slug VARCHAR(80) NOT NULL UNIQUE,
    monthly_price DECIMAL(10,2) NOT NULL,
    yearly_price DECIMAL(10,2) NOT NULL,
    social_profile_limit INT NULL,
    scheduled_post_limit INT NULL,
    competitor_limit INT NULL,
    analytics_depth ENUM('basic','advanced','full','enterprise') NOT NULL,
    features JSON NOT NULL,
    is_custom_pricing TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subscriptions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    plan_id BIGINT UNSIGNED NOT NULL,
    billing_cycle ENUM('monthly','yearly') NOT NULL,
    status ENUM('trialing','active','past_due','expired','cancelled') NOT NULL DEFAULT 'trialing',
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    trial_ends_at DATE NULL,
    auto_renew TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_subscriptions_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_subscriptions_plan FOREIGN KEY (plan_id) REFERENCES plans(id),
    INDEX idx_subscriptions_status_end (status, end_date)
);

CREATE TABLE payments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('card','paypal','bank_transfer','mock_gateway') NOT NULL DEFAULT 'mock_gateway',
    status ENUM('pending','paid','failed','refunded') NOT NULL,
    transaction_id VARCHAR(120) NOT NULL UNIQUE,
    paid_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE,
    CONSTRAINT fk_payments_user FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_payments_status_paid_at (status, paid_at)
);

CREATE TABLE invoices (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT UNSIGNED NOT NULL,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('draft','open','paid','void','overdue') NOT NULL DEFAULT 'open',
    issued_at DATETIME NOT NULL,
    CONSTRAINT fk_invoices_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE,
    INDEX idx_invoices_status_due_date (status, due_date)
);

CREATE TABLE coupons (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(60) NOT NULL UNIQUE,
    discount_type ENUM('percent','fixed') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    max_redemptions INT NULL,
    expires_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE referrals (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    referrer_user_id BIGINT UNSIGNED NOT NULL,
    referred_email VARCHAR(150) NOT NULL,
    reward_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    status ENUM('pending','qualified','rewarded') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_referrals_user FOREIGN KEY (referrer_user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_referrals_status (status)
);

CREATE TABLE social_accounts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    platform ENUM('facebook','instagram','x','linkedin') NOT NULL,
    profile_name VARCHAR(120) NOT NULL,
    profile_handle VARCHAR(120) NOT NULL,
    encrypted_token VARBINARY(255) NOT NULL,
    token_last_four VARCHAR(4) NOT NULL,
    status ENUM('connected','expired','disconnected') NOT NULL DEFAULT 'connected',
    connected_at DATETIME NOT NULL,
    CONSTRAINT fk_social_accounts_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_social_profile (platform, profile_handle),
    INDEX idx_social_accounts_account_platform (account_id, platform)
);

CREATE TABLE media_assets (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_size INT UNSIGNED NOT NULL,
    uploaded_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_media_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_media_user FOREIGN KEY (uploaded_by) REFERENCES users(id)
);

CREATE TABLE posts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    created_by BIGINT UNSIGNED NOT NULL,
    title VARCHAR(150) NOT NULL,
    body TEXT NOT NULL,
    status ENUM('draft','scheduled','published','failed') NOT NULL DEFAULT 'draft',
    ai_generated TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_posts_user FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_posts_status_created (status, created_at)
);

CREATE TABLE post_media (
    post_id BIGINT UNSIGNED NOT NULL,
    media_asset_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (post_id, media_asset_id),
    CONSTRAINT fk_post_media_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_post_media_media FOREIGN KEY (media_asset_id) REFERENCES media_assets(id) ON DELETE CASCADE
);

CREATE TABLE scheduled_posts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT UNSIGNED NOT NULL,
    social_account_id BIGINT UNSIGNED NOT NULL,
    scheduled_for DATETIME NOT NULL,
    queue_position INT NOT NULL,
    cron_status ENUM('queued','processing','published','failed') NOT NULL DEFAULT 'queued',
    published_at DATETIME NULL,
    failure_reason VARCHAR(255) NULL,
    CONSTRAINT fk_scheduled_posts_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_scheduled_posts_social FOREIGN KEY (social_account_id) REFERENCES social_accounts(id) ON DELETE CASCADE,
    INDEX idx_scheduled_posts_queue (scheduled_for, cron_status, queue_position)
);

CREATE TABLE saved_replies (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(100) NOT NULL,
    body TEXT NOT NULL,
    created_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_saved_replies_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_saved_replies_user FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE messages (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    social_account_id BIGINT UNSIGNED NOT NULL,
    external_message_id VARCHAR(150) NOT NULL,
    sender_name VARCHAR(120) NOT NULL,
    message_body TEXT NOT NULL,
    message_type ENUM('dm','comment','review') NOT NULL,
    sentiment ENUM('positive','neutral','negative') NOT NULL DEFAULT 'neutral',
    assigned_user_id BIGINT UNSIGNED NULL,
    status ENUM('new','open','resolved','archived') NOT NULL DEFAULT 'new',
    received_at DATETIME NOT NULL,
    CONSTRAINT fk_messages_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_messages_social FOREIGN KEY (social_account_id) REFERENCES social_accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_messages_assignee FOREIGN KEY (assigned_user_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY uniq_external_message (social_account_id, external_message_id),
    INDEX idx_messages_status_received (status, received_at)
);

CREATE TABLE tags (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(80) NOT NULL,
    type ENUM('priority','sentiment','category','campaign') NOT NULL,
    color VARCHAR(20) NOT NULL DEFAULT '#4f46e5',
    CONSTRAINT fk_tags_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_tag_name (account_id, name)
);

CREATE TABLE message_tags (
    message_id BIGINT UNSIGNED NOT NULL,
    tag_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (message_id, tag_id),
    CONSTRAINT fk_message_tags_message FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
    CONSTRAINT fk_message_tags_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

CREATE TABLE automation_rules (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(120) NOT NULL,
    trigger_type ENUM('keyword','sentiment','priority','review_score') NOT NULL,
    trigger_value VARCHAR(120) NOT NULL,
    action_type ENUM('assign','reply','tag','escalate') NOT NULL,
    action_value VARCHAR(255) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_automation_rules_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    INDEX idx_automation_rules_active (account_id, is_active)
);

CREATE TABLE analytics (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    social_account_id BIGINT UNSIGNED NOT NULL,
    metric_date DATE NOT NULL,
    impressions INT UNSIGNED NOT NULL DEFAULT 0,
    reach INT UNSIGNED NOT NULL DEFAULT 0,
    likes INT UNSIGNED NOT NULL DEFAULT 0,
    comments INT UNSIGNED NOT NULL DEFAULT 0,
    shares INT UNSIGNED NOT NULL DEFAULT 0,
    clicks INT UNSIGNED NOT NULL DEFAULT 0,
    followers INT UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT fk_analytics_social FOREIGN KEY (social_account_id) REFERENCES social_accounts(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_analytics_day (social_account_id, metric_date),
    INDEX idx_analytics_metric_date (metric_date)
);

CREATE TABLE reports (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    created_by BIGINT UNSIGNED NOT NULL,
    name VARCHAR(120) NOT NULL,
    format ENUM('pdf','csv') NOT NULL,
    filters JSON NOT NULL,
    scheduled_frequency ENUM('manual','weekly','monthly') NOT NULL DEFAULT 'manual',
    next_run_at DATETIME NULL,
    last_run_at DATETIME NULL,
    file_path VARCHAR(255) NULL,
    CONSTRAINT fk_reports_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_reports_user FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_reports_next_run (next_run_at)
);

CREATE TABLE competitors (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(150) NOT NULL,
    platform VARCHAR(80) NOT NULL,
    handle VARCHAR(120) NOT NULL,
    benchmark_score DECIMAL(5,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_competitors_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    INDEX idx_competitors_account (account_id)
);

CREATE TABLE mentions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    source VARCHAR(80) NOT NULL,
    keyword VARCHAR(120) NOT NULL,
    mention_text TEXT NOT NULL,
    sentiment ENUM('positive','neutral','negative') NOT NULL DEFAULT 'neutral',
    occurred_at DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mentions_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    INDEX idx_mentions_occurred (account_id, occurred_at),
    INDEX idx_mentions_keyword (keyword)
);

CREATE TABLE reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    source VARCHAR(80) NOT NULL,
    reviewer_name VARCHAR(120) NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    review_text TEXT NOT NULL,
    response_text TEXT NULL,
    responded_by BIGINT UNSIGNED NULL,
    reviewed_at DATETIME NOT NULL,
    CONSTRAINT fk_reviews_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_user FOREIGN KEY (responded_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_reviews_rating_date (rating, reviewed_at)
);

CREATE TABLE audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NULL,
    action VARCHAR(150) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    entity_id BIGINT UNSIGNED NULL,
    metadata JSON NULL,
    ip_address VARCHAR(45) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_audit_entity (entity_type, entity_id),
    INDEX idx_audit_created_at (created_at)
);

INSERT INTO roles (name, description) VALUES
('Admin', 'Full workspace access including billing and automation.'),
('Team Member', 'Operational access for publishing and inbox workflows.'),
('Enterprise User', 'Executive access with enterprise integrations.');

INSERT INTO permissions (code, label) VALUES
('manage_billing', 'Manage billing'),
('manage_users', 'Manage users'),
('publish_posts', 'Publish posts'),
('manage_inbox', 'Manage inbox'),
('view_analytics', 'View analytics'),
('manage_enterprise', 'Use enterprise integrations');

INSERT INTO role_permissions (role_id, permission_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(2,3),(2,4),(2,5),
(3,1),(3,2),(3,5),(3,6);

INSERT INTO plans (name, slug, monthly_price, yearly_price, social_profile_limit, scheduled_post_limit, competitor_limit, analytics_depth, features, is_custom_pricing) VALUES
('Standard', 'standard', 79.00, 777.36, 5, 100, 0, 'basic', JSON_ARRAY('Unified inbox','Basic reporting','5 social profiles','14-day trial'), 0),
('Professional', 'professional', 119.00, 1170.96, 15, 350, 10, 'advanced', JSON_ARRAY('Bulk scheduling','Saved replies','Automation','Exports'), 0),
('Advanced', 'advanced', 149.00, 1466.16, NULL, NULL, 20, 'full', JSON_ARRAY('Listening','Sentiment','Scheduled reports','Routing'), 0),
('Enterprise', 'enterprise', 0.00, 0.00, NULL, NULL, 20, 'enterprise', JSON_ARRAY('SSO','Salesforce','Proofpoint','AI automation','Dedicated support'), 1);

INSERT INTO accounts (name, tier, industry, timezone, sso_enabled) VALUES
('Northstar Commerce', 'advanced', 'Retail', 'America/New_York', 0),
('Helix Studio', 'professional', 'Agency', 'America/Chicago', 0),
('Atlas Enterprise', 'enterprise', 'Technology', 'UTC', 1);

INSERT INTO users (account_id, role_id, name, email, password_hash, status) VALUES
(1, 1, 'Ariana Admin', 'admin@socialflow.test', '$2y$10$2EQmM7H9O6q6wJZpMIXPbuJX.ztG4mk7w6xWy2S1YvP4I7M0h0s9G', 'active'),
(2, 2, 'Taylor Team', 'team@socialflow.test', '$2y$10$2EQmM7H9O6q6wJZpMIXPbuJX.ztG4mk7w6xWy2S1YvP4I7M0h0s9G', 'active'),
(3, 3, 'Elliot Enterprise', 'enterprise@socialflow.test', '$2y$10$2EQmM7H9O6q6wJZpMIXPbuJX.ztG4mk7w6xWy2S1YvP4I7M0h0s9G', 'active');

INSERT INTO subscriptions (account_id, plan_id, billing_cycle, status, start_date, end_date, trial_ends_at, auto_renew) VALUES
(1, 3, 'yearly', 'active', '2026-01-01', '2026-12-31', NULL, 1),
(2, 2, 'monthly', 'trialing', '2026-03-10', '2026-04-10', '2026-03-24', 1),
(3, 4, 'yearly', 'active', '2026-01-15', '2027-01-14', NULL, 1);

INSERT INTO social_accounts (account_id, platform, profile_name, profile_handle, encrypted_token, token_last_four, status, connected_at) VALUES
(1, 'instagram', 'Northstar IG', '@northstar', UNHEX(SHA2('token1',256)), '8A21', 'connected', NOW()),
(1, 'linkedin', 'Northstar LinkedIn', 'northstar-co', UNHEX(SHA2('token2',256)), 'B932', 'connected', NOW()),
(3, 'x', 'Atlas X', '@atlasx', UNHEX(SHA2('token3',256)), 'C441', 'connected', NOW());

INSERT INTO posts (account_id, created_by, title, body, status, ai_generated) VALUES
(1, 1, 'Spring Launch', 'Meet the new collection with AI-assisted captioning.', 'scheduled', 1),
(1, 1, 'Webinar Promo', 'Join our demand generation webinar next Thursday.', 'draft', 0);

INSERT INTO scheduled_posts (post_id, social_account_id, scheduled_for, queue_position, cron_status) VALUES
(1, 1, '2026-03-23 09:00:00', 1, 'queued');

INSERT INTO tags (account_id, name, type, color) VALUES
(1, 'Priority', 'priority', '#ef4444'),
(1, 'Billing', 'category', '#3b82f6'),
(1, 'Positive', 'sentiment', '#22c55e');

INSERT INTO messages (account_id, social_account_id, external_message_id, sender_name, message_body, message_type, sentiment, assigned_user_id, status, received_at) VALUES
(1, 1, 'ig-101', 'Ava Johnson', 'Love the new launch creative!', 'comment', 'positive', 1, 'open', NOW()),
(1, 2, 'li-202', 'Noah Smith', 'Can someone send pricing options?', 'dm', 'neutral', 1, 'new', NOW());

INSERT INTO message_tags (message_id, tag_id) VALUES (1, 1), (1, 3), (2, 2);

INSERT INTO analytics (social_account_id, metric_date, impressions, reach, likes, comments, shares, clicks, followers) VALUES
(1, '2026-03-20', 5500, 4300, 320, 46, 24, 178, 11200),
(1, '2026-03-21', 6100, 4700, 355, 51, 30, 201, 11268),
(2, '2026-03-21', 4200, 3100, 190, 26, 17, 143, 8200);

INSERT INTO reports (account_id, created_by, name, format, filters, scheduled_frequency, next_run_at) VALUES
(1, 1, 'Executive Performance Summary', 'pdf', JSON_OBJECT('range','30d','channels',JSON_ARRAY('instagram','linkedin')), 'weekly', '2026-03-27 08:00:00');

INSERT INTO competitors (account_id, name, platform, handle, benchmark_score) VALUES
(1, 'Rival Brand A', 'instagram', '@rivala', 78.4),
(1, 'Rival Brand B', 'linkedin', 'rival-b', 73.2);

INSERT INTO mentions (account_id, source, keyword, mention_text, sentiment, occurred_at) VALUES
(1, 'news', 'Northstar', 'Northstar launches an innovative social commerce experience.', 'positive', NOW()),
(1, 'forum', 'Northstar support', 'Northstar support resolved my issue quickly.', 'positive', NOW());

INSERT INTO reviews (account_id, source, reviewer_name, rating, review_text, response_text, responded_by, reviewed_at) VALUES
(1, 'Google', 'Chris Lee', 5, 'Excellent support and easy scheduling.', 'Thank you for the feedback!', 1, NOW());

INSERT INTO audit_logs (account_id, user_id, action, entity_type, entity_id, metadata, ip_address) VALUES
(1, 1, 'subscription.updated', 'subscription', 1, JSON_OBJECT('from','professional','to','advanced'), '127.0.0.1');
