USE nrb_registration;
-- Demo account: username admin, password ChangeMe123! (change immediately after first login).
INSERT INTO users (username,password_hash,full_name) VALUES
('admin','$2y$12$YJ.j3en9fJdvIB3hjWRpbed8fPLk21y8b4ge28lW5oe/EAX5yKRN6','Demo Administrator')
ON DUPLICATE KEY UPDATE username=VALUES(username);
INSERT INTO applicants (applicant_no,first_name,last_name,date_of_birth,sex,phone,email,address,district,nationality,status) VALUES
('NRB-26-000101','Tadala','Phiri','1998-04-12','Female','+265 991 000 101','tadala.phiri@example.test','Area 12, Sample Street','Lilongwe','Malawian','Approved'),
('NRB-26-000102','Chisomo','Banda','2001-09-23','Male','+265 991 000 102','chisomo.banda@example.test','Plot 18, Fictional Road','Blantyre','Malawian','In Review'),
('NRB-26-000103','Thoko','Mbewe','1995-01-08','Female','+265 991 000 103','thoko.mbewe@example.test','House 4, Demo Avenue','Zomba','Malawian','Pending'),
('NRB-26-000104','Pempho','Zulu','1989-11-30','Other',NULL,'pempho.zulu@example.test','Test Area','Mzuzu','Malawian','Rejected')
ON DUPLICATE KEY UPDATE applicant_no=VALUES(applicant_no);
INSERT INTO registrations (applicant_id,registration_date,office_name,notes)
SELECT id, CASE applicant_no WHEN 'NRB-26-000101' THEN '2026-09-01' WHEN 'NRB-26-000102' THEN '2026-09-11' WHEN 'NRB-26-000103' THEN '2026-10-02' ELSE '2026-10-09' END, 'Main Registration Office', 'Fictional sample record' FROM applicants WHERE applicant_no IN ('NRB-26-000101','NRB-26-000102','NRB-26-000103','NRB-26-000104') ON DUPLICATE KEY UPDATE office_name=VALUES(office_name);
INSERT INTO id_cards (applicant_id,card_number,issue_date,expiry_date,status,notes)
SELECT id,'DEMO-ID-0001','2026-09-05','2036-09-04','Issued','Fictional demonstration card' FROM applicants WHERE applicant_no='NRB-26-000101' AND NOT EXISTS (SELECT 1 FROM id_cards WHERE card_number='DEMO-ID-0001');
INSERT INTO id_cards (applicant_id,card_number,issue_date,expiry_date,status,notes)
SELECT id,'DEMO-ID-0002',NULL,NULL,'Pending','Awaiting card production' FROM applicants WHERE applicant_no='NRB-26-000102' AND NOT EXISTS (SELECT 1 FROM id_cards WHERE card_number='DEMO-ID-0002');
