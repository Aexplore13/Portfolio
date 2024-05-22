use Portfolio;
SELECT * FROM ihm;

-- How many total deaths occured in the hospital and what was the percentage of the mortality rate?
SELECT SUM(HOSPITAL_DEATH) AS TOTAL_DEATHS_HOSPITAL,ROUND(SUM(HOSPITAL_DEATH)*100/COUNT(*),2) AS MORTALITY_RATE
FROM IHM;

ALTER TABLE IHM
ADD COLUMN timestamp_column TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- What was the death count of each ethnicity? 
UPDATE IHM
SET ETHNICITY = 'Mixed'
WHERE ETHNICITY = '0';

SELECT ETHNICITY,COUNT(HOSPITAL_DEATH) AS DEATH_COUNT
FROM IHM
GROUP BY ETHNICITY;

ALTER TABLE IHM
ADD COLUMN timestamp_column TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- What was the death count of each gender? 
UPDATE IHM
SET GENDER = 'OTHER'
WHERE GENDER = '0';

SELECT GENDER, COUNT(HOSPITAL_DEATH) AS GENDER_WISE_DEATH_COUNT
FROM IHM
GROUP BY GENDER;

-- Comparing the average and max ages of patients who died and patients who survived
SELECT ROUND(AVG(AGE),2) AS AVERAGE_AGE, MAX(AGE)
FROM IHM
WHERE HOSPITAL_DEATH= 1
GROUP BY HOSPITAL_DEATH
UNION
SELECT ROUND(AVG(AGE),2) AS AVERAGE_AGE, MAX(AGE)
FROM IHM
WHERE HOSPITAL_DEATH= 0
GROUP BY HOSPITAL_DEATH;

-- Comparing the amount of patients that died and survived by each age 

SELECT AGE,COUNT(CASE WHEN HOSPITAL_DEATH= 1 THEN 1 END) AS AMOUNT_THAT_DIED,
	COUNT(CASE WHEN HOSPITAL_DEATH= 0 THEN 1 END) AS AMOUNT_THAT_SURVIVED
FROM IHM
GROUP BY AGE;

-- Age distribution of patients in 10-year intervals 
SELECT CONCAT(FLOOR(AGE/10)*10,"-",FLOOR(AGE/10)*10+9) AS AGE_INTERVAL, COUNT(*) AS PATIENT_COUNT
FROM IHM
GROUP BY AGE;

-- Amount of patients above 65 who died vs Amount of patients between 50-65 who died
SELECT COUNT(CASE WHEN AGE<65 AND HOSPITAL_DEATH=1 THEN 1 END) AS DIED_OVER_65, 
       COUNT(CASE WHEN AGE BETWEEN 50 AND 65 AND HOSPITAL_DEATH=1 THEN 1 END) AS DIED_BETWEEN_50_AND_65
FROM IHM;

-- Calculating the average probability of hospital death for patients of different age groups
SELECT
      CASE
          WHEN AGE <40 THEN "39 AND BELOW"
          WHEN AGE>=40 AND AGE<60 THEN "40-59"
          WHEN AGE>=60 AND AGE>80 THEN "60-79"
          ELSE "80 AND ABOVE"
          END AS AGE_GROUP,
	AVG(APACHE_4A_ICU_DEATH_PROB) AS AVG_PROB
FROM IHM
GROUP BY AGE_GROUP;
          
-- Which admit source of the ICU did most patients die in and get admitted to?
SELECT ICU_ADMIT_SOURCE,COUNT(*) AS TOTAL_ADDMIT, SUM(HOSPITAL_DEATH) TOTAL_DEATH
FROM IHM
GROUP BY ICU_ADMIT_SOURCE
ORDER BY TOTAL_DEATH DESC;

-- Average age of people in each ICU admit source and amount that died
SELECT ICU_ADMIT_SOURCE, ROUND(AVG(AGE),0) AVG_AGE,COUNT(HOSPITAL_DEATH) TOTAL_DEATH
FROM IHM
GROUP BY ICU_ADMIT_SOURCE;

-- Average age of people in each type of ICU and amount that died
SELECT ICU_TYPE, round(avg(age),0) Avg_age,count(hospital_death) Total_death
from ihm
group by icu_type;

-- Average weight, bmi, and max heartrate of people who died

select round(Avg(weight),2) Avg_Weight,round(Avg(BMI),2) Avg_BMI,max(heart_rate_apache) Max_heartrate
from ihm
where hospital_death=1;

-- What were the top 5 ethnicities with the highest BMI? 
select Ethnicity,round(avg(BMI),2) as Top_5_Highest_BMI
from ihm
group by Ethnicity
order by Top_5_highest_BMI desc
Limit 5;

-- What is the mortality rate in percentage? 
Select concat( round(count(case when hospital_death=1 then 1 end)*100/count(*),2),"","%") as Mortalitiy_Rate
from ihm;

-- How many patients are suffering from each comorbidity? 

Select
Sum(aids) as Patients_with_aids,
sum(cirrhosis) as Patient_with_cirrhosis,
sum(diabetes_mellitus) as patients_with_diabetes,
sum(hepatic_failure) as patients_with_hepatic_failure,
sum(immunosuppression) as patient_with_immunosuppression,
sum(leukemia) as patients_with_leukemia,
sum(lymphoma) as Patients_with_lymphoma,
sum(solid_tumor_with_metastasis) as Patients_with_Solide_Tumor
from ihm;


 -- What was the percentage of patients with each comorbidity among those who died? 
 Select
 concat(round(sum(case when aids=1 then 1 else 0 end)*100/count(*),2),"","%") as Aids,
 concat(round(sum(case when cirrhosis=1 then 1 else 0 end)*100/count(*),2),"","%") as cirrhosis,
 concat(round(sum(case when diabetes_mellitus=1 then 1 else 0 end)*100/count(*),2),"","%") as diabetes_mellitus,
 concat(round(sum(case when hepatic_failure=1 then 1 else 0 end)*100/count(*),2),"","%") as hepatic_failure,
 concat(round(sum(case when immunosuppression=1 then 1 else 0 end)*100/count(*),2),"","%") as immunosuppression,
 concat(round(sum(case when leukemia=1 then 1 else 0 end)*100/count(*),2),"","%") as leukemia,
 concat(round(sum(case when lymphoma=1 then 1 else 0 end)*100/count(*),2),"","%") as lymphoma,
 concat(round(sum(case when solid_tumor_with_metastasis=1 then 1 else 0 end)*100/count(*),2),"","%") as solid_tumor_with_metastasis
 from ihm;
 
-- What was the percentage of patients who underwent elective surgery?
Select 
concat(round(sum(case when elective_surgery=1 then 1 else 0 end)*100/count(*),2),"","%") as Elective_Surgery
from ihm;

-- What was the average weight and height for male & female patients who underwent elective surgery?
Select 
round(avg(case when gender="M" then weight end),2) as Male_Avg_Weight,
round(avg(case when gender="M" then height end),2) as Male_Avg_Height,
round(avg(case when gender="F" then weight end),2) as Female_Avg_Weight,
round(avg(case when gender="F" then height end),2) as Female_Avg_Height
from ihm
where elective_surgery=1;

-- What were the top 10 ICUs with the highest hospital death probability? 
Select * from ihm;
Select icu_id,round(sum(apache_4a_icu_death_prob),2) as Highest_Hospital_Death_Prob
from ihm
group by icu_id
order by Highest_Hospital_Death_Prob desc
limit 10;

-- What was the average length of stay at each ICU for patients who survived and those who didn't? 
