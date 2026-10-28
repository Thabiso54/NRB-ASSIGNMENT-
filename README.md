# NRB National ID Registration System

A PHP + MySQL/MariaDB academic implementation of the National ID Registration System assignment. It includes applicant registration, listing/search, viewing/editing/deletion, registration records, ID card issuance/status management, login, CSRF protection, prepared statements, output escaping, validation, duplicate handling and fictional sample data.

> **Important:** The assignment says to implement your previously designed EER/logical/physical models. Those models were not provided with the assignment PDF. This repository therefore uses a provisional schema. Compare `sql/schema.sql` with your own model and adjust table/attribute names and relationships before submission. This is an academic demonstration, not an official government service. Never use real citizen identity data.

## Requirements
- XAMPP with Apache, PHP 8.1+ and MySQL/MariaDB (PDO MySQL extension enabled)
- Or PHP 8.1+ with a MySQL/MariaDB server
- Git (optional, for GitHub)

## Run on XAMPP (Windows)
1. Start **Apache** and **MySQL** from the XAMPP Control Panel.
2. Copy the `nrb-national-id` folder into `C:\xampp\htdocs\`.
3. Open `http://localhost/phpmyadmin/`.
4. Import `sql/schema.sql`, then import `sql/sample_data.sql` (the schema script creates and selects `nrb_registration`).
5. Copy `config.example.php` to `config.php`. For a default XAMPP install, host `127.0.0.1`, port `3306`, database `nrb_registration`, user `root`, password blank. If your MySQL root account has a password, set it in `config.php`.
6. Open `http://localhost/nrb-national-id/login.php`.
7. Demo login: **admin** / **ChangeMe123!**. Change the demo password before sharing/deployment. Use the **Password** link after login to change the demo password immediately. Choose a unique password with at least 12 characters, uppercase, lowercase and a number.

## Run on GitHub
GitHub Pages does **not** run PHP or MySQL. Push the source to a GitHub repository for version control and lecturer review, then run the app on XAMPP or deploy it to a PHP-capable host with MySQL/MariaDB. Do not commit `config.php`, actual credentials, or real personal information. The `.env.example` file is a reference only; this starter app reads `config.php` and does not parse `.env`.

### Push to GitHub
```bash
git init
git add .
git commit -m "Build NRB National ID Registration System"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/nrb-national-id-registration.git
git push -u origin main
```
Create the repository first on GitHub. In repository **Settings → Collaborators**, invite the lecturer username `Mwamvani` and ensure access is granted. The repository URL and access must be verified in GitHub itself; this project cannot create the repository or send invitations on your behalf.

## Project structure
```text
nrb-national-id/
├── app/                 # PDO bootstrap, shared layout and security helpers
├── assets/              # CSS and JavaScript
├── docs/                # Test plan and submission checklist
├── screenshots/         # Add your own running-app evidence here
├── sql/                 # Schema, fictional sample data, demonstration queries
├── applicant_form.php   # Create/update applicant
├── applicant_view.php   # Details, related cards and controlled deletion
├── applicants.php       # Search/list applicants
├── card_form.php        # Create/update card issuance details
├── cards.php            # Search/list ID cards
├── index.php            # Dashboard
├── login.php / logout.php
├── config.example.php   # Safe config template
└── README.md
```

## Database model in this starter
- `users`: local staff login accounts.
- `applicants`: one row per fictional applicant; unique applicant number.
- `registrations`: registration event/details; one registration per applicant in this starter.
- `id_cards`: card issuance records; an applicant can have multiple historical card records.
- `audit_logs`: records create/update/delete/card actions by signed-in user where available.

Relationships use InnoDB foreign keys. Applicant deletion cascades to registration/card rows; the UI requires an explicit typed confirmation. SQL uses `UNIQUE`, `NOT NULL`, `ENUM`, indexes, and a card date check constraint.

## Security notes
- PDO prepared statements with emulated prepares disabled.
- HTML output escaped with `htmlspecialchars`.
- CSRF tokens checked on POST forms.
- Passwords stored as PHP password hashes; sessions regenerated after login.
- Form validation, duplicate/constraint error handling and generic DB error messages.
- `config.php` is git-ignored; keep credentials out of screenshots and source control.
- For any public deployment, use HTTPS, a least-privilege DB account, secure cookie settings, rate limiting, a password-change/reset process, backups, and a professional security review. Do not expose this demo with actual identity data.

## Tests and evidence
Follow `docs/TEST_PLAN.md`. Run tests using the fictional data and capture your own screenshots while the app is running. The `screenshots/` folder is intentionally empty; no fake screenshots are included. Record real outcomes in your report.

## Troubleshooting
- **Configuration missing:** copy `config.example.php` to `config.php`.
- **Database connection failed:** verify MySQL is running, the database exists, and credentials/port in `config.php` are correct.
- **404 on localhost:** ensure the folder is inside `htdocs` and use the matching URL.
- **PDO driver missing:** enable/install `pdo_mysql` for the PHP version used by Apache.
- **Login fails:** import `sql/sample_data.sql`; demo credentials are case-sensitive.
