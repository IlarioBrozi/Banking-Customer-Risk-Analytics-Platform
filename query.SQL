/* ============================================================
   BANKING ANALYTICS & RISK MONITORING PROJECT
   ============================================================

   Objective:
   Build a banking analytics layer to monitor:

   1. Deposit vs Loan Exposure
   2. Customer Profitability
   3. Credit Risk Segmentation
   4. Regional Risk Analysis
   5. Transaction Behavior
   6. Fraud / Anomaly Detection
   7. Debt-to-Income Risk
   8. Customer Segmentation
   9. Account Dormancy
   10. Daily Banking Activity KPIs

   Tables:
   - customers
   - accounts
   - loans
   - transactions

============================================================ */

/* ============================================================
   KPI 1: TOTAL DEPOSITS VS LOAN EXPOSURE
    How much money has the bank collected in deposits versus how much has been lent out?
============================================================ */

SELECT
    (SELECT SUM(balance) FROM accounts) AS total_deposits,
    (SELECT SUM(amount) FROM loans) AS total_loans;


/* ============================================================
   KPI 2: CUSTOMER NET VALUE
    Which customers have the strongest financial position?
============================================================ */

SELECT
    c.customer_id,
    c.income,

    COALESCE(a.total_deposits,0) AS total_deposits,
    COALESCE(l.total_loans,0) AS total_loans,

    COALESCE(a.total_deposits,0) - COALESCE(l.total_loans,0)
      AS net_value

FROM customers c

LEFT JOIN
(
    SELECT
        customer_id,
        SUM(balance) AS total_deposits
    FROM accounts
    GROUP BY customer_id
) a
ON c.customer_id = a.customer_id

LEFT JOIN
(
    SELECT
        customer_id,
        SUM(amount) AS total_loans
    FROM loans
    GROUP BY customer_id
) l
ON c.customer_id = l.customer_id;



/* ============================================================
   KPI 3: CREDIT RISK SEGMENTATION
    How risky is each customer based on credit score?
============================================================ */

SELECT
    customer_id,
    credit_score,

    CASE
        WHEN credit_score < 650 THEN 'HIGH RISK'
        WHEN credit_score BETWEEN 650 AND 720 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_segment

FROM customers;

/* ============================================================
   KPI 4: PROVINCE RISK EXPOSURE
    Which provinces contain higher concentrations of risky customers?
============================================================ */

SELECT
    province,
    AVG(credit_score) AS avg_credit_score,
    COUNT(*) AS customer_count

FROM customers

GROUP BY province

ORDER BY avg_credit_score ASC;

/* ============================================================
   KPI 5: TRANSACTION BEHAVIOR ANALYSIS
    How active is each account?
============================================================ */

SELECT
    account_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_volume,
    AVG(amount) AS avg_transaction_amount

FROM transactions

GROUP BY account_id;

/* ============================================================
   ADVANCED ANALYTICS 1:
   FRAUD / ANOMALY DETECTION
    Which transactions are significantly larger than normal?
============================================================ */

SELECT
    *,

    CASE
        WHEN amount >
        (
            SELECT
                AVG(amount) + (2 * STDDEV(amount))
            FROM transactions
        )
        THEN 'SUSPICIOUS'

        ELSE 'NORMAL'
    END AS anomaly_flag

FROM transactions;

/* Logic

A transaction is flagged when it exceeds:

Average Transaction Amount + 2 Standard Deviations

This identifies statistically unusual activity that may require investigation./*

/* ============================================================
   ADVANCED ANALYTICS 2:
   DEBT-TO-INCOME ANALYSIS
    Which customers carry excessive debt relative to income?
============================================================ */

SELECT
    c.customer_id,

    COALESCE(SUM(l.amount),0) AS total_debt,

    c.income,

    ROUND(
        COALESCE(SUM(l.amount),0)
        / NULLIF(c.income,0),
        2
    ) AS debt_to_income_ratio

FROM customers c

LEFT JOIN loans l
ON c.customer_id = l.customer_id

GROUP BY
    c.customer_id,
    c.income

ORDER BY debt_to_income_ratio DESC;

/* ============================================================
   ADVANCED ANALYTICS 3:
   CUSTOMER SEGMENTATION
    How should customers be categorized based on wealth and liabilities?
============================================================ */

SELECT
    c.customer_id,

    COALESCE(a.total_deposits,0) AS deposits,
    COALESCE(l.total_loans,0) AS loans,

    CASE

        WHEN
        COALESCE(a.total_deposits,0)
        - COALESCE(l.total_loans,0) > 20000
        THEN 'WEALTHY'

        WHEN
        COALESCE(l.total_loans,0)
        >
        COALESCE(a.total_deposits,0)
        THEN 'HIGH LIABILITY'

        ELSE 'STANDARD'

    END AS customer_segment

FROM customers c

LEFT JOIN
(
    SELECT
        customer_id,
        SUM(balance) AS total_deposits
    FROM accounts
    GROUP BY customer_id
) a
ON c.customer_id = a.customer_id

LEFT JOIN
(
    SELECT
        customer_id,
        SUM(amount) AS total_loans
    FROM loans
    GROUP BY customer_id
) l
ON c.customer_id = l.customer_id;

/* ============================================================
   ADVANCED ANALYTICS 4:
   ACCOUNT DORMANCY
    Which accounts are inactive?
============================================================ */

SELECT
    account_id,
    status,

    CASE
        WHEN status = 'dormant'
        THEN 1
        ELSE 0
    END AS dormancy_flag

FROM accounts;

/* ============================================================
   ADVANCED ANALYTICS 5:
   DAILY BANKING KPI
    How is transaction volume evolving over time?
============================================================ */

SELECT

    DATE(transaction_date) AS day,

    COUNT(*) AS transaction_count,

    SUM(amount) AS daily_volume,

    SUM(SUM(amount))
        OVER (
            ORDER BY DATE(transaction_date)
        ) AS cumulative_volume

FROM transactions

GROUP BY DATE(transaction_date)

ORDER BY day;

/* ============================================================

This project demonstrates:

SQL Aggregations (SUM, AVG, COUNT)
Window Functions (OVER)
Risk Analytics
Fraud Detection Logic
Customer Segmentation
Banking KPIs
Financial Ratio Analysis
NULL Handling (COALESCE)
Safe Division (NULLIF)
Multi-table Joins
Business-Oriented SQL Reporting

============================================================ */
