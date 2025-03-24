# 📊 Sql Project- Resturant Order Analysis

![Project/Resturant orders Analysis/DALL·E 2025-03-25 03.08.35 - A professional and modern cover image for a restaurant order analysis project. The image should feature a stylish restaurant setting with digital orde.webp](https://github.com/rimshasiddiqui68/SQL-Portfolio/blob/0ea0e7833082db05d731e135e5ba60601b5f1413/Project/Resturant%20orders%20Analysis/DALL%C2%B7E%202025-03-25%2003.08.35%20-%20A%20professional%20and%20modern%20cover%20image%20for%20a%20restaurant%20order%20analysis%20project.%20The%20image%20should%20feature%20a%20stylish%20restaurant%20setting%20with%20digital%20orde.webp)

## About this Project

 This project provides an insightful dataset capturing a quarter’s worth of customer orders from a restaurant serving international cuisine.
 Within this dataset, you’ll find comprehensive details on each order—including the date, time, ordered items, and menu information like cuisine type, item names, and pricing. This analysis offers a deep dive into customer preferences, spending patterns, and ordering trends, helping to uncover key business insights!

## 🗂️ Data Schema
### **1️⃣ menu_items1 Table**
Contains information about menu items available in the restaurant.

| Column       | Data Type  | Description                              |
|-------------|-----------|------------------------------------------|
| menu_item_id | INT (Primary Key) | Unique ID for each menu item |
| item_name   | VARCHAR   | Name of the menu item                   |
| category    | VARCHAR   | Type of cuisine or menu category        |
| price       | DECIMAL   | Price of the menu item in US dollars    |

### **2️⃣ order_details1 Table**
Contains details of customer orders.

| Column          | Data Type  | Description                                |
|----------------|-----------|--------------------------------------------|
| order_details_id | INT (Primary Key) | Unique ID of an order item     |
| order_id       | INT (Foreign Key) | ID of the order                     |
| order_date     | DATE      | Date of order placement (MM/DD/YY)        |
| order_time     | Text      | Time of order placement (HH:MM:SS AM/PM)  |
| item_id        | INT (Foreign Key) | References `menu_item_id` in `menu_items1` |

## 📊 Recommended Analysis
- **What were the least and most ordered items?** Identify popular and underperforming menu items and their categories.
- **What do the highest spend orders look like?** Analyze which items were included in high-value orders and the total spending.
- **Were there certain times that had more or fewer orders?** Discover peak business hours and off-peak times.
- **Which cuisines should we focus on developing more menu items for?** Determine which categories receive the most orders to refine the menu.

  ## 🔍 Approach  

- **Data Acquisition:** Imported restaurant order data into an SQL database, consisting of menu details and customer order records.  
- **Data Cleaning:** Used SQL to refine the dataset by removing duplicates, ensuring data consistency, and standardizing date and time formats for seamless analysis.  
- **Information Extraction:** Queried key details such as the most and least ordered items, total sales per category, and high-value orders.  
- **Advanced SQL Analysis:** Applied advanced SQL techniques, including aggregations and joins, to uncover ordering trends, peak ordering times, and revenue insights.  
- **Metric Exploration:** Analyzed various performance metrics, such as total revenue, average order value, and item popularity, to understand customer preferences.  
- **Business Insights & Recommendations:** Derived actionable insights to optimize menu offerings, improve operational efficiency, and enhance customer experience.

- ## 🔗 Dataset Link  
📂 **Restaurant Order Dataset:** [Click here](https://mavenanalytics.io/data-playground?accessType=open&dataStructure=Multiple%20tables&order=date_added%2Cdesc&page=3&pageSize=5) to access the dataset.  

## 📬 Contact  
For queries, reach out via GitHub Issues or connect on [LinkedIn](https://www.linkedin.com/in/rimsha-siddiqui-501618268/).  

