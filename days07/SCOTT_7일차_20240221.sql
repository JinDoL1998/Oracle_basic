-- [1] insa ���̺��� �� �μ��� ����� ��ȸ
-- ��. SET ���� ������  UNION, UNION ALL
-- ��. �����������

SELECT buseo, COUNT(*) "�����"
FROM insa
GROUP BY buseo;

SELECT DISTINCT buseo
, (SELECT COUNT(*) cnt
FROM insa 
WHERE buseo = p.buseo) cnt
FROM insa p;

-- [2] emp ���̺��� �޿��� ����
-- [1] rank()
SELECT *
FROM(
    SELECT empno, ename
    ,sal+NVL(comm,0) pay
    ,RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) rank
    FROM emp
)
WHERE rank <= 3;

-- [2] ���� 
SELECT 
(SELECT COUNT(*)+1 FROM emp c WHERE sal+NVL(comm,0) > (p.sal+NVL(comm,0))) pay_rank
,p.*
FROM emp p
ORDER BY pay_rank;

-- [3] TOP-N
SELECT *
FROM emp;

-- [3] insa ���̺��� ���ڻ����, ���ڻ���� ��ȸ
-- ��. SET
-- ��. GROUP BY
-- ��. DECODE
SELECT COUNT(*) "��ü�����"
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, '����')) "���ڻ����"
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, '����')) "���ڻ����"
FROM insa;

SELECT
 DECODE(MOD(SUBSTR(ssn,8,1),2),1 ,'0')
FROM insa;

SELECT DECODE(gender,1,'����','����') "�����", COUNT(*)
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn,8,1),2) gender
    FROM insa
    )
GROUP BY gender
UNION ALL
SELECT '��ü', COUNT(*)
FROM insa;

SELECT COUNT(*)
FROM insa;

-- [4] emp �� �μ��� ����� ��ȸ
SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- [4-2] ���� ���� ������� �μ���ȣ�� �ƴ϶� �μ����� ���
SELECT dname, COUNT(*)
FROM dept d JOIN emp e ON e.deptno = d.deptno
GROUP BY dname
UNION ALL
SELECT 'OPERATIONS', COUNT(*)
FROM emp
WHERE deptno = 40
ORDER BY dname ASC;

SELECT dname, COUNT(e.deptno)
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY dname;


SELECT COUNT(*)
,COUNT(DECODE(deptno, 10, 'O')) "10"
,COUNT(DECODE(deptno, 20, 'O')) "20"
,COUNT(DECODE(deptno, 30, 'O')) "30"
,COUNT(DECODE(deptno, 40, 'O')) "40"
FROM emp;

-- [5] insa ���̺��� ���� ��, ���� ��, ���� ����
-- DECODE �Լ� ���
-- ��. 1002�� ����� �ֹε�Ϲ�ȣ 800221-1544236 update ���� ����
SELECT SYSDATE
,TO_CHAR(SYSDATE, 'DD')
FROM dual;

UPDATE insa
SET ssn = SUBSTR(ssn,1,2) || TO_CHAR(SYSDATE,'MMDD') || SUBSTR(ssn, 7)
WHERE num IN (1001, 1002);
COMMIT; 

SELECT num, name, ssn
,DECODE(s,1,'������',0,'����',-1,'���� ��') s
,CASE s
    WHEN 1 THEN '���� ��'
    WHEN 0 THEN '����'
    ELSE '���� ��'
END ��Ī
FROM(
    SELECT num, name, ssn
    ,TRUNC(SYSDATE)
    ,SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) s
    ,CASE 
        WHEN TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE) > 0 THEN '���� ��'
        WHEN TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE) = 0 THEN '����'
        ELSE '���� ��'
    END ��Ī
    FROM insa
);

-- [5-2] emp ���̺��� 10�� �μ��� sal 10%�λ� 20�� �μ��� 15% �λ�, �� �� �μ��� 5% �λ�
SELECT deptno, ename, sal
,sal*DECODE(deptno, 10, 1.1, 20, 1.15, 1.05) increase_rate
FROM emp;

SELECT deptno, ename, sal 
,CASE
    WHEN deptno = 10 THEN sal*1.1
    WHEN deptno = 20 THEN sal*1.15
    ELSE sal*1.05
END increase_sal
FROM emp;

-- [����] insa ���̺��� �ѻ����, ������ �����, ���û��ϻ����, ������ ����� ���
-- [1]
SELECT COUNT(*)
,COUNT(DECODE(s, 1, '����')) "���� �� �����"
,COUNT(DECODE(s, 0, '����')) "���� ���� �����"
,COUNT(DECODE(s, -1, '����')) "���� �� �����"
FROM (
    SELECT 
    SIGN(TO_DATE(SUBSTR(ssn, 3, 4),'MMDD') - TRUNC(SYSDATE)) s
    FROM insa
    );

-- [2]
SELECT 
CASE s
    WHEN 1 THEN '���� ��'
    WHEN 0 THEN '���� ����'
    ELSE '���� ��'
END ���Ͽ���
, COUNT(*)
FROM (
    SELECT 
    SIGN(TO_DATE(SUBSTR(ssn, 3, 4),'MMDD') - TRUNC(SYSDATE)) s
    FROM insa
    )t
GROUP BY s;

-- [����] emp ���̺��� ��� pay ���� ���ų� ���� ������� �޿����� ���
-- [1]
WITH a AS (
        SELECT TO_CHAR(AVG(sal+NVL(comm,0)), '9999.00') avg_pay
        FROM emp
    )
    ,b AS (
        SELECT empno, ename, sal+NVL(comm,0) pay
        FROM emp
    )
SELECT '��� �޿� �̻� ��', SUM(b.pay) "��� �޿� �̻� ��"
FROM a, b
WHERE b.pay >= a.avg_pay;

-- [2]
SELECT SUM(sal+NVL(comm,0)) pay
FROM emp
WHERE sal+NVL(comm,0) >= (SELECT ROUND(AVG(sal+NVL(comm,0)),2) FROM emp);

-- [3]
SELECT 
    SUM(DECODE( SIGN(pay - avg_pay), 1, pay ))
    , SUM(CASE
        WHEN pay-avg_pay > 0 THEN pay
        ELSE                      NULL
    END)
FROM(
    SELECT empno, ename, sal+NVL(comm,0) pay
            ,(SELECT ROUND(AVG(sal+NVL(comm,0)),2) FROM emp) avg_pay
    FROM emp
);

-- [����] emp, dept ���̺��� ����ؼ� 
-- ����� �������� �ʴ� �μ��� �μ���ȣ, �μ��� ���
-- [1]
SELECT d.deptno, dname
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
WHERE e.empno IS NULL;

-- [2]
SELECT dname, deptno
FROM dept
WHERE deptno = (
            SELECT deptno
            FROM dept
            MINUS
            SELECT DISTINCT deptno
            FROM emp);

SELECT t.deptno, d.dname
FROM dept d JOIN (
            SELECT deptno
            FROM dept
            MINUS
            SELECT DISTINCT deptno
            FROM emp
            ) t
            ON  t.deptno = d.deptno;
            
SELECT p.deptno, p.dname
FROM dept p
--WHERE (SELECT COUNT(*) FROM emp WHERE deptno = p.deptno) = 0;
WHERE EXISTS (SELECT empno FROM emp WHERE deptno = p.deptno);


--SELECT d.deptno, d.dname, COUNT(empno) cnt
--FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno

-- HAVING ��

SELECT d.deptno, d.dname, COUNT(empno) cnt
            FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno
            -- WHERE cnt = 0  -- ORA-00904: "CNT": invalid identifier
            GROUP BY d.deptno, d.dname
            HAVING COUNT(empno) = 0
            ORDER BY d.deptno;

-- [����] insa ���̺��� �� �μ��� ���ڻ������ �ľ��ؼ� 5���̻��� ���� ���
SELECT buseo, COUNT(buseo) cnt
FROM (  
    SELECT num, name, buseo,ssn
    ,MOD(SUBSTR(ssn, 8, 1),2) gender
    FROM insa
)
WHERE gender = 0
GROUP BY buseo
HAVING COUNT(buseo) >= 5;

-- [����] emp ���̺��� �μ���, job�� ����� �ѱ޿���
SELECT deptno, job
, COUNT(*) cnt
, SUM(sal+NVL(comm,0)) deptno_pay_sum
, AVG(sal+NVL(comm,0)) deptno_pay_avg
, MAX(sal+NVL(comm,0)) deptno_pay_max
, MIN(sal+NVL(comm,0)) deptno_pay_min
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;

-- (�ϱ�) Oracle 10g PARTITION OUTER JOIN ����
WITH t AS(
            SELECT DISTINCT job
            FROM emp
        )
SELECT deptno, t.job, NVL(SUM(sal+NVL(comm,0)),0) d_j_pay_sum
FROM t LEFT OUTER JOIN emp e PARTITION BY(deptno) ON t.job = e.job
GROUP BY deptno, t.job
ORDER BY deptno;

-- GROUPING SETS ��
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT job, COUNT(*)
FROM emp
GROUP BY job;

SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

-- LISTAGG(�Լ�)
SELECT ename
FROM emp
WHERE deptno = 10;

SELECT ename
FROM emp
WHERE deptno = 20;

SELECT ename
FROM emp
WHERE deptno = 30;

--(�ϱ�)
SELECT d.deptno
,NVL(LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename), '����� �������� �ʽ��ϴ�.') "�μ��� ���" -- ename�� LIST ��� ����
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno;

SELECT *
FROM salgrade; -- �޿� ��� ���̺�
--grade losal   hisal
--1	    700 	1200
--2	    1201	1400
--3	    1401	2000
--4	    2001	3000
--5	    3001	9999
SELECT ename, sal
, CASE
    WHEN sal BETWEEN 700 AND 1200 THEN 1
    WHEN sal BETWEEN 1201 AND 1400 THEN 2
    WHEN sal BETWEEN 1401 AND 2000 THEN 3
    WHEN sal BETWEEN 2001 AND 3000 THEN 4
    WHEN sal BETWEEN 3001 AND 9999 THEN 5
    
  END grade
FROM emp;

-- [salgrade ���̺� + emp ���̺� ����]
-- JOIN ON ����       NON equal ����
SELECT ename, sal, losal || '-' || hisal "RANGE", grade
FROM emp JOIN salgrade ON sal BETWEEN losal AND hisal;

-- [���� ǥ���� ����Ŭ �Լ�]
SELECT * 
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d');

-- [���� �Լ�]
-- 1) RANK()
-- 2) DENSE_RANK()
-- 3) PERCENT_RANK()
-- 4) ROW_NUMBER()
-- 5) FIRST() / LAST()

-- [����] emp ���̺��� sal ���� �Űܺ���
SELECT empno, ename, sal
,RANK() OVER(ORDER BY sal DESC) r_rank
,DENSE_RANK() OVER(ORDER BY sal DESC) d_rank
,ROW_NUMBER() OVER(ORDER BY sal DESC) rn_rank
FROM emp;
--7654	MARTIN	1250	9	9	9
--7521	WARD	1250	9	9	10
--7900	JAMES	950	    11	10	11

SELECT empno, ename, sal, deptno
,RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) r_rank
,DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) d_rank
,ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rn_rank
FROM emp;

-- [����] emp ���̺��� �� ����� �޿��� ��ü ����, �μ��� ������ ���
SELECT deptno, ename, pay
,RANK() OVER(ORDER BY pay) total_rank
,RANK() OVER(PARTITION BY deptno ORDER BY pay) dept_rank
FROM(
SELECT deptno,empno, ename, sal+NVL(comm,0) pay
FROM emp
)
ORDER BY deptno ASC;

-- [ROLLUP/CUBE ������]
-- insa ���̺���
-- ���ڻ���� : 31��
-- ���ڻ���� : 29��
-- ��ü����� : 60��

-- [1]
SELECT DECODE(gender,1,'���ڻ����', 0,'���ڻ����') �����, COUNT(*) || '��'
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)
GROUP BY gender
UNION ALL
SELECT '��ü �����', COUNT(*) || '��'
FROM insa;

-- [2]
SELECT COUNT(*)
,COUNT(DECODE())
,COUNT(DECODE())
FROM insa;

-- [3]
SELECT DECODE(gender,1,'���ڻ����', 0,'���ڻ����', '��ü�����') �����, COUNT(*) || '��' "�ο� ��"
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)
GROUP BY CUBE(gender);
GROUP BY ROLLUP(gender); 

-- ��2)

SELECT buseo, jikwi, COUNT(*) cnt
,SUM(basicpay) ���޺��޿���
FROM insa
--GROUP BY ROLLUP(buseo, jikwi) 
--GROUP BY CUBE(buseo, jikwi) 
GROUP BY buseo, ROLLUP(jikwi) 
ORDER BY buseo;

-- [����] emp ���̺��� ���� ���� �Ի��� ����� ���� �ʰ�(�ֱ�)�� �Ի��� ����� ���� ��ȸ
--        �Ի��� ���� �ϼ�

SELECT ename, hiredate, d
FROM(
    SELECT ename, hiredate
    ,TO_NUMBER((TO_CHAR(hiredate,'YYMMDD'))) d
    FROM emp 
) e
WHERE e.d = (SELECT MAX(TO_NUMBER((TO_CHAR(hiredate,'YYMMDD')))) FROM emp);

SELECT 
MAX(hiredate)
,MIN(hiredate)
,MAX(hiredate) - MIN(hiredate)
FROM emp;

-- [����]  insa ���̺��� �� ������� �����̸� ����ؼ� ���
-- 1) ������ = ���س⵵ - ���ϳ⵵ (���� ���������� -1)
--      ��. ���� ������ ����
--      ��. 981223-1XXXXXX
SELECT name, ssn, birth_year, current_year, s
, current_year - birth_year + DECODE(s, 1, -1, -1, 0, 0, -1) || '��' "�� ����"
FROM(
SELECT ssn, name
,CASE
    WHEN gender IN (1,2) THEN '19' || year
    WHEN gender IN (3,4) THEN '20' || year
    WHEN gender IN (8,9) THEN '18' || year
END birth_year
,TO_CHAR(SYSDATE,'YYYY') current_year
,SIGN(SYSDATE - TO_DATE(MONTH,'MMDD')) s
    FROM(
        SELECT name, ssn
        ,SUBSTR(ssn,1,2) year
        ,SUBSTR(ssn,8,1) gender
        ,SUBSTR(ssn,3,4) MONTH
    FROM insa
)
);

-- [2]
SELECT t.name, t.ssn
, ���س⵵-���ϳ⵵ + CASE S 
                        WHEN 1 THEN -1
                        ELSE 0
                    END ������
FROM(
    SELECT name, ssn
    ,TO_CHAR(SYSDATE, 'YYYY') ���س⵵
    ,CASE
        WHEN SUBSTR(ssn,8,1) IN (1,2,5,6) THEN 1900
        WHEN SUBSTR(ssn,8,1) IN (3,4,7,8) THEN 2000
        ELSE 1800
    END + SUBSTR(ssn,1,2) ���ϳ⵵
    , SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD')-TRUNC(SYSDATE)) s -- ������, ���û���, ������
    FROM insa
    ) t;

SELECT 
TO_CHAR(SYSDATE,'MMDD') 
FROM dual;

SELECT *
FROM insa;



