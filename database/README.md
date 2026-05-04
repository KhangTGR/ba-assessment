# Database Setup and Analysis Guide

This guide provides instructions on how to set up the environment using Docker, connect via DBeaver, and perform initial data analysis using SQL.

## 1. Docker Compose Setup (Infrastructure)

Before connecting with DBeaver, you must spin up the database container.
```yaml
services:
  vcb-db-staging:
    image: postgres:17
    container_name: vcb_fraud_db
    environment:
      POSTGRES_USER: chi_ba_intern
      POSTGRES_PASSWORD: VcbPassword123
      POSTGRES_DB: vcb_digibank_staging
    ports:
      - "5432:5432"
    volumes:
      - ./init-db:/docker-entrypoint-initdb.d
```

**To start the database:**
1. Place your SQL scripts (`01_schema.sql`, `02_view.sql`, `03_data.sql`) inside an `init-db` folder.
2. Open your terminal in the project directory.
3. Run the command: `docker-compose up -d`.
4. Verify the logs show: `database system is ready to accept connections`.


## 2. DBeaver Connection Setup

To connect to the database system, follow these steps:

* **Database Type:** Select **PostgreSQL**.
* **Host:** `localhost`.
* **Port:** `5432`.
* **Database:** `vcb_digibank_staging`.
* **Username:** `chi_ba_intern`.
* **Password:** `VcbPassword123`.

**Note:** Click **Test Connection** to ensure the connection is successful before proceeding.

## 3. Schema Overview

The system consists of five main tables used for fraud detection analysis:

1.  **`users`**: Contains customer information and their `daily_limit`.
2.  **`atm_locations`**: Directory of ATM machines (check the `is_active` column for maintenance status).
3.  **`transactions`**: The primary transaction log.
4.  **`user_devices`**: List of trusted devices registered by customers.
5.  **`blacklist_ips`**: Suspected or malicious IP addresses.

## 4. SQL Examples for Business Analysts

View the 10 most recent transactions to understand the data structure:
```sql
SELECT * FROM transactions 
ORDER BY transaction_time DESC 
LIMIT 10;
```

Identify transactions exceeding the daily limit for Students:
```sql
SELECT u.full_name, u.customer_segment, t.amount, u.daily_limit
FROM transactions t
JOIN users u ON t.user_id = u.user_id
WHERE u.customer_segment = 'Student' AND t.amount > u.daily_limit;
```
