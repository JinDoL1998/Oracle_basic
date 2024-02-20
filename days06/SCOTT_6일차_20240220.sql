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
, TO_CHAR(SYSDATE, 'CC')
, TO_CHAR(SYSDATE, 'DDD') -- ���� ���� ��¥
FROM dual;







