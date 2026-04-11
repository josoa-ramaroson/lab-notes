# Task 2. Explore BigQuery console

```sql
SELECT end_station_name FROM `bigquery-public-data.london_bicycles.cycle_hire`;

SELECT * FROM `bigquery-public-data.london_bicycles.cycle_hire` WHERE duration>=1200;

```

# Task 3. Use additional SQL Keywords: GROUP BY, COUNT, AS, and ORDER BY
```sql
SELECT start_station_name FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;

SELECT start_station_name, COUNT(*) FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;

SELECT start_station_name, COUNT(*) AS num_starts FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name;

SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY start_station_name;

SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num;

SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC;
```

# Task 4. Export BigQuery data to CSV files
Extract a subset of the public dataset by :
```sql
SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC;
```

In the Query Results section, click Save **results > Local download > CSV**. Save the file as `start_station_name.csv`.

Clear the editor and execute this again:
```sql
SELECT end_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY end_station_name ORDER BY num DESC;
```
In the Query Results section, click Save **results > Local download > CSV**. Save the file as `end_station_name.csv`

Select **Navigation menu > Cloud Storage > Buckets**, and then click Create Bucket..

# Task 5. Create a Cloud SQL instance
Create a Development and multi regional instances from the cloud console

# Task 6. Create a Cloud SQL database and table
On the Cloud SQL page for your instance named **my-demo**, scroll to the section named **Connect to this instance**, and click **Open Cloud Shell**.

Execute this on the shell
```bash
gcloud sql connect my-demo --user=root --quiet
```

```sql 
CREATE DATABASE bike;
USE bike;

CREATE TABLE london1 (start_station_name VARCHAR(255), num INT);

USE bike;
CREATE TABLE london2 (end_station_name VARCHAR(255), num INT);

SELECT * FROM london1;
SELECT * FROM london2;
```

# Task 7. Upload CSV files to tables
1. In your Cloud SQL instance page, click **Import**.
2. Select **CSV** as File format.
3. In the Cloud Storage file field, click **Browse**, and then click the arrow next to your bucket name, and then click `start_station_data.csv`. Click **Select**.
4. Select the `bike` database, and type in `london1` as your table.
5. Click **Import**

# Task 8. Run data queries in Cloud SQL
```sql
INSERT INTO london1 (start_station_name, num) VALUES ("test destination", 1);
SELECT start_station_name AS top_stations, num FROM london1 WHERE num>100000
UNION
SELECT end_station_name, num FROM london2 WHERE num>100000
ORDER BY top_stations DESC;

```
