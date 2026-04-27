# Homework 8 – PySpark Distributed Run on GCP

## Analysis Description

### Analysis A: Hourly Activity

This analysis examines taxi activity by time of day and location.
The dataset is grouped by **Borough** and **pickup hour**, and the total number of trips is counted for each combination.

Output fields:

* Borough
* pickup_hour
* trip_count

---

### Analysis B: Fare and Tip Summary

This analysis summarizes fare and tipping behavior across locations.
The dataset is grouped by **Borough**, and the following metrics are computed:

* total number of trips
* average fare amount
* average tip amount

This analysis is implemented using **Spark SQL**.

---

## Commands Used to Run the Job

```bash
export REGION=us-west1
export BUCKET=hw8-cs131-pp-3
export CODE_URI=gs://$BUCKET/code/pyspark_job.py

# Upload script to GCS
gsutil cp hw8/pyspark_job.py $CODE_URI

# Submit Dataproc Serverless job
gcloud dataproc batches submit pyspark "$CODE_URI" \
  --region="$REGION" \
  --deps-bucket="gs://$BUCKET"
```

---

## GCS Output Paths

The results are written to the following locations in Google Cloud Storage:

* gs://hw8-cs131-pp-3/output/analysis_a/
* gs://hw8-cs131-pp-3/output/analysis_b/

---

## Local vs Distributed Execution

When running PySpark locally, it is easier to iterate quickly and debug small pieces of logic, since everything runs on a single machine with immediate feedback. However, it can be difficult to observe how operations scale or how data is physically processed.

In contrast, distributed execution using Dataproc Serverless provides insight into how large-scale data processing works. Tasks such as joins and aggregations are split across multiple executors, and operations like shuffling and broadcasting become visible in the Spark UI. While setup and debugging are more complex in the cloud environment, it better reflects real-world data engineering workflows and highlights performance considerations such as data movement and parallelism.
