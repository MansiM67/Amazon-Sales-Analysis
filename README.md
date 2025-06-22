# Amazon Sales Analysis | MySQL + Power BI Project

**Author:** [Mansi Mittal]  
**Date:** [22 June 2025]

---

## 📌 Project Background

This project analyzes Amazon India sales transaction data using **MySQL for backend processing** and **Power BI for dashboard visualization**.  
As a Data Analyst, the objective was to extract actionable insights to support product performance evaluation, fulfillment optimization, sales trend tracking, and region-specific marketing strategies.

The project delivers insights and recommendations in the following key areas:

- 📈 Monthly & Quarterly Sales Trends  
- 📦 Top-Selling Categories & Sizes  
- 🚚 Fulfillment Method Performance (FBA vs FBM)  
- ❌ Return & Cancellation Patterns  
- 🌍 State-wise Revenue Contribution  

Artifacts:  
- SQL Script: `project_AMAZON.sql`  
- Power BI Dashboard: `Amazon_Sales Dashboard.pbix`  

---

## 🧾 Dataset & Features

The dataset includes the following key columns:

- **order_id**, **order_date**, **category**, **size**
- **qty**, **amount**, **currency**, **fulfilled_by**, **sales_channel**
- **status_**, **fulfillment**, **ship_state**, **ship_city**
- **b2b**, **courier_status**

Key data preparation steps:

- Fixed invalid date values (`0000-00-00`) using `STR_TO_DATE`
- Created derived columns: `Year`, `Month`, `Order Tier`, `Fixed Date`
- Cleaned text inconsistencies and standardized null values
- Removed duplicates using `GROUP BY order_id`
- Filtered out invalid orders (zero quantity/amount)

---

## 🧪 SQL-Based Exploratory Analysis

All SQL analysis was conducted using **MySQL** to clean, transform, and extract insights from Amazon India’s order dataset.

---

### ✅ Time-Based Trends
- Monthly sales and revenue growth using `DATE_FORMAT()` and `GROUP BY`
- Identification of peak-performing months using `RANK()` and `SUM()`
- Running total of monthly sales using window functions

---

### ✅ Product Analysis
- Revenue contribution by product category (`category`)
- Quantity sold by category and size (`GROUP BY category, size`)
- Most popular size per category using `ROW_NUMBER()`
- Categories with high cancellation/return rates
- Cancellation percentage using `CASE WHEN` and `ROUND()`

---

### ✅ Fulfillment & Shipping
- Revenue and order count comparison between FBA and FBM
- Return and cancellation pattern by fulfillment method
- Analysis of `status_` against `fulfillment` type

---

### ✅ Customer Behavior
- Top 10 highest-spending customers by `SUM(amount)`
- Average order value (AOV) per state
- Customer ranking by frequency and revenue using `RANK()` and `COUNT(DISTINCT order_id)`
- Classification of orders into High, Medium, Low tiers by amount

---

### ✅ Regional Insights
- State-wise and city-wise revenue distribution
- Top-performing regions in terms of total sales
- Underperforming regions with low revenue
- Detection of month-over-month revenue drops by state using `LAG()`

---

### ✅ Operational & Strategic Metrics
- Sales breakdown by sales channel (Online vs Retail)
- Cancellations segmented by state and category
- Top 3 selling categories per state using window functions


---

## 🔍 Key Insights

- 📊 **Sales surged in Q4**, indicating strong seasonal performance.
- 👕 **T-Shirts and Jeans** contributed the highest to total revenue.
- 🚛 **FBA fulfillment** accounted for more than 60% of shipped orders.
- ❌ **Cancellation and return rates** were highest in `Trousers` and `Shirts`.
- 📍 **Maharashtra, Karnataka, and Delhi** led in sales volume and value.

---

## 📈 Dashboard Highlights (Power BI)

- 🔢 KPI Cards: Total Revenue, Order Count, Average Order Value, Cancellation %
- 📊 Line Chart: Monthly Sales Trend
- 📦 Bar Chart: Top Categories by Revenue
- 🚚 Donut Chart: Fulfillment Method Share (FBA vs FBM)
- 🌍 Filled Map: Revenue by State (India only)
- 🎛️ Slicers: Year, Category, Fulfillment, Status, Region

> Dashboard file: `Amazon_Sales Dashboard.pbix`


---

## ✅ Recommendations

- 📦 Increase stock for top-performing categories (e.g., T-Shirts)
- ⚙️ Prioritize **FBA** logistics for operational efficiency
- 🚫 Investigate high cancellation SKUs for quality/fit issues
- 🌐 Expand marketing efforts in underperforming states
- 📊 Monitor monthly sales slumps for demand-based forecasting

---

## ⚠️ Assumptions

- All amounts are assumed in **INR (₹)**
- `order_date` was cleaned and parsed via SQL using a fixed format
- Only **completed (shipped)** orders were included for final KPIs
- `ship_state` is assumed to reflect final delivery location

---

## 📬 Contact

- **Email:** mansiln67@gmail.com
- **LinkedIn:** https://www.linkedin.com/in/mansi-mittal-286493202?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BA8ldT6BzSSC6%2B%2F2WeZlwig%3D%3D 
- **GitHub:** https://github.com/MansiM67
- **Portfolio:** [Your Portfolio Website](https://yourportfolio.com)

---

⭐ If you found this project useful or insightful, please ⭐ star the repo and share!
