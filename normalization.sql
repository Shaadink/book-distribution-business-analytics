


CREATE TABLE dim_supplier (
    supplier_key INT IDENTITY(1,1) PRIMARY KEY,
    supplier_name NVARCHAR(150) NOT NULL
);



INSERT INTO dim_supplier (supplier_name)
SELECT DISTINCT purchase_shop
FROM books1
WHERE purchase_shop IS NOT NULL;



SELECT * FROM dim_supplier;





CREATE TABLE dim_logistics (
    logistics_key INT IDENTITY(1,1) PRIMARY KEY,
    logistics_provider_name NVARCHAR(150) NOT NULL
);



INSERT INTO dim_logistics (logistics_provider_name)
SELECT DISTINCT logistics_provider
FROM books1
WHERE logistics_provider IS NOT NULL;


SELECT * FROM dim_logistics;





CREATE TABLE dim_category (
    category_key INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL
);


INSERT INTO dim_category (category_name)
SELECT DISTINCT category
FROM books1
WHERE category IS NOT NULL;


SELECT * FROM dim_category;







CREATE TABLE dim_book (
    book_key INT IDENTITY(1,1) PRIMARY KEY,
    book_name NVARCHAR(300) NOT NULL,
    publisher NVARCHAR(150),
    category_key INT,
    FOREIGN KEY (category_key) REFERENCES dim_category(category_key)
);




INSERT INTO dim_book (book_name, publisher, category_key)
SELECT DISTINCT 
    r.book_name,
    r.publisher,
    c.category_key
FROM books1 r
JOIN dim_category c
    ON r.category = c.category_name;


SELECT TOP 10 * FROM dim_book;





CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT,
    month INT,
    month_name NVARCHAR(20),
    quarter INT,
    day_of_week NVARCHAR(20),
    week_number INT
);


INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    month,
    month_name,
    quarter,
    day_of_week,
    week_number
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(order_date, 'yyyyMMdd')) AS date_key,
    order_date,
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date),
    DATEPART(QUARTER, order_date),
    DATENAME(WEEKDAY, order_date),
    DATEPART(WEEK, order_date)
FROM books1
WHERE order_date IS NOT NULL;


SELECT TOP 10 * FROM dim_date ORDER BY full_date;




CREATE TABLE fact_sales (
    sales_key INT IDENTITY(1,1) PRIMARY KEY,
    order_id NVARCHAR(20),

    date_key INT,
    supplier_key INT,
    logistics_key INT,
    book_key INT,

    quantity INT,
    cost_per_unit DECIMAL(12,2),
    selling_price_per_unit DECIMAL(12,2),
    profit_per_unit_rupees DECIMAL(12,2),

    line_revenue DECIMAL(14,2),
    line_cost DECIMAL(14,2),
    line_profit DECIMAL(14,2),

    delivery_days INT,
    damage_flag INT,

    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (supplier_key) REFERENCES dim_supplier(supplier_key),
    FOREIGN KEY (logistics_key) REFERENCES dim_logistics(logistics_key),
    FOREIGN KEY (book_key) REFERENCES dim_book(book_key)
);



INSERT INTO fact_sales (
    order_id,
    date_key,
    supplier_key,
    logistics_key,
    book_key,
    quantity,
    cost_per_unit,
    selling_price_per_unit,
    profit_per_unit_rupees,
    line_revenue,
    line_cost,
    line_profit,
    delivery_days,
    damage_flag
)
SELECT
    r.order_id,
    d.date_key,
    s.supplier_key,
    l.logistics_key,
    b.book_key,
    r.quantity,
    r.cost_per_unit,
    r.selling_price_per_unit,
    r.profit_per_unit_rupees,
    r.line_revenue,
    r.line_cost,
    r.line_profit,
    r.delivery_days,
    r.damage_flag
FROM books1 r
JOIN dim_date d
    ON r.order_date = d.full_date
JOIN dim_supplier s
    ON r.purchase_shop = s.supplier_name
JOIN dim_logistics l
    ON r.logistics_provider = l.logistics_provider_name
JOIN dim_book b
    ON r.book_name = b.book_name;


SELECT COUNT(*) FROM fact_sales;

SELECT TOP 5 * FROM fact_sales;




CREATE TABLE fact_order_summary (
    order_id NVARCHAR(20) PRIMARY KEY,
    shipment_date_key INT,
    delivery_date_key INT,

    courier_charge DECIMAL(14,2),
    number_of_boxes INT,
    weight_kg DECIMAL(12,2),
    other_expenses DECIMAL(14,2),

    FOREIGN KEY (shipment_date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (delivery_date_key) REFERENCES dim_date(date_key)
);



INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    month,
    month_name,
    quarter,
    day_of_week,
    week_number
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(shipment_date, 'yyyyMMdd')),
    shipment_date,
    YEAR(shipment_date),
    MONTH(shipment_date),
    DATENAME(MONTH, shipment_date),
    DATEPART(QUARTER, shipment_date),
    DATENAME(WEEKDAY, shipment_date),
    DATEPART(WEEK, shipment_date)
FROM books1
WHERE shipment_date IS NOT NULL
AND shipment_date NOT IN (SELECT full_date FROM dim_date);




INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    month,
    month_name,
    quarter,
    day_of_week,
    week_number
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(delivery_date, 'yyyyMMdd')),
    delivery_date,
    YEAR(delivery_date),
    MONTH(delivery_date),
    DATENAME(MONTH, delivery_date),
    DATEPART(QUARTER, delivery_date),
    DATENAME(WEEKDAY, delivery_date),
    DATEPART(WEEK, delivery_date)
FROM books1
WHERE delivery_date IS NOT NULL
AND delivery_date NOT IN (SELECT full_date FROM dim_date);



CREATE TABLE fact_order_summary (
    order_id NVARCHAR(20) PRIMARY KEY,
    shipment_date_key INT,
    delivery_date_key INT,
    courier_charge DECIMAL(14,2),
    number_of_boxes INT,
    weight_kg DECIMAL(12,2),
    other_expenses DECIMAL(14,2),
    FOREIGN KEY (shipment_date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (delivery_date_key) REFERENCES dim_date(date_key)
);




INSERT INTO fact_order_summary (
    order_id,
    shipment_date_key,
    delivery_date_key,
    courier_charge,
    number_of_boxes,
    weight_kg,
    other_expenses
)
SELECT
    r.order_id,
    ds.date_key,
    dd.date_key,
    MAX(r.courier_charge),
    MAX(r.number_of_boxes),
    MAX(r.weight_kg),
    MAX(r.other_expenses)
FROM books1 r
JOIN dim_date ds
    ON r.shipment_date = ds.full_date
JOIN dim_date dd
    ON r.delivery_date = dd.full_date
GROUP BY
    r.order_id,
    ds.date_key,
    dd.date_key;




    TRUNCATE TABLE fact_order_summary;


SELECT COUNT(*) FROM fact_order_summary;

SELECT COUNT(DISTINCT order_id) FROM books1;



SELECT 
    SUM(line_revenue) AS Total_Revenue,
    SUM(line_cost) AS Total_Cost,
    SUM(line_profit) AS Total_Profit,
    ROUND(
        (SUM(line_profit) * 100.0 / SUM(line_revenue)), 2
    ) AS Profit_Margin_Percentage
FROM fact_sales;




SELECT 
    d.year,
    d.month,
    SUM(f.line_revenue) AS Monthly_Revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
