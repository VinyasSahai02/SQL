-- Categories Table
category_id	INT
category_name	TEXT
description	TEXT

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

-- Suppliers Table
supplier_id	INT
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
home_page	TEXT

-- Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
select products.product_name,suppliers.company_name,categories.category_name from products
join categories on categories.category_id= products.category_id
join suppliers on suppliers.supplier_id= products.supplier_id

-- Show the category_name and the average product unit price for each category rounded to 2 decimal places.
select category_name, round(avg(unit_price),2) from products
left join categories on categories.category_id = products.category_id
GROUP BY category_name

-- Show the city, company_name, contact_name from the customers and suppliers table merged together.
-- Create a column which contains 'customers' or 'suppliers' depending on the table it came from.
select city,company_name,contact_name,"Customers" from customers
union
select city,company_name,contact_name, "Suppliers" from suppliers