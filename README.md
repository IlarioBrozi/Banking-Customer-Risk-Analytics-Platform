# Banking Customer & Risk Analytics Platform

A SQL + BI banking analytics project simulating a real-world retail banking data mart focused on **customer profitability, credit risk, fraud detection, and transaction behavior analysis**.

---

## Business Context

Retail banks need to balance **profitability and risk exposure** across millions of customers.

This project simulates a banking analytics environment to answer:

- Who are the most profitable customers?
- Which customers present high credit risk?
- What patterns indicate fraud or anomalies?
- How do deposits compare to loan exposure?
- Which provinces show higher financial risk?
- Which channels drive risky behavior?

---

## Data Model

This project uses a simplified banking data mart with 4 core tables:

### customers
- customer_id  
- age  
- province  
- employment_status  
- credit_score  
- income  

### accounts
- account_id  
- customer_id  
- account_type  
- balance  
- open_date  
- status  

### transactions
- transaction_id  
- account_id  
- transaction_date  
- amount  
- transaction_type  
- channel  

### loans
- loan_id  
- customer_id  
- loan_type  
- amount  
- interest_rate  
- status  

---

## Tech Stack

- SQL (PostgreSQL / MySQL compatible)
- Data modeling (star-schema style thinking)
- BI tools (Power BI)
- Analytical techniques (risk, fraud, segmentation)

---
