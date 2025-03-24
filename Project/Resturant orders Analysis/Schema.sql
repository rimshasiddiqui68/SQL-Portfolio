-- Create a database if does not exist
CREATE DATABASE resturant_orders;

CREATE TABLE menu_items1
LIKE menu_items;

CREATE TABLE order_details1
LIKE order_details;

INSERT menu_items1
SELECT * FROM menu_items;

INSERT order_details1
SELECT * FROM 
order_details;

-- checking the duplicates 
select `ï»¿menu_item_id` ,count(*)
from menu_items1
group by `ï»¿menu_item_id`
having count(*)>1 ;

select `ï»¿order_details_id` ,count(*)
from order_details1
group by `ï»¿order_details_id`
having count(*) > 1;
-- -- No duplicate found

-- LETS change the header of both table
ALTER table menu_items1
CHANGE 
`ï»¿menu_item_id` menu_item_id INT;
ALTER TABLE order_details1
CHANGE
`ï»¿order_details_id` order_details_id INT;

-- Let's Update Date Format and it's type to Date
UPDATE order_details1
set order_date = str_to_date(order_date, '%m/%d/%Y');

ALTER TABLE order_details1
MODIFY COLUMN
order_date date;
desc order_details1;
