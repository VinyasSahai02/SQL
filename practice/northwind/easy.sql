-- Categories Table
category_id	INT
category_name	TEXT
description	TEXT

-- Show the category_name and description from the categories table sorted by category_name.
select category_name, description from categories
order by category_name


-- Customers Table
customer_id	TEXT
company_name	TEXT
contact_name	TEXT
contact_title	TEXT
address	TEXT
city	TEXT
region	TEXT
postal_code	TEXT
country	TEXT
phone	TEXT
fax	TEXT

-- Show all the contact_name, address, city of all customers which are not from 'Germany', 'Mexico', 'Spain'
select contact_name, address, city from customers
where country not in ('Germany', 'Mexico', 'Spain')


-- Orders Table
order_id	INT
customer_id	TEXT
employee_id	INT
order_date	DATE
required_date	DATE
shipped_date	DATE
ship_via	INT
freight	DECIMAL
ship_name	TEXT
ship_address	TEXT
ship_city	TEXT
ship_region	TEXT
ship_postal_code	TEXT
ship_country	TEXT

-- Show order_date, shipped_date, customer_id, Freight of all orders placed on 2018 Feb 26
select order_date,shipped_date,customer_id,freight from orders
where order_date like '2018-02-26'

-- Show the employee_id, order_id, customer_id, required_date, shipped_date from all orders shipped later than the required date
select employee_id,order_id,customer_id,required_date,shipped_date from orders
where shipped_date > required_date

-- Show the employee_id, order_id, customer_id, required_date, shipped_date from all orders shipped later than the required date
select order_id from orders
where order_id%2 == 0

-- Show the city, company_name, contact_name of all customers from cities which contains the letter 'L' in the city name, sorted by contact_name
select city,company_name,contact_name from customers
where city like "%L%"
order by contact_name

-- Show the company_name, contact_name, fax number of all customers that has a fax number. (not null)
select company_name,contact_name,fax from customers
where fax is not null


-- Employees Table
employee_id	INT
last_name	TEXT
first_name	TEXT
title	TEXT
title_of_courtesy	TEXT
birth_date	DATE
hire_date	DATE
address	TEXT
city	TEXT
region	TEXT
postal_code	TEXT
country	TEXT
home_phone	TEXT
extension	TEXT
reports_to	INT

-- Show the first_name, last_name. hire_date of the most recently hired employee.
select first_name,last_name,max(hire_date) from employees
-- NOTE
select first_name,last_name,hire_date from employees
where max(hire_date) 
-- is wrong as aggregate cannot be used directly with where 
-- so do this instead
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date = (SELECT MAX(hire_date) FROM employees)


-- Products Table 
product_id	INT
product_name	TEXT
supplier_id	INT
category_id	INT
quantity_per_unit	TEXT
unit_price	DECIMAL
units_in_stock	INT
units_on_order	INT
reorder_level	INT
discontinued	INT

-- Show the average unit price rounded to 2 decimal places, the total units in stock, total discontinued products from the products table.
SELECT round(avg(Unit_Price), 2) AS average_price,
SUM(units_in_stock) AS total_stock,
SUM(discontinued) as total_discontinued
FROM products;
