## ShipEase Logistic Analysis

 ## Data Cleaning

 **1.Identify incorrect delivery dates in the `Status` table where the month exceeds 12.**
 ```sql
SELECT * FROM customer;
SELECT Delivery_date from status
WHERE CAST(SUBSTRING(DELIVERY_DATE, 6, 2) AS UNSIGNED) > 12;
```
There were several rows which had month > 12

**2.Detect records where the month is February but the date is incorrectly entered as 30 or 31.**
 ```sql
SELECT *
FROM Status
WHERE MONTH(STR_TO_DATE(DELIVERY_DATE, '%m/%d/%Y')) = 2 
  AND DAY(STR_TO_DATE(DELIVERY_DATE, '%m/%d/%Y')) > 29; 
```
As a result there were no such entries

**3.Check for empty or missing values and convert them into NULL.**

Checking to empyty entries
```sql
  SELECT *
FROM Status
WHERE DELIVERY_DATE IS NULL
   OR DELIVERY_DATE = ''
   OR DELIVERY_DATE LIKE '%NA%'
   OR DELIVERY_DATE = '0000-00-00'; 
```
Let's Convert these empty row entries into null for the 
```sql
  UPDATE status
SET delivery_Date = NULL
WHERE deliver_Date = ''; 
```
Doing the same for the rest Date columns.

**4.Convert date columns into a proper DATE format.**
```sql
UPDATE Status
SET Sent_date = STR_TO_DATE(Sent_date, '%m/%d/%Y')
WHERE Sent_date LIKE '%/%/%';
```
```sql
UPDATE Payment_Details
	SET Payment_Date = STR_TO_DATE(Payment_Date,'%m/%d/%Y')
   WHERE Payment_Date LIKE '%/%/%';
```
```sql
PDATE membership
	SET End_Date = STR_TO_DATE(End_Date,'%m/%d/%Y')
   WHERE End_Date LIKE '%/%/%';
```
**5.Change column data types from TEXT to DATE for consistency.**
```sql
ALTER TABLE payment_details
	MODIFY COLUMN Payment_Date DATE;
```
```sql
ALTER TABLE STATUS
	MODIFY COLUMN Delivery_Date Date, MODIFY COLUMN Sent_Date Date ;
```
```sql
ALTER TABLE MEMBERSHIP
	MODIFY COLUMN Start_Date Date, MODIFY COLUMN End_Date Date ;
```
**6.There are some values where the Delivery Date is < then Sent Date **
```sql
SELECT *
FROM Status
WHERE DELIVERY_DATE < SENT_DATE;
```
**Result Set :**

| SH_ID | Current_Status | Sent_Date | Delivery_Date |
|-------|----------------|------------|----------------|
| 998 | DELIVERED | 2013-11-21 | 2013-11-15 |
| 390 | DELIVERED | 2009-03-24 | 2009-03-09 |
| 227 | DELIVERED | 2002-01-25 | 2002-01-05 |
| 57  | DELIVERED | 2004-03-18 | 2004-03-02 |
| 246 | DELIVERED | 2019-03-03 | 2019-03-01 |
| 172 | DELIVERED | 2004-10-29 | 2004-10-26 |
| 969 | DELIVERED | 2013-03-19 | 2013-03-09 |
| 536 | DELIVERED | 2016-09-23 | 2016-09-21 |
| 25  | DELIVERED | 2004-05-29 | 2004-05-17 |
| 473 | DELIVERED | 2012-01-25 | 2012-01-17 |
| 872 | DELIVERED | 2008-05-21 | 2008-05-17 |
| 866 | DELIVERED | 1995-01-22 | 1995-01-01 |
<br>
 ⚠️ Delivery date is earlier than the sent date indicating incorrect data entry, let's fix this.
 
 **7.Flag such entries as logically incorrect dates for data quality tracking.**
```sql
ALTER TABLE Status ADD COLUMN Delivery_Flag VARCHAR(20);
UPDATE Status
SET Delivery_Flag = 'Invalid Date'
WHERE DELIVERY_DATE < SENT_DATE
  AND current_STATUS = 'Delivered';
```
**Result Set :** 
> 🚩 *Flagged entries where the delivery date is earlier than the sent date — marked as 'Invalid Date'.*

Displaying only first 5 entries for convenience
> 
| SH_ID | Current_Status | Sent_Date | Delivery_Date | Delivery_Flag |
|-------|----------------|------------|----------------|----------------|
| 998 | DELIVERED | 2013-11-21 | 2013-11-15 | Invalid Date |
| 390 | DELIVERED | 2009-03-24 | 2009-03-09 | Invalid Date |
| 227 | DELIVERED | 2002-01-25 | 2002-01-05 | Invalid Date |
| 57  | DELIVERED | 2004-03-18 | 2004-03-02 | Invalid Date |
| 246 | DELIVERED | 2019-03-03 | 2019-03-01 | Invalid Date |

<br>

## Analysis

**8.Create a view to calculate the Total Payable Amount (Amount + Shipping Charges)**
```sql
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
```
**Result Set :** 
Displaying only first 5 entries for convenience
| SH_ID | C_ID | Product_Price | SH_CHARGES | Total_Payable_Charges |
|-------|------|----------------|-------------|------------------------|
| 690   | 230  | 49302          | 1210        | 50512                 |
| 933   | 3189 | 78698          | 1114        | 79812                 |
| 261   | 2216 | 69417          | 1020        | 70437                 |
| 445   | 1904 | 39655          | 1351        | 41006                 |
| 722   | 7342 | 87400          | 566         | 87966                 |

<br>

**9.Create a view PaymentNotDone to identify customers with pending payments.**
```sql
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
```
**Result Set :** 
Displaying only first 5 entries for convenience
| Payment_Status | Amount | C_ID | C_Name   | C_Email_ID                | C_Contact_No |
|----------------|---------|------|----------|---------------------------|---------------|
| NOT PAID       | 69417   | 2216 | Jaylene  | Geraldine867@ymail.co.in  | 9835395970    |
| NOT PAID       | 39655   | 1904 | Stacie   | Brenda905@ymail.com       | 3881250181    |
| NOT PAID       | 87400   | 7342 | Jonathan | Malie282@gmail.com        | 1507211823    |
| NOT PAID       | 99239   | 2154 | Catherine| Clay224@gmail.com         | 8094222335    |
| NOT PAID       | 23921   | 5543 | Pierre   | Alaysha578@hotmail.com    | 4133741447    |

<br>

**10.Find the frequency (in percentage) of each payment mode used.**

```sql
SELECT Payment_mode,
count(*) As Total_Transactions,
Round((count(*)* 100.0/ (SELECT COUNT(*) From Payment_details)),2) AS Percentage
FROM Payment_details
GROUP BY Payment_mode
Order By 
Percentage DESC;
```
**Result Set :** 
| Payment_Mode  | Total_Transactions | Percentage |
|----------------|--------------------|-------------|
| COD            | 106                | 53.00%      |
| CARD PAYMENT   | 94                 | 47.00%      |

<br>

**11.Determine the highest total payable amount across all shipments.**
```sql
SELECT MAX(Total_Payable_Charges)
from Payment_summary;
```
**Result Set :** 
| MAX(Total_Payable_Charges) | 
|----------------------------|
| '100989'                   | 

<br>

**12.Extract the Customer ID and Name of customers whose membership lasted (or will last) more than 10 years.**
```sql
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
```
**Result Set :** Displaying First 9 entries for Convinience 

| C_ID | C_NAME   | START_DATE  | END_DATE   | Membership_Years |
|------|-----------|-------------|-------------|------------------|
| 3189 | Reginald  | 2014-09-26  | 2034-04-11  | 20 |
| 7633 | Italia    | 1986-06-20  | 2006-07-22  | 20 |
| 6713 | Merna     | 2004-09-17  | 2024-06-03  | 20 |
| 4527 | Austin    | 1989-11-30  | 2009-06-14  | 20 |
| 3622 | Eddie     | 2018-10-02  | 2038-12-07  | 20 |
| 3270 | George    | 1998-09-20  | 2018-10-29  | 20 |
| 7771 | Andre     | 2002-11-14  | 2022-12-23  | 20 |
| 9917 | Franklin  | 2014-04-17  | 2033-12-04  | 20 |
| 2216 | Jaylene   | 1983-10-23  | 2002-07-13  | 19 |

<br>

**13.Identify customers who got their product delivered on the next day after it was sent.**
```sql
SELECT *
FROM Status
WHERE DATEDIFF(Delivery_Date, Sent_Date) = 1;
```
**Result Set :**
| SH_ID  | Current_Status | Sent_Date   | Delivery_Date |
|--------|----------------|-------------|----------------|
| 127    | DELIVERED      | 2006-01-08  | 2006-01-09     | 

<br>

**14.Determine the top 5 shipping contents with the highest total amount.**
```sql
SELECT s.SH_CONTENT,
SUM(p.AMOUNT) AS Content_Wise_Amount
FROM Shipment_details s
JOIN
payment_details p 
ON S.SH_ID = p.SH_ID
GROUP BY s.SH_CONTENT
ORDER BY Content_Wise_Amount DESC
limit 5;
```
**Result Set :**

| SH_CONTENT           | Content_Wise_Amount |
|----------------------|---------------------|
| Construction         | 1,186,840           |
| Home Furnishing      | 1,092,491           |
| Healthcare           | 1,002,275           |
| Arts and Crafts      | 947,911             |
| Industrial Equipments| 882,596             |

<br>

**15.Find which product categories are shipped most frequently.**
```sql
SELECT SH_CONTENT,
COUNT(SH_CONTENT) AS Content_wise_count
FROM shipment_details
GROUP BY SH_CONTENT
ORDER BY Content_wise_count DESC;
```
**Result Set :**

| SH_CONTENT           | Content_Wise_Count |
|----------------------|--------------------|
| Home Furnishing      | 22                 |
| Arts and Crafts      | 22                 |
| Luggage              | 21                 |
| Construction         | 21                 |
| Industrial Equipments| 19                 |
| Electronics          | 18                 |
| Hazardous Goods      | 17                 |
| Automotive           | 17                 |
| Healthcare           | 16                 |
| Food and Beverages   | 14                 |
| Fashion              | 13                 |

<br>

**16.Analyze which service type is preferred most by customers.**
```sql
SELECT SER_TYPE AS Service_Type,
COUNT(SER_TYPE) AS Frequency
FROM Shipment_details
GROUP BY SER_TYPE
ORDER BY Frequency DESC;
```
**Result Set :**
| Service_Type | Frequency |
|---------------|------------|
| Express       | 102        |
| Regular       | 98         |

<br>

**17.Retrieve shipments where the weight is greater than the average weight.**
```sql
SELECT SH_ID, SH_CONTENT, SH_WEIGHT
FROM shipment_details
WHERE SH_WEIGHT > (
    SELECT AVG(SH_WEIGHT)
    FROM shipment_details
)
ORDER BY SH_WEIGHT DESC;
```
**Result Set :** Displaying first 10 result for the convinience 

| SH_ID | SH_CONTENT         | SH_WEIGHT |
|--------|--------------------|------------|
| 191    | Home Furnishing    | 997        |
| 336    | Construction       | 996        |
| 261    | Luggage            | 994        |
| 42     | Arts and crafts    | 987        |
| 665    | Arts and crafts    | 982        |
| 444    | Construction       | 973        |
| 731    | Hazardous Goods    | 970        |
| 242    | Construction       | 959        |
| 364    | Automotive         | 957        |
| 955    | Home Furnishing    | 957        |

<br>

**18.Calculate the percentage of customers in each type category.**
```sql
SELECT 
    C_Type,
    COUNT(*) AS Count_of_Type,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customer)), 2) AS Percentage
FROM Customer
GROUP BY C_Type
ORDER BY Percentage DESC;
```
**Result Set :**
| C_Type         | Count_of_Type | Percentage |
|----------------|----------------|-------------|
| Retail         | 78             | 39.00%      |
| Internal Goods | 68             | 34.00%      |
| Wholesale      | 54             | 27.00%      |

<br>

**19.Identify unique employee designations across all branches.**

```sql
SELECT 
    distinct(E_DESIGNATION)
FROM employee_details;
```
**Result Set :** Displaying the first 10 entries for convinience

| E_DESIGNATION |
|------------------------------|
| Market analyst |
| Chief finance officer |
| Transport manager |
| Warehouse manager |
| Branch manager |
| Project director |
| HR manager |
| Material handling executive |
| Non-executive director |
| In House logistics executive |

<br>

**20.Calculate total revenue by year.**
```sql
SELECT 
    CASE 
        WHEN YEAR(Payment_Date) BETWEEN 1971 AND 1978 THEN '1971-1978'
        WHEN YEAR(Payment_Date) BETWEEN 1979 AND 1986 THEN '1979-1986'
        WHEN YEAR(Payment_Date) BETWEEN 1987 AND 1994 THEN '1987-1994'
        WHEN YEAR(Payment_Date) BETWEEN 1995 AND 2002 THEN '1995-2002'
        WHEN YEAR(Payment_Date) BETWEEN 2003 AND 2010 THEN '2003-2010'
        WHEN YEAR(Payment_Date) BETWEEN 2011 AND 2019 THEN '2011-2019'
        ELSE 'Other'
    END AS Year_Batch,
    SUM(Amount) AS Total_Revenue
FROM payment_details
WHERE payment_status = 'PAID'
GROUP BY Year_Batch
ORDER BY Year_Batch;
```
**Result Set :**

| Year_Batch | Total_Revenue |
|-------------|---------------|
| 1971-1978 | 469632 |
| 1979-1986 | 368032 |
| 1987-1994 | 826064 |
| 1995-2002 | 783957 |
| 2003-2010 | 1440237 |
| 2011-2019 | 956146 |
<br>

**21.Find the percentage of unpaid payments.**
```sql
SELECT 
    Payment_Status,
    COUNT(*) AS Total_Transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payment_details), 2) AS Percentage
FROM payment_details
WHERE payment_status = "NOT PAID"
GROUP BY Payment_Status;
```

**Result Set :**
| Payment_Status | Total_Transactions | Percentage |
|----------------|--------------------|-------------|
| NOT PAID       | 100                | 50.00%      |
<br>


**22.Identify the product with the highest shipping cost.**
```sql
SELECT SH_CONTENT , MAX(SH_CHARGES) AS SHIPPING_COST
FROM shipment_details
group by SH_CONTENT
ORDER BY SHIPPING_COST DESC ;
```
**Result Set :**
| SH_CONTENT | SHIPPING_COST |
|-------------|----------------|
| Arts and crafts | 1486 |
| Automotive | 1473 |
| Hazardous Goods | 1470 |
| Fashion | 1455 |
| Healthcare | 1446 |
| Home Furnishing | 1433 |
| Luggage | 1425 |
| Industrial Equipments | 1419 |
| Electronics | 1414 |
| Construction | 1393 |
| Food and Beverages | 1381 |

<br>

**23.Calculate the average membership duration (in years).**
```sql
SELECT 
    ROUND(AVG(DATEDIFF(
        COALESCE(End_Date, CURDATE()), 
        Start_Date
    ) / 365), 2) AS Avg_Membership_Duration_Years
FROM Membership;
```
**Result Set :**

| Avg_Membership_Duration_Years  |
|--------------------------------|
| 10.98                          |

<br>

**24.Determine the average payment amount per mode of payment.**
```sql
SELECT AVG(ps.Total_Payable_charges) as AVG_Payment,
p.payment_mode
FROM payment_summary as ps
JOIN
payment_details p
on ps.C_ID = P.C_ID
GROUP BY p.payment_mode
ORDER BY  AVG_Payment DESC;
```

**Result Set :**
| AVG_Payment | Payment_Mode  |
|--------------|---------------|
| 50492.3585   | COD           |
| 46005.4574   | CARD PAYMENT  |

<br>
