from pyspark.sql import SparkSession
from pyspark.sql.functions import col, hour, avg, count, broadcast

# Create Spark session
spark = (
    SparkSession.builder
    .appName("Taxi Analysis")
    .getOrCreate()
)


# 1. Read data
trips = spark.read.parquet("gs://hw8-cs131-pp-3/data/yellow_tripdata_2022-01.parquet")

zones = spark.read.option("header", True).csv(
"gs://hw8-cs131-pp-3/data/taxi_zone_lookup.csv", header=True)
zones = zones.withColumn("LocationID", col("LocationID").cast("long"))


# 2. Filter rows
filtered_trips = trips.filter(
    (col("fare_amount") > 0) &
    (col("trip_distance") > 0) &
    col("PULocationID").isNotNull() &
    col("tpep_pickup_datetime").isNotNull()
)


# 3. Join (large + small table)
# Broadcast the small lookup table
joined = filtered_trips.join(
    broadcast(zones),
    filtered_trips.PULocationID == zones.LocationID,
    "inner"
)


# 4. Add pickup hour column
data = joined.withColumn(
    "pickup_hour",
    hour(col("tpep_pickup_datetime"))
)

data = data.filter(col("Borough").isNotNull())

# Analysis A: Hourly Activity
analysis_a = data.groupBy("Borough", "pickup_hour").agg(count("*").alias("trip_count")).orderBy("Borough", "pickup_hour")


# Analysis B: Fare/Tip Summary
data.createOrReplaceTempView("taxi_data")
analysis_b = spark.sql("""
    SELECT
        Borough,
        COUNT(*) AS trip_count,
        AVG(fare_amount) AS avg_fare,
        AVG(tip_amount) AS avg_tip
    FROM taxi_data
    GROUP BY Borough
    ORDER BY Borough
""")

# 5. Write output as Parquet
analysis_a.write.mode("overwrite").parquet("gs://hw8-cs131-pp-3/output/analysis_a")
analysis_b.write.mode("overwrite").parquet("gs://hw8-cs131-pp-3/output/analysis_b")

# Stop session
spark.stop()


