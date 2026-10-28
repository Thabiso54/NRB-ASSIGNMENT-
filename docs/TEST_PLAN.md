# Test plan and evidence checklist

Use fictional data only. Capture screenshots from your own running application; do not submit invented evidence.

| ID | Feature | Test steps | Expected result | Evidence |
|---|---|---|---|---|
| T01 | Login | Sign in with `admin` and demo password | Dashboard appears; session is established | `01-dashboard.png` |
| T02 | Applicant creation | Register a fictional person with valid required fields | Success message; applicant number generated; registration row created | `02-registration-success.png` |
| T03 | Required validation | Submit blank first name or last name | Inline validation message; no record inserted | `03-required-validation.png` |
| T04 | Date validation | Enter a future date of birth | Form rejects the date | `04-invalid-date.png` |
| T05 | Listing/search | Search by applicant number and by name | Only matching records appear; JOIN shows registration date | `05-applicant-search.png` |
| T06 | Edit applicant | Change district/status and save | Updated values persist in database | `06-edit-applicant.png` |
| T07 | Card issuance | Create card with a fictional unique card number, status Issued and issue date | Card appears in list and applicant details | `07-card-issued.png` |
| T08 | Card date validation | Set expiry earlier than issue date | Form rejects the date range | `08-card-date-validation.png` |
| T09 | Duplicate constraint | Attempt duplicate applicant number or card number directly in SQL | UNIQUE constraint rejects duplicate; UI shows a safe message when applicable | `09-duplicate-constraint.png` |
| T10 | Prepared search | Search using punctuation such as `' OR 1=1 --` | Treated as search text; does not reveal all records | `10-safe-search.png` |
| T11 | Deletion | Type DELETE into the applicant deletion confirmation | Applicant and related records are deleted under FK rules | `11-delete-confirmation.png` |
| T12 | DB unavailable | Stop MySQL and reload app | Clear generic connection error; detailed exception is logged server-side | `12-db-error.png` |

## Database verification queries
```sql
SELECT COUNT(*) FROM applicants;
SELECT a.applicant_no, a.first_name, a.last_name, r.registration_date
FROM applicants a LEFT JOIN registrations r ON r.applicant_id = a.id;
SELECT a.applicant_no, c.card_number, c.status
FROM applicants a JOIN id_cards c ON c.applicant_id = a.id;
SELECT action, details, created_at FROM audit_logs ORDER BY id DESC;
```

## Demonstration narrative
1. Explain that the browser sends form data to PHP; PHP validates it and executes PDO prepared statements against MySQL/MariaDB.
2. Register a fictional applicant, show the generated applicant number and related registration record.
3. Search for the record and open the detail page; edit a field and show it persisted.
4. Record an ID card with an issue date and `Issued` status; show it in both card management and applicant details.
5. Demonstrate invalid input and a duplicate key constraint.
6. Explain GitHub is used for source control; GitHub Pages alone cannot execute this PHP/MySQL application.
