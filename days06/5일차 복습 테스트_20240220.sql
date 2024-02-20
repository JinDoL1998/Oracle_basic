-- SCOTT
--2.emp ���̺��� �޿��� ��ձ޿��� ���ϰ�
--   �� ����� �޿�-��ձ޿��� �Ҽ��� 3�ڸ����� �ø�,�ݿø�,�����ؼ� �Ʒ��� 
--   ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- [1]
SELECT ename, pay, ROUND(avg_pay,2) avg_pay
, CEIL((pay - avg_pay)*100)/100  "�� �ø�"
, ROUND((pay - avg_pay),2) "�� �ݿø�"
, TRUNC((pay - avg_pay), 2) "�� ����"
FROM(
    SELECT ename, sal+NVL(comm, 0) pay
    ,ROUND((SELECT AVG(sal+NVL(comm, 0)) FROM emp),3) avg_pay
    FROM emp
);

-- [2]
WITH temp AS(
            SELECT ename, sal+NVL(comm,0) pay
            , (SELECT AVG(sal+NVL(comm,0)) FROM emp) avg_pay
            FROM emp
            )
SELECT ename, pay, ROUND(avg_pay,2)
, CEIL((t.pay - t.avg_pay) * 100) / 100 "�� �ø�"
, ROUND(t.pay - t.avg_pay, 2) "�� �ݿø�"
, TRUNC(t.pay - t.avg_pay, 2) "�� ����"
FROM temp t;

--2-2. emp ���̺��� �޿��� ��ձ޿��� ���ϰ�
--    �� ����� �޿��� ��ձ޿� ���� ������ "����"
--                   ��ձ޿� ���� ������ "����"��� ���
-- [1]
SELECT ename, pay, avg_pay
, NVL2(NULLIF(SIGN(pay - avg_pay), 1), '����', '����')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    ,ROUND((SELECT AVG(sal+NVL(comm, 0))FROM emp),2) avg_pay
    FROM emp
    );

--3. insa ���̺��� ���ڻ����, ���ڻ������ ��� 
--[ ������ ]
-- ����        �����
--���ڻ����	31
--���ڻ����	29
--[1]
SELECT REPLACE(REPLACE(gender,0,'����'), 1, '����') || '�����' ����
, COUNT(*) �����
FROM(
    SELECT name, MOD(SUBSTR(ssn, 8, 1),2) gender
    FROM insa
    )
GROUP BY gender;

--insa ���̺��� ��� ������� 14�� ���� ����� �� �� ���� �������� ������ �ۼ��ϼ���. 
SELECT CEIL(COUNT(*) / 14)
FROM insa;


--6. emp ���̺��� �ְ� �޿���, ���� �޿��� ���� ��� ��ȸ
--  [������]
--empno   ename   job     mgr     hiredate   pay      deptno  etc
--7369	SMITH	CLERK	 7902	 80/12/17	 800	    20   �ְ�޿���
--7839	KING	PRESIDENT		 81/11/17	 5000		10   �����޿���

-- [1]
SELECT empno, ename, job, mgr, hiredate
,sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) IN (  SELECT MAX(sal+NVL(comm,0)) max_pay, 
                        MIN(sal+NVL(comm,0)) min_pay FROM emp ); --X
WHERE sal+NVL(comm,0) IN (
                   (SELECT MAX(sal+NVL(comm,0)) max_pay FROM emp)
                  , (SELECT MIN(sal+NVL(comm,0)) min_pay FROM emp) 
      );  
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) FROM emp)
OR sal+NVL(comm,0) = (SELECT MIN(sal+NVL(comm,0)) FROM emp);


SELECT empno, ename, job, mgr, hiredate
,sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) FROM emp)
UNION
SELECT empno, ename, job, mgr, hiredate
,sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MIN(sal+NVL(comm,0)) FROM emp);


--7.  emp ���̺��� 
--   comm �� 400 ������ ����� ���� ��ȸ
--  ( ���� : comm �� null �� ����� ���� )
-- LNNVL() �Լ�
-- LNNVL(null) => true
SELECT ename, sal, comm
FROM emp
WHERE LNNVL(comm >= 400);

--8. emp ���̺��� [�� �μ���] �޿�(pay)�� ���� ���� �޴� ����� ���� ���.    
--   ��. Correlated Subquery(��ȣ���� ��������) ����ؼ� Ǯ��
SELECT *
FROM emp p
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) 
                         FROM emp c WHERE deptno = p.deptno);
                         
-- 9. emp ���̺��� 30�� �μ��� PAY�� ��� �� ����׷����� �Ʒ��� ���� �׸��� ���� �ۼ�
--( �ʿ��� �κ��� ��� �м��ϼ���~    PAY�� 100 ������ # �Ѱ� , �ݿø�ó�� )
--[������]
--DEPTNO ENAME  PAY     BAR_LENGTH      
------------ ---------- ---------- ----------
--30	BLAKE	2850	29	 #############################
--30	MARTIN	2650	27	 ###########################
--30	ALLEN	1900	19	 ###################
--30	WARD	1750	18	 ##################
--30	TURNER	1500	15	 ###############
--30	JAMES	950	    10	 ##########                 

SELECT deptno, ename, pay
,RPAD(CEIL(pay/100), CEIL(pay/100) ,'#') "BAR_LENGTH"
FROM(    
    SELECT deptno, ename, sal+NVL(comm,0) pay
    FROM emp
)
WHERE deptno = 30
ORDER BY pay DESC;

-- 13. emp ���� ���PAY ���� ���ų� ū ����鸸�� �޿����� ���.
-- [1]
SELECT ename, sal, comm, sal+NVL(comm,0) pay
, ROUND((SELECT AVG(sal+NVL(comm,0)) FROM emp),5) avg_pay
FROM emp
WHERE sal+NVL(comm,0) >= (
                            ROUND((SELECT AVG(sal+NVL(comm,0)) FROM emp),5) 
                            );
                            
-- [2]




-- 17. insa ���̺���
-- �����ȣ(num) ��  1002 �� ����� �ֹι�ȣ�� ��,�ϸ��� ���ó�¥�� �����ϼ���.
--                              ssn = '80XXXX-1544236'    
SELECT num, name, ssn
,SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7)
FROM insa
WHERE num = 1002;  

UPDATE insa
SET ssn = SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7)
WHERE num = 1002;

COMMIT;

SELECT num, name, ssn
FROM insa
WHERE num = 1002;

SELECT SYSDATE
,TO_CHAR(SYSDATE, 'YYYY') year
,TO_CHAR(SYSDATE, 'MM') MONTH
,TO_CHAR(SYSDATE, 'DD') "DATE"
,TO_CHAR(SYSDATE, 'DY') day
,TO_CHAR(SYSDATE, 'MM.DD') md
FROM dual;
-- 17-2 insa ���̺��� ������ �������� ������ ���� ���θ� ����ϴ� ������ �ۼ��ϼ��� . 
SELECT name, ssn , SYSDATE
,SUBSTR(ssn,3,4) ssn_md
,SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) "����" -- ���(���� ��) , 0 (����), ���� (���� ��)
,REPLACE(REPLACE(REPLACE(SIGN( TO_DATE( SUBSTR( ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)),-1,'����'),0,'����'),1,'������') ��

FROM insa;

--18. emp ���̺��� ename, pay , �ִ�pay�� 5000�� 100%�� ����ؼ�
--   �� ����� pay�� ��з��� ����ؼ� 10% �� ���ϳ�(*)�� ó���ؼ� ���
--   ( �Ҽ��� ù ° �ڸ����� �ݿø��ؼ� ��� )
-- [1]
SELECT ename, pay, max_pay
,pay/max_pay * 100 || '%' "�ۼ�Ʈ"
, RPAD(ROUND(pay/max_pay * 10),ROUND(pay/max_pay * 10)+1, '*') "�� ����"
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    , (SELECT MAX(sal+NVL(comm,0)) FROM emp) max_pay
    FROM emp
);

-- [2]
WITH t AS(
SELECT ename, sal+NVL(comm, 0) pay
,(SELECT SUM(sal+NVL(comm,0)) FROM emp) sum_pay
FROM emp
)
SELECT t.ename, t.pay, t.sum_pay
,ROUND(t.pay/t.sum_pay * 100,2) || '%' percent
,ROUND(t.pay/t.sum_pay * 100) star_count
,RPAD(' ', (t.pay/t.sum_pay * 100)+1, '*') star_graph
FROM t;



























