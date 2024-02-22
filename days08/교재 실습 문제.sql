-- p.550 [1]
SELECT 
first_name || last_name "Name"
,job_id "Job"
,salary "Salary"
,salary*12+100 "Increased Ann_Salary"
,(SALARY+100)*12 "Increased Salary"
FROM employees;

SELECT *
FROM employees;

-- [2]
SELECT LAST_NAME ||' : 1 Year Salary = $' ||SALARY*12  "1 Year Salary"
FROM EMPLOYEES;

-- [3]
SELECT DISTINCT DEPARTMENT_ID, JOB_ID
FROM EMPLOYEES;

-- p.551 [1]
SELECT LAST_NAME "e and o Name"
FROM EMPLOYEES
WHERE LAST_NAME
LIKE '%e%' AND LAST_NAME LIKE '%o%' ;

-- p.552 [2]
SELECT FIRST_NAME || LAST_NAME "Name", JOB_ID, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE BETWEEN to_date('20060520','yyyymmdd') 
AND to_date('20070520','yyyymmdd')
ORDER BY HIRE_DATE;

-- [3]
SELECT FIRST_NAME || LAST_NAME "Name", SALARY, JOB_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
ORDER BY SALARY DESC ,COMMISSION_PCT DESC;

-- p.553 [1]
SELECT INITCAP(FIRST_NAME) || ' ' || 
INITCAP(LAST_NAME) || ' is a ' || UPPER(JOB_ID) "Employee JOBs"
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%s';

-- [2]
SELECT INITCAP(FIRST_NAME) || ' ' || INITCAP(LAST_NAME) "Name"
, salary
, salary*12 * NVL(commission_pct, 1) "Annual Salary"
, NVL2(commission_pct, 'Salary + Commission', 'Salary Only') "Commission"
FROM employees
ORDER BY "Annual Salary" DESC;

-- [3]
SELECT FIRST_NAME || ' ' || LAST_NAME "Name"
, HIRE_DATE
, TO_CHAR(HIRE_DATE, 'day') "Day of the week"
FROM EMPLOYEES
ORDER BY HIRE_DATE;

-- p.555 [1]
SELECT DEPARTMENT_ID ,
TO_CHAR(SUM(SALARY),'$999,999.00') "Sum Salary",
TO_CHAR(ROUND(AVG(SALARY),2),'$999,999.00') "AVG Salary", 
TO_CHAR(MAX(SALARY),'$999,999.00') "Max Salary",
TO_CHAR(MIN(SALARY),'$999,999.00') "Min Salary"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID;

-- [2]
SELECT JOB_ID, AVG(SALARY)  "AVG Salary"
FROM EMPLOYEES
HAVING JOB_ID != 'CLERK'
AND AVG(SALARY) > 10000
GROUP BY JOB_ID
ORDER BY "AVG Salary" DESC;

-- p.558 [1]
SELECT d.department_name, COUNT(e.employee_id)
FROM departments d , employees e
HAVING e.department_id = d.department_id
AND COUNT(e.employee_id) >= 5
GROUP BY d.department_name, d.department_id, e.department_id
ORDER BY COUNT(e.employee_id) DESC;

-- [2]
CREATE TABLE job_grades(
grade_level VARCHAR(3), lowest_sal NUMBER, highest_sal NUMBER);

-- [2]
INSERT INTO job_grades VALUES('A', 1000, 2999);
INSERT INTO job_grades VALUES('B', 3000, 5999);
INSERT INTO job_grades VALUES('C', 6000, 9999);
INSERT INTO job_grades VALUES('D', 10000, 14999);
INSERT INTO job_grades VALUES('E', 15000, 24999);
INSERT INTO job_grades VALUES('F', 25000, 40000);
COMMIT;

SELECT DISTINCT e.first_name || ' ' || e.last_name "Name"
, e.job_id, d.department_name, e.hire_date
, e.salary, jg.grade_level
FROM job_grades jg, departments d, employees e
WHERE e.salary BETWEEN jg.lowest_sal AND jg.highest_sal
AND e.department_id = d.department_id
ORDER BY salary ASC;

-- [3]
SELECT e1.first_name || ' ' || e1.last_name || ' ' || 'report to' || ' ' ||
UPPER(e2.first_name) || ' ' || UPPER(e2.last_name) "Employee VS Manager"
FROM employees e1 LEFT JOIN employees e2 
ON e1.manager_id = e2.employee_id;



select *
FROM employees;







