create table dim_cities(
 City_id varchar(10),
 City varchar(25),
 Tier varchar(25),
 primary key (City_id)
);

create table dim_respondents(
Respondent_ID int,
Name varchar(35),
Age varchar(10),
Gender varchar(10),
City_ID varchar(10),
primary key (Respondent_ID)
);

create table fact_survey_responses(
Response_ID	int,
Respondent_ID int,
Consume_frequency varchar(20),
Consume_time varchar(35),
Consume_reason	varchar(50),
Heard_before varchar(10),
Brand_perception varchar(10),
General_perception varchar(10),
Tried_before varchar(5),
Taste_experience int,
Reasons_preventing_trying varchar(35),
Current_brands varchar(10),
Reasons_for_choosing_brands varchar(35),
Improvements_desired varchar(25),
Ingredients_expected varchar(15),
Health_concerns varchar(5),
Interest_in_natural_or_organic varchar(10),
Marketing_channels varchar(35),
Packaging_preference varchar(40),
Limited_edition_packaging varchar(10),
Price_range	varchar(10),
Purchase_location varchar(25),
Typical_consumption_situations varchar(35)
);


--Which demographic segments (age × gender) show the highest preference for energy drinks?
SELECT
    r.age,
    r.gender,
    COUNT(*) AS respondent_count
FROM fact_survey_responses f
JOIN dim_respondents r
    ON f.respondent_id = r.respondent_id
GROUP BY r.age, r.gender
ORDER BY respondent_count DESC;

--Which age group (15–18, 19–24, 25–30, 30+) is most valuable for CodeX based on awareness ?
SELECT
    r.age,
	COUNT(*) AS total_respondents,
	sum(case when f.heard_before ='Yes' then 1 else 0 end) as aware_count,
	round((SUM(CASE WHEN f.heard_before = 'Yes' THEN 1 ELSE 0 END)*100.0)/count(*),2) as percentage_aware 
FROM fact_survey_responses f
JOIN dim_respondents r
    ON f.respondent_id = r.respondent_id
GROUP BY r.age
ORDER BY aware_count DESC;

--Which cities show the highest and lowest brand awareness for CodeX?
SELECT
    c.city,
    ROUND(
        SUM(CASE WHEN f.heard_before = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS awareness_percentage
FROM fact_survey_responses f
JOIN dim_respondents r
    ON f.respondent_id = r.respondent_id
JOIN dim_cities c
    ON r.city_id = c.city_id
GROUP BY c.city
ORDER BY awareness_percentage DESC;

--What is the overall brand rating of CodeX?
SELECT
    c.city,
    ROUND(AVG(f.taste_experience), 2) AS avg_rating
FROM fact_survey_responses f
JOIN dim_respondents r ON f.respondent_id = r.respondent_id
JOIN dim_cities c ON r.city_id = c.city_id
where tried_before = 'Yes'
GROUP BY c.city
ORDER BY avg_rating DESC;

--Which area of business should we focus more on our product development? (Branding/taste/availability)
select Reasons_for_choosing_brands, count(*) as reasons
from fact_survey_responses
group by Reasons_for_choosing_brands
order by reasons desc;

--Which marketing channels have driven the highest awareness for CodeX?
SELECT
    marketing_channels,
    COUNT(*) AS awareness_count
FROM fact_survey_responses
WHERE heard_before = 'Yes'
GROUP BY marketing_channels
ORDER BY awareness_count DESC;

--What ingredients do consumers care about most when choosing an energy drink?
SELECT
    r.age,
    f.ingredients_expected,
    COUNT(*) AS preference_count
FROM fact_survey_responses f
JOIN dim_respondents r ON f.respondent_id = r.respondent_id
GROUP BY r.age,f.ingredients_expected
ORDER BY r.age, preference_count DESC;

--What packaging types are most preferred?

SELECT
    c.city,
    f.packaging_preference,
    COUNT(*) AS preference_count
FROM fact_survey_responses f
JOIN dim_respondents r ON f.respondent_id = r.respondent_id
JOIN dim_cities c ON r.city_id = c.city_id
GROUP BY c.city, f.packaging_preference
ORDER BY c.city, preference_count DESC;

--Where do consumers most frequently purchase energy drinks?

SELECT
    c.city,
    f.purchase_location,
    COUNT(*) AS purchase_count
FROM fact_survey_responses f
JOIN dim_respondents r ON f.respondent_id = r.respondent_id
JOIN dim_cities c ON r.city_id = c.city_id
GROUP BY c.city, f.purchase_location
ORDER BY c.city, purchase_count DESC;

--In which situations do consumers consume energy drinks most often?

select 
 typical_consumption_situations,
    COUNT(*) AS usage_count
FROM fact_survey_responses
GROUP BY typical_consumption_situations
ORDER BY usage_count DESC;


--Who are the top competitors in the market?

SELECT
    current_brands,
    COUNT(*) AS respondent_count
FROM fact_survey_responses
GROUP BY current_brands
ORDER BY respondent_count DESC;

--What are the main reasons consumers prefer competitors over CodeX?

select Reasons_for_choosing_brands as brands,Count(*) as Reasons_prefer_brands
from fact_survey_responses
where current_brands <> 'Codex'
group by Reasons_for_choosing_brands
Order by Reasons_prefer_brands DESC;

--What factors influence purchase decisions the most ?
select Limited_edition_packaging, count(*) as Survey_answer
from fact_survey_responses
group by Limited_edition_packaging
order by Survey_answer desc;

select Price_range, count(*) as desired_price
from fact_survey_responses
group by Price_range
order by desired_price desc;

select Reasons_for_choosing_brands, count(*) as desired_factor
from fact_survey_responses
group by Reasons_for_choosing_brands
order by 2 desc;




