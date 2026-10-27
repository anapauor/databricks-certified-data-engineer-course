-- Databricks notebook source
-- MAGIC %md
-- MAGIC
-- MAGIC ## Lab: Querying Files

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Run the following cell to setup the lab environment

-- COMMAND ----------

-- MAGIC %run ../Includes/Setup-Lab

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.widgets.text("dataset_school", dataset_school)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Q1- Extracting data directly from Parquet files
-- MAGIC
-- MAGIC Use a SELECT statement to directly query the content of the Parquet files in the directory **${dataset.school}/enrollments**

-- COMMAND ----------

-- SELECT * FROM parquet.`:dataset.school/enrollments`
SELECT * FROM parquet.`/Volumes/workspace/DE_Associate_School/dataset/enrollments`;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Use the above SELECT query in a CTAS statement to create the table **enrollments**

-- COMMAND ----------

create table enrollments 
as 
SELECT * FROM parquet.`/Volumes/workspace/DE_Associate_School/dataset/enrollments`;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC Run the below cell to ensure data was written as expected in the **enrollments** table

-- COMMAND ----------

SELECT * FROM enrollments

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Q2- Registering Tables from JSON Files
-- MAGIC
-- MAGIC Use CTAS statement to create the table **students** from the json files in the directory: **${dataset.school}/students-json**
-- MAGIC

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS students
AS 
SELECT * FROM json.`/Volumes/workspace/DE_Associate_School/dataset/students-json`;



-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC Run the below cell to ensure data was written as expected in the **students** table

-- COMMAND ----------

SELECT * FROM students

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Q3- Registering Tables from CSV Files
-- MAGIC
-- MAGIC Create the manged table **courses** from the csv files in the directory: **${dataset_school}/courses-csv**
-- MAGIC
-- MAGIC Knowing that:
-- MAGIC * The delimiter is semicolon (**;**)
-- MAGIC * There is a header of column names in each file

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS courses
as
select * 
from read_files(
:dataset_school || '/courses-csv',
format => 'csv',
delimiter => ';',
header => 'true',
inferSchema => 'true'
)

-- COMMAND ----------

drop table students_csv;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Query the data in the **courses** table to ensure data was written as expected.

-- COMMAND ----------

select * from courses;


-- COMMAND ----------

-- MAGIC %md
-- MAGIC Run the below cell to ensure data was written as expected in the **courses** table

-- COMMAND ----------

SELECT * FROM courses

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC Finally, review the metadata information of the table **courses**, and verify that the table type is Managed

-- COMMAND ----------

DESCRIBE EXTENDED courses