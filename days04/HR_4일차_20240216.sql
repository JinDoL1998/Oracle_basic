CREATE SYNONYM arirang
FOR scott.emp;

SELECT *
FROM arirang;

SELECT *
FROM employees
WHERE salary = ANY
        (SELECT salary 
        FROM employees
        WHERE department_id = 30); 