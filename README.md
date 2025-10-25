# Introduction
📊 Exploring the data job market has never been more exciting!  
In this project, I focused on **data analyst roles** to uncover 💰 *top-paying positions*, 🔥 *in-demand skills*, and 📈 *where high demand meets high salary* in today’s data industry.

🔍 Want to check the queries behind the insights?  
They’re all here ➡️ [project_sql folder](/project_sql/)

# Background
This project started from my curiosity to better understand the **data analyst job market** — what skills actually matter, which ones pay the most, and where the biggest opportunities are.  
It’s all about finding a clear path to growth for anyone looking to level up in data analytics.

The dataset comes from my [SQL Course](https://lukebarousse.com/sql) and includes detailed info on **job titles, salaries, locations, and key skills** used across the industry.

### The main questions I set out to answer were:
1. 💼 What are the top-paying data analyst jobs?  
2. 🧠 What skills are required for those top-paying roles?  
3. 📊 Which skills are most in demand for data analysts?  
4. 💵 Which skills are linked to higher salaries?  
5. 🚀 What are the most valuable skills to learn next?

# Tools I Used
To explore and analyze the job market, I worked with a few key tools that made the process efficient and clear:

- **SQL:** The main driver behind my analysis — used to query and extract insights from the dataset.  
- **PostgreSQL:** My database of choice for managing and exploring large sets of job postings.  
- **Visual Studio Code:** My workspace for writing, testing, and refining SQL queries.  
- **Git & GitHub:** For version control, organization, and sharing my work — keeping everything clean and trackable.

# The Analysis
Each SQL query in this project was built to answer a specific question about the data analyst job market.  
From identifying the **highest-paying roles** to pinpointing **the most in-demand and valuable skills**, every step helps connect data skills with real-world career impact.

### 1. Top-Paying Data Analyst Jobs
To uncover the highest-paying opportunities, I analyzed data analyst positions based on **average yearly salary** and **location**, focusing on **remote roles** to highlight flexible, high-value opportunities.  
This query reveals where the top salaries are concentrated and which companies are leading the way in compensation for data professionals.

```sql
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

Here’s what stood out from the top data analyst jobs in 2023:

- 💰 **Wide Salary Range:** The top 10 highest-paying data analyst roles range from **$184K to $650K**, highlighting the strong earning potential within the field.  
- 🏢 **Diverse Employers:** Companies like **SmartAsset**, **Meta**, and **AT&T** are among those offering top-tier salaries — showing that high-paying data roles exist across multiple industries.  
- 🎯 **Varied Job Titles:** From *Data Analyst* to *Director of Analytics*, the range of titles reflects the diverse paths and specializations available within data analytics.

![Top Paying Roles](top_paying_roles.png)  
*Bar chart visualizing the salaries for the top 10 highest-paying data analyst roles (generated from my SQL query results).*

### 2. Skills for Top-Paying Jobs
To identify the skills that define top earners, I joined the **job postings** data with the **skills dataset**.  
This analysis highlights which technical skills employers prioritize when offering higher salaries.

```sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND job_location = 'Anywhere' 
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
Here’s what stood out the most in-demand skills for the top-paying data analyst roles in 2023:

- 🧠 **SQL** dominates the list, appearing in **8 out of 10** of the top-paying job postings.  
- 🐍 **Python** follows closely with **7 mentions**, reinforcing its essential role in data analytics.  
- 📊 **Tableau** remains a key visualization tool, appearing in **6 listings** among high-salary positions.  
- 💡 Other valuable skills like **R**, **Snowflake**, **Pandas**, and **Excel** also show consistent demand across top roles.

![Top Paying Skills](assets/2_top_paying_roles_skills.png)  
*Bar chart visualizing the frequency of skills among the top 10 highest-paying data analyst roles (generated from my SQL query results).*

### 3. In-Demand Skills for Data Analysts

To uncover which skills are most sought after in the data analytics job market, this query identifies the skills most frequently mentioned in job postings for remote data analyst roles.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

Here’s the breakdown of the most in-demand skills for data analysts in 2023:

- 🧠 **SQL** and **Excel** remain the cornerstone tools of data analysis, emphasizing the need for strong foundations in data manipulation and spreadsheet modeling.  
- 🐍 **Python**, 📊 **Tableau**, and 💼 **Power BI** are increasingly vital, highlighting the growing importance of technical and visualization skills for effective data storytelling and decision-making.  

| **Skill** | **Demand Count** |
|------------|------------------|
| SQL        | 7,291            |
| Excel      | 4,611            |
| Python     | 4,330            |
| Tableau    | 3,745            |
| Power BI   | 2,609            |

*Table displaying the top 5 most in-demand skills for data analyst roles, based on job posting frequency (SQL query results).*

### 4. Skills Based on Salary

This analysis explores which technical skills are associated with the highest average salaries for data analysts, helping identify which tools and technologies offer the greatest financial return.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
Here’s the breakdown of the top-paying skills for data analysts in 2023:

- 🚀 **Big Data & Machine Learning Expertise:** Analysts proficient in technologies like **PySpark**, **Couchbase**, and machine learning tools such as **DataRobot** and **Jupyter** command the highest salaries, reflecting the industry's strong emphasis on large-scale data processing and predictive analytics.  
- 💻 **Software Development & Deployment Proficiency:** Skills in **GitLab**, **Kubernetes**, and **Airflow** bridge the gap between data analysis and engineering, highlighting the growing demand for automation, scalability, and efficient data pipeline management.  
- ☁️ **Cloud Computing Expertise:** Familiarity with cloud-based and data engineering tools like **Elasticsearch**, **Databricks**, and **GCP** significantly boosts earning potential, emphasizing the importance of cloud infrastructure in modern analytics workflows.  

| **Skill**       | **Average Salary ($)** |
|------------------|-----------------------:|
| PySpark          | 208,172               |
| Bitbucket        | 189,155               |
| Couchbase        | 160,515               |
| Watson           | 160,515               |
| DataRobot        | 155,486               |
| GitLab           | 154,500               |
| Swift            | 153,750               |
| Jupyter          | 152,777               |
| Pandas           | 151,821               |
| Elasticsearch    | 145,000               |

*Table displaying the top 10 highest-paying skills for data analysts in 2023 (based on SQL query results).*

### 5. Most Optimal Skills to Learn

Combining insights from both **demand** and **salary** data, this query identifies the most strategic skills for data analysts to focus on — those that are highly sought after by employers **and** command strong average salaries.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

| **Skill ID** | **Skill**    | **Demand Count** | **Average Salary ($)** |
|--------------|--------------|-----------------:|-----------------------:|
| 8            | Go           | 27              | 115,320               |
| 234          | Confluence   | 11              | 114,210               |
| 97           | Hadoop       | 22              | 113,193               |
| 80           | Snowflake    | 37              | 112,948               |
| 74           | Azure        | 34              | 111,225               |
| 77           | BigQuery     | 13              | 109,654               |
| 76           | AWS          | 32              | 108,317               |
| 4            | Java         | 17              | 106,906               |
| 194          | SSIS         | 12              | 106,683               |
| 233          | Jira         | 20              | 104,918               |

*Table of the most optimal skills for data analysts, sorted by salary.*

Here’s the breakdown of the most optimal skills for Data Analysts in 2023:

- 🧠 **High-Demand Programming Languages:**  
  **Python** and **R** lead the way with demand counts of **236** and **148** respectively. While widely used, their average salaries — **$101,397** for Python and **$100,499** for R — suggest strong demand but also broad accessibility among analysts.

- ☁️ **Cloud Tools and Technologies:**  
  Skills in **Snowflake**, **Azure**, **AWS**, and **BigQuery** demonstrate both high demand and above-average salaries, underscoring the rising importance of **cloud platforms and big data infrastructure** in analytics workflows.

- 📊 **Business Intelligence & Visualization Tools:**  
  **Tableau** and **Looker** remain key tools for translating complex data into actionable insights, with demand counts of **230** and **49** and average salaries of **$99,288** and **$103,795**, respectively.

- 🗄️ **Database Technologies:**  
  Proficiency in both **traditional and NoSQL databases** — such as **Oracle**, **SQL Server**, and **NoSQL** — continues to be essential, with salaries ranging from **$97,786** to **$104,534**, reflecting their ongoing relevance in data storage and management.
# What I Learned

Throughout this project, I leveled up my SQL and data analysis skills, transforming raw curiosity into actionable insights. Here’s what I took away from this journey:

- **🧩 Complex Query Crafting:** Honed my ability to write advanced SQL queries — joining multiple tables seamlessly, utilizing `WITH` clauses for temporary datasets, and designing efficient query flows to extract meaningful results.
- **📊 Data Aggregation Mastery:** Strengthened my command of `GROUP BY`, `COUNT()`, `AVG()`, and other aggregate functions, turning complex datasets into concise and interpretable summaries.
- **💡 Analytical Problem-Solving:** Gained deeper experience in translating real-world questions into structured, data-driven SQL solutions — bridging the gap between technical querying and business insights.

---

# Conclusions

### Insights

From this analysis, several key takeaways about the data analyst job market emerged:

1. **Top-Paying Data Analyst Jobs:**  
   Remote roles for data analysts show a wide salary range, with top positions reaching up to **$650,000** annually — reflecting high variability and opportunity in the field.  
2. **Skills for Top-Paying Jobs:**  
   Advanced **SQL** proficiency stands out as a consistent requirement for the best-paying positions, confirming its central role in high-value analytics work.  
3. **Most In-Demand Skills:**  
   **SQL** also ranks as the most requested skill across job postings, making it essential for analysts seeking broad employability.  
4. **Skills with Higher Salaries:**  
   Specialized technologies such as **SVN** and **Solidity** are tied to higher average salaries, showing that niche technical expertise can significantly boost earning potential.  
5. **Optimal Skills for Market Value:**  
   **SQL** continues to dominate both demand and salary performance — making it one of the most strategic skills for analysts to master to maximize career growth and job market value.  

---

### Closing Thoughts

This project not only sharpened my technical SQL expertise but also offered a clearer picture of what defines success in the data analytics landscape.  
By uncovering which skills are **most in demand** and **most rewarding**, I’ve developed a roadmap for continuous professional development — one that balances technical depth with market relevance.  

For aspiring data analysts, this analysis highlights a simple truth:  
> **The combination of analytical thinking, SQL fluency, and adaptability to new technologies is the ultimate career advantage.**
