CREATE DATABASE loan_project;
USE loan_project;

CREATE TABLE loan_data (
loan_id INT PRIMARY KEY,
no_of_dependents INT,
education VARCHAR(50),
self_employed VARCHAR(10),
income_annum BIGINT,
loan_amount BIGINT,
loan_term INT,
cibil_score INT,
residential_assets_value BIGINT,
commercial_assets_value BIGINT,
luxury_assets_value BIGINT,
bank_asset_value BIGINT,
loan_status VARCHAR(20)
);

-- Total applicants
SELECT COUNT(*) AS total_applicants FROM loan_data;

-- Approval vs Rejection
SELECT loan_status, COUNT(*) AS total
FROM loan_data
GROUP BY loan_status;

-- Average income of approved customers
SELECT AVG(income_annum) AS avg_income
FROM loan_data
WHERE loan_status='Approved';

-- Average CIBIL by loan status
SELECT loan_status, AVG(cibil_score) avg_cibil
FROM loan_data
GROUP BY loan_status;

-- Top 5 highest loan amount customers
SELECT loan_id, loan_amount
FROM loan_data
ORDER BY loan_amount DESC
LIMIT 5;

-- Approval rate by education
SELECT education,
COUNT(CASE WHEN loan_status='Approved' THEN 1 END) AS approved
FROM loan_data
GROUP BY education;

-- Self employed approval count
SELECT self_employed, COUNT(*) total
FROM loan_data
WHERE loan_status='Approved'
GROUP BY self_employed;

-- High income but rejected
SELECT loan_id, income_annum, loan_status
FROM loan_data
WHERE income_annum > 5000000
AND loan_status='Rejected';

-- Average assets by loan status
SELECT loan_status,
AVG(residential_assets_value + commercial_assets_value +
luxury_assets_value + bank_asset_value) AS avg_assets
FROM loan_data
GROUP BY loan_status;

-- Dependents vs approval
SELECT no_of_dependents, COUNT(*) total
FROM loan_data
WHERE loan_status='Approved'
GROUP BY no_of_dependents;

-- Avg income > 5L by education
SELECT education, AVG(income_annum) avg_income
FROM loan_data
GROUP BY education
HAVING avg_income > 500000;

-- CIBIL > 700 groups
SELECT loan_status, AVG(cibil_score) avg_cibil
FROM loan_data
GROUP BY loan_status
HAVING avg_cibil > 700;

-- Create education table
CREATE TABLE education_info(
education VARCHAR(50),
risk_level VARCHAR(20)
);

INSERT INTO education_info VALUES
('Graduate','Low Risk'),
('Not Graduate','High Risk');

-- Join risk level with applicants
SELECT l.loan_id, l.education, e.risk_level
FROM loan_data l
LEFT JOIN education_info e
ON l.education = e.education;

-- Approval count by risk level
SELECT e.risk_level, COUNT(*) total
FROM loan_data l
LEFT JOIN education_info e
ON l.education=e.education
WHERE l.loan_status='Approved'
GROUP BY e.risk_level;

-- Loan amount greater than avg loan
SELECT loan_id, loan_amount
FROM loan_data
WHERE loan_amount >
(SELECT AVG(loan_amount) FROM loan_data);

-- Top CIBIL approved customers
SELECT loan_id, cibil_score
FROM loan_data
WHERE loan_status='Approved'
ORDER BY cibil_score DESC
LIMIT 10;





