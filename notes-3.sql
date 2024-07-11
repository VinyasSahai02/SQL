--subqueries
SELECT * FROM transactions
WHERE user_id=(
    SELECT id FROM users
    WHERE name='David'
)

SELECT id, song_name, artist_id FROM songs
WHERE artist_id IN (
    SELECT id FROM artist
    WHERE artist_name LIKE 'Rick%'
)


--relations
--one to one-->foreign key can be in any table and it references id of the other table
--one to many-->foreign key will be in the many table and references the id in the one table
--many to many-->joining table is created

--normalization
--SOME RULES FOR DATABASE DESIGN
--every table shound have a primary key(unique identifier)
--90% of the time that primary key will be id column
--avoid duplicate data
--avoid storying data that is completely dependent on other data
--keep your schema simple


--JOINS(work on rows not columns)
--inner join
--by default if we just write join then SQL does inner join
--returns all records in table1 that have matching records in table2
--similar to vien diagram representing intersection of 2 sets
SELECT * FROM users  -->as * so every column in both tables are returned
INNER JOIN countries
ON users.country_code = countries.country_code

SELECT users.name, users.age, countries.name AS country_name
FROM users
INNER JOIN countries
ON users.country_code = countries.country_code
ORDER BY country_name ASC;


--left join
--returns every record in table1 whether or not it has a match in table2
--similar to vein diagram representing whole of setA
SELECT users.name, sum(transactions.amount) AS sum, count(transactions.id) AS count
FROM users
LEFT JOIN transactions 
ON user.id=transactions.user_id
GROUP BY users.id;


--right join
--returns every record in table2 whether or not it has a match in table1
--similar to vein diagram representing whole of setB
--does not make sense as you can always exchange your tables and use a left join


--full join
--returns all the rows from both tables whether or not they are related
--similar to vein diagram representing whole of both sets


--multiple joins
SELECT users.id, users.name, users.age, 
users.username, countries.name 
sum(transactions.amount) AS balance FROM users
LEFT JOIN countries ON users.country_code = countries.country_code
LEFT JOIN transactions ON transactions.user_id =users.id
GROUP BY users.id;
--there are three tables users, transactions, countries
--we need all the user data so we are doing LEFT JOIN


--performance
--index
CREATE INDEX index_name ON table_name(column_name)
--by default id is assigned primary key so it is also assigned index
--makes things fast(increase read speed but slow down write speed)
--but we dont add index to every column
--we only add index to columns we frequently perform look ups on
--index_name is usually like name_idx(name column is indexed)

--multicolumn index
--only added when we do frequent look ups on specific combinations onk columns
CREATE INDEX user_id_recdpient_id_idx ON transactions(user_id, recepient_id)
--order inside () matters as we use this to speed up queries that only care about the user_id


--IMP POINTS
--demormalization
--sometimes rules of thumb can be ignored
--that means we can introduce duplicate data if it speeds up the proccess

--SQL injection-->google