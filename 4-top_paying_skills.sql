/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve
*/


SELECT skills,
    round(avg(salary_year_avg),0) as avg_salary
from job_postings_fact
INNER JOIN skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg is not NULL AND
    job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25