-- Patients Table
patient_id	INT primary key
first_name	TEXT
last_name	TEXT
gender	CHAR(1)
birth_date	DATE
city	TEXT
province_id	CHAR(2)
allergies	TEXT
height	INT
weight	INT

-- Province Names Table
province_id    CHAR(2) primary key
province_name    TEXT

-- Admissions Table
patient_id	INT primary key
admission_date	DATE
discharge_date	DATE
diagnosis	TEXT
attending_doctor_id	INT

-- Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name,gender FROM patients
where gender='M'

--  Show first name and last name of patients who does not have allergies. (null)
SELECT first_name, last_name FROM patients
where allergies is null

-- Show first name of patients that start with the letter 'C'
SELECT first_name FROM patients
where first_name like "C%"

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name,last_name FROM patients
where weight between 100 and 120

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients
set allergies = 'NKA'
where allergies is null

-- Show first name and last name concatinated into one column to show their full name.
SELECT concat(first_name ," ", last_name) as fullName FROM patients

-- Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'
SELECT first_name,last_name,province_name FROM patients
inner join province_names on province_names.province_id=patients.province_id

-- Show how many patients have a birth_date with 2010 as the birth year.
SELECT count() as total_patients FROM patients
where year(birth_date) = 2010

-- Show the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name,last_name,max(height) from patients

-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
SELECT * from patients
where patient_id in (1,45,534,879,1000)

-- Show the total number of admissions
SELECT count(*) as total_admissions from admissions

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT * from admissions
where admission_date=discharge_date

-- Show the patient id and the total number of admissions for patient_id 579.
SELECT patient_id,count(*) from admissions
where patient_id= 579

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
SELECT distinct city  from patients
where province_id= 'NS'

-- Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
SELECt first_name,last_name,birth_date  from patients
where height>160 and weight>70

-- Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'
SELECt first_name,last_name,allergies  from patients
where allergies is not null and city="Hamilton"
