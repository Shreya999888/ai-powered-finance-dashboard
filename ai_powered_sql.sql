CREATE DATABASE IF NOT EXISTS finance_project1;
USE finance_project1;

CREATE TABLE transactions (
    transaction_id   INT AUTO_INCREMENT PRIMARY KEY,
    transaction_date DATE NOT NULL,
    description      VARCHAR(255),
    category         VARCHAR(100),
    amount           DECIMAL(12,2) NOT NULL,
    transaction_type ENUM('Income','Expense') NOT NULL
);

LOAD DATA LOCAL INFILE 'C:/path/to/cleaned_finance_data.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(transaction_date, description, category, amount, transaction_type);

SELECT COUNT(*) AS total_rows, MIN(transaction_date) AS first_date, MAX(transaction_date) AS last_date
FROM transactions;

SELECT
  SUM(category IS NULL OR category = '') AS missing_category,
  SUM(description IS NULL OR description = '') AS missing_description,
  SUM(amount IS NULL) AS missing_amount
FROM transactions;

SELECT transaction_date, description, amount, COUNT(*) AS cnt
FROM transactions
GROUP BY transaction_date, description, amount
HAVING cnt > 1;

SELECT transaction_type, COUNT(*) AS txns, ROUND(SUM(amount),2) AS total
FROM transactions
GROUP BY transaction_type;

SELECT
  DATE_FORMAT(transaction_date, '%Y-%m') AS month,
  ROUND(SUM(CASE WHEN transaction_type='Income' THEN amount ELSE 0 END),2) AS income,
  ROUND(SUM(CASE WHEN transaction_type='Expense' THEN amount ELSE 0 END),2) AS expense,
  ROUND(SUM(CASE WHEN transaction_type='Income' THEN amount ELSE -amount END),2) AS net_savings
FROM transactions
GROUP BY month
ORDER BY month;

SELECT month, income, expense,
  ROUND((income - expense) / NULLIF(income,0) * 100, 2) AS savings_rate_pct
FROM (
  SELECT
    DATE_FORMAT(transaction_date,'%Y-%m') AS month,
    SUM(CASE WHEN transaction_type='Income' THEN amount ELSE 0 END) AS income,
    SUM(CASE WHEN transaction_type='Expense' THEN amount ELSE 0 END) AS expense
  FROM transactions
  GROUP BY month
) m
ORDER BY month;

SELECT category,
  ROUND(SUM(amount),2) AS total_spent,
  ROUND(SUM(amount) / SUM(SUM(amount)) OVER () * 100, 2) AS pct_of_expenses
FROM transactions
WHERE transaction_type = 'Expense'
GROUP BY category
ORDER BY total_spent DESC;

SELECT YEAR(transaction_date) AS year,
  ROUND(SUM(CASE WHEN transaction_type='Income' THEN amount ELSE 0 END),2) AS income,
  ROUND(SUM(CASE WHEN transaction_type='Expense' THEN amount ELSE 0 END),2) AS expense
FROM transactions
GROUP BY year
ORDER BY year;

SELECT transaction_date, description, category, amount
FROM transactions
WHERE transaction_type = 'Expense'
ORDER BY amount DESC
LIMIT 10;

WITH monthly AS (
  SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month, SUM(amount) AS expense
  FROM transactions
  WHERE transaction_type = 'Expense'
  GROUP BY month
)
SELECT month,
  ROUND(expense,2) AS expense,
  ROUND(LAG(expense) OVER (ORDER BY month),2) AS prev_month,
  ROUND((expense - LAG(expense) OVER (ORDER BY month))
        / NULLIF(LAG(expense) OVER (ORDER BY month),0) * 100, 2) AS mom_change_pct
FROM monthly;

WITH monthly AS (
  SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month,
    SUM(CASE WHEN transaction_type='Income' THEN amount ELSE -amount END) AS net
  FROM transactions
  GROUP BY month
)
SELECT month, ROUND(net,2) AS net,
  ROUND(SUM(net) OVER (ORDER BY month),2) AS cumulative_savings
FROM monthly;

WITH monthly AS (
  SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month, SUM(amount) AS expense
  FROM transactions
  WHERE transaction_type = 'Expense'
  GROUP BY month
)
SELECT month, ROUND(expense,2) AS expense,
  ROUND(AVG(expense) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_3m
FROM monthly;

SELECT year, category, total_spent,
  RANK() OVER (PARTITION BY year ORDER BY total_spent DESC) AS rank_in_year
FROM (
  SELECT YEAR(transaction_date) AS year, category, SUM(amount) AS total_spent
  FROM transactions
  WHERE transaction_type = 'Expense'
  GROUP BY year, category
) t;

WITH stats AS (
  SELECT category, AVG(amount) AS avg_amt, STDDEV(amount) AS std_amt
  FROM transactions
  WHERE transaction_type = 'Expense'
  GROUP BY category
)
SELECT t.transaction_date, t.description, t.category, t.amount,
  ROUND((t.amount - s.avg_amt) / NULLIF(s.std_amt,0), 2) AS z_score
FROM transactions t
JOIN stats s ON t.category = s.category
WHERE t.transaction_type = 'Expense'
  AND ABS((t.amount - s.avg_amt) / NULLIF(s.std_amt,0)) > 3
ORDER BY z_score DESC;

CREATE OR REPLACE VIEW vw_monthly_summary AS
SELECT
  DATE_FORMAT(transaction_date,'%Y-%m-01') AS month_start,
  YEAR(transaction_date) AS year,
  MONTH(transaction_date) AS month_num,
  SUM(CASE WHEN transaction_type='Income' THEN amount ELSE 0 END) AS income,
  SUM(CASE WHEN transaction_type='Expense' THEN amount ELSE 0 END) AS expense,
  SUM(CASE WHEN transaction_type='Income' THEN amount ELSE -amount END) AS net_savings
FROM transactions
GROUP BY month_start, year, month_num;

CREATE OR REPLACE VIEW vw_category_summary AS
SELECT YEAR(transaction_date) AS year, category,
  COUNT(*) AS txn_count,
  ROUND(SUM(amount),2) AS total_spent,
  ROUND(AVG(amount),2) AS avg_txn_amount
FROM transactions
WHERE transaction_type = 'Expense'
GROUP BY year, category;