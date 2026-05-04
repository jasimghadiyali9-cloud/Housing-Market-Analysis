CREATE DATABASE housing_db;
USE housing_db;
CREATE TABLE housing_data (Id BIGINT, Date DATE,Price FLOAT,Bedrooms INT,Bathrooms FLOAT,Sqft_living INT,Sqft_lot INT,Floors FLOAT,Waterfront INT,View INT,`Condition` INT,
Grade INT,Sqft_above INT,Sqft_basement INT,Yr_built INT,Yr_renovated INT,Zipcode INT,Lat FLOAT,`Long` FLOAT,Sqft_living15 INT,Sqft_lot15 INT,House_age INT,YearsSinceRenovation INT,Has_Basement INT,Has_Renovation INT,Price_persqft FLOAT,Relative_size FLOAT,Relativesizecategory VARCHAR(20),Bathroom_Group VARCHAR(20),
Bedroom_Group VARCHAR(20));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/housing_cleaned_data_v2.csv'
INTO TABLE housing_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@Id, @Date, Price, Bedrooms, Bathrooms, Sqft_living, Sqft_lot, Floors,
Waterfront, View, `Condition`, Grade, Sqft_above, Sqft_basement,
Yr_built, Yr_renovated, Zipcode, Lat, `Long`,
Sqft_living15, Sqft_lot15, House_age, YearsSinceRenovation,
Has_Basement, Has_Renovation, Price_persqft, Relative_size,
Relativesizecategory, Bathroom_Group, Bedroom_Group)
SET 
Id = @Id,
Date = STR_TO_DATE(@Date, '%m/%d/%Y');

SELECT * FROM housing_data;
TRUNCATE TABLE housing_data;
#Grade avg
SELECT Grade, AVG(Price) AS avg_price
FROM housing_data
GROUP BY Grade
ORDER BY avg_price DESC;
#size impact on price 
SELECT 
    CASE 
        WHEN Sqft_living < 1500 THEN 'Small'
        WHEN Sqft_living BETWEEN 1500 AND 3000 THEN 'Medium'
        ELSE 'Large'
    END AS SizeCategory,
    AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY SizeCategory
Order by AvgPrice desc;

#Bathroom VS Bedroom (Utility vs Capacity)
SELECT Bedrooms, AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY Bedrooms
ORDER BY Bedrooms;

SELECT Bathrooms, AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY Bathrooms
ORDER BY Bathrooms;

#Grade Impact 
SELECT Grade, AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY Grade
ORDER BY Grade;

#Waterfront impact 
SELECT Waterfront, AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY Waterfront;

#basement impact
SELECT Has_Basement_Fixed, AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY Has_Basement_Fixed;

#rennovation impact
SELECT Has_Renovation, AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY Has_Renovation;

#relative size impact
SELECT CASE WHEN Relative_Size < 0.8 THEN 'Small vs Area'
			WHEN Relative_Size BETWEEN 0.8 AND 1.2 THEN 'Average'
        ELSE 'Large vs Area'
    END AS RelativeCategory,
    AVG(Price) AS AvgPrice
FROM housing_data
GROUP BY RelativeCategory
ORDER BY AvgPrice DESC;

#TOP SPENDING
SELECT Id, Price
FROM housing_data
WHERE Price = (SELECT MAX(Price) FROM housing_data);

#LEAST SPENDING
SELECT Id, Price
FROM housing_data
WHERE Price = (SELECT MIN(Price) FROM housing_data);