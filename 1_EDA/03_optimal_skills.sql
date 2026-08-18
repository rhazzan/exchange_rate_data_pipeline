/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.

*/

select
    sd.skills,
    (round(median(jpf.salary_year_avg) / 1000000,2)) as median_salary,
    round(count(jpf.*) * median_salary,2) as optimal_score,
    round(ln(count(jpf.*)),1) as log_demand_count
from job_postings_fact as jpf
join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
join skills_dim as sd
    on sjd.skill_id = sd.skill_id
where jpf.job_work_from_home = True
        and jpf.salary_year_avg is not null
        and sd.skills is not null
        and jpf.job_title_short = 'Data Engineer'
group by sd.skills
order by 
    log_demand_count desc
limit 25;

/*
┌────────────┬───────────────┬───────────────┬──────────────────┐
│   skills   │ median_salary │ optimal_score │ log_demand_count │
│  varchar   │    double     │    double     │      double      │
├────────────┼───────────────┼───────────────┼──────────────────┤
│ sql        │          0.13 │        146.64 │              7.0 │
│ python     │          0.14 │        158.62 │              7.0 │
│ aws        │          0.14 │        109.62 │              6.7 │
│ azure      │          0.13 │         61.75 │              6.2 │
│ spark      │          0.14 │         70.42 │              6.2 │
│ snowflake  │          0.14 │         61.32 │              6.1 │
│ airflow    │          0.15 │          57.9 │              6.0 │
│ kafka      │          0.14 │         40.88 │              5.7 │
│ java       │          0.14 │         42.42 │              5.7 │
│ redshift   │          0.13 │         35.62 │              5.6 │
│ databricks │          0.13 │         34.58 │              5.6 │
│ scala      │          0.14 │         34.58 │              5.5 │
│ terraform  │          0.18 │         34.74 │              5.3 │
│ git        │          0.14 │         29.12 │              5.3 │
│ gcp        │          0.14 │         27.44 │              5.3 │
│ hadoop     │          0.14 │         27.72 │              5.3 │
│ nosql      │          0.13 │         25.09 │              5.3 │
│ tableau    │          0.12 │         19.68 │              5.1 │
│ kubernetes │          0.15 │         22.05 │              5.0 │
│ pyspark    │          0.14 │         21.28 │              5.0 │
│ docker     │          0.14 │         20.16 │              5.0 │
│ postgresql │          0.12 │         15.48 │              4.9 │
│ sql server │          0.12 │         16.68 │              4.9 │
│ power bi   │          0.12 │         15.48 │              4.9 │
│ mongodb    │          0.14 │         19.04 │              4.9 │
└────────────┴───────────────┴───────────────┴──────────────────┘
  25 rows                                             4 columns
*/



