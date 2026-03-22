# SocialFlow SaaS

SocialFlow SaaS is a modular social media marketing and management MVP built with PHP, MySQL, HTML, CSS, and Vanilla JavaScript. It includes a pricing-aware registration flow, dashboard UI, AJAX endpoints, mock automation services, and a production-minded MySQL schema for local development on XAMPP or similar stacks.

## Features
- Secure authentication scaffolding with CSRF protection, password hashing, session hardening, and role-aware access.
- SaaS billing architecture with plans, subscriptions, payments, invoices, coupons, referrals, and trial handling.
- Social account management, post scheduling, inbox routing, analytics, listening, review management, and audit logging.
- Enterprise-ready mock integrations for SSO, Salesforce, Proofpoint, brand listening, and AI automation.
- Responsive dashboard UI with Chart.js widgets and AJAX-powered interactions.

## Project Structure
- `app/` application classes, controllers, services, config, and helpers.
- `api/` lightweight JSON endpoints for dashboard interactions.
- `database/sql/schema.sql` normalized database schema and seed data.
- `views/` reusable layout and page templates.
- `assets/` frontend CSS and JavaScript.
- `index.php` app entry point and route switcher.

## Local Setup
1. Create a MySQL database named `socialflow`.
2. Import `database/sql/schema.sql`.
3. Copy `app/Config/config.example.php` to `app/Config/config.php` and adjust credentials.
4. Serve the project with XAMPP/Apache or run `php -S localhost:8000` from the repo root.
5. Open `http://localhost:8000/index.php`.

## Demo Credentials
- **Admin:** `admin@socialflow.test` / `Password@123`
- **Team Member:** `team@socialflow.test` / `Password@123`
- **Enterprise User:** `enterprise@socialflow.test` / `Password@123`

> Note: External integrations and payment processing are mocked to keep the MVP self-contained.
