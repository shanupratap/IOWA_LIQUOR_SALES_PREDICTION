create database iowa_liquor;
use iowa_liquor;
show tables;

rename table `iowa_liquor_sales` to liquor_sales;
select * from liquor_sales;

alter table liquor_sales
drop column `Address`,
drop column `County Number`,
drop column `Category`,
drop column `Vendor Number`, 
drop column `Item Number`,
drop column `Iowa ZIP Code Tabulation Areas`,
drop column `Iowa Watershed Sub-Basins (HUC 08)`,
drop column `Iowa Watersheds (HUC 10)`,
drop column `County Boundaries of Iowa`,
drop column `US Counties`;


select * from liquor_sales;
describe liquor_sales;

alter table  liquor_sales
add column Order_Date DATETIME;

UPDATE liquor_sales
SET Order_Date = STR_TO_DATE(COALESCE(`Date`, '0000-00-00'), '%m/%d/%Y')
WHERE `Date` IS NOT NULL AND `Date` != '';

select Order_Date from liquor_sales;
alter table  liquor_sales
drop column `Date`;

alter table liquor_sales
rename column `index` to Index_No,
rename column  `Invoice/Item Number` to Invoice_Num,
rename column  `Store Number` to Store_Num,
rename column  `Store Name` to Store_Name,
rename column  `City` to City,
rename column  `Zip Code` to Zip_Code,
rename column  `Store Location` to Store_Location,
rename column  `County` to County,
rename column  `Category Name` to Category_Name,
rename column  `Vendor Name` to Vendor_Name,
rename column  `Item Description` to Item_Description,
rename column  `Pack` to Pack,
rename column  `Bottle Volume (ml)` to Bottle_Volume,
rename column  `State Bottle Cost` to State_Bottle_Cost,
rename column  `State Bottle Retail` to State_Bottle_Retail,
rename column  `Bottles Sold` to Bottles_Sold,
rename column  `Sale (Dollars)` to Sale_Dollars,
rename column  `Volume Sold (Liters)` to Volume_Sold_Litres,
rename column  `Volume Sold (Gallons)` to Volume_Sold_Gallons;

select * from liquor_sales;


SELECT * FROM liquor_sales WHERE Index_No IS NULL;
SELECT * FROM liquor_sales WHERE Invoice_Num IS NULL;
SELECT * FROM liquor_sales WHERE Store_Num IS NULL;
SELECT * FROM liquor_sales WHERE Store_Name IS NULL;
SELECT * FROM liquor_sales WHERE City IS NULL;

select City from liquor_sales;
SELECT City
FROM liquor_sales
GROUP BY City
ORDER BY COUNT(*) DESC
LIMIT 1;
SELECT City, COUNT(*)
FROM liquor_sales
GROUP BY City;
SELECT COUNT(*)
FROM liquor_sales
WHERE City IS NULL;
DELETE FROM liquor_sales
WHERE City IS NULL;


SELECT * FROM liquor_sales WHERE Zip_Code IS NULL;
SELECT COUNT(*)
FROM liquor_sales
WHERE zip_code IS NULL;
DELETE FROM liquor_sales
WHERE zip_code IS NULL;

SELECT * FROM liquor_sales WHERE Store_Location IS NULL;
SELECT Store_Location
FROM liquor_sales
GROUP BY Store_Location
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT Store_Location, COUNT(*)
FROM liquor_sales
GROUP BY Store_Location;

UPDATE liquor_sales
SET Store_Location = "No Loaction"
WHERE Store_Location IS NULL;

SELECT * FROM liquor_sales WHERE County IS NULL;
SELECT * FROM liquor_sales WHERE Category_Name IS NULL;
SELECT * FROM liquor_sales WHERE Vendor_Name IS NULL;
SELECT * FROM liquor_sales WHERE Item_Description IS NULL;
SELECT * FROM liquor_sales WHERE Pack IS NULL;
SELECT * FROM liquor_sales WHERE Bottle_Volume IS NULL;
SELECT * FROM liquor_sales WHERE State_Bottle_Cost IS NULL;
SELECT * FROM liquor_sales WHERE State_Bottle_Retail IS NULL;
SELECT * FROM liquor_sales WHERE Bottles_Sold IS NULL;
SELECT * FROM liquor_sales WHERE Sale_Dollars IS NULL;
SELECT * FROM liquor_sales WHERE Volume_Sold_Litres IS NULL;
SELECT * FROM liquor_sales WHERE Volume_Sold_Gallons IS NULL;
SELECT * FROM liquor_sales WHERE Order_Date IS NULL;


# Total sales amount per store:
SELECT Store_Num, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Store_Num;

# Total sales volume in litres per store:
SELECT Store_Num, SUM(Volume_Sold_Litres) AS Total_Volume_Litres
FROM liquor_sales
GROUP BY Store_Num;

# Top 5 best-selling items:
SELECT Item_Description, SUM(Bottles_Sold) AS Total_Sold
FROM liquor_sales
GROUP BY Item_Description
ORDER BY Total_Sold DESC
LIMIT 5;

# Total sales amount per category:
SELECT Category_Name, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Category_Name;

# Total sales amount per city:
SELECT City, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY City;

# Total sales amount per month:
SELECT EXTRACT(MONTH FROM Order_Date) AS Month, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY EXTRACT(MONTH FROM Order_Date);

# Average bottle volume sold per store:
SELECT Store_Num, AVG(Bottle_Volume) AS Avg_Bottle_Volume
FROM liquor_sales
GROUP BY Store_Num;

# Total sales amount per vendor:
SELECT Vendor_Name, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Vendor_Name;

# Total sales amount per county with more than 10 stores:
SELECT s.County, SUM(s.Sale_Dollars) AS Total_Sales
FROM liquor_sales s
JOIN (
    SELECT County, COUNT(DISTINCT Store_Num) AS Store_Count
    FROM liquor_sales
    GROUP BY County
    HAVING COUNT(DISTINCT Store_Num) > 10
) c ON s.County = c.County
GROUP BY s.County;

# SOME IMPORTSNT KPIs:

# 1) Total Sales Amount:
SELECT SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales;

# 2) Average Sales Amount per Transaction:
SELECT AVG(Sale_Dollars) AS Avg_Sales_Per_Transaction
FROM liquor_sales;

# 3) Total Volume Sold in Litres:
SELECT SUM(Volume_Sold_Litres) AS Total_Volume_Litres
FROM liquor_sales;

# 4) Average Bottles Sold per Transaction:
SELECT AVG(Bottles_Sold) AS Avg_Bottles_Per_Transaction
FROM liquor_sales;

# 5) Total Number of Transactions:
SELECT COUNT(*) AS Total_Transactions
FROM liquor_sales;

# 6) Average Bottle Volume:
SELECT AVG(Bottle_Volume) AS Avg_Bottle_Volume
FROM liquor_sales;

# 7) Total Sales Amount per Store:
SELECT Store_Num, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Store_Num;

# 8) Total Sales Amount per Category:
SELECT Category_Name, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Category_Name;

# 9) Total Sales Amount per Vendor:
SELECT Vendor_Name, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Vendor_Name;

# 10) Average Sales Amount per Store:
SELECT Store_Num, AVG(Sale_Dollars) AS Avg_Sales_Per_Store
FROM liquor_sales
GROUP BY Store_Num;

# 11) Total Sales Amount per Month:
SELECT EXTRACT(MONTH FROM Order_Date) AS Month, SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY EXTRACT(MONTH FROM Order_Date);

# 1) What is the most popular consumed liquor in Iowa?

select Item_Description, sum(Bottles_Sold) as Total_Bottles_Sold
from liquor_sales
where City = 'Iowa City' 
group by Item_Description
order by Total_Bottles_Sold desc
limit 1;

# 2) What stores have sold the most liquor?
select Store_Name, sum(Volume_Sold_Litres) as Total_Liquor_Sold_Litres
from liquor_sales
group by Store_Name
order by Total_Liquor_Sold_Litres desc;

# 3) What cities have the most consumption of liquors?
select City, sum(Volume_Sold_Litres) as Total_Litres_Consumed
from liquor_sales
group by City
order by Total_Litres_Consumed desc;

# 4) Is there a seasonal consuption behavior?
select
    extract(month from Order_Date) as Month,
    SUM(Sale_Dollars) as Total_Sales
from 
    liquor_sales
group by
    extract(month from Order_Date)
order by 
    extract(month from Order_Date);

    
# 5) How can we predict sales by zipcode given the dataset?
CREATE TABLE sales_by_zipcode AS
SELECT Zip_Code,
       SUM(Sale_Dollars) AS Total_Sales
FROM liquor_sales
GROUP BY Zip_Code;

select * from sales_by_zipcode;

# Calculate the percentage change in sales revenue (Sale_Dollars) between two periods:
SELECT 
    Order_Date AS `Current_Date`,
    SUM(Sale_Dollars) AS Current_Sales,
    LAG(Order_Date) OVER (ORDER BY Order_Date) AS Previous_Date,
    SUM(Sale_Dollars) AS Previous_Sales,
    (SUM(Sale_Dollars) - LAG(SUM(Sale_Dollars)) OVER (ORDER BY Order_Date)) / LAG(SUM(Sale_Dollars)) OVER (ORDER BY Order_Date) * 100 AS Sales_Percentage_Change
FROM 
    liquor_sales
GROUP BY 
    Order_Date
ORDER BY 
    Order_Date;
    
# Calculate the percentage change in volume sold (Volume_Sold_L) between two periods:

SELECT 
    Order_Date `AS Current_Date`,
    SUM(Volume_Sold_Litres) AS Current_Volume,
    LAG(Order_Date) OVER (ORDER BY Order_Date) AS Previous_Date,
    SUM(Volume_Sold_Litres) AS Previous_Volume,
    (SUM(Volume_Sold_Litres) - LAG(SUM(Volume_Sold_Litres)) OVER (ORDER BY Order_Date)) / LAG(SUM(Volume_Sold_Litres)) OVER (ORDER BY Order_Date) * 100 AS Volume_Percentage_Change
FROM 
    liquor_sales
GROUP BY 
    Order_Date
ORDER BY 
    Order_Date;
    
# Month on month chnge in sales:
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
    SUM(Sale_Dollars) AS Total_Sales,
    LAG(SUM(Sale_Dollars), 1) OVER (ORDER BY DATE_FORMAT(Order_Date, '%Y-%m')) AS Previous_Month_Sales,
    (SUM(Sale_Dollars) - LAG(SUM(Sale_Dollars), 1) OVER (ORDER BY DATE_FORMAT(Order_Date, '%Y-%m'))) AS Sales_Change
FROM 
    liquor_sales
GROUP BY 
    DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY 
    DATE_FORMAT(Order_Date, '%Y-%m');
    
SELECT 
    Order_Date,
    Sale_Dollars,
    LAG(Sale_Dollars) OVER (ORDER BY Order_Date) AS Previous_Sale_Dollars
FROM 
    liquor_sales;
    
SELECT 
    Order_Date,
    Sale_Dollars,
    LEAD(Sale_Dollars) OVER (ORDER BY Order_Date) AS Next_Sale_Dollars
FROM 
    liquor_sales;
    
SELECT 
    Order_Date,
    Sale_Dollars,
    RANK() OVER (ORDER BY Sale_Dollars DESC) AS Sales_Rank
FROM 
    liquor_sales;
    
SELECT 
    Order_Date,
    Sale_Dollars,
    DENSE_RANK() OVER (ORDER BY Sale_Dollars DESC) AS Dense_Sales_Rank
FROM 
    liquor_sales;


