create database walmart;
use walmart;
select * from walmart;
# 1: Identifying the Top Branch by Sales Growth Rate

-- Step 1: Extract Year and Month, and calculate monthly sales per branch
WITH MonthlySales AS(
SELECT Branch,
DATE_Format(Date, '%Y-%m') AS YearMonth,
SUM(Total) AS TotalSales
FROM walmart
GROUP BY Branch, yearMonth),
-- Step 2: Add previous month's sales using LAG() window function And Find the avg growthrate
MonthlyGrowth AS(
SELECT Branch,
       YearMonth,
       TotalSales,
       LAG(TotalSales) OVER (PARTITION BY Branch ORDER BY YearMonth) AS PrevMonthSales
       FROM MonthlySales
       )
 SELECT Branch,
ROUND(AVG(((TotalSales - PrevMonthSales) / PrevMonthSales) * 100), 2) AS GrowthRate
 FROM MonthlyGrowth
 WHERE PrevMonthSales IS NOT NULL  -- (Filters out the first month of sales (because it has no previous month to compare).)
 GROUP BY Branch
 ORDER BY GrowthRate DESC
 LIMIT 1;

# 2: Finding the Most Profitable Product Line for Each Branch

-- Step 1: Calculate profit per product line per branch
WITH ProductlineProfit AS(
SELECT Branch,
`Product line`,
SUM(Total) AS TotalRevenue,
SUM(cogs) AS TotalCogs,
(Sum(Total)-SUM(cogs)) AS Profit
FROM walmart
GROUP BY Branch ,`Product line`),

-- Step 2: Rank product lines by profit within each branch
RankedProfit AS (
SELECT * ,
RANK() OVER(PARTITION BY Branch ORDER BY Profit DESC) AS ProfitRank
FROM ProductlineProfit
)
-- Step 3: Select the top product line for each branch
SELECT 
Branch,
`Product line` AS MostProfitableProductLine,
TotalRevenue,
TotalCogs,
Profit
FROM RankedProfit
WHERE ProfitRank = 1;
  
# 3: Analyzing Customer Segmentation Based on Spending
-- Step 1: calculate total and AVG spending per customer

WITH CustomerSpen AS(
SELECT `Invoice ID`,
ROUND(SUM(Total),2) AS TotalSpent,
ROUND(AVG(Total),2) AS AvgSpent
FROM walmart
GROUP BY `Invoice ID`),

-- Step 2: is to segment the customer into low , medium and high using NTIlE
SegementedCus AS(
Select *,
NTILE(3) OVER (ORDER BY TotalSpent) AS SpendTier
FROM CustomerSpen
)

-- Make tier name to lables 
SELECT 
`Invoice ID` AS Customer_ID,
TotalSpent,
AvgSpent,
case SpendTier
when 1 then "Low Spender"
when 2 then "Medium Spender"
when 3 then "High Spender"
END AS SpendingCategory
FROM SegementedCus;

# 4: Detecting Anomalies in Sales Transactions
-- Step 1: Get average total per product line

WITH ProductlineAvg AS (
SELECT `Product line`,
AVG(Total) AS AvgTotal
FROM walmart
GROUP BY `Product line`
),
-- Step 2: Join and detect anomalies
AnomaliesDete AS (
SELECT 
w.`Invoice ID`,
w.`Product line`,
w.Total,
p.AvgTotal,
CASE 
WHEN w.Total > p.AvgTotal * 1.5 THEN "High Anomaly"   # Anything obove 50% of Avg Total is suspicious  and a high anomaly
WHEN w.Total > p.AvgTotal* 0.5 THEN "Low Anomaly"     # Anything below 50% of Avg Total is suspicious and a low anomaly 
ELSE NULL
END AS Anomaly_flag
FROM walmart w
JOIN ProductlineAvg p 
ON w.`Product line` = p.`Product line`
)
-- Step 3: Return only anomalies
SELECT * 
FROM AnomaliesDete
WHERE Anomaly_flag IS NOT NULL;

# 5: Most Popular Payment Method by City 
# Find the most used payment method (like Cash, Credit card, Ewallet) in each city.

-- Step 1: Count payment method usage per city
WITH PaymentsCount AS(
SELECT 
City,
Payment,
COUNT(*) AS UsageCount
FROM walmart
GROUP BY City, Payment
),

-- Step 2: Rank payment methods by usage in each city
RankedPaymt As (
SELECT * ,
  RANK() OVER (PARTITION BY City ORDER BY UsageCount DESC) AS PaymentRank
FROM PaymentsCount
)

-- Step 3: Select the top payment method for each city
SELECT 
    City,
    Payment AS MostPopularPaymentMethod,
    UsageCount
FROM RankedPaymt
WHERE PaymentRank = 1;

# 6: Monthly Sales Distribution by Gender

SELECT 
 DATE_Format(Date, '%Y-%m') AS SalesMonth,
Gender,
Round(Sum(Total),2) As TotalSales
FROM walmart
GROUP  BY SalesMonth , Gender  
Order By  SalesMonth , gender;
  
# 7: Best Product Line by Customer Type (in terms of total sales)
SELECT `Customer type`FROM walmart;
-- Step 1: Calculate total sales per product line for each customer type
WITH ProductPref AS (
SELECT 
`Customer type`,
`Product line`,
ROUND(SUM(Total),2) AS TotalSales
FROM walmart 
GROUP BY `Customer type`,`Product line`
),

-- Step 2: Rank the product lines by revenue for each customer type
RankedPro AS (
SELECT * ,
  RANK() OVER(PARTITION BY `Customer type` ORDER BY TotalSales Desc) AS RevenueRank
FROM ProductPref
)
SELECT 
 `Customer type`,
 `Product line` AS BestProductlinePreferred,
 TotalSales
 FROM RankedPro 
 WHERE RevenueRank = 1;
 
# 8 : Finding Top 5 Customers by Sales Volume
SELECT 
`Invoice ID`,
SUM(Total) as TotalSales
from walmart
group by `Invoice ID`
order by TotalSales DESC
limit 5;

#10: Analyzing Sales Trends by Day of the Week 
SELECT DAYOFWEEK(Date) AS DayOfWeek, 
      Round( SUM(Total),2) AS TotalSales
FROM walmart
GROUP BY DAYOFWEEK(Date)
ORDER BY DayOfWeek;
  
# 11: Average Transaction Value by Payment Method
SELECT 
  `Payment`,
  ROUND(AVG(Total), 2) AS AvgTransactionValue
FROM walmart
GROUP BY Payment
ORDER BY AvgTransactionValue DESC;

# 12: Branch-wise Product Line Performance
SELECT 
  Branch,
  `Product line`,
  ROUND(SUM(Total), 2) AS TotalSales
FROM walmart
GROUP BY Branch, `Product line`
ORDER BY Branch, TotalSales DESC;

# 13: Customer Type Spending Patterns
SELECT 
  `Customer type`,
  ROUND(AVG(Total), 2) AS AvgSpending
FROM walmart
GROUP BY `Customer type`;

# 14: Best Performing City by Revenue
SELECT 
  `City`, 
  ROUND(SUM(Total), 2) AS TotalSales
FROM walmart
GROUP BY City
ORDER BY TotalSales DESC;

# 15: Peak Sales Hour by Branch
SELECT 
  `Branch`,
  HOUR(`Time`) AS Hour,
  ROUND(SUM(Total), 2) AS TotalSales
FROM walmart
GROUP BY Branch, HOUR(`Time`)
ORDER BY Branch, TotalSales DESC;

