-- Patients Table
patient_id	INT
first_name	TEXT
last_name	TEXT
gender	CHAR(1)
birth_date	DATE
city	TEXT
province_id	CHAR(2)
allergies	TEXT
height	INT
weight	INT

-- Admission Table 
patient_id	INT
admission_date	DATE
discharge_date	DATE
diagnosis	TEXT
attending_doctor_id	INT

-- Show unique birth years from patients and order them by ascending.
SELECT distinct Year(birth_date) FROM patients
order by birth_date asc

-- Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id,first_name FROM patients
where first_name like "s____%s"

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.
SELECT patients.patient_id,first_name,last_name FROM patients
inner join admissions on  admissions.patient_id= patients.patient_id
where diagnosis like "Dementia"

-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.
SELECT first_name FROM patients
order by length(first_name) asc, first_name asc

-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.
select (SELECT count(*) FROM patients
where gender like 'M') as male_count,
(select count(*) from patients
where gender like 'F') as female_count

-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
-- Show results ordered ascending by allergies then by first_name then by last_name.
select first_name,last_name,allergies FROM patients
where allergies IN ('Penicillin', 'Morphine')
order by allergies asc, first_name asc,  last_name asc

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id,diagnosis from admissions
group by patient_id,diagnosis
having count(*)>1

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.
SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;


-- Doctors Table
doctor_id	INT
first_name	TEXT
last_name	TEXT
specialty	TEXT

-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"
SELECT first_name, last_name, 'Patient' as role FROM patients
    union all
select first_name, last_name, 'Doctor' from doctors;

-- Show all allergies ordered by popularity. Remove NULL values from query.
select allergies, count(allergies) as Total_Diagnosis from patients
group by allergies
having allergies not like "NULL"
order by Total_Diagnosis desc
-- OR 
SELECT allergies, COUNT(*) AS total_diagnosis FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
-- Sort the list starting from the earliest birth_date.
select first_name,last_name,birth_date from patients
where year(birth_date) between 1970 and 1979
order by birth_date asc

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters.
-- Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
select concat(upper(last_name),',',lower(first_name)) as Full_name from patients
order by first_name desc

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id,sum(height) as totalheight from patients
group by province_id
having totalheight >= 7000 

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight) - min(weight) as weightdata from patients
where last_name like "Maroni"


-- Admission Table 
patient_id	INT
admission_date	DATE
discharge_date	DATE
diagnosis	TEXT
attending_doctor_id	INT

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) as admissionday ,count(*) as number from admissions
group by admissionday
order by number desc

-- Show all columns for patient_id 542's most recent admission_date.
select * from admissions
where patient_id = 542
order by admission_date desc
limit 1
-- or 
SELECT * FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING admission_date = MAX(admission_date);

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
SELECT patient_id, attending_doctor_id, diagnosis 
FROM admissions
WHERE (patient_id%2 != 0 AND attending_doctor_id IN (1, 5, 19))
   OR (attending_doctor_id LIKE '%2%' AND LENGTH(patient_id) = 3);

-- 