-- Data Cleaning Project:

-- First Look at Dataset:
SELECT *
FROM [Messy_Data_Project].[dbo].[House_Messy]

-- Checking for Duplicates:
SELECT Property_ID, Address, Owner_Name, Sale_Date, Property_Value, Area_Acres, Year_Built, Bedrooms, Bathrooms, Stories, Taxable_Value, Land_Value, Building_Type, COUNT(*) AS cnt
FROM [Messy_Data_Project].[dbo].[House_Messy]
GROUP BY Property_ID, Address, Owner_Name, Sale_Date, Property_Value, Area_Acres, Year_Built, Bedrooms, Bathrooms, Stories, Taxable_Value, Land_Value, Building_Type
HAVING COUNT(*) > 1

-- CTE to identify duplicates based on all columns
WITH DuplicateCheck AS (
    SELECT 
        Property_ID, Address, Owner_Name, Sale_Date, Property_Value, Area_Acres, 
        Year_Built, Bedrooms, Bathrooms, Stories, Taxable_Value, Land_Value, Building_Type,
        COUNT(*) AS cnt
    FROM [Messy_Data_Project].[dbo].[House_Messy]
    GROUP BY Property_ID, Address, Owner_Name, Sale_Date, Property_Value, Area_Acres, 
             Year_Built, Bedrooms, Bathrooms, Stories, Taxable_Value, Land_Value, Building_Type
)
SELECT * 
FROM DuplicateCheck
WHERE cnt > 1

-- Finding Invalid Property Values:
SELECT *
FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Property_Value = 0 OR Property_Value IS NULL

-- Removing Invalid Property Values:
DELETE FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Property_Value = 0 OR Property_Value IS NULL

-- Handling Null Values:
SELECT *
FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Owner_Name IS NULL
   OR Area_Acres IS NULL
   OR Year_Built IS NULL
   OR Bedrooms IS NULL

-- Removing the Null Values:
DELETE FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Owner_Name IS NULL
   OR Area_Acres IS NULL
   OR Year_Built IS NULL
   OR Bedrooms IS NULL

-- Checking for Outliers:
SELECT * 
FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Area_Acres < 0
   OR Property_Value < 50000
   OR Year_Built > YEAR(GETDATE())  
   OR Bedrooms < 1

--Removing Outliers:
DELETE FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Area_Acres < 0
   OR Property_Value < 50000
   OR Year_Built > YEAR(GETDATE()) 
   OR Bedrooms < 1

-- Triming Leading/Trailing Spaces:
SELECT * 
FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Address LIKE '% %'

UPDATE [Messy_Data_Project].[dbo].[House_Messy]
SET Address = LTRIM(RTRIM(Address))  -- Removes leading and trailing spaces
WHERE Address LIKE '% %'  -- Removes spaces from Addresses

-- Normalizing Data:
WITH NormalizedArea AS (
    SELECT DISTINCT Area_Acres
    FROM [Messy_Data_Project].[dbo].[House_Messy]
)
UPDATE H
SET H.Area_Acres = ROUND(H.Area_Acres, 2)
FROM [Messy_Data_Project].[dbo].[House_Messy] H
JOIN NormalizedArea NA ON H.Area_Acres = NA.Area_Acres
WHERE H.Area_Acres IS NOT NULL

-- CTE to standardize Building_Type values
WITH StandardizedBuildingType AS (
    SELECT Property_ID, 
           CASE 
               WHEN Building_Type LIKE '%Single%' THEN 'Single Family'
               WHEN Building_Type LIKE '%Condo%' THEN 'Condo'
               ELSE 'Other'
           END AS Standardized_Building_Type
    FROM [Messy_Data_Project].[dbo].[House_Messy]
)
UPDATE H
SET H.Building_Type = SBT.Standardized_Building_Type
FROM [Messy_Data_Project].[dbo].[House_Messy] H
JOIN StandardizedBuildingType SBT ON H.Property_ID = SBT.Property_ID

-- Subquery to find invalid Property_Value
DELETE FROM [Messy_Data_Project].[dbo].[House_Messy]
WHERE Property_Value IN (
    SELECT Property_Value
    FROM [Messy_Data_Project].[dbo].[House_Messy]
    WHERE Property_Value = 0 OR Property_Value IS NULL
)

-- Inspecting the Cleaned Dataset:
SELECT *
FROM [Messy_Data_Project].[dbo].[House_Messy]



