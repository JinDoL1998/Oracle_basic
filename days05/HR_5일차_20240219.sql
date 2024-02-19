-- HR

SELECT commission_pct
FROM employees;

SELECT COUNT(*) 
FROM employees 
WHERE commission_pct IS NOT NAN;

SELECT COUNT(*) 
FROM employees 
WHERE commission_pct IS NOT NULL;


SELECT last_name FROM employees
WHERE salary IS NOT INFINITE;

SELECT *
FROM employees;

-- [문제] employees 테이블에서 salary의 1000단위 마다 별 1개씩 출력하는 쿼리 작성.
SELECT last_name
, salary
, ROUND(salary/1000) "별 개수"
, RPAD(' ',ROUND(salary/1000)+1, '*') "Salary"
FROM employees
WHERE department_id = 80
ORDER BY last_name, "Salary";




SELECT EXTRACT(month FROM order_date) "month",
      COUNT(order_date) "Orders"
FROM orders
GROUP BY EXTRACT(month FROM order_date)
ORDER BY 'Orders' DESC;




SELECT last_name, employee_id, hire_date
,EXTRACT(YEAR FROM hire_date) year
FROM employees -- 사원 테이블로 부터
WHERE EXTRACT(YEAR FROM TO_DATE(hire_date, 'DD-MM-RR')) > 1998 -- 1998 다음년도 부터
ORDER BY hire_date; -- 먼저 입사한 사원부터 오름차순 정렬

DESC employees;






