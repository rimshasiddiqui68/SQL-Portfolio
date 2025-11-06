CREATE DATABASE ShipEase;
Use ShipEase;
-------------------------------------------------------------------------------------------------------------------------------------------
--  1) Find the incorrect dates in the 'STATUS' table from the 'DELIVERY DATE' column, where the month is greater than 12.

SELECT * FROM customer;
SELECT Delivery_date from status
WHERE CAST(SUBSTRING(DELIVERY_DATE, 6, 2) AS UNSIGNED) > 12;

--------------------------------------------------------------------------------------------------------------------------------------------
-- # 2) Search for the records where the month is February but the date is incorrectly entered as 30 and 31.

SELECT *
FROM Status
WHERE MONTH(STR_TO_DATE(DELIVERY_DATE, '%m/%d/%Y')) = 2 
  AND DAY(STR_TO_DATE(DELIVERY_DATE, '%m/%d/%Y')) > 29;    # As a result there were no such entries
  
  --------------------------------------------------------------------------------------------------------------------------------------------------
  -- # 3) Checking for the empty values and converting tjem into NULL
  SELECT *
FROM Status
WHERE DELIVERY_DATE IS NULL
   OR DELIVERY_DATE = ''
   OR DELIVERY_DATE LIKE '%NA%'
   OR DELIVERY_DATE = '0000-00-00';

UPDATE status
SET delivery_Date = NULL
WHERE deliver_Date = '';     # Doing the same for the rest date columns

------------------------------------------------------------------------------------------------------------------------------------------------
# 4) Converting the Date into proper DATE FORMAT
SET SQL_SAFE_UPDATES = 0;
UPDATE Status
SET Sent_date = STR_TO_DATE(Sent_date, '%m/%d/%Y')
WHERE Sent_date LIKE '%/%/%';

UPDATE Payment_Details
	SET Payment_Date = STR_TO_DATE(Payment_Date,'%m/%d/%Y')
   WHERE Payment_Date LIKE '%/%/%';
    
UPDATE membership
	SET End_Date = STR_TO_DATE(End_Date,'%m/%d/%Y')
   WHERE End_Date LIKE '%/%/%';

----------------------------------------------------------------------------------------------------------------------------------------------
# 5) Changing their Datatype from TEXT to DATE
ALTER TABLE payment_details
	MODIFY COLUMN Payment_Date DATE;
    
ALTER TABLE STATUS
	MODIFY COLUMN Delivery_Date Date, MODIFY COLUMN Sent_Date Date ;
ALTER TABLE MEMBERSHIP
	MODIFY COLUMN Start_Date Date, MODIFY COLUMN End_Date Date ;

--------------------------------------------------------------------------------------------------------------------------------------------------
# 6) There are some values where the Delivery Date is < then Sent Date 
SELECT *
FROM Status
WHERE DELIVERY_DATE < SENT_DATE;

# 7) Making them as flag entry caus logically these dates are incorrect
ALTER TABLE Status ADD COLUMN Delivery_Flag VARCHAR(20);
UPDATE Status
SET Delivery_Flag = 'Invalid Date'
WHERE DELIVERY_DATE < SENT_DATE
  AND current_STATUS = 'Delivered';
SELECT *
FROM Status;

---------------------------------------------------------------------------------------------------------------------------------------------------
# 8) creating a view to calculate total payable amount (Amount+ shipping charges)
CREATE VIEW Payment_Summary AS
SELECT 
    p.SH_ID,
    p.C_ID,
    p.AMOUNT AS Product_Price,
    s.SH_CHARGES,
    (p.AMOUNT + s.SH_CHARGES) AS Total_Payable_Charges
FROM 
    Payment_Details p
JOIN 
    Shipment_Details s
ON 
    p.SH_ID = s.SH_ID;
    
   SELECT * FROM Payment_Summary;
  -------------------------------------------------------------------------------------------------------------------------------------------------
  # 9) Create a view 'PaymentNotDone' of those customers who have not paid the amount.
  SELECT payment_status from payment_details;
  
  CREATE VIEW PaymentNotDone AS
  SELECT p.payment_status,
  p.C_ID,
  c.C_NAME,
  c.C_EMAIL_ID,
  c.C_CONT_NO
  FROM Payment_details p
  JOIN customer c
  on p.C_ID = c.C_ID
  where payment_status = 'NOT PAID';
  
  SELECT * FROM PaymentNotDone;
------------------------------------------------------------------------------------------------------------------------------------------------
# 10) Find the frequency (in percentage) of each of the class of the payment mode

SELECT Payment_mode,
count(*) As Total_Transactions,
Round((count(*)* 100.0/ (SELECT COUNT(*) From Payment_details)),2) AS Percentage
FROM Payment_details
GROUP BY Payment_mode
Order By 
Percentage DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------
# 11)  What is the highest total payable amount ?
SELECT MAX(Total_Payable_Charges)
from Payment_summary;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 12)Extract the customer id and the customer name  of the customers who were or will be the member of the branch for more than 10 years
SELECT 
    c.C_ID, 
    c.C_NAME, 
    m.START_DATE, 
    m.END_DATE, 
    ROUND(DATEDIFF(
    COALESCE(m.end_date,CURDATE()),m.start_date)/ 365,0)
AS Membership_Years
FROM 
    Customer c
JOIN 
    Membership m 
ON 
    c.M_ID = m.M_ID
HAVING 
    Membership_Years > 10;
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
# 13) Who got the product delivered on the next day the product was sent?
SELECT *
FROM Status
WHERE DATEDIFF(Delivery_Date, Sent_Date) = 1;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 14) Which shipping content had the highest total amount (Top 5).
select * from shipment_details;

SELECT s.SH_CONTENT,
SUM(p.AMOUNT) AS Content_Wise_Amount
FROM Shipment_details s
JOIN
payment_details p 
ON S.SH_ID = p.SH_ID
GROUP BY s.SH_CONTENT
ORDER BY Content_Wise_Amount DESC
limit 5;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 15)  Which product categories from shipment content are transferred more?  
select * from shipment_details;
SELECT SH_CONTENT,
COUNT(SH_CONTENT) AS Content_wise_count
FROM shipment_details
GROUP BY SH_CONTENT
ORDER BY Content_wise_count DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 16) Which service type is preferred more?
SELECT SER_TYPE AS Service_Type,
COUNT(SER_TYPE) AS Frequency
FROM Shipment_details
GROUP BY SER_TYPE
ORDER BY Frequency DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 17) Find the shipment id and shipment content where the weight is greater than the average weight.
SELECT SH_ID, SH_CONTENT, SH_WEIGHT
FROM shipment_details
WHERE SH_WEIGHT > (
    SELECT AVG(SH_WEIGHT)
    FROM shipment_details
)
ORDER BY SH_WEIGHT DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 18) How many customers belong to each “type” category, and express that count as a percentage of the total number of customers.
SELECT 
    C_Type,
    COUNT(*) AS Count_of_Type,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customer)), 2) AS Percentage
FROM Customer
GROUP BY C_Type
ORDER BY Percentage DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 19)  Finding the unique designations of the employees.
SELECT 
    distinct(E_DESIGNATION)
FROM employee_details;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 20)Total revenue by month or year 
SELECT YEAR(Payment_Date) AS Year, MONTH(Payment_Date) AS Month, SUM(Amount) AS Total_Revenue
FROM payment_details
where payment_status = "PAID"
GROUP BY Year, Month;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 21) find the percentage of unpaid payments
SELECT 
    Payment_Status,
    COUNT(*) AS Total_Transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payment_details), 2) AS Percentage
FROM payment_details
WHERE payment_status = "NOT PAID"
GROUP BY Payment_Status;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 22) Product with the highest shipping cost 
SELECT SH_CONTENT , MAX(SH_CHARGES) AS SHIPPING_COST
FROM shipment_details
group by SH_CONTENT
ORDER BY SHIPPING_COST DESC ;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 23) AVG Membership years
SELECT 
    ROUND(AVG(DATEDIFF(
        COALESCE(End_Date, CURDATE()), 
        Start_Date
    ) / 365), 2) AS Avg_Membership_Duration_Years
FROM Membership;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 24) Average payment amount per mode
SELECT AVG(ps.Total_Payable_charges) as AVG_Payment,
p.payment_mode
FROM payment_summary as ps
JOIN
payment_details p
on ps.C_ID = P.C_ID
GROUP BY p.payment_mode
ORDER BY  AVG_Payment DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





