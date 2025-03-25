## Resturant Order Analysis
## `Basic Analysis`

**1.How many unique menu items are available?**
```sql
SELECT distinct count(item_name) as Total_menu_items
FROM menu_items1;
```
**Result Set :**
|    Total Menu Items|
|------------------|
|  32   |  
<br>

**2.Different categories in menu_item**
```sql
SELECT DISTINCT category
FROM menu_items1;
```
**Result Set :**
| Category  |
|-----------|
| American  |
| Asian     |
| Mexican   |
| Italian   |
<br>

**3.No of items in each category**
```sql
select category, count(item_name) as No_of_dishes
from menu_items1
group by category;
```
**Result Set :**
| Cuisine   | Number of Dishes |
|-----------|----------------|
| American  | 6              |
| Asian     | 8              |
| Mexican   | 9              |
| Italian   | 9              |
<br>

**4.what is the average price of menu items**
```sql
SELECT category, count(item_name) as No_of_dishes, avg(price) as Avg_price
from menu_items1
GROUP BY category;
```
**Result Set :**
| Cuisine   | Number of Dishes | Average Price ($) |
|-----------|----------------|-------------------|
| American  | 6              | 10.07            |
| Asian     | 8              | 13.48            |
| Mexican   | 9              | 11.80            |
| Italian   | 9              | 16.75            |
<br>

**5.Least expensive item on the menu**
```sql
SELECT category, item_name,price
from menu_items1
order by price asc;
```
**Result Set :**
displaying only first 5 entries for convenience
| Category  | Item Name     | Price ($) |
|-----------|-------------|-----------|
| Asian     | Edamame     | 5         |
| American  | Mac & Cheese | 7         |
| American  | French Fries | 7         |
| Mexican   | Chips & Salsa | 7         |
| American  | Hot Dog     | 9         |
<br>

**6.Most expensive item on the menu**
```sql
SELECT category, item_name,price
from menu_items1
order by price desc;
```
**Result Set :**
displaying only first 8 entries for convenience
| Category | Item Name              | Price ($) |
|----------|------------------------|-----------|
| Italian  | Shrimp Scampi          | 19.95     |
| Asian    | Korean Beef Bowl       | 17.95     |
| Asian    | Pork Ramen             | 17.95     |
| Italian  | Spaghetti & Meatballs  | 17.95     |
| Italian  | Meat Lasagna           | 17.95     |
| Italian  | Chicken Parmesan       | 17.95     |
| Italian  | Eggplant Parmesan      | 16.95     |
| Asian    | Orange Chicken         | 16.50     |
<br>

**7. How many total orders have been placed**
```sql
SELECT count(order_id) as Total_orders
FROM order_details1;
```
**Result Set :**
| Total Orders |
|----------|
| 12234    | 
<br>

## `Order Based Analysis`

**8.Total revenue generated from all orders**
```sql
SELECT SUM(m.price) as Total_revenue 
from order_details1 o
JOIN menu_items1 m ON 
o.item_id = m.menu_item_id;
```
**Result Set :**
| Total Revenue ($)  |
|----------|
| 159,217.90   | 
<br>

**9.which menu item has been orderd the most**
```sql
SELECT m.category,m.item_name,count(o.item_id) as order_count
from order_details1 o 
JOIN menu_items1 m On o.item_id = m.menu_item_id
GROUP by m.item_name,m.category
ORDER BY order_count desc;
```
**Result Set :** displaying only first 8 entries for convenience

| Category  | Item Name             | Order Count |
|-----------|----------------------|-------------|
| American  | Hamburger            | 622         |
| Asian     | Edamame              | 620         |
| Asian     | Korean Beef Bowl     | 588         |
| American  | Cheeseburger         | 583         |
| American  | French Fries         | 571         |
| Asian     | Tofu Pad Thai        | 562         |
| Mexican   | Steak Torta          | 489         |
| Italian   | Spaghetti & Meatballs | 470         |
<br>

**10.Top 5 most ordered menu items**
```sql
SELECT m.category,m.item_name,count(o.item_id) as order_count
from order_details1 o 
JOIN menu_items1 m On o.item_id = m.menu_item_id
GROUP by m.item_name,m.category
ORDER BY order_count desc
limit 5;
```
**Result Set :**
| Category  | Item Name             | Order Count |
|-----------|----------------------|-------------|
| American  | Hamburger            | 622         |
| Asian     | Edamame              | 620         |
| Asian     | Korean Beef Bowl     | 588         |
| American  | Cheeseburger         | 583         |
| American  | French Fries         | 571         |
<br>

**11.Least ordered menu item**
```sql
SELECT m.category,m.item_name,count(o.item_id) as order_count
from order_details1 o 
JOIN menu_items1 m On o.item_id = m.menu_item_id
GROUP by m.item_name,m.category
ORDER BY order_count asc;
```
**Result Set :** displaying only first 8 entries for convenience
| Category  | Item Name             | Order Count |
|-----------|----------------------|-------------|
| Mexican   | Chicken Tacos        | 123         |
| Asian     | Potstickers          | 205         |
| Italian   | Cheese Lasagna       | 207         |
| Mexican   | Steak Tacos          | 214         |
| Mexican   | Cheese Quesadillas   | 233         |
| Mexican   | Chips & Guacamole    | 237         |
| American  | Veggie Burger        | 238         |
| Italian   | Shrimp Scampi        | 239         |
<br>

**12.total no of item sold per category**
```sql
SELECT m.category , count(o.item_id) as Total_item_sold
from order_details1 o
JOIN menu_items1 m ON o.item_id = m.menu_item_id
GROUP BY category;
```
**Result Set :**
| Category  |Total item sold       | 
|-----------|----------------------|
| Asian     | 3470        |
| Italian   | 2948         | 
| Mexican   | 2945     | 
| Americam  | 2734         |
<br>

**13.Find the order id with most no of items**
```sql
SELECT order_id, COUNT(item_id) AS item_count
FROM order_details1
GROUP BY order_id
ORDER BY item_count DESC;
```
**Result Set :** displaying only first 8 entries for convenience
| Order ID | Number of Items Ordered |
|----------|------------------------|
| 4305     | 14                     |
| 3473     | 14                     |
| 1957     | 14                     |
| 330      | 14                     |
| 440      | 14                     |
| 443      | 14                     |
| 2675     | 14                     |
| 5066     | 13                     |
<br>

**14.Find the orders which has more than 12 menu items**
```sql
SELECT order_id, count(item_id) as Item_count
FROM order_details1
GROUP BY order_id
having Item_count > 12;
```
**Result Set :** displaying only first 8 entries for convenience
| Order ID | Number of Items Ordered |
|----------|------------------------|
| 330      | 14                     |
| 440      | 14                     |
| 443      | 14                     |
| 1274     | 13                     |
| 1569     | 13                     |
| 1685     | 13                     |
| 1734     | 13                     |
| 1957     | 14                     |
<br>

**15. How many orders has more than 12 menu items**
```sql
SELECT COUNT(order_id) as order_count
from(SELECT order_id, count(item_id) as Item_count
FROM order_details1
group by order_id
having Item_count>12) as fr;
```
**Result Set :**
| Order Count |
|----------|
| 20     |
<br>

**16.Top 5 order that spend the most money**
```sql
SELECT o.order_id , sum(m.price) as Total_amount
FROM menu_items1 m
JOIN order_details1 o on o.item_id = m.menu_item_id
GROUP BY o.order_id
ORDER BY Total_amount desc
LIMIT 5;
```
**Result Set :**
| Order ID | Total Amount ($) |
|----------|------------------|
| 440      | 192.15           |
| 2075     | 191.05           |
| 1957     | 190.10           |
| 330      | 189.70           |
| 2675     | 185.10           |
<br>

## ` Time-Based Analysis`

**17.What is the trend of orders per day? (Daily order count)**
```sql
SELECT order_date, count(distinct order_id) as Total_order
FROM order_details1
GROUP BY order_date
ORDER BY order_date;
```
**Result Set :** displaying only 8 first entries for better convinience
| Order Date  | Total Orders |
|------------|--------------|
| 2023-01-01 | 69           |
| 2023-01-02 | 67           |
| 2023-01-03 | 66           |
| 2023-01-04 | 52           |
| 2023-01-05 | 54           |
| 2023-01-06 | 64           |
| 2023-01-07 | 58           |
| 2023-01-08 | 72           |
<br>

**18.What are the peak order times? (Most frequent order hours)**
```sql
SELECT 
    DATE_FORMAT(STR_TO_DATE(order_time, '%h:%i:%s %p'), '%h %p') AS order_hour, 
    COUNT(*) AS total_orders
FROM order_details1
GROUP BY order_hour
ORDER BY total_orders DESC;
```
**Result Set :** displaying only 8 first entries for better convinience
| Order Hour | Total Orders |
|------------|-------------|
| 12 PM      | 1672        |
| 01 PM      | 1575        |
| 05 PM      | 1370        |
| 06 PM      | 1307        |
| 07 PM      | 1085        |
| 04 PM      | 1054        |
| 02 PM      | 968         |
| 08 PM      | 889         |
<br>

**19.How does order volume change over time (monthly)**
```sql
SELECT
   DATE_FORMAT(order_date, '%Y-%m') AS month, 
COUNT(DISTINCT order_id) AS Total_orders
FROM order_details1
GROUP BY month
order by month;
```
**Result Set :** 
| Order Month | Total Orders |
|------------|--------------|
| 2023-01    | 1845         |
| 2023-02    | 1685         |
| 2023-03    | 1840         |
<br>

## `Customer Behavior & Pricing Analysis`

**20.What is total revenue per category**
```sql
SELECT m.category , sum(m.price) AS Total_revenue
FROM order_details1 o
JOIN menu_items1 m ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY Total_revenue desc;
```

**Result Set :**
| Category  | Total Revenue ($)     |
|-----------|----------------------|
| Italian   | 49,462.70            |
| Asian     | 46,720.65            |
| Mexican   | 34,796.80            |
| American  | 28,237.75            |
<br>

**21.What is the most expensive order ever placed**
```sql
SELECT o.order_id,
SUM(m.price) AS total_order_value
FROM order_details1 o
JOIN menu_items1 m ON o.item_id = m.menu_item_id
GROUP BY o.order_id
ORDER BY total_order_value desc
LIMIT 1;
```

**Result Set :**
| Order ID | Total Order Value ($) |
|----------|----------------------|
| 440      | 192.15               |
<br>

**22.Details of highest spends orders**
```sql
SELECT 
    m.item_name,
    m.category,
    o.order_id,
    order_summary.total_order_value,
    order_summary.total_items
FROM order_details1 o
JOIN menu_items1 m ON o.item_id = m.menu_item_id
JOIN (
    -- Subquery to calculate total order value and total items per order
    SELECT 
        order_id,
        SUM(m.price) AS total_order_value,
        COUNT(o.item_id) AS total_items
    FROM order_details1 o
    JOIN menu_items1 m ON o.item_id = m.menu_item_id
    GROUP BY order_id
) AS order_summary ON o.order_id = order_summary.order_id
ORDER BY order_summary.total_order_value DESC;
```
**Result Set :** displaying first 22 entries for better convinience 
| Item Name              | Category  | Order ID | Total Order Value | Total Items |
|------------------------|----------|----------|-------------------|-------------|
| Eggplant Parmesan     | Italian  | 440      | 192.15            | 14          |
| French Fries         | American | 440      | 192.15            | 14          |
| Chicken Parmesan     | Italian  | 440      | 192.15            | 14          |
| Chips & Salsa       | Mexican  | 440      | 192.15            | 14          |
| Edamame             | Asian    | 440      | 192.15            | 14          |
| Meat Lasagna        | Italian  | 440      | 192.15            | 14          |
| Korean Beef Bowl    | Asian    | 440      | 192.15            | 14          |
| Fettuccine Alfredo  | Italian  | 440      | 192.15            | 14          |
| Fettuccine Alfredo  | Italian  | 440      | 192.15            | 14          |
| Spaghetti & Meatballs | Italian | 440      | 192.15            | 14          |
| Spaghetti & Meatballs | Italian | 440      | 192.15            | 14          |
| Spaghetti           | Italian  | 440      | 192.15            | 14          |
| Hot Dog            | American | 440      | 192.15            | 14          |
| Steak Tacos       | Mexican  | 440      | 192.15            | 14          |
| Eggplant Parmesan  | Italian  | 2075     | 191.05            | 13          |
| Eggplant Parmesan  | Italian  | 2075     | 191.05            | 13          |
| Chips & Salsa      | Mexican  | 2075     | 191.05            | 13          |
| Steak Burrito      | Mexican  | 2075     | 191.05            | 13          |
| Salmon Roll       | Asian    | 2075     | 191.05            | 13          |
| California Roll   | Asian    | 2075     | 191.05            | 13          |
| Mushroom Ravioli  | Italian  | 2075     | 191.05            | 13          |
| Meat Lasagna      | Italian  | 2075     | 191.05            | 13          |
<br>

**22.Total orders per menu item categorized by their respective menu categories:**
```sql
SELECT 
    m.category, 
    m.item_name, 
    COUNT(o.item_id) AS total_orders
FROM order_details1 o
JOIN menu_items1 m ON o.item_id = m.menu_item_id
GROUP BY m.category, m.item_name
ORDER BY m.category, total_orders DESC;
```
**Result Set :**

| Category  | Item Name              | Total Orders |
|-----------|------------------------|--------------|
| Asian     | Edamame                | 620          |
| Asian     | Korean Beef Bowl       | 588          |
| Asian     | Tofu Pad Thai          | 562          |
| Asian     | Orange Chicken         | 456          |
| Asian     | Pork Ramen             | 360          |
| Asian     | California Roll        | 355          |
| Asian     | Salmon Roll            | 324          |
| Asian     | Potstickers            | 205          |
| Italian   | Spaghetti & Meatballs  | 470          |
| Italian   | Eggplant Parmesan      | 420          |
| Italian   | Spaghetti              | 367          |
| Italian   | Chicken Parmesan       | 364          |
| Italian   | Mushroom Ravioli       | 359          |
| Italian   | Meat Lasagna           | 273          |
| Italian   | Fettuccine Alfredo     | 249          |
| Italian   | Shrimp Scampi          | 239          |
| Italian   | Cheese Lasagna         | 207          |
| Mexican   | Steak Torta            | 489          |
| Mexican   | Chips & Salsa          | 461          |
| Mexican   | Chicken Burrito        | 455          |
| Mexican   | Chicken Torta          | 379          |
| Mexican   | Steak Burrito          | 354          |
| Mexican   | Chips & Guacamole      | 237          |
| Mexican   | Cheese Quesadillas     | 233          |
| Mexican   | Steak Tacos            | 214          |
| Mexican   | Chicken Tacos          | 123          |
<br>


