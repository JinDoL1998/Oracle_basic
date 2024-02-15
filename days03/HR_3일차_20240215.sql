SELECT e.*
,NVL(phone_number, '연락처 등록 안됨') tel
FROM employees e;

SELECT first_name, last_name
, CONCAT ( CONCAT(first_name, ' '), last_name) NAME
FROM employees;

SELECT num, name, tel
,NVL2(tel, 'O' || tel, 'X') tel
FROM insa
WHERE buseo IN '개발부';

SELECT DISTINCT buseo
FROM insa 
ORDER BY buseo ASC;

SELECT FIRST_NAME, LAST_NAME
, CONCAT ( CONCAT(first_name, ' '), last_name) NAME
FROM employees;

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R%' -- last_name이 R로 시작하는 이름
ORDER BY salary;

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R___'
ORDER BY salary;






















