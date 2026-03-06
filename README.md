# 📊 Book Distribution Business Analytics

## Project Overview

This project presents an **end-to-end data analytics pipeline** designed to analyze the operations of a wholesale book distribution business operating between **Delhi suppliers and Kerala retailers**.

The objective of the project is to transform raw transactional data into **actionable business insights** using a structured **data warehouse, automated analytics pipeline, forecasting models, and dashboards**.

The system integrates **SQL Server, Python automation, and Prophet forecasting** to analyze business performance, supplier efficiency, logistics reliability, and revenue trends.

This project demonstrates how analytics can support **data-driven decision making in supply chain and retail distribution businesses**.

---

# 🏢 Business Problem

Wholesale distribution businesses deal with complex supply chains involving suppliers, logistics partners, and retailers.

Without proper analytics, it becomes difficult to answer important questions such as:

- Which books generate the most revenue?
- Which suppliers contribute the most profit?
- Which logistics providers deliver fastest?
- Which logistics partners cause the most damage?
- How does revenue change over time?
- What will future demand look like?

This project builds a **data-driven analytics system** to answer these questions using structured data analysis and forecasting.

---

# 📂 Dataset Description

### Dataset Period
September 2022 — January 2025

Each row represents a **single book line item within an order**.

### Key Columns

```
order_id
order_date
purchase_shop
logistics_provider
shipment_date
delivery_date
delivery_days
damage_flag
book_name
category
publisher
quantity
cost_per_unit
selling_price_per_unit
profit_per_unit_rupees
line_revenue
line_cost
line_profit
courier_charge
number_of_boxes
weight_kg
other_expenses
```

This dataset enables analysis of **financial performance, product sales, logistics efficiency, and supplier performance**.

---

# 🗄 Data Warehouse Architecture

A **Star Schema Data Warehouse** was implemented using **SQL Server**.

### Fact Table
```
fact_sales
```

Contains transactional data including:

- revenue
- cost
- profit
- order information
- logistics metrics

### Dimension Tables

```
dim_book
dim_supplier
dim_category
dim_logistics
dim_date
```

This dimensional model enables efficient analysis across multiple business dimensions such as **time, suppliers, product categories, and logistics providers**.

---

# 🔎 Business Analytics (SQL)

A set of **12 analytical SQL queries** were developed to answer core business questions.

These queries analyze:

1. Overall financial performance  
2. Revenue trends over time  
3. Top revenue generating books  
4. Category contribution to revenue  
5. Supplier profitability  
6. Logistics delivery performance  
7. Shipment damage rates  
8. Most profitable books  
9. Yearly revenue growth  
10. Highest value orders  
11. Supplier–logistics profit combinations  
12. Time series dataset for forecasting  

The results of these queries are automatically exported as **CSV outputs for reporting and forecasting**.

---

# ⚙️ Automation Pipeline

A Python automation script (`run_pipeline.py`) executes the entire analytics workflow.

### Pipeline Steps

1. Load raw CSV transaction data  
2. Insert data into SQL Server tables  
3. Execute analytical SQL queries  
4. Export query results automatically  
5. Create a time-series dataset  
6. Run forecasting models  
7. Save forecast outputs  

The pipeline ensures that whenever **new transactions are added**, all insights and forecasts are **automatically refreshed**.

---

# 📈 Forecasting

Time-series forecasting is implemented using **Facebook Prophet**.

### Forecasted Metrics

- Revenue
- Profit
- Orders
- Average delivery time
- Damage rate

The forecasting model helps anticipate **future demand patterns and operational performance**.

---

# 📊 Visualization

A **Power BI dashboard** was built to visualize key business insights including:

- Revenue trends
- Profit performance
- Supplier contribution
- Category performance
- Logistics efficiency
- Operational KPIs

The dashboard provides a clear overview of the **overall health and performance of the business**.

---

# 🏗 Project Architecture

```
Raw CSV Transactions
        │
        ▼
SQL Server Data Warehouse
(Star Schema)
        │
        ▼
SQL Business Analytics Queries
        │
        ▼
Python Automation Pipeline
(run_pipeline.py)
        │
        ▼
Time Series Dataset
        │
        ▼
Forecasting Model (Prophet)
        │
        ▼
Power BI Dashboard
```

---

# 📌 Key Business Insights

## Overall Financial Performance

The business generated **₹2.39M in revenue** with a **profit margin of 34.19%**, indicating strong procurement efficiency and effective pricing strategy.

---

## Revenue Trends

Revenue peaks during **mid-year and year-end periods**, indicating seasonal demand patterns.  
This insight helps optimize **inventory planning and supplier procurement timing**.

---

## Top Revenue Generating Books

Top titles include:

- **Gray’s Anatomy — ₹485,730**
- Naruto Vol 1
- One Piece

Although Naruto sold more units, **Gray’s Anatomy generated higher revenue due to higher pricing**.

---

## Category Revenue Contribution

| Category | Contribution |
|---------|--------------|
| Fiction | 32.28% |
| Manga | 21.94% |
| Medical | 20.31% |

Fiction and manga categories generate the largest share of revenue.

---

## Supplier Profit Contribution

Top suppliers contributing to profit:

- **Metro Book Distributors — ₹328,300**
- **Delhi Book Hub — ₹236,200**

These suppliers play a key role in overall profitability.

---

## Logistics Performance

| Provider | Avg Delivery |
|---------|--------------|
| IRCTC Cargo | 7 days |
| VR Logistics | ~9 days |
| SRB Logistics | ~9 days |

IRCTC Cargo delivers fastest but requires monitoring due to higher damage rates.

---

## Shipment Damage Rate

| Provider | Damage Rate |
|---------|--------------|
| IRCTC Cargo | 10.38% |
| VR Logistics | 3.41% |
| SRB Logistics | 3.51% |

VR Logistics shows significantly better shipment reliability.

---

## Most Profitable Books

- **Gray’s Anatomy — ₹114,900**
- **Naruto Vol 1 — ₹111,000**
- **The Silent Patient — ₹98,800**

Both academic and fiction books contribute strongly to profitability.

---

## Yearly Revenue Growth

| Year | Revenue |
|------|---------|
| 2022 | ₹336,746 |
| 2023 | ₹975,846 |
| 2024 | ₹1,000,678 |

The business shows **consistent growth over time**.

---

# 💡 Business Recommendations

Based on the analysis:

- Increase procurement of **high-margin academic books**
- Expand inventory in **fiction and manga categories**
- Prioritize **VR Logistics for safer shipments**
- Use **IRCTC Cargo mainly for urgent deliveries**
- Focus on **high-value bulk orders**
- Improve packaging to reduce shipment damage

These actions can improve **profitability, logistics efficiency, and customer satisfaction**.

---

# 🛠 Tech Stack

**Database**
- SQL Server

**Programming**
- Python
- Pandas
- PyODBC

**Machine Learning**
- Facebook Prophet

**Visualization**
- Power BI

**Automation**
- Python ETL Pipeline

---

# 🚀 Project Value

This project demonstrates the **complete analytics lifecycle**:

- Data Engineering
- Data Modeling
- Business Analytics
- Automation Pipelines
- Forecasting
- Dashboard Reporting

It highlights how businesses can transform operational data into **strategic business intelligence**.

---

# 👨‍💻 Author

**Shadin K**

BSc Statistics Graduate  
Data Analyst  

Skills:
SQL • Python • Power BI • Data Modeling • Forecasting
