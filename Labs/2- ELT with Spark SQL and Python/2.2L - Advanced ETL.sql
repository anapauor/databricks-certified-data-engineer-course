-- Databricks notebook source
-- MAGIC %md
-- MAGIC
-- MAGIC ## Lab: Advanced ETL

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Run the following cell to setup the lab environment 

-- COMMAND ----------

-- MAGIC %run ../Includes/Setup-Lab

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Q1- Interacting with JSON data
-- MAGIC
-- MAGIC Review the nested data structures of the **profile** column in the **students** table created in the previous lab

-- COMMAND ----------

SELECT email, profile
FROM students

-- COMMAND ----------

DESCRIBE students

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC Use the appropriate syntax to access the **last_name** and **city** information from the **profile** column

-- COMMAND ----------

SELECT email, profile:last_name AS student_surname, profile:city AS student_city
FROM students

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Q2- Higher Order Functions
-- MAGIC
-- MAGIC Review the array column **courses** in the **enrollments** table created in the previous lab

-- COMMAND ----------

SELECT enroll_id, courses 
FROM enrollments limit 3;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Filter this array column to keep only course elements having subtotal greater than 40

-- COMMAND ----------

SELECT
  enroll_id,
  filter(courses, i -> i.subtotal > 40) AS large_totals
  FROM enrollments


-- COMMAND ----------

select * from 
(SELECT
  enroll_id,
  courses,
  EXPLODE(COURSES) AS courses_j,
  cast(courses_j.subtotal as int) as large_totals
FROM enrollments)
WHERE large_totals > 40

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Q3- SQL UDFs

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC Define a UDF function named **get_letter_grade** that takes one parameter named **gpa** of type DOUBLE. It returns the corresponding letter grade as indicated in the following table:
-- MAGIC
-- MAGIC
-- MAGIC
-- MAGIC | GPA (4.0 Scale) | Grade Letter |
-- MAGIC |---------|-----------|
-- MAGIC |    3.50 - 4.0    |    A   |
-- MAGIC |    2.75 - 3.44    |    B  |
-- MAGIC |    2.0 - 2.74    |    C   |
-- MAGIC |    0.0 - 1.99    |    F   |

-- COMMAND ----------

CREATE OR REPLACE FUNCTION get_letter_grade(gpa DOUBLE) 
  RETURN CASE WHEN gpa >= 3.50 THEN 'A' 
              WHEN  2.75 < gpa AND gpa <= 3.44 THEN 'B'
              WHEN 2.0 < gpa AND GPA <= 2.74 THEN 'C'
              WHEN gpa >= 0 AND GPA <= 1.99 THEN 'F'
            END ;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC Let's apply the above UDF on the **students** table created in the previous lab
-- MAGIC
-- MAGIC Fill in the below query to call the defined UDF on the **gpa** column 

-- COMMAND ----------

SELECT student_id, gpa, get_letter_grade(GPA) as letter_grade
FROM students