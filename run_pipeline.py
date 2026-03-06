
import pyodbc
import pandas as pd
from prophet import Prophet

print("Starting Complete Data Pipeline...")

# ------------------------------------
# STEP 1: Connect to SQL Server
# ------------------------------------

conn = pyodbc.connect(
    r"Driver={SQL Server};"
    r"Server=LAPTOP-NTDJQAQE\SQLEXPRESS;"
    r"Database=book_dw_clean3;"
    r"Trusted_Connection=yes;"
)

cursor = conn.cursor()

print("Connected to SQL Server")


# ------------------------------------
# STEP 2: LOAD CSV INTO SQL TABLE
# ------------------------------------

print("Loading CSV data into SQL...")

cursor.execute("TRUNCATE TABLE books1")

csv_file = "fact_sales.csv"

df_csv = pd.read_csv(csv_file)

for index, row in df_csv.iterrows():

    cursor.execute("""
    INSERT INTO books1 (
        order_id,
        order_date,
        purchase_shop,
        logistics_provider,
        shipment_date,
        delivery_date,
        delivery_days,
        damage_flag,
        book_name,
        category,
        publisher,
        quantity,
        cost_per_unit,
        profit_per_unit_rupees,
        selling_price_per_unit,
        line_revenue,
        line_cost,
        line_profit,
        courier_charge,
        number_of_boxes,
        weight_kg,
        other_expenses
    )
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    """,

    row.order_id,
    row.order_date,
    row.purchase_shop,
    row.logistics_provider,
    row.shipment_date,
    row.delivery_date,
    row.delivery_days,
    row.damage_flag,
    row.book_name,
    row.category,
    row.publisher,
    row.quantity,
    row.cost_per_unit,
    row.profit_per_unit_rupees,
    row.selling_price_per_unit,
    row.line_revenue,
    row.line_cost,
    row.line_profit,
    row.courier_charge,
    row.number_of_boxes,
    row.weight_kg,
    row.other_expenses
    )

conn.commit()

print("CSV successfully loaded into SQL")


# ------------------------------------
# STEP 3: RUN SQL ANALYSIS QUERIES
# ------------------------------------

print("Running analysis queries...")

with open("analysis.sql", "r") as file:
    analysis_script = file.read()

queries = analysis_script.split(";")

for i, query in enumerate(queries):

    if query.strip():

        try:

            df_query = pd.read_sql(query, conn)

            filename = f"query_result_{i+1}.csv"

            df_query.to_csv(filename, index=False)

            print(f"Saved {filename}")

        except:
            print(f"Query {i+1} executed")


print("SQL analysis completed")


# ------------------------------------
# STEP 4: EXPORT TIME SERIES DATASET
# ------------------------------------

summary_query = """
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
ORDER BY d.full_date
"""

summary_df = pd.read_sql(summary_query, conn)

summary_df.to_csv("business_timeseries.csv", index=False)

print("Time series dataset exported")

conn.close()


# ------------------------------------
# STEP 5: FORECASTING
# ------------------------------------

print("Forecasting started")

df = pd.read_csv("business_timeseries.csv")

df['full_date'] = pd.to_datetime(df['full_date'])

monthly_df = df.resample("ME", on="full_date").sum().reset_index()


def run_forecast(column_name, file_name):

    data = monthly_df[['full_date', column_name]].rename(
        columns={'full_date':'ds', column_name:'y'}
    )

    model = Prophet()

    model.fit(data)

    future = model.make_future_dataframe(periods=6, freq='ME')

    forecast = model.predict(future)

    forecast[['ds','yhat','yhat_lower','yhat_upper']].to_csv(file_name, index=False)

    print(f"{column_name} forecast saved")


run_forecast("revenue","forecast_revenue.csv")
run_forecast("profit","forecast_profit.csv")
run_forecast("orders","forecast_orders.csv")
run_forecast("avg_delivery_days","forecast_delivery_days.csv")
run_forecast("damage_rate","forecast_damage_rate.csv")

print("Pipeline Finished Successfully")