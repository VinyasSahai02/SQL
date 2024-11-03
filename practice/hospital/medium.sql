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
-- union doesn't allow duplicate values, union all does.

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

-- Show first_name, last_name, and the total number of admissions attended for each doctor.
select first_name,last_name,count(*) from doctors
inner join admissions on doctors.doctor_id= admissions.attending_doctor_id
group by doctor_id

-- For each doctor, display their id, full name, and the first and last admission date they attended.
select doctor_id,concat(first_name,' ',last_name) as fullName,min(admission_date),max(admission_date) from doctors
inner join admissions on doctors.doctor_id= admissions.attending_doctor_id
group by doctor_id


-- province_names Table
province_id	CHAR(2)
province_name	TEXT

-- Display the total amount of patients for each province. Order by descending.
select province_name, count(*) as total from patients
inner join province_names on province_names.province_id=patients.province_id
group by province_name
order by total desc

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;

-- display the first name, last name and number of duplicate patients based on their first name and last name.
-- Ex: A patient with an identical name can be considered a duplicate.
select first_name,last_name ,count(*) from patients
group by first_name,last_name
having count(*)>1
                               
-- Display patient's full name,
-- height in the units feet rounded to 1 decimal,
-- weight in the unit pounds rounded to 0 decimals,
-- birth_date,
-- gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.                       
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    ROUND(height / 30.48, 1) AS height_feet,
    ROUND(weight * 2.205, 0) AS weight_pounds,
    birth_date,
    CASE 
        WHEN gender = 'M' THEN 'Male'
        WHEN gender = 'F' THEN 'Female'
        ELSE 'Other'
    END AS gender_full
FROM patients;

-- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
select patients.patient_id, first_name, last_name from patients
left join admissions on admissions.patient_id = patients.patient_id
where admissions.patient_id is null
-- Get all rows from the patients table, regardless of whether there’s a corresponding record in the admissions table.
-- By using WHERE admissions.patient_id IS NULL, you’re filtering for rows where patients.patient_id has no match in admissions.patient_id. This lets you find patients who don’t have any records in the admissions table.
