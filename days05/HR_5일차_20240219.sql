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

-- [����] employees ���̺��� salary�� 1000���� ���� �� 1���� ����ϴ� ���� �ۼ�.
SELECT last_name
, salary
, ROUND(salary/1000) "�� ����"
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
FROM employees -- ��� ���̺�� ����
WHERE EXTRACT(YEAR FROM TO_DATE(hire_date, 'DD-MM-RR')) > 1998 -- 1998 �����⵵ ����
ORDER BY hire_date; -- ���� �Ի��� ������� �������� ����

DESC employees;






