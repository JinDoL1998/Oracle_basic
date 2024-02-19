SELECT * 
FROM emp
WHERE ename LIKE '%' || UPPER('la') || '%';
WHERE REGEXP_LIKE(ename, 'la', 'i');
WHERE ename LIKE UPPER('%lA%');

SELECT ename
, REPLACE(ename, 'LA', '<span style="color:red">LA</span>')
FROM emp;

-- insa ���̺��� ���ڴ� 'X', ���ڴ� 'O' �� ����(gender) ����ϴ� ���� �ۼ� 
-- [1]
SELECT t.name, t.ssn
--,t.gender
-- If�� PL/SQL
,REPLACE( REPLACE( t.gender, 1, 'O' ), 0, 'X')
FROM( -- INLINE VIEW
    SELECT name, ssn
    , MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)t;

-- [2]
--NULLIF(ù��, �ΰ�)
--ù�� == �ΰ�    null ��ȯ
--ù�� != �ΰ�    ù���� ��ȯ
SELECT ename,job
    ,lengthb(ename),lengthb(job)
    ,NULLIF(lengthb(ename),lengthb(job)) nullif_result
FROM emp 
WHERE deptno=20;

SELECT name
,LENGTH(name)
,LENGTHB(name)
FROM insa;

SELECT NAME, SSN
, NVL2(NULLIF(MOD(SUBSTR(SSN, 8, 1), 2), 1), 'O', 'X') GENDER
FROM INSA;

SELECT *
FROM emp
WHERE REGEXP_LIKE(ename, 'king', 'i');

 INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC', 'SEOUL'); 
commit;
UPDATE dept
SET dname = dname || '2', loc = 'POHANG'
WHERE dname = 'QC';

SELECT * FROM dept;


DELETE dept
WHERE deptno = 50;
COMMIT;

DESC insa;
SELECT name, ibsadate
--,TO_CHAR(ibsadate, 'YYYY.MM.DD(DY)')
,TO_CHAR(ibsadate, 'YYYY')
FROM insa
--WHERE TO_CHAR(ibsadate,'YYYY') >= 2000;
--WHERE ibsadate >= '2000.01.01';
WHERE EXTRACT(YEAR FROM ibsadate) >= 2000;

-- dual ����
SELECT SYSDATE
FROM ;

-- ���������
SELECT 5+3, 5-3, 5/3, MOD(5,3)
-- ORA-01476: divisor is equal to zero
SELECT 5/0
SELECT MOD(5,0)
FROM dual;

-- PUBLIC SYNONYM ����
-- ORA-01031: insufficient privileges
CREATE SYNONYM arirang
FOR scott.emp;

-- REPLACE() �Լ�
SELECT name, ssn
, REPLACE(ssn, '-')
FROM insa;
--SUBSTR(ssn, 1, 6) || SUBSTR(ssn, 8) ssn

SELECT
TO_DATE('2024', 'YYYY')
, TO_DATE('2024/03', 'YYYY/MM') 
, TO_DATE('2024/05/21')
FROM dual;

SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '[��|��]')
AND REGEXP_LIKE(ssn, '^7[0-9]12');

-- YY�� RR�� ������:
-- RR�� YY�� �Ѵ� �⵵�� ������ ���ڸ��� ����� ������, 
-- ���� system���� ����� ��Ÿ������ �ϴ� �⵵�� ���⸦ ���� ���� �� ��µǴ� ���� �ٸ���.
-- RR�� �ý��ۻ�(1900���)�� �⵵�� �������� �Ͽ� 
-- ���� 50�⵵���� ���� 49������� ���س⵵�� ����� 1850�⵵���� 1949�⵵������ ������ ǥ���ϰ�, 
-- �� ������ ���Ƴ� ��� �ٽ� 2100���� �������� ���� 50�⵵���� ���� 49������� ���� ����Ѵ�.

-- YY�� ������ system���� �⵵�� ������.
SELECT TO_CHAR(SYSDATE, 'CC')
FROM dual;

SELECT 
'05/01/10' -- ���ڿ�
, TO_CHAR(TO_DATE('05/01/10', 'YY/MM/DD'), 'YYYY') date_YY
, TO_CHAR(TO_DATE('05/01/10', 'RR/MM/DD'), 'RRRR') date_RR
FROM dual;

SELECT 
'97/01/10' -- ���ڿ�
, TO_CHAR(TO_DATE('97/01/10', 'YY/MM/DD'), 'YYYY') date_YY
, TO_CHAR(TO_DATE('97/01/10', 'RR/MM/DD'), 'RRRR') date_RR
FROM dual;

SELECT name, ibsadate
FROM insa;

-- ORDER BY ��
-- 1�������� �μ����� �������� ���� ��
-- 2�������� pay ��������
SELECT deptno, ename, sal+NVL(comm, 0) pay
FROM emp
ORDER BY 1 ASC, 3 DESC;  --OREDER BY deptno ASC, pay DESC;

--����Ŭ ������ (operator) ����
-- 1) �� ������ : WHERE ������ ����, ��¥, ���� ũ�⳪ ������ ���ϴ� ������
--              =, !=, ^=, <> > < >= <=
--      ANY, SOME, ALL : �񱳿����� ���ÿ� SQL ������
--      TRUE, FALSE, NULL ��ȯ
SELECT ename, sal
FROM emp
WHERE sal = null;
WHERE sal <= 1250;
WHERE sal < 1250;
WHERE sal >= 1250;
WHERE sal > 1250;
WHERE sal != 1250;
WHERE sal = 1250;

--ANY
--SOME
--ALL
-- emp ���̺��� ��ձ޿����� ���� �޴� ������� ������ ��ȸ
-- 1. emp ���̺��� ��� �޿�? avg() �����Լ�, �׷��Լ�
SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp;

SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= (SELECT AVG(sal+NVL(comm,0)) avg_pay
                            FROM emp);
-- WHERE sal+NVL(comm,0) >= 2260.416666666666666666666667;
-- [����] �� �μ��� ��� �޿����� ���� �޴� ������� ������ ��ȸ.
SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 10; -- 10�� �μ����� ���

SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 20; -- 20�� �μ����� ���

SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 30; -- 30�� �μ����� ���

SELECT *
FROM emp
WHERE deptno = 10 AND sal+NVL(comm,0) >= 2916.666666666666666666
UNION
SELECT *
FROM emp
WHERE deptno = 20 AND sal+NVL(comm,0) >= 2258.333333333333333333
UNION
SELECT *
FROM emp
WHERE deptno = 30 AND sal+NVL(comm,0) >= 1933.333333333333333333;

-- [����] 30�� �μ��� �ְ� �޿����� ���� �޴� ������� ������ ��ȸ.
SELECT *
FROM emp
--WHERE sal+NVL(comm,0) > (ALL (sal+NVL(comm,0) max_pay_30
--                            FROM emp
--                            WHERE deptno = 30));
WHERE sal+NVL(comm,0) > (SELECT MAX(sal+NVL(comm,0)) max_pay_30
                            FROM emp
                            WHERE deptno = 30);

SELECT ename,empno 
FROM emp
WHERE deptno=10 AND job='CLERK';

SELECT ename,empno 
FROM emp
where deptno NOT IN(10,30);

WITH temp AS (SELECT sal+NVL(comm,0) pay FROM emp)
SELECT MAX(pay)
,MIN(pay)
,AVG(pay)
,SUM(pay)
FROM temp;

WITH temp AS (SELECT sal+NVL(comm,0) pay FROM emp)
SELECT MAX(pay)
,MIN(pay)
,AVG(pay)
,SUM(pay)
FROM temp;

-- ��� ���� ����(correlated subquery)
-- [1]��� ��ü���� �ְ� �޿��� �޴� ����� ������ ��ȸ, �����, �����ȣ, �޿���, �μ���ȣ
SELECT empno, ename, sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
                            FROM emp
                            );
                    
SELECT deptno, empno, ename, sal+NVL(comm,0) pay
FROM emp
ORDER BY pay ASC;

-- [2]�� �μ��� �ְ� �޿��� �޴� ����� ������ ��ȸ(���)
SELECT empno, ename, sal+NVL(comm,0) pay, deptno
FROM emp p
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
                            FROM emp c
                            WHERE deptno = p.deptno)
ORDER BY deptno ASC;

-- �� �μ��� ��պ��� ū �μ����� ���� ��ȸ
SELECT deptno,ename,sal
-- ****** ORA-00937: not a single-group group function
-- �����ռ��� SELECT������ �Ϲ�Į�����̶� ���� ����
,(SELECT AVG(sal) FROM emp WHERE deptno = t1.deptno)
FROM emp t1
WHERE sal > (SELECT AVG(sal)
            FROM emp t2
            WHERE t2.deptno=t1.deptno)
ORDER BY deptno ASC;          

--UNION                            
--SELECT empno, ename, sal+NVL(comm,0) pay, deptno
--FROM emp
--WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
--                            FROM emp
--                            WHERE deptno = 20)
--UNION                            
--SELECT empno, ename, sal+NVL(comm,0) pay, deptno
--FROM emp
--WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
--                            FROM emp
--                            WHERE deptno = 30)
--ORDER BY deptno;

-- 2) 
--����Ŭ �Լ� (function) ����
--
--����Ŭ �ڷ���(data type) ����















