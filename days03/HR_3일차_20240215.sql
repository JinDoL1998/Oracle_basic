SELECT e.*
,NVL(phone_number, '����ó ��� �ȵ�') tel
FROM employees e;

SELECT first_name, last_name
, CONCAT ( CONCAT(first_name, ' '), last_name) NAME
FROM employees;

SELECT num, name, tel
,NVL2(tel, 'O' || tel, 'X') tel
FROM insa
WHERE buseo IN '���ߺ�';

SELECT DISTINCT buseo
FROM insa 
ORDER BY buseo ASC;

SELECT FIRST_NAME, LAST_NAME
, CONCAT ( CONCAT(first_name, ' '), last_name) NAME
FROM employees;

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R%' -- last_name�� R�� �����ϴ� �̸�
ORDER BY salary;

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R___'
ORDER BY salary;






















