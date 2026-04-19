---Viewing the tables
SELECT * 
FROM `workspace`.`default`.`userprofiles`
LIMIT 10;

SELECT * 
FROM `workspace`.`default`.`viewership`
LIMIT 10;

---Creating a new table from the two given datasets using a LEFT JOIN
CREATE OR REPLACE TABLE bright_tv_final AS
SELECT A.UserId,
       A.Gender,
       A.Race,
       A.Age,
       A.Province,
       B.Channel2,
       B.RecordDate2,
       B.Duration2
  
FROM `workspace`.`default`.`userprofiles` AS A
LEFT JOIN `workspace`.`default`.`viewership` AS B
ON A.UserId = B.userid4;

---Counting the number of distinct viewers
SELECT 
    COUNT(DISTINCT UserId) AS no_of_viewers,
    COUNT(UserId) AS no_of_views
FROM bright_tv_final;

---Number of Channels
SELECT COUNT(DISTINCT(Channel2)) AS no_of_channels
FROM bright_tv_final;

---Analysis start and end dates
SELECT 
    MIN(RecordDate2) AS start_date,
    MAX(RecordDate2) AS end_date
FROM bright_tv_final;

--- Dealing with the NULL values in the data

---SELECT *,
---IFNULL(ROUND(Age, 0), '0') AS AGE,
--IFNULL(Province, 'No Province')AS PROVINCE,
--IFNULL(Channel2, 'No Channel2')AS CHANNEL
--FROM bright_tv_final;

----Time bucket
SELECT COUNT(*) AS total_views,
    date_format(to_timestamp(RecordDate2), 'MMMM') AS Month_name,
    date_format(to_timestamp(RecordDate2), 'EEEE') AS Day_name,
    CASE 
        WHEN date_format(to_timestamp(RecordDate2), 'EEEE') IN ('Saturday','Sunday') 
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS weekly_viewing 
FROM bright_tv_final
GROUP BY 
    Month_name,
    Day_name,
    weekly_viewing;

SELECT 
    CASE 
        WHEN HOUR(to_timestamp(RecordDate2)) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(to_timestamp(RecordDate2)) BETWEEN 12 AND 17 THEN 'Day'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS total_views  
FROM bright_tv_final
GROUP BY time_of_day
ORDER BY total_views DESC;

----Age bucket
SELECT Age,
    CASE 
        WHEN Age BETWEEN 0 AND 12 THEN 'Child'
        WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
        WHEN Age BETWEEN 20 AND 39 THEN 'Young Adult'
        WHEN Age BETWEEN 40 AND 59 THEN 'Adult'
        WHEN Age BETWEEN 60 AND 79 THEN 'Senior'
        ELSE 'Unknown'
    END AS Age_group,
COUNT(DISTINCT UserId) AS viewers
FROM bright_tv_final
GROUP BY Age;

---Viewership by Race
SELECT Race,
       COUNT(DISTINCT UserId) AS viewers_per_race
FROM bright_tv_final
GROUP BY Race;

---Most viewed Channel
SELECT Channel2,
       COUNT(UserId) AS views_per_channel
FROM bright_tv_final
GROUP BY Channel2
ORDER BY views_per_channel DESC;
---SUPERSPORT LIVE EVENTS

---Province with the highest viewership
SELECT COALESCE(Province, 'Unknown') AS Province,
       COUNT(UserId) AS views_per_province
FROM bright_tv_final
GROUP BY Province
ORDER BY views_per_province DESC;
----GAUTENG

--- Viewership by gender
SELECT Gender,
       COUNT(DISTINCT UserId) AS viewers_per_gender
FROM bright_tv_final
GROUP BY Gender;
