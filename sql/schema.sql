-- NRB National ID Registration System
-- Import into MySQL 8+ / MariaDB 10.4+ using phpMyAdmin or CLI.
CREATE DATABASE IF NOT EXISTS nrb_registration CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nrb_registration;
CREATE TABLE IF NOT EXISTS users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 username VARCHAR(60) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 full_name VARCHAR(120) NOT NULL,
 is_active TINYINT(1) NOT NULL DEFAULT 1,
 last_login DATETIME NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS applicants (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 applicant_no VARCHAR(30) NOT NULL UNIQUE,
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(100) NOT NULL,
 date_of_birth DATE NOT NULL,
 sex ENUM('Female','Male','Other') NOT NULL,
 phone VARCHAR(25) NULL,
 email VARCHAR(150) NULL,
 address VARCHAR(255) NULL,
 district VARCHAR(100) NULL,
 nationality VARCHAR(80) NOT NULL DEFAULT 'Malawian',
 status ENUM('Pending','In Review','Approved','Rejected') NOT NULL DEFAULT 'Pending',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX idx_applicant_name (last_name, first_name), INDEX idx_applicant_status (status), INDEX idx_applicant_phone (phone)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS registrations (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 applicant_id INT UNSIGNED NOT NULL UNIQUE,
 registration_date DATE NOT NULL,
 office_name VARCHAR(120) NOT NULL,
 notes VARCHAR(500) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_registration_applicant FOREIGN KEY (applicant_id) REFERENCES applicants(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS id_cards (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 applicant_id INT UNSIGNED NOT NULL,
 card_number VARCHAR(40) NOT NULL UNIQUE,
 issue_date DATE NULL,
 expiry_date DATE NULL,
 status ENUM('Pending','Printed','Issued','Lost','Expired','Cancelled') NOT NULL DEFAULT 'Pending',
 notes VARCHAR(500) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX idx_card_applicant (applicant_id), INDEX idx_card_status (status),
 CONSTRAINT fk_card_applicant FOREIGN KEY (applicant_id) REFERENCES applicants(id) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT chk_card_dates CHECK (issue_date IS NULL OR expiry_date IS NULL OR expiry_date >= issue_date)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS audit_logs (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NULL,
 applicant_id INT UNSIGNED NULL,
 action VARCHAR(60) NOT NULL,
 details VARCHAR(250) NULL,
 ip_address VARCHAR(45) NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_audit_created (created_at), INDEX idx_audit_applicant (applicant_id),
 CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;
