-- SCOTT
-- [����] ��� ������ ���(�μ���ȣ, �μ���, �����, �Ի�����)
-- dept : deptno, dname, loc
-- emp : deptno, empno, enmae, sla, job, comm, hiredate

SELECT d.deptno, e.ename, e.hiredate, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT d.deptno, e.ename, e.hiredate, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno; -- ���� ������

-- 14. emp ���̺��� �޿� TOP3 ��ȸ
-- TOP-N�м� �� (����)
SELECT ROWNUM, e.*
FROM(
    SELECT deptno, ename, sal+NVL(comm,0) pay
    FROM emp
    ORDER BY pay DESC
    ) e
WHERE ROWNUM <=3 ;

WHERE ROWNUM BETWEEN 3 AND 5; -- X
WHERE ROWNUM > 3;   -- X ù��° ������ ������ �� �ִ�

-- [2]
SELECT e.*
FROM(
    SELECT 
    RANK() OVER( ORDER BY sal+NVL(comm,0) DESC) "pay_rank"
    ,empno, ename, hiredate, sal+NVL(comm,0) pay
    FROM emp
) e
WHERE e."pay_rank" = 1;

-- �� �μ��� pay 2����� ��� (����)
SELECT e.*
FROM(
    SELECT 
    deptno
    ,RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC, ename) deptno_pay_rank
    ,empno, ename, hiredate, sal+NVL(comm,0) pay
    FROM emp
) e
WHERE e.deptno_pay_rank BETWEEN 2 AND 3;

---------------------------------------------------------------------------------
--TO_CHAR(NUMBER) : ���� -> ���� ��ȯ
--TO_CHAR(DATE) : ��¥ -> ���� ��ȯ
SELECT SYSDATE
, TO_CHAR(SYSDATE, 'CC') a
, TO_CHAR(SYSDATE, 'DDD') b-- ���� ���� ��¥

, TO_CHAR(SYSDATE, 'W') c --08 ���� ���° ��
, TO_CHAR(SYSDATE, 'W') d -- 3  ���� ���° ��
, TO_CHAR(SYSDATE, 'IW') e -- 08 1���� ��°��
FROM dual;

-- ww : 1��1�� ���� 7�� �������� 
SELECT 
TO_CHAR(TO_DATE('2024.01.01'), 'WW') a
,TO_CHAR(TO_DATE('2024.01.02'), 'WW') b
,TO_CHAR(TO_DATE('2024.01.03'), 'WW') c
,TO_CHAR(TO_DATE('2024.01.04'), 'WW') d
,TO_CHAR(TO_DATE('2024.01.05'), 'WW') e
,TO_CHAR(TO_DATE('2024.01.06'), 'WW') f
,TO_CHAR(TO_DATE('2024.01.07'), 'WW') g
,TO_CHAR(TO_DATE('2024.01.08'), 'WW') h
,TO_CHAR(TO_DATE('2024.01.14'), 'WW') i
FROM dual;

-- iw : ISO ǥ�� �� ������ ~ �Ͽ��� 1����
SELECT 
TO_CHAR(TO_DATE('2022.01.01'), 'iw') a
,TO_CHAR(TO_DATE('2022.01.02'), 'iw') b
,TO_CHAR(TO_DATE('2022.01.03'), 'iw') c
,TO_CHAR(TO_DATE('2022.01.04'), 'iw') d
,TO_CHAR(TO_DATE('2022.01.05'), 'iw') e
,TO_CHAR(TO_DATE('2022.01.06'), 'iw') f
,TO_CHAR(TO_DATE('2022.01.07'), 'iw') g
,TO_CHAR(TO_DATE('2022.01.08'), 'iw') h
,TO_CHAR(TO_DATE('2022.01.14'), 'iw') i
,TO_CHAR(TO_DATE('2022.01.15'), 'iw') j
FROM dual;

SELECT 
TO_CHAR(SYSDATE, 'BC')
,TO_CHAR(SYSDATE, 'Q') -- 1�б�, 2�б�, 3�б�, 4�б�
FROM dual;

SELECT 
TO_CHAR(SYSDATE, 'HH') a
,TO_CHAR(SYSDATE, 'HH24') b
,TO_CHAR(SYSDATE, 'MI') c
,TO_CHAR(SYSDATE, 'SS') d

,TO_CHAR(SYSDATE, 'DY') e
,TO_CHAR(SYSDATE, 'DAY') f

,TO_CHAR(SYSDATE, 'DL') g -- Long 2024�� 2�� 20�� ȭ����
,TO_CHAR(SYSDATE, 'DS') h -- Short 2024/02/20
FROM dual;


SELECT ename, hiredate
,TO_CHAR(hiredate, 'DL')
,TO_CHAR(SYSDATE, 'TS')  -- ���� 3:51:27

,TO_CHAR(CURRENT_TIMESTAMP, 'HH24:MI:SS.FF')
FROM emp;

-- [����] ���� ��¥�� TO_CHAR() �Լ��� ����ؼ�
-- 2024�� 02�� 20�� ���� xx:xx:xx(ȭ)

SELECT 
SUBSTR(TO_CHAR(SYSDATE,'DL '),1, 13) 
|| TO_CHAR(SYSDATE, 'TS (DY)') "��¥"

, TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��" AM HH24:MI:SS (DY)') "���̾� ���"
FROM dual;

SELECT name, ssn
, SUBSTR(ssn, 1, 6)
, TO_DATE(SUBSTR(ssn, 1, 6))
, TO_CHAR(TO_DATE(SUBSTR(ssn, 1, 6)), 'DL')
FROM insa;

SELECT 
TO_DATE('0821', 'MMDD')
,TO_DATE('2023', 'YYYY')
,TO_DATE('202312', 'YYYYMM')
, TO_DATE('23�� 01�� 12��', 'YY"��" MM"��" DD"��"')
FROM dual;

-- [����] ������ '6/14' ���ú��� ���� �ϼ� ?
-- ORA-01821: date format not recognized
SELECT SYSDATE
, TO_DATE('6/14', 'MM/DD')
, CEIL(ABS(SYSDATE - TO_DATE('6/14', 'MM/DD')))
FROM dual;

-- [����] 4�ڸ� �μ���ȣ�� ���
SELECT deptno
, LPAD(deptno, 4, '0')
, CONCAT('00', deptno)
, TO_CHAR(deptno, '0999')
FROM emp;

-- java
-- if(a==b) c

-- Oracle 
-- DECODE(a,b,c)

--if(a == b) c
--else d

-- DECODE(a,b,c,d)

--if (a == b) c
--else if (a == d) e
--else if (a == f) g
--else h

-- DECODE(a,b,c, d,e, f,g, h)

-- [����] insa���̺��� ����/����

SELECT name, ssn, gender
, DECODE(gender, 1, '����', '����') AS "����"
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn, 8, 1),2) gender
    FROM insa
);

SELECT name, ssn, birth_date
,DECODE(birth_date,1,'������',0,'����',-1,'����') "���� �����°�"
FROM(
    SELECT name, ssn
    ,SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) birth_date
    FROM insa
); 

-- [����] emp ���̺��� �� ����� ��ȣ, �̸�, �޿� ���
-- ����) 10�� �μ������� �޿��� 15% �λ��ؼ� �޿�
-- ����) 20�� �μ������� �޿��� 10% �λ��ؼ� �޿�
-- ����) 30�� �μ������� �޿��� 5% �λ��ؼ� �޿�

SELECT deptno, empno, ename, pay
,pay * (1+DECODE(deptno, 10, 0.15, 20, 0.1, 30, 0.05)) rate
FROM(
    SELECT deptno, empno, ename, sal+NVL(comm,0) pay
    FROM emp
);