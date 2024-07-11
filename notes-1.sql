-- CREATING A SQL SCHEMA / A TABLE
CREATE TABLE products(
    -- colomn_name datatype,
    id INT NOT NULL,
    -- not null is added so that a record with no id provided cannot be created
    name STRING,
    price MONEY,
    -- MONEY is a data type-->to see more data types check docs

    PRIMARY KEY (id)
    -- allow a colomn to uniquely identify each record in the database
    -- only one record will exist with an id as 1
);

-- ADDING DATA INTO A TABLE
INSERT INTO products
VALUES (1,"Pen",10)

-- if we dont have data for some column then we add data
--  by selecting the fields for which we have the data
INSERT INTO products(id,name)
VALUES (2,"Pencil")


-- READ OPERATION IN SQL
SELECT * FROM 'products';  --display whole table
SELECT name,price FROM 'products';  --displaying particular columns from the table
SELECT * FROM 'products' 
WHERE id=1;  --displaying particular rows from the table
--there are other opertors which can be used--> see docs


--UPDATE OPERATION
UPDATE Table_name
SET column1=value1, column2=value2
WHERE condition;

UPDATE products
SET price=5
WHERE id=2;

--changing the table
--adding another column
ALTER TABLE products
ADD stock INT

UPDATE products
SET stock=32
WHERE id=1;

UPDATE products
SET stock=12
WHERE id=2;


--DELETE OPERATION
DELETE FROM products WHERE id=2;


CREATE TABLE customers(
    id INT NOT NULL,
    first_name STRING,
    last_name STRING,
    address STRING,
    PRIMARY KEY(id),
)
INSERT INTO customers
VALUES (1,'john','doe','32 cherry blvd')
INSERT INTO customers
VALUES (2,'angela','yu','12 sunset drive')


--RELATIONS IN SQL
CREATE TABLE orders(
    id INT NOT NULL,
    order_number INT,
    customer_id INT,
    product_id INT,
    PRIMARY KEY(id),
    FOREIGN KEY(customer_id) REFERENCES customers(id)
    FOREIGN KEY(product_id) REFERENCES products(id)
    --references means what value is being used to access both the tables
    --customer_id in orders table can be matched with id in customers table


    --FOREIGN KEY
    --provides a reference btw sql data
    --let us take an eg. There are 2 tables with (id,name,address) 
    --and (customer_id,product_id,order_name) as columns 
    --then customer_id serves as a foreign key
    --and can be used to access data from one table to the other
)

INSERT INTO orders
VALUES (1,4362,2,1)  --angela yu bought a pen


--JOINING 2 TABLE
SELECT orders.orders_number, customers.first_name, customers.last_name, customers.address
--these are all the columns that we join in our new table
FROM orders
--from orders as we are joining from the foreign keys in the orders table
INNER JOIN customers ON orders.customer.id=customer.id
--foreign key in orders table match with the primary key in customers table

--TABLE LOOKS LIKE
-- order_number=4362
-- first_name=angela
-- last_name=yu
-- address=12 sunset drive

--there are many join methods-->left join, right join etc.
--see docs

SELECT orders.order_number, products.name, products.price, products.stock
FROM orders
INNER JOIN products ON orders.product_id=products.id

--TABLE LOOKS LIKE
-- order_number=4362
-- name=pen
-- price=10
-- stock=32