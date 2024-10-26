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