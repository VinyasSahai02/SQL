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
weight  INT

-- Show all of the patients grouped into weight groups.
-- Show the total amount of patients in each weight group.
-- Order the list by the weight group decending.
-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

-- Show patient_id, weight, height, isObese from the patients table.
-- Display isObese as a boolean 0 or 1.
-- Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg.
-- height is in units cm.
SELECT patient_id, weight, height, weight / power(CAST(height AS float) / 100, 2) >= 30 AS isObese
FROM patients


-- Admissions Table
patient_id	INT
admission_date	DATE
discharge_date	DATE
diagnosis	TEXT
attending_doctor_id  INT

-- Doctors Table
doctor_id	INT
first_name	TEXT
last_name	TEXT
specialty	TEXT

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
select patients.patient_id, patients.first_name, patients.last_name, doctors.specialty 
from patients
join admissions on admissions.patient_id = patients.patient_id
join doctors on doctors.doctor_id = admissions.attending_doctor_id
where admissions.diagnosis like "Epilepsy" and doctors.first_name like "Lisa"

-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission.
-- Show the patient_id and temp_password.
-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date
select distinct patients.patient_id, concat(patients.patient_id,len(patients.last_name),year(patients.birth_date)) as Temp_password
from patients
join admissions on admissions.patient_id = patients.patient_id

-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.
select 
case
	when patient_id%2==0 then "Yes"
	when patient_id%2!=0 then "No"
	else "other"
end as has_insurance,
sum(case
	when patient_id%2==0 then 10
    when patient_id%2!=0 then 50
    else 0
    end) as cost_after_insurance
from admissions
group by has_insurance


-- Province_names Table
province_id	CHAR(2)
province_name	TEXT

-- Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
select province_name from patients
join province_names on province_names.province_id = patients.province_id
group by province_name
having sum(case when gender= 'M' then 1 else 0 end) > sum(case when gender= 'F' then 1 else 0 end)

-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- - First_name contains an 'r' after the first two letters.
-- - Identifies their gender as 'F'
-- - Born in February, May, or December
-- - Their weight would be between 60kg and 80kg
-- - Their patient_id is an odd number
-- - They are from the city 'Kingston'
select * from patients
where first_name like "__r%" and
gender ='F' and
weight between 60 and 80 and
patient_id%2!=0 and
city like "Kingston"
-- instead of % we can also use MOD(patient_id, 2) != 0;

-- Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
SELECT 
    concat(ROUND((SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2),'%')
FROM patients;

-- For each day display the total amount of admissions on that day. Display the amount changed from the previous date.
select admission_date,count(*), count(*)-LAG(COUNT(*)) OVER (ORDER BY admission_date) from admissions
group by admission_date
order by admission_date

-- Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
select province_name
from province_names
order by
  (not province_name = 'Ontario'),
  province_name
-- or 
select province_name
from province_names
order by
  province_name = 'Ontario' desc,
  province_name
-- or 
SELECT province_name
FROM province_names
ORDER BY
  CASE
    WHEN province_name = 'Ontario' THEN 1
    ELSE province_name
  END
-- or 
select province_name
from province_names
order by
  (case when province_name = 'Ontario' then 0 else 1 end),
  province_name

-- We need a breakdown for the total amount of admissions each doctor has started each year.
-- Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
SELECT
  doctors.doctor_id as doctor_id,
  CONCAT(doctors.first_name,' ', doctors.last_name) as doctor_name,
  doctors.specialty,
  YEAR(admissions.admission_date) as selected_year,
  COUNT(*) as total_admissions
FROM doctors
  LEFT JOIN admissions ON doctors.doctor_id = admissions.attending_doctor_id
GROUP BY
  doctor_name,
  selected_year
ORDER BY doctor_id, selected_year