-- 1. Overall Financial Performance
SELECT 
    SUM(line_revenue) AS Total_Revenue,
    SUM(line_cost) AS Total_Cost,
    SUM(line_profit) AS Total_Profit,
    ROUND(SUM(line_profit)*100.0/SUM(line_revenue),2) AS Profit_Margin_Percent
FROM fact_sales;


-- 2. Revenue Over Time
SELECT 
    d.year,
    d.month,
    SUM(f.line_revenue) AS Monthly_Revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;


-- 3. Top Revenue Generating Books
SELECT TOP 10
    b.book_name,
    SUM(f.quantity) AS Total_Quantity_Sold,
    SUM(f.line_revenue) AS Total_Revenue
FROM fact_sales f
JOIN dim_book b
ON f.book_key = b.book_key
GROUP BY b.book_name
ORDER BY Total_Revenue DESC;


-- 4. Revenue Contribution by Category
SELECT 
    c.category_name,
    SUM(f.line_revenue) AS Revenue,
    ROUND(
        SUM(f.line_revenue)*100.0/
        (SELECT SUM(line_revenue) FROM fact_sales),2
    ) AS Revenue_Percentage
FROM fact_sales f
JOIN dim_book b
ON f.book_key=b.book_key
JOIN dim_category c
ON b.category_key=c.category_key
GROUP BY c.category_name
ORDER BY Revenue DESC;


-- 5. Supplier Profit Contribution
SELECT 
    s.supplier_name,
    SUM(f.line_revenue) AS Revenue,
    SUM(f.line_profit) AS Profit
FROM fact_sales f
JOIN dim_supplier s
ON f.supplier_key=s.supplier_key
GROUP BY s.supplier_name
ORDER BY Profit DESC;


-- 6. Fastest Logistics Provider
SELECT 
    l.logistics_provider_name,
    AVG(f.delivery_days) AS Avg_Delivery_Days
FROM fact_sales f
JOIN dim_logistics l
ON f.logistics_key=l.logistics_key
GROUP BY l.logistics_provider_name
ORDER BY Avg_Delivery_Days;


-- 7. Logistics Provider Damage Rate
SELECT 
    l.logistics_provider_name,
    SUM(f.damage_flag) AS Damaged_Orders,
    COUNT(*) AS Total_Shipments,
    ROUND(SUM(f.damage_flag)*100.0/COUNT(*),2) AS Damage_Rate_Percent
FROM fact_sales f
JOIN dim_logistics l
ON f.logistics_key=l.logistics_key
GROUP BY l.logistics_provider_name
ORDER BY Damage_Rate_Percent DESC;


-- 8. Most Profitable Books
SELECT TOP 10
    b.book_name,
    SUM(f.line_profit) AS Total_Profit
FROM fact_sales f
JOIN dim_book b
ON f.book_key=b.book_key
GROUP BY b.book_name
ORDER BY Total_Profit DESC;


-- 9. Yearly Revenue Growth
SELECT 
    d.year,
    SUM(f.line_revenue) AS Revenue,
    LAG(SUM(f.line_revenue)) 
        OVER (ORDER BY d.year) AS Previous_Year_Revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_key=d.date_key
GROUP BY d.year
ORDER BY d.year;


-- 10. Top Orders by Revenue
SELECT TOP 10
    order_id,
    SUM(line_revenue) AS Order_Revenue
FROM fact_sales
GROUP BY order_id
ORDER BY Order_Revenue DESC;


-- 11. Supplier + Logistics Profit Combination
SELECT 
    s.supplier_name,
    l.logistics_provider_name,
    SUM(f.line_profit) AS Total_Profit
FROM fact_sales f
JOIN dim_supplier s
ON f.supplier_key=s.supplier_key
JOIN dim_logistics l
ON f.logistics_key=l.logistics_key
GROUP BY 
    s.supplier_name,
    l.logistics_provider_name
ORDER BY Total_Profit DESC;


-- 12. Summary Table for Forecasting
SELECT 
    d.full_date,
    SUM(f.line_revenue) AS revenue,
    SUM(f.line_profit) AS profit,
    COUNT(DISTINCT f.order_id) AS orders,
    AVG(f.delivery_days) AS avg_delivery_days,
    AVG(f.damage_flag*1.0) AS damage_rate
FROM fact_sales f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.full_date
ORDER BY d.full_date;