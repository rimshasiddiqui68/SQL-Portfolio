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



