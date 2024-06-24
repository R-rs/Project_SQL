CREATE DATABASE IF NOT EXISTS data_career;

USE data_career;

DROP TABLE IF EXISTS skills;
CREATE TABLE data_career.skills (skill_id INT PRIMARY KEY, 
								skill_name VARCHAR(50));
ALTER TABLE skills1
MODIFY  skill_id INT;
                            
DROP TABLE IF EXISTS data_branches;
CREATE TABLE data_career.data_branches (branch_id INT PRIMARY KEY, 
										branch_name VARCHAR(50));
                            
DROP TABLE IF EXISTS regime;
CREATE TABLE data_career.regime (regime_id INT PRIMARY KEY, 
								regime_name VARCHAR(50));                          

DROP TABLE IF EXISTS country;
CREATE TABLE data_career.country (country_id INT PRIMARY KEY, 
								country_name VARCHAR(50));    
                                
DROP TABLE IF EXISTS experience;
CREATE TABLE data_career.experience (job_level_id INT PRIMARY KEY, 
									job_level_name VARCHAR(50));                                                          

DROP TABLE IF EXISTS company;
CREATE TABLE data_career.company (company_id INT PRIMARY KEY, 
								company_name VARCHAR(150),
                                    country_id INT);
                                    
DROP TABLE IF EXISTS connected;
CREATE TABLE data_career.connected (connected_id INT PRIMARY KEY, 
								job_title_id INT,
                                   skill_id INT);                                    
#Create the relationship between company and country tables
ALTER TABLE company
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id)
REFERENCES country(country_id);

#Create the relationship between conected and skills1
ALTER TABLE connected
ADD CONSTRAINT fk_skill_id
FOREIGN KEY (skill_id)
REFERENCES skills1(skill_id);

#Create the relationship between conected and job_title_1
ALTER TABLE connected
ADD CONSTRAINT fk_job_title_id
FOREIGN KEY (job_title_id)
REFERENCES job_title_1(job_title_id);

DROP TABLE IF EXISTS job_title_1;
CREATE TABLE data_career.job_offer (job_title_id INT PRIMARY KEY, 
							job_title_name VARCHAR (150),
                            company_id INT,
                            country_id INT,
                            job_level_id INT,
                            regime_id INT,
                            branch_id INT);
                            
#Create the relationship between job_title_1 and data_branches
ALTER TABLE job_title_1
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id)
REFERENCES data_branches(branch_id);

#Create the relationship between job_title_1 and company
ALTER TABLE job_title_1
ADD CONSTRAINT fk_company_id
FOREIGN KEY (company_id)
REFERENCES company(company_id);

#Create the relationship between job_title_1 and country
ALTER TABLE job_title_1
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id)
REFERENCES country(country_id);

#Create the relationship between job_title_1 and experience
ALTER TABLE job_title_1
ADD CONSTRAINT fk_job_level_id
FOREIGN KEY (job_level_id)
REFERENCES experience(job_level_id);

#Create the relationship between job_title_1 and regime
ALTER TABLE job_title_1
ADD CONSTRAINT fk_regime_id
FOREIGN KEY (regime_id)
REFERENCES regime(regime_id);

---------------------------------------------------------------------------------------

-- our first insight!
SELECT *
FROM job_title_1 j
LEFT JOIN connected c
ON j.job_title_id = c.job_title_id;

SELECT connected_id
FROM job_title_1 j
LEFT JOIN connected c
ON j.job_title_id = c.job_title_id
GROUP BY connected.skill_id;

SELECT skill_id, COUNT(*) AS count
FROM connected
GROUP BY skill_id
ORDER by count DESC
LIMIT 10;



SELECT c.skill_id, COUNT(*) AS count
FROM connected c
JOIN skills1 s
ON s.skill_id = c.skill_id
GROUP BY c.skill_id
ORDER by count DESC
LIMIT 10;

-- TOP_10_GERAL--

CREATE VIEW top_10_skills AS
SELECT s.skill_name, s.skill_id, COUNT(*) AS skill_count
FROM connected c
JOIN skills1 s 
ON s.skill_id = c.skill_id
GROUP BY c.skill_id, s.skill_name
ORDER BY COUNT(*) DESC
LIMIT 12;

SELECT * FROM top_10_skills;

CREATE VIEW top_10_skills AS
SELECT s.skill_name, s.skill_id, COUNT(*) AS skill_count
FROM connected c
JOIN skills1 s ON s.skill_id = c.skill_id
GROUP BY c.skill_id, s.skill_name
ORDER BY COUNT(*) DESC
LIMIT 12;

--  ANALYST JOB OFFERS--

SELECT d.branch_name, COUNT(*)
FROM job_title_1 j
join data_branches d
On j.branch_id = d.branch_id
WHERE d.branch_id = 0;

--  ENGINEER JOB OFFERS--

SELECT d.branch_name, COUNT(*)
FROM job_title_1 j
join data_branches d
On j.branch_id = d.branch_id
WHERE d.branch_id = 1;

--  SCIENTIST JOB OFFERS--

SELECT d.branch_name, COUNT(*)
FROM job_title_1 j
join data_branches d
On j.branch_id = d.branch_id
WHERE d.branch_id = 4;

--  INTELLIGENCE JOB OFFERS--

SELECT d.branch_name, COUNT(*)
FROM job_title_1 j
join data_branches d
On j.branch_id = d.branch_id
WHERE d.branch_id = 2;

--  OTHERS JOB OFFERS--

SELECT d.branch_name, COUNT(*)
FROM job_title_1 j
join data_branches d
On j.branch_id = d.branch_id
WHERE d.branch_id = 3;

select * from data_branches;


-- ANALYST COUNT OF SKILLS __

CREATE VIEW analyst_skill_count AS
SELECT a.skill_id, skill_name, count FROM (SELECT skill_id, COUNT(*) as count
				FROM connected c
				JOIN job_title_1 j
				ON c.job_title_id = j.job_title_id
                WHERE j.branch_id = 0
				GROUP BY skill_id) AS a
                LEFT JOIN skills1 ON skills1.skill_id = a.skill_id
                ORDER BY count DESC;


-- ENGINEER COUNT OF SKILLS __

CREATE VIEW engineer_skill_count AS
SELECT a.skill_id, skill_name, count FROM (SELECT skill_id, COUNT(*) as count
				FROM connected c
				JOIN job_title_1 j
				ON c.job_title_id = j.job_title_id
                WHERE j.branch_id = 1
				GROUP BY skill_id) AS a
                LEFT JOIN skills1 ON skills1.skill_id = a.skill_id
                ORDER BY count DESC;
                
-- SCIENTIST COUNT OF SKILLS __

CREATE VIEW scientist_skill_count AS
SELECT a.skill_id, skill_name, count FROM (SELECT skill_id, COUNT(*) as count
				FROM connected c
				JOIN job_title_1 j
				ON c.job_title_id = j.job_title_id
                WHERE j.branch_id = 4
				GROUP BY skill_id) AS a
                LEFT JOIN skills1 ON skills1.skill_id = a.skill_id
                ORDER BY count DESC;     
------------------------------------------
-- ANALYST SKILL COUNT           
    
SELECT * FROM analyst_skill_count;
 
SELECT * FROM skills1;

SELECT 
(SELECT ROUND(SUM(count)/(1438)*100,2) as 'SQL Related Skills'
FROM analyst_skill_count
WHERE skill_name LIKE '%SQL%') as `SQL %`,

(-- ANALYST '%Python%'
SELECT ROUND(SUM(count)/(1438)*100,2) as 'Python Related Skills'
FROM analyst_skill_count
WHERE skill_name LIKE '%Python%') as `PYTHON %`,

(-- ANALYST '%Tableau%'
SELECT ROUND(SUM(count)/(1438)*100,2) as 'Tableau Related Skills'
FROM analyst_skill_count
WHERE skill_name LIKE '%Tableau%') as `TABLEAU %`,

(-- ANALYST '%Power%'
SELECT ROUND(SUM(count)/(1438)*100,2) as 'Power BI'
FROM analyst_skill_count
WHERE skill_name LIKE '%Power%') as `POWER BI %`,

(-- ANALYST '%visu%'
SELECT ROUND(SUM(count)/(1438)*100,2) as 'Data Visualization Related Skills'
FROM analyst_skill_count
WHERE skill_name LIKE '%Data vis%') as `Data Visualization %`,

(-- ANALYST '%R%'
SELECT ROUND(SUM(count)/(1438)*100,2) as 'R Related Skills'
FROM analyst_skill_count
WHERE skill_name LIKE 'R') as `R %`,

(-- ANALYST '%excel%'
SELECT ROUND(SUM(count)/(1438)*100,2) as 'Excel Related Skills'
FROM analyst_skill_count
WHERE skill_name LIKE '%excel%') as `EXCEL %`

FROM analyst_skill_count
LIMIT 1;

------------------------------------------
-- ENGINEER SKILL COUNT

SELECT * FROM engineer_skill_count;
 
SELECT 
(
SELECT ROUND(SUM(count)/(4034)*100,2) as 'Python Related Skills'
FROM engineer_skill_count
WHERE skill_name LIKE '%Python%') as `PYTHON %`,

(SELECT ROUND(SUM(count)/(4034)*100,2) as 'SQL Related Skills'
FROM engineer_skill_count
WHERE skill_name LIKE '%SQL%') as `SQL %`,

(SELECT ROUND(SUM(count)/(4034)*100,2) as 'AWS Related Skills'
FROM engineer_skill_count
WHERE skill_name LIKE '%aws%') as `AWS %`,

(SELECT ROUND(SUM(count)/(4034)*100,2) as 'ETL'
FROM engineer_skill_count
WHERE skill_name LIKE '%etl%') as `ETL %`,

(SELECT ROUND(SUM(count)/(4034)*100,2) as 'SPARK Related Skills'
FROM engineer_skill_count
WHERE skill_name LIKE '%spark%') as `SPARK %`,

(SELECT ROUND(SUM(count)/(4034)*100,2) as 'SnowFlake Related Skills'
FROM engineer_skill_count
WHERE skill_name LIKE '%snow%') as `SNOWFLAKE %`,

(SELECT ROUND(SUM(count)/(4034)*100,2) as 'Java Related Skills'
FROM engineer_skill_count
WHERE skill_name LIKE 'java%') as `JAVA %`

FROM engineer_skill_count
LIMIT 1;
----------------------------------------------
-- SCIENTIST SKILL COUNT

SELECT * FROM scientist_skill_count;
 
SELECT 
(
SELECT ROUND(SUM(count)/(199)*100,2) as 'Python Related Skills'
FROM scientist_skill_count
WHERE skill_name LIKE '%Python%') as `PYTHON %`,

(SELECT ROUND(SUM(count)/(199)*100,2) as 'SQL Related Skills'
FROM scientist_skill_count
WHERE skill_name LIKE '%SQL%') as `SQL %`,

(SELECT ROUND(SUM(count)/(199)*100,2) as 'R Related Skills'
FROM scientist_skill_count
WHERE skill_name LIKE 'R') as `R %`,

(SELECT ROUND(SUM(count)/(199)*100,2) as 'Machine Learning Related Skills'
FROM scientist_skill_count
WHERE skill_name LIKE '%machin%') as `Machine Learning %`,

(SELECT ROUND(SUM(count)/(199)*100,2) as 'Statistics'
FROM scientist_skill_count
WHERE skill_name LIKE '%stat%') as `Statistics %`,

(SELECT ROUND(SUM(count)/(199)*100,2) as 'Data Visualization Related Skills'
FROM scientist_skill_count
WHERE skill_name LIKE '%visu%') as `SPARK %`,

(SELECT ROUND(SUM(count)/(199)*100,2) as 'Communication Related Skills'
FROM scientist_skill_count
WHERE skill_name LIKE '%commu%') as `Communication %`

FROM scientist_skill_count
LIMIT 1;

--------------------------------------------------

SELECT COUNT(regime) FROM job_title_id ;

-- ANALYST JOB REGIME --
SELECT r.regime_id, r.regime_name, count
FROM regime r
JOIN 
(
SELECT regime_id, ROUND(COUNT(*)/(1438)*100,2) as count 
FROM job_title_1 j
WHERE j.branch_id = 0
GROUP BY regime_id) count_regime
ON r.regime_id = count_regime.regime_id;

-- ENGINEER JOB REGIME --
SELECT r.regime_id, r.regime_name, count
FROM regime r
JOIN 
(
SELECT regime_id, ROUND(COUNT(*)/(4034)*100,2) as count 
FROM job_title_1 j
WHERE j.branch_id = 1
GROUP BY regime_id) count_regime
ON r.regime_id = count_regime.regime_id;

-- SCIENTIST JOB REGIME --

SELECT r.regime_id, r.regime_name, count
FROM regime r
JOIN 
(
SELECT regime_id, ROUND(COUNT(*)/(199)*100,2) as count 
FROM job_title_1 j
WHERE j.branch_id = 4
GROUP BY regime_id) count_regime
ON r.regime_id = count_regime.regime_id;

