# ShipEase Logistic Data Analysis

<p align="center">
  <img src="https://github.com/rimshasiddiqui68/SQL-Portfolio/blob/8490b548e5af8f10b1d955dce5a115a579a1fc7a/Project-ShipEase%20Logistic%20Data%20Analysis/Screenshot%202025-11-06%20192826.png?raw=true" alt="ShipEase Logistic Analysis" width="100%">
</p>

## Introduction
In the scope of this project, the objective is to explore and analyse the operational data of a logistics company, focusing on understanding how efficiently the company manages shipments, payments, and customer relationships. Using MySQL for querying and data exploration, this project examines key metrics such as delivery timelines, shipment costs, employee performance, and customer memberships. The goal is to uncover trends, identify process inefficiencies, and derive actionable insights to improve logistics operations and client satisfaction.

## Dataset Description
The dataset used in this project consists of seven interconnected CSV files that replicate the inner workings of a real logistics company covering everything from shipment management and payment tracking to employee performance and customer retention.

## Problem Description
The logistics company operates in both domestic and international sectors, managing the end-to-end movement of goods from suppliers to customers. Each stage from shipment creation and tracking to payment collection directly impacts cost efficiency and customer satisfaction.  

Shipments include various types of products, and payments are processed upon delivery. Both the delivery staff and branch heads are responsible for updating shipment status to ensure accurate tracking. 

The goal is to design and analyze a relational database that reflects these real-world logistics operations, enabling insights into delivery performance, cost management, and customer engagement through structured data analysis.

## Approach
1. **Data Import:** Load the CSV files into MySQL using the Import Table Wizard.  
2. **Data Cleaning:** Ensure no null values are present and correct any inconsistencies.  
3. **Column Renaming:** Rename columns for clarity and consistency.  
4. **Data Typing:** Convert columns to appropriate data types for analysis.

## List of Analytical Questions to be solved
The following analytical questions were explored using MySQL to uncover insights from the logistics company’s database. These queries focus on data validation, customer analysis, shipment efficiency, and overall operational performance.

1. Identify incorrect delivery dates in the `Status` table where the month exceeds 12.  
2. Detect records where the month is February but the date is incorrectly entered as 30 or 31.  
3. Check for empty or missing values and convert them into `NULL`.  
4. Convert date columns into a proper `DATE` format.  
5. Change column data types from `TEXT` to `DATE` for consistency.  
6. Identify records where the Delivery Date is earlier than the Sent Date.  
7. Flag such entries as logically incorrect dates for data quality tracking.  
8. Create a view to calculate the Total Payable Amount (Amount + Shipping Charges).  
9. Create a view `PaymentNotDone` to identify customers with pending payments.  
10. Find the frequency (in percentage) of each payment mode used.  
11. Determine the highest total payable amount across all shipments.  
12. Extract the Customer ID and Name of customers whose membership lasted (or will last) more than 10 years.  
13. Identify customers who got their product delivered on the next day after it was sent.  
14. Determine the top 5 shipping contents with the highest total amount.  
15. Find which product categories are shipped most frequently.  
16. Analyze which service type is preferred most by customers.  
17. Retrieve shipments where the weight is greater than the average weight.  
18. Calculate the percentage of customers in each type category.  
19. Identify unique employee designations across all branches.  
20. Calculate total revenue by month and year.  
21. Find the percentage of unpaid payments.  
22. Identify the product with the highest shipping cost.  
23. Calculate the average membership duration (in years).  
24. Determine the average payment amount per mode of payment.

 ## Tool Used : `MySql`

 ## 📊 Detailed Analysis Report

You can read the complete storytelling-style analysis and insights here:  
➡️ [View Full Analysis Report](https://github.com/rimshasiddiqui68/SQL-Portfolio/blob/7f8c65b84532e7c69404ed5ac4473d69eb4231fb/Project-ShipEase%20Logistic%20Data%20Analysis/Analysis.md)


