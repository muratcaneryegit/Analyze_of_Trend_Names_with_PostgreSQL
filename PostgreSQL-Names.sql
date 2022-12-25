SELECT *
FROM names
LIMIT 10

-- First names that appear in all 101 years and the total with that first name
SELECT first_name,SUM(num)
FROM names
GROUP BY first_name
HAVING COUNT(first_name)=101
ORDER BY SUM(num) DESC

--Target is to capture the type of popularity that each name in the dataset for broaden our understanding
SELECT first_name,SUM(num),
CASE WHEN COUNT(first_name)>80 THEN 'Classic'
WHEN COUNT(first_name)>50 THEN 'Semi-classic'
WHEN COUNT(first_name)>20 THEN 'Semi-trendy'
ELSE 'Trendy' END AS popularity_type
FROM names
GROUP BY first_name
ORDER BY first_name
LIMIT 20

SELECT RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
first_name,SUM(num)
FROM names
WHERE sex='F'
GROUP BY first_name
LIMIT 10

SELECT first_name
FROM names
WHERE sex='F' AND year>2015 AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY SUM(num) DESC

--Based on the results in the previous task, Olivia is the most popular female name ending in 'A' since 2015
--To understand the popularity of the name Olivia, its cumulative increase will be examined

SELECT year,first_name,num,
SUM(num) OVER(ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_olivias
FROM names
WHERE first_name='Olivia'
ORDER BY year

--Exploring popular male names
SELECT year,MAX(num) AS max_num
FROM names
WHERE sex='M'
GROUP BY year
LIMIT 10

--Using self join to find out the most popular male names each year
SELECT n.year,first_name,num
FROM names AS n
JOIN (SELECT year,MAX(num) AS max_num
FROM names
WHERE sex='M'
GROUP BY year
) AS sub
ON n.year=sub.year AND n.num=sub.max_num
ORDER BY n.year DESC
LIMIT 10

WITH CTE_COUNT AS(SELECT n.year,first_name,num
FROM names AS n
JOIN (SELECT year,MAX(num) AS max_num
FROM names
WHERE sex='M'
GROUP BY year
) AS sub
ON n.year=sub.year AND n.num=sub.max_num
ORDER BY n.year DESC)

SELECT first_name,COUNT(first_name) AS Count_Top_Name
FROM CTE_COUNT
GROUP BY first_name
ORDER BY Count_Top_Name DESC



