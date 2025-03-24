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
