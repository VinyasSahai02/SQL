-- Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). 
-- If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
(SELECT CITY, LENGTH(CITY) AS NAME_LENGTH
 FROM STATION
 ORDER BY NAME_LENGTH ASC, CITY ASC
 LIMIT 1)
UNION ALL
(SELECT CITY, LENGTH(CITY) AS NAME_LENGTH
 FROM STATION
 ORDER BY NAME_LENGTH DESC, CITY ASC
 LIMIT 1)

--  You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
-- Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
-- Root: If node is root node.
-- Leaf: If node is leaf node.
-- Inner: If node is neither root nor leaf node.
        N	P
        1	2
        3	2
        6	8
        9	8
        2	5
        8	5
        5	NULL
-- output
        1 Leaf
        2 Inner
        3 Leaf
        5 Root
        6 Leaf
        8 Inner
        9 Leaf
select n, 
case
when p is null then "Root"
when n not in (select p from bst WHERE p IS NOT NULL) then "Leaf"
else "Inner"
end
from bst
order by n

-- Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.
-- The tables may contain duplicate records.
-- The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.

-- The following tables contain company data:
-- Company: The company_code is the code of the company and founder is the founder of the company. 
-- Lead_Manager: The lead_manager_code is the code of the lead manager, and the company_code is the code of the working company. 
-- Senior_Manager: The senior_manager_code is the code of the senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 
-- Manager: The manager_code is the code of the manager, the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 
-- Employee: The employee_code is the code of the employee, the manager_code is the code of its manager, the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 
-- output
        C1 Angela 1 2 5 13 
        C10 Earl 1 1 2 3 
        C100 Aaron 1 2 4 10 
        C11 Robert 1 1 1 1 
        C12 Amy 1 2 6 14 
        C13 Pamela 1 2 5 14 
        C18 Carol 1 2 5 6 
        C19 Paula 1 2 4 7 
        C2 Frank 1 1 1 3 
        C20 Marilyn 1 1 2 2 
        C21 Jennifer 1 1 3 7 
        C22 Harry 1 1 3 6 
SELECT 
    c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code) AS lead_manager_count,
    COUNT(DISTINCT sm.senior_manager_code) AS senior_manager_count,
    COUNT(DISTINCT m.manager_code) AS manager_count,
    COUNT(DISTINCT e.employee_code) AS employee_count
FROM Company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code
LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Manager m ON c.company_code = m.company_code
LEFT JOIN Employee e ON c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code ASC

-- 
