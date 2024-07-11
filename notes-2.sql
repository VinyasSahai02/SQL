-- SQLite does not enforce type checking 
-- whereas postgreSQL enforces type checking

CREATE TABLE users(id INTEGER, name TEXT, age INTEGER);
INSERT INTO users(id, name, age) VALUES (1,'john doe',21);
INSERT INTO users(id, name, age) VALUES (2,1,21);
-- SQLite will let you execute both even when we are putting name as a INT instead of  TEXT

--we are building a app database like PAYPAL
CREATE TABLE people(
    id INTEGER,
    handle TEXT,
    name TEXT,
    age INTEGER,
    balance INTEGER,
    is_admin BOOLEAN
)
CREATE TABLE transactions(
    id INTEGER,
    recepient_id INTEGER,
    sender_id INTEGER,
    note TEXT,
    amount INTEGER
)

--altering a table
-- ALTER TABLE employees
-- RENAME TO contractors;
-- RENAME COLUMN salary TO invoice;
-- ADD COLUMN job TEXT;
-- DROP COLUMN is_manager;

ALTER TABLE people RENAME TO users;
ALTER TABLE users RENAME COLUMN handle TO username;
ALTER TABLE users ADD COLUMN password TEXT;


--see docs for migration
ALTER TABLE transactions ADD COLUMN was_successful BOOLEAN;
ALTER TABLE transactions ADD COLUMN transaction_type TEXT;

-----imp---->>>> data types depend on the database engine


--constraints
CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    --primary key constraint act both as UNIQUE AND NOT NULL
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    country_code TEXT NOT NULL,
    username TEXT UNIQUE,
    password TEXT NOT NULL,
    is_admin BOOLEAN
)


--auto increment(AUTOINCREMENT)
--used in id-->if the entires are in order 1,2,3,4 then auto increment helps
--UUID-->random auto generated ids
--in SQLite integer id field that has primary key contraint will auto increment by default

SELECT count(*) FROM users; --gives number of rows

--soft delete is where we dont actually delete the data but we mark the required data as deleted
--then we filter the database to perform operations on the unmarked data

--ORM-->google

--renaming columns/alias
SELECT employee_id AS id, employee_name AS name FROM employees


--IIF func
--in SQLite IIF func works like a ternary
IIF(carA > carB, "car A is bigger", "car B is bigger")

SELECT *,
IIF(was_successful, "no action req", "perform an audit") AS audit
FROM transactions;
--returns the table and adds a column audit
--the audit column has a entry "no action req" if was_successful is true
--else "perform an audit" if was_successful is false


-- between and not between
SELECT name,age FROM users 
WHERE age BETWEEN 18 AND 30;


--distinct
--lets say we have 3 users from USA, 4 users from JP, 2 users from IND
--distinct keyword will return only 3 values that are
--USA, JP and IND
SELECT DISTINCT country_code FROM users;


--see operstors for logic AND/OR operations etc
(this AND that) OR the_other --combination


--in
SELECT name, age, country_code FROM users
WHERE country_code IN ('US', 'CA', 'MX')
--returns rows in which country_code is one of these


--like
SELECT * FROM users 
WHERE name LIKE 'Al%'
--returns data where name starts with Al

SELECT * FROM users 
WHERE name LIKE 'Al___' --underscore operator
--returns data where name starts with 'Al' and
-- is exactly 5 letters


--limit
SELECT * FROM transactions
WHERE note LIKE "%lunch%"
LIMIT 5;
--returns at most 5 rows that have the query 'lunch' in note column


--order by
SELECT * FROM transactions
WHERE amount BETWEEN 10 AND 80
ORDER BY amount;
--returns data in ascending order
--for decending order
ORDER BY amount DESC


--IMP NOTE
SELECT * FROM transactions 
WHERE amount BETWEEN 10 AND 80
LIMIT 4
ORDER BY amount DESC;

SELECT * FROM transactions 
WHERE amount BETWEEN 10 AND 80
ORDER BY amount DESC
LIMIT 4;
--first will not work as we need to order the results 
--before limiting them


--aggregate func
--count
SELECT count(*) FROM users;
--sum
SELECT sum(salary) FROM employees;
--max
SELECT max(price) FROM products;
--min
SELECT product_name, min(price) FROM products
--avg
SELECT avg(age) FROM users WHERE country_code="US";

--group by
--usually every time a aggrigate is used we also use group by
| user_id | amount |
|---------|--------|
| 1       | 100    |
| 1       | 150    |
| 2       | 50     |
| 2       | 75     |
| 3       | 200    |
SELECT user_id, sum(amount) FROM transactions
GROUP BY user_id;
--gives us sum of each users amount with their user_id
--if group by statement was not present then it will
--simply return total sum of all users and user_id as null
| user_id | sum(amount) |
|---------|-------------|
| 1       | 250         |
| 2       | 125         |
| 3       | 200         |

| user_id | sum(amount) |
|---------|-------------|
| NULL    | 575         |


--having
--similar to WHERE 
--diff is having operates on rows after an aggregation has taken place
SELECT sender_id, sum(amount) AS balance FROM transactions
WHERE note LIKE '%lunch%'
GROUP BY sender_id
HAVING balance>20
ORDER BY balance ASC;
--returns sender_id and their balance in which the 
--notes column has 'lunch' and their balance is >20 in asc order

--round
SELECT round(avg(age)) FROM users
WHERE country_code='US';