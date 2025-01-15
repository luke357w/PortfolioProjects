-- Employee Performance and Salary Project --

-- Current Employee Count and Salary by Department --
SELECT Department, COUNT(*) AS Number_of_Employees, AVG(Salary) AS Average_Salary, MIN(Salary) AS Min_Salary, MAX(Salary) AS Max_Salary
FROM [Employee_Performance].[dbo].[Employee_Performance_dataset]
WHERE Status = 'Active' AND Performance_Score is not null
GROUP BY Department;
--  The Sales Department has the largest number of active employees at 87, followed by IT and HR. -- 
-- The IT Department has the largest Average Salary at $6088. --

-- Current Employees whose Performance Score is at least 3 --
SELECT Name, Age, Gender, Department, Salary, Joining_Date, Performance_Score, Experience, Status, Location, Session
FROM [Employee_Performance].[dbo].[Employee_Performance_dataset]
WHERE Status = 'Active' AND Performance_Score is not null AND Performance_Score >= 3
ORDER BY Performance_Score desc;
-- This query shows Current Employees that have a Performance of at least 3. --
-- There are 138 Active Employees. -- 

-- CTE of Departments, Performance, and Salary -- 
WITH Dept_Stats AS (
SELECT Name, Age, Gender, Department, Salary, Joining_Date, Performance_Score, Experience, Status, Location, Session
FROM [Employee_Performance].[dbo].[Employee_Performance_dataset]
WHERE Status = 'Active' AND Performance_Score is not null AND Performance_Score >= 3
)
SELECT Department,Performance_Score,
COUNT(*) AS Number_of_Employees,
AVG(Salary) AS Average_Salary,
MIN(Salary) AS Min_Salary,
MAX(Salary) AS Max_Salary
FROM Dept_Stats
GROUP BY Department, Performance_Score
ORDER BY Department desc, Performance_Score;
-- The HR Department has the highest Average Performance Score and Salary among the departments. --
-- The Sales Department performances the worst on average as well as contains the lowest average salary. --

-- Employee Retention Stats -- 
SELECT Department,
	   YEAR(Joining_Date) AS Join_Year,
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN Status = 'Inactive' THEN 1 ELSE 0 END) AS Inactive_Employees
FROM [Employee_Performance].[dbo].[Employee_Performance_dataset]
GROUP BY YEAR(Joining_Date), Department
ORDER BY Join_Year DESC;
-- This query shows Active Employees vs. Inactive Employees. --
-- HR showed consistent retention in recent years. In 2024, HR had 28 active employees and 8 inactive employees, indicating stable performance. --
-- IT and Sales experienced higher turnover, particularly in 2020 and 2021. --
-- By 2024, both IT and Sales departments showed growth and stability. --