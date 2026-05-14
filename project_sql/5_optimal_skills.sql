SELECT
    *,
    (
        (avg_skill_salary / MAX(avg_skill_salary) OVER()) * 0.7
        +
        (demand_count / MAX(demand_count) OVER()) * 0.3
    ) AS optimal_score

FROM (
    SELECT
        skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_skill_salary,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills
    ORDER BY demand_count DESC, avg_skill_salary DESC
    LIMIT 25
) AS top_skills

ORDER BY optimal_score DESC;