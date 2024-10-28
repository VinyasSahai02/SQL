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


-- Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late.
-- Order by employee last_name, then by first_name, and then descending by number of orders.
select employees.first_name,employees.last_name, count(orders.order_id) as num_orders,
(case 
when orders.shipped_date<=orders.required_date then "On Time"
else "Late"
end) as Shipped 
from employees
join orders on employees.employee_id = orders.employee_id
group by employees.first_name, employees.last_name, Shipped
ORDER BY employees.last_name, employees.first_name, num_orders DESC


-- Order_Details Table
order_id	INT
product_id	INT
quantity	INT
discount	DECIMAL

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

-- Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places
Select 
YEAR(orders.order_date) AS 'order_year' , 
ROUND(SUM(products.unit_price * order_details.quantity * order_details.discount),2) AS 'discount_amount' 
from orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
group by YEAR(orders.order_date)
order by order_year desc;
