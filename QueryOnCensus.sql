CREATE DATABASE Census;
USE Census;
SHOW TABLES;

-- dataset1_csv has districts of each state with information such as growth, sex_ratio and literacy
SELECT * FROM dataset1_csv;

-- dataset2_csv has districts of each state with its area in square km and total population in each district
SELECT * FROM dataset2_csv;


-- Count no of rows from our dataset
SELECT 
	COUNT(*) 
FROM dataset1_csv;

SELECT 
	COUNT(*) 
FROM dataset2_csv;

-- Data from my state - Karnataka
-- It is evident that Coastal area, Dakshina kannada district has highest literacy rate and Yadgir has lowest literacy rate
SELECT
	*
FROM dataset1_csv
WHERE state = 'Karnataka'
ORDER BY literacy DESC;

-- Data from South India - It is evident that Kerala state has highest literacy in South India
SELECT
	state,
	ROUND(AVG(literacy),2) AS Average_literacy_Statewise
FROM dataset1_csv
WHERE state IN ('karnataka', 'Kerala', 'Andhra pradesh', 'Tamil Nadu')
GROUP BY state
ORDER BY Average_literacy_Statewise DESC;

-- Data from all the states of India 
-- It is evident that Kerala state has highest literacy in comparision with all the states of India and Bihar has lowest literacy rate
SELECT
	state,
	ROUND(AVG(literacy),2) AS Average_literacy_Statewise
FROM dataset1_csv
GROUP BY state
ORDER BY Average_literacy_Statewise DESC;

-- Population of India
SELECT
	SUM(population)
FROM dataset2_csv;

-- Average growth
SELECT
	AVG(growth) * 100
FROM dataset1_csv;

-- Average growth of states 
-- It is clear that Andaman and Nicobar Islands has lowest growth and Nagaland has highest growth
SELECT
	state,
    ROUND(AVG(growth) * 100, 2)AS avg_growth
FROM dataset1_csv
GROUP BY state
ORDER BY avg_growth ASC;

-- Average literacy rate per state and also which is greater than 90
SELECT
	state,
    ROUND(AVG(literacy), 0) AS avg_literacy
FROM dataset1_csv
GROUP BY state
HAVING ROUND(AVG(literacy), 0) > 90
ORDER BY avg_literacy ASC;

-- Top 3 states that shown highest avg growth state
SELECT
	state,
	ROUND(AVG(growth) * 100,2) AS avg_growth
FROM dataset1_csv
GROUP BY state
ORDER BY avg_growth DESC
LIMIT 3;

-- Bottom 3 states that shown lowest avg growth state
SELECT
	state,
	ROUND(AVG(growth) * 100,2) AS avg_growth
FROM dataset1_csv
GROUP BY state
ORDER BY avg_growth ASC
LIMIT 3;

DROP TABLE IF EXISTS TopStates;

-- Created a table named topstates and inserted average of each state into that
CREATE TABLE TopStates
(
	state VARCHAR(500),
	topstate FLOAT
);
INSERT INTO TopStates
SELECT
	state,
    ROUND(AVG(literacy), 0) AS avg_literacy
FROM dataset1_csv
GROUP BY state
ORDER BY avg_literacy DESC;

SELECT * FROM TopStates;

DROP TABLE IF EXISTS BottomStates;
-- Created a table named bottomstates and inserted average of each state into that
CREATE TABLE BottomStates
(
	state VARCHAR(500),
	bottomstate FLOAT
);

INSERT INTO BottomStates
SELECT
	state,
    ROUND(AVG(literacy), 0) AS avg_literacy
FROM dataset1_csv
GROUP BY state
ORDER BY avg_literacy ASC;
SELECT * FROM BottomStates;

SELECT 
	* 
FROM TopStates
ORDER BY topstate DESC
LIMIT 3;


SELECT 
	* 
FROM BottomStates
ORDER BY Bottomstate
LIMIT 3;

-- Top and Bottom 3 states in literacy state
SELECT * FROM (
				SELECT 
					* 
				FROM TopStates
				ORDER BY topstate DESC
				LIMIT 3
				) AS A
UNION
SELECT * FROM (
				SELECT 
					* 
				FROM BottomStates
				ORDER BY Bottomstate
				LIMIT 3
                ) AS B;
                
                
                
-- State starting with letter A 
SELECT DISTINCT STATE
FROM dataset1_csv
WHERE state LIKE 'A%';

-- Ending with letter d
SELECT DISTINCT STATE
FROM dataset1_csv
WHERE state LIKE '%d';

-- Advanced--
-- Using mathematical concepts and data present in table, we are going to find more insights from it
-- Total Literacy state
-- total literate people/population = literacy_ratio
-- total literate people = literacy_ratio * population
-- total illiterate people = (1 - literacy_ratio) * population

-- Finding total_literate and illiterate people in each state
SELECT
	C.state, SUM(literate_people) AS total_literate, SUM(illiterate_people) AS total_illiterate
FROM
(SELECT
	D.district, D.state,
    ROUND(D.literacy_ratio * D.population, 0) AS literate_people, ROUND((1-D.literacy_ratio) * D.population, 0) AS illiterate_people,
    D.population, (D.literacy_ratio * D.population) + ((1-D.literacy_ratio) * D.population) AS total_pop_cross_verifying
FROM 
(SELECT
	A.district, A.state, A.literacy/100 AS literacy_ratio, B.population
FROM dataset1_csv A
INNER JOIN dataset2_csv B
	ON A.district = B.district) D) C
GROUP BY C.state;

-- Window functions - Top 3 districts of every state in terms of literacy

SELECT
	A.*
FROM
(SELECT
	district,
    state,
    literacy,
    rank() OVER(PARTITION BY state ORDER BY literacy DESC) Rank_in_literacy
FROM dataset1_csv) AS A
WHERE A.Rank_in_literacy IN(1, 2, 3)
ORDER BY state;
	
  -- Top 3 districts of every state in terms of sex_ratio
SELECT
	district,
    state,
    Sex_Ratio,
    DENSE_RANK() OVER(PARTITION BY state ORDER BY sex_ratio DESC) AS Dense_rnk 
FROM dataset1_csv;
 
