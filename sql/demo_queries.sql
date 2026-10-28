USE nrb_registration;
-- 1. List applicant and registration details with JOIN.
SELECT a.applicant_no,a.first_name,a.last_name,a.date_of_birth,a.status,r.registration_date,r.office_name
FROM applicants a LEFT JOIN registrations r ON r.applicant_id=a.id ORDER BY a.last_name;
-- 2. Search by applicant number (prepared statement placeholder in PHP: WHERE applicant_no = ?).
SELECT * FROM applicants WHERE applicant_no='NRB-26-000101';
-- 3. Search by name fragment (PHP binds %term%).
SELECT * FROM applicants WHERE first_name LIKE '%Tadala%' OR last_name LIKE '%Tadala%';
-- 4. Display card issuance records with applicant names.
SELECT a.applicant_no,CONCAT(a.first_name,' ',a.last_name) AS applicant,c.card_number,c.issue_date,c.expiry_date,c.status
FROM applicants a JOIN id_cards c ON c.applicant_id=a.id;
-- 5. Demonstrate UPDATE using fictional sample data. Run deliberately, then inspect.
UPDATE applicants SET district='Lilongwe' WHERE applicant_no='NRB-26-000103';
-- 6. Demonstrate controlled DELETE on a test row only; related records cascade.
-- DELETE FROM applicants WHERE applicant_no='NRB-26-000104';
-- 7. Integrity checks: duplicate applicant number should fail due to UNIQUE.
-- INSERT INTO applicants (applicant_no,first_name,last_name,date_of_birth,sex) VALUES ('NRB-26-000101','Duplicate','Demo','2000-01-01','Other');
