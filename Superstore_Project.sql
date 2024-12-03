-- Exploratory Data Analysis Project:

-- Iniital Inspection of Data:
SELECT *
FROM [Superstore_Project].[dbo].[superstore]
ORDER BY COUNTRY, SEGMENT

SELECT Profit, Sales, Segment, Category
FROM [Superstore_Project].[dbo].[superstore]

-- Calculating Distinct Order_ID's:
SELECT COUNT(DISTINCT(Order_ID)) as Order_Count
FROM [Superstore_Project].[dbo].[superstore]

-- Summary Statistics for Key Metrics:
SELECT AVG(Sales) as Avg_Sales, AVG(Profit) as Avg_Profit, MIN(Sales) as Min_Sales, MIN(Profit) as Min_Profit,
MAX(Sales) as Max_Sales, MAX(Profit) as Max_Profit
FROM [Superstore_Project].[dbo].[superstore]

-- Calculating Profit Ratio:
SELECT ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Ratio
FROM [Superstore_Project].[dbo].[superstore]

-- Profit Ratio by State, City, and Region:
SELECT 
    State, 
    City, 
    Region, 
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Ratio_Percentage
FROM [Superstore_Project].[dbo].[superstore]
GROUP BY 
    State, 
    City, 
    Region

-- Aggregating Sales and Profit by Year and Month:
SELECT 
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM [Superstore_Project].[dbo].[superstore]
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month

-- Calculating Total and Average Sales by Region:
SELECT 
    Region,
    SUM(Sales) AS Total_Sales,
    AVG(Sales) AS Avg_Sales
FROM [Superstore_Project].[dbo].[superstore]
GROUP BY Region
ORDER BY Total_Sales DESC

-- Filtering data:
SELECT 
    Customer_Name, 
    Category, 
    Sales
FROM [Superstore_Project].[dbo].[superstore]
WHERE Category LIKE '%Furniture%' AND Region IN ('West', 'East') AND Sales > 500
ORDER BY Sales desc

-- Profit Ratio and Profitability Calculation:
SELECT 
    State,
    City,
    Category,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Ratio_Percentage,
    CASE 
        WHEN ROUND(SUM(Profit) / SUM(Sales) * 100, 2) > 0 THEN 'Profitable'
        ELSE 'Unprofitable'
    END AS Profit_Segment
FROM [Superstore_Project].[dbo].[superstore]
GROUP BY State, City, Category

-- CTE to calculate Profit Ratio by State, City, and Region:
WITH Profitability AS (
    SELECT 
        State, 
        City, 
        Region,
        ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Ratio_Percentage
    FROM [Superstore_Project].[dbo].[superstore]
    GROUP BY State, City, Region
)
SELECT 
    State, 
    City, 
    Region, 
    Profit_Ratio_Percentage,
    CASE 
        WHEN Profit_Ratio_Percentage > 0 THEN 'Profitable'
        ELSE 'Unprofitable'
    END AS Profit_Segment
FROM Profitability
ORDER BY Profit_Ratio_Percentage DESC

-- Subquery to calculate Total for Category by Product:
SELECT 
    State, 
    City, 
    Category, 
    Sales,
    (SELECT SUM(Sales) 
     FROM [Superstore_Project].[dbo].[superstore] s2 
     WHERE s2.Category = s.Category) AS Total_Sales_For_Category
FROM [Superstore_Project].[dbo].[superstore] s

-- Self Join to Compare Sales in Different Regions:
SELECT 
    a.Product_ID,
    a.Product_Name,
    a.Region AS Region_A,
    a.Sales AS Sales_Region_A,
    b.Region AS Region_B,
    b.Sales AS Sales_Region_B
FROM 
    [Superstore_Project].[dbo].[superstore] a
JOIN 
    [Superstore_Project].[dbo].[superstore] b
    ON a.Product_ID = b.Product_ID
WHERE 
    a.Region = 'West' 
    AND b.Region = 'East'
    AND a.Product_ID IS NOT NULL
ORDER BY 
    a.Product_Name

-- Self Join to Compare Sales for same Product in Different States:
SELECT 
    a.Product_ID,
    a.Product_Name,
    a.State AS State_A,
    a.Sales AS Sales_State_A,
    b.State AS State_B,
    b.Sales AS Sales_State_B
FROM 
    [Superstore_Project].[dbo].[superstore] a
JOIN 
    [Superstore_Project].[dbo].[superstore] b
    ON a.Product_ID = b.Product_ID
WHERE 
    a.State != b.State
ORDER BY 
    a.Product_Name

-- Self Join to Compare Sales by Various Categories:
SELECT 
    a.Customer_ID,
    a.Customer_Name,
    a.Category AS Category_A,
    a.Sales AS Sales_Category_A,
    b.Category AS Category_B,
    b.Sales AS Sales_Category_B
FROM 
    [Superstore_Project].[dbo].[superstore] a
JOIN 
    [Superstore_Project].[dbo].[superstore] b
    ON a.Customer_ID = b.Customer_ID
WHERE 
    a.Category != b.Category
ORDER BY 
    a.Customer_Name



















