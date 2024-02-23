
-- �ڹ�       ������ ����      0.0 <= double Math.random() < 1.0
-- ����Ŭ      dbms_random ��Ű��     !=   �ڹ� ��Ű�� java.io
--            ���� ���õ� PL/SQL(���ν���, �Լ�)���� ����    ���� ���õ� Ŭ�������� ���� 

SELECT
--SYS.dbms_random.value -- 0.0 <=  �Ǽ�  < 1.0
--,SYS.dbms_random.value(0,100) -- 0.0 <=  �Ǽ�  < 100
--SYS.dbms_random.string('U', 5) -- Upper(�빮��) �ڵ����� 5�� �߻�
--SYS.dbms_random.string('X', 5) -- �빮�� + ����
SYS.dbms_random.string('P', 5) -- �빮�� + ���� + Ư������
--SYS.dbms_random.string('L', 5) -- Lower(�ҹ���) 
--SYS.dbms_random.string('A',5) -- ���ĺ�
FROM dual;

-- [����] ������ ���������� 1�� �߻����Ѽ� ����ϼ���.
-- [����] ������ �ζǹ�ȣ�� 1�� �߻����Ѽ� ����ϼ���
SELECT
TRUNC(SYS.dbms_random.value(0,101)) ��������
,TRUNC(SYS.dbms_random.value(1,46)) �ζǹ�ȣ
FROM dual;

-- [�Ǻ�(pivot) ����] (�ϱ�)
-- pivot ������ �ǹ� : ���� �߽����� ȸ����Ű��
--      �� ����� ����/���� - �ǹ� ���
-- SELECT * 
--  FROM (�ǹ� ��� ������)
-- PIVOT (�׷��Լ�(�����÷�) FOR �ǹ��÷� IN(�ǹ��÷� �� AS ��Ī...))

SELECT empno, ename
, job
FROM emp;
-- �� job���� ������� ������� ��ȸ.

SELECT job, COUNT(*)
FROM emp e
GROUP BY ROLLUP(job);

-- 1) �Ǻ� ��� ������
SELECT job
FROM emp;

-- 2) �Ǻ� �Լ� ó��
SELECT *
FROM (
    SELECT job
    FROM emp
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));

SELECT
COUNT(DECODE(job, 'CLERK', 'O')) CLERK
,COUNT(DECODE(job, 'SALESMAN', 'O')) SALESMAN
,COUNT(DECODE(job, 'PRESIDENT', 'O')) PRESIDENT
,COUNT(DECODE(job, 'MANAGER', 'O')) MANAGER
,COUNT(DECODE(job, 'ANALYST', 'O')) ANALYST
FROM emp;

-- �ǽ�2) ���� �Ի��� ����� ���� �ľ�
SELECT *
FROM(
    SELECT
    TO_CHAR(hiredate, 'MM') �Ի��
    FROM emp
)
PIVOT(COUNT(�Ի��) FOR �Ի�� IN ('01' AS "1��", '02' "2��",'03' "3��",'04' "4��",'05' "5��",'06' "6��"
                                ,'07' "7��",'08' "8��",'09' "9��",'10' "10��",'11' "11��",'12' "12��"));
                                
SELECT
TO_CHAR(hiredate, 'MM') MONTH
,TO_CHAR(hiredate, 'FMMM') || '��' month
, EXTRACT(MONTH FROM hiredate)|| '��' month
FROM emp;

-- [�ǽ�] ������ ���� �Ի� �� ���
SELECT *
FROM(
    SELECT
    TO_CHAR(hiredate, 'YYYY') �Ի��
    ,TO_CHAR(hiredate, 'MM') �Ի��
    FROM emp
)
PIVOT(COUNT(�Ի��) FOR �Ի�� IN ('01' AS "1��", '02' "2��",'03' "3��",'04' "4��",'05' "5��",'06' "6��"
                                ,'07' "7��",'08' "8��",'09' "9��",'10' "10��",'11' "11��",'12' "12��"));

-- [����] emp ���̺��� �� �μ��� , job�� ������� ��ȸ
SELECT *
FROM(
    SELECT
    d.deptno, dname, job
    FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
)
PIVOT(COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'MANAGER', 'PRESIDENT', 'ANALYST')) 
ORDER BY deptno;

-- �ǽ�)
SELECT job, deptno, sal
FROM emp;
--
SELECT *
FROM (
    SELECT job, deptno, sal
    FROM emp
    )
PIVOT( SUM(sal) FOR deptno IN ('10', '20', '30'));

SELECT *
FROM (
    SELECT job, deptno, sal, ename
    FROM emp
    )
PIVOT( SUM(sal) AS "�հ�", MAX(sal) AS "�ְ��", MAX(ename) AS "�ְ���" FOR deptno IN ('10', '20', '30'));

-- RIGHT OUTER JOIN
SELECT
d.deptno, dname, job
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno; -- RIGHT JOIN
--WHERE e.deptno = d.deptno(+); -- LEFT JOIN
--FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno;

-- [����] emp ���̺��� sal�� ���� 20%�� �ش�Ǵ� ����� ������ ��ȸ

SELECT ename, sal_rank
FROM(
    SELECT ename, sal
    ,RANK() OVER(ORDER BY sal DESC) sal_rank
    FROM emp
)
WHERE sal_rank <= (SELECT COUNT(*) FROM emp)*0.2;

-- [����]
--emp ���� �� ����� �޿��� ��ü�޿��� �� %�� �Ǵ� �� ��ȸ.
--       ( %   �Ҽ��� 3�ڸ����� �ݿø��ϼ��� )
--            ������ �Ҽ��� 2�ڸ������� ���.. 7.00%,  3.50%     
--
--ENAME             PAY   TOTALPAY ����     
------------ ---------- ---------- -------
--SMITH             800      27125   2.95%
--ALLEN            1900      27125   7.00%
--WARD             1750      27125   6.45%
--JONES            2975      27125  10.97%
--MARTIN           2650      27125   9.77%
--BLAKE            2850      27125  10.51%
--CLARK            2450      27125   9.03%
--KING             5000      27125  18.43%
--TURNER           1500      27125   5.53%
--JAMES             950      27125   3.50%
--FORD             3000      27125  11.06%
--MILLER           1300      27125   4.79%

SELECT ename, pay, totalpay
, TO_CHAR(ROUND(pay/totalpay * 100,2),999.99) || '%' ����
FROM(
    SELECT ename, sal+NVL(comm,0) pay,
    (SELECT SUM(sal+NVL(comm,0)) FROM emp) totalpay
    FROM emp
);

-- [����] insa���̺� 
--     [�ѻ����]      [���ڻ����]      [���ڻ����] [��������� �ѱ޿���]  [��������� �ѱ޿���] [����-max(�޿�)] [����-max(�޿�)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400      2650000          2550000

SELECT * FROM insa;



SELECT DECODE(gender,1,'���ڻ����',0,'���ڻ����','�ѻ����') "�����" 
, COUNT(*), DECODE(gender,1,MAX(pay),0,MAX(pay)) "�ִ� �޿�"
, DECODE(gender,1,SUM(pay), 0, SUM(pay)) "�޿� ��"
FROM(
    SELECT basicpay + sudang pay
    ,MOD(SUBSTR(ssn,8,1),2) gender
    FROM insa
    )
GROUP BY ROLLUP(gender);

SELECT 
COUNT(*) �ѻ����
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, '����')) ���ڻ����
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, '����')) ���ڻ����
,SUM(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, basicpay)) "��������� �ѱ޿���"
,SUM(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, basicpay)) "��������� �ѱ޿���"
,MAX(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, basicpay)) "����-max(�޿�)"
,MAX(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, basicpay)) "����-max(�޿�)"
FROM insa;

-- [����] ����(RANK) �Լ� ����ؼ� Ǯ�� 
--   emp ���� �� �μ��� �ְ�޿��� �޴� ����� ���� ���
--   
--    DEPTNO ENAME             PAY DEPTNO_RANK
------------ ---------- ---------- -----------
--        010 KING             5000           1
--        20 FORD             3000           1
--        30 BLAKE            2850           1

-- [1]
SELECT  deptno, ename
, (SELECT MAX(pay) FROM emp) pay
, deptno_rank
FROM(
    SELECT deptno, ename, sal+NVL(comm,0) pay
    ,RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC ) deptno_rank
    FROM emp
) 
WHERE deptno_rank = 1
ORDER BY deptno ASC;

-- [2]
SELECT t.deptno, e.ename, t.max_pay, 1 DEPTNO_RANK
FROM(
    SELECT deptno, MAX(sal+NVL(comm,0)) max_pay
    FROM emp
    GROUP BY deptno
    ) t, emp e
WHERE t.deptno = e.deptno AND t.max_pay = (e.sal+NVL(e.comm,0))
ORDER BY deptno ASC;

-- [3]
SELECT deptno, ename, pay, deptno_rank
FROM(
    SELECT deptno, ename
    ,sal+NVL(comm,0) pay
    ,RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) pay_rank
    ,RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) deptno_rank
    FROM emp
)
WHERE deptno_rank = 1;

-- [����] emp ���̺���
-- �� �μ��� �����, �μ� �ѱ޿���, �μ� ��ձ޿�

SELECT d.deptno, COUNT(*) �μ�����
, NVL(SUM(e.sal+NVL(comm,0)),0) �ѱ޿���
, NVL(ROUND(AVG(e.sal+NVL(comm,0)),2),0) ���
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno;

-- [����] insa ���̺��� �� �μ��� / ��������� / ����� �� ������ ���(��ȸ)
SELECT buseo, city, COUNT(*) �����
FROM insa
GROUP BY buseo, city
ORDER BY buseo, city;

-- insa ���̺��� �� �μ��� / ��������� / ����� �� ������ ���(��ȸ)
WITH c AS(
        SELECT DISTINCT city
        FROM insa
        )
SELECT buseo, c.city, COUNT(num)
FROM insa i1 PARTITION BY(buseo) RIGHT OUTER JOIN c ON i1.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;

-- [����] 
-- insa ���̺��� 
--[������]
--                                           �μ������/��ü����� == ��/�� ����
--                                           �μ��� �ش缺�������/��ü����� == �μ�/��%
--                                           �μ��� �ش缺�������/�μ������ == ��/��%
--                                           
--�μ���     �ѻ���� �μ������   ����  ���������   ��/��%   �μ�/��%     ��/��%
--���ߺ�       60       14         F       8       23.3%     13.3%     57.1%
--���ߺ�       60       14         M       6       23.3%     10%       42.9%
--��ȹ��       60       7         F       3       11.7%       5%       42.9%
--��ȹ��       60       7         M       4       11.7%     6.7%       57.1%
--������       60       16         F       8       26.7%    13.3%       50%
--������       60       16         M       8       26.7%    13.3%       50%
--�λ��       60       4         M       4       6.7%      6.7%       100%
--�����       60       6         F       4       10%       6.7%       66.7%
--�����       60       6         M       2       10%       3.3%       33.3%
--�ѹ���       60       7         F       3       11.7%     5%         42.9%
--�ѹ���       60       7         M    4         11.7%      6.7%       57.1%
--ȫ����       60       6         F       3       10%       5%           50%
--ȫ����       60       6         M       3       10%       5%           50% 

DESC insa;

SELECT buseo
, COUNT(buseo)
, DECODE(gender,1,'M',0,'F') ����, COUNT(gender) ���������
,COUNT(buseo)/COUNT(gender) "��/��"
FROM(
    SELECT buseo
    ,MOD(SUBSTR(ssn,8,1),2) gender
    FROM insa
    )
GROUP BY buseo, gender
ORDER BY buseo, gender;

---
SELECT s.*
, ROUND(�μ������/�ѻ���� * 100,1) || '%' "��/��%"
, ROUND(���������/�ѻ���� * 100,1) || '%' "�μ�/��%"
, ROUND(���������/�μ������ * 100,1) || '%' "��/��%"
FROM(
    SELECT buseo
    ,(SELECT COUNT(*) FROM insa) �ѻ����
    ,(SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) �μ������
    ,gender ����
    ,COUNT(*) ���������
    FROM(
        SELECT buseo, name, ssn
        ,DECODE(MOD(SUBSTR(ssn,8,1),2),1, 'M', 'F') gender
        FROM insa
        )t
    GROUP BY buseo, gender
    ORDER BY buseo, gender
)s;

-- [����] SMS ������ȣ ������ 6�ڸ� ���� �߻�
SELECT SYS.dbms_random.value
        , TRUNC(SYS.dbms_random.value(100000, 1000000))
        , TO_CHAR(TRUNC(SYS.dbms_random.value(10000, 1000000)), '099999')
FROM dual;

SELECT deptno,
TO_CHAR(deptno, '0099')
FROM dept;

-- [����] LISTAGG �Լ�
--SELECT LISTAGG(����÷�, '���й���') WITHIN GROUP (ORDER BY ���ı����÷�) 
--FROM TABLE�� ;

SELECT d.deptno,
NVL(LISTAGG(ename, '/') WITHIN GROUP (ORDER BY ename), '�������')
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno 
GROUP BY d.deptno;

-- [����] emp ���̺��� 30�� �μ��� �ְ� ���� sal�� �޴� ���������ȸ

SELECT deptno, ename, hiredate, sal
FROM emp
WHERE sal = (SELECT MIN(DECODE(deptno, 30, sal)) FROM emp)
AND deptno = 30
UNION0
SELECT deptno, ename, hiredate, sal
FROM emp
WHERE sal = (SELECT MAX(DECODE(deptno, 30, sal)) FROM emp)
AND deptno = 30;

--

SELECT deptno, ename, hiredate, sal
FROM (
    SELECT deptno, ename, hiredate, sal,
           RANK() OVER (PARTITION BY deptno ORDER BY sal ASC) AS srtop,
           RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS srlow
    FROM emp
    WHERE deptno = 30
) r
WHERE srtop = 1 OR srlow = 1; 

-- [������ ����] emp ���̺���
--              ������� ���� ���� �μ���� �����
--              ������� ���� ���� �μ���� �����


SELECT MAX(cnt), MIN(cnt)
FROM(
SELECT dname, COUNT(*) cnt
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY dname
);

--WITH a AS ()
--    ,b AS (FROM a)
SELECT d.dname, t.cnt
FROM(
    SELECT dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
    GROUP BY dname
)t RIGHT JOIN dept d ON t.dname = d.dname
GROUP BY d.dname
WHERE t.cnt = (SELECT MAX(cnt) FROM t); 

SELECT t.deptno, cnt
FROM (
    SELECT d.deptno, COUNT(empno) cnt
    ,RANK() OVER(ORDER BY COUNT(empno) ASC) cnt_rank
    FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
    GROUP BY d.deptno
    )t
WHERE t.cnt_rank IN (1, 4);
-- RANK ���� �Լ� ��� x
-- MAX(cnt), MIN(cnt)

-- ��.
WITH t AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
    )
SELECT dname, cnt
FROM t
WHERE cnt IN( (SELECT MAX(cnt) FROM t), (SELECT MIN(cnt) FROM t) );

-- ��. WITH �� ����
WITH a AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
    )
    , b AS(
    SELECT MIN(cnt) mincnt, MAX(cnt) maxcnt
    FROM a
    )
SELECT a.dname, a.cnt
FROM a, b 
WHERE a.cnt IN (b.mincnt, b.maxcnt);

-- ��. �м��Լ� : FIRST, LAST
--               ? �����Լ�(COUNT, SUM, AVG, MAX, MIN) �� ���� ����Ͽ�
--               �־��� �׷쿡 ���� ���������� ������ �Ű� ����� �����ϴ� �Լ�.
WITH a AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
    )
SELECT MAX(cnt)
      ,MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt ASC) max_dname
      ,MIN(cnt)
      ,MIN(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt ASC) min_dname
FROM a;

-- �м��Լ� �߿� CUME_DIST() : �־��� �׷쿡 ���� ������� ���� ������ ���� ��ȯ
                -- ������ ��(����)  0 <    <= 1
SELECT deptno, ename, sal
, CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) dept_dist
FROM emp;

-- �м��Լ� �߿� PERCENT_RANK() : �ش� �׷� ���� ����� ����
--                              0 <=  ������ ��  <= 1
-- ����� ���� ? �׷� �ȿ��� �ش� ���� ������ ���� ���� ����
SELECT deptno, ename, sal
--, PERCENT_RANK() OVER (ORDER BY sal) PERCENT
, PERCENT_RANK() OVER (PARTITION BY deptno ORDER BY sal) PERCENT
FROM emp;

-- NTILE(expr) NŸ�� : ��Ƽ�� ���� expr�� ��õ� ��ŭ ������ ����� ��ȯ�ϴ� �Լ�
-- �����ϴ� ���� ��Ŷ(bucket)�̶�� �Ѵ�.
SELECT deptno, ename, sal
, NTILE(4) OVER(ORDER BY sal) ntiles
FROM emp;

SELECT buseo, name, basicpay
,NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay) ntiles
FROM insa;

-- WIDTH_BUCKET(expr, minvalue, maxvalue, numbuckets) == NTILE() �Լ��� ������ �м��Լ�, ������( �ּҰ�, �ִ밪 ���� ���� )
SELECT deptno, ename, sal
, NTILE(4) OVER(ORDER BY sal) ntiles
, WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;

--  �ʼ�(�÷���), ������ ���� ��ġ, ���� ������ ����ϴ� ��
-- LAG( expr,       offset,        default_value)
--  ? �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�, ��(���� ��)
-- LEAD(expr, offset, default_value)
--  ? �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�, ��(���� ��)

SELECT deptno, ename, hiredate, sal
,LAG(sal, 1, 0) OVER(ORDER BY hiredate) pre_sal
,LAG(sal, 2, -1) OVER(ORDER BY hiredate) pre_sal
,LEAD(sal, 1, -1) OVER(ORDER BY hiredate) next_sal
FROM emp
WHERE deptno = 30;

-- offset : �� ������, default_value : �ٲ� ��

-------------------------------------------------------------------------------
-- [����Ŭ �ڷ���(data typ)]

-- 1) ����(��) �����ϴ� �ڷ���
����)
CHAR((SIZE [BYTE|CHAR]))
��)
CHAR(3 CHAR) ? 3���ڸ� �����ϴ� �ڷ���, 'abc', '�ѱۼ�'
CHAR(3 BYTE) ? 3����Ʈ�� ���ڸ� �����ϴ� �ڷ��� 'abc', '��' CHAR(3) == CHAR(3 BYTE)
CHAR == CHAR(1) == CHAR(1 BYTE)
���������� ���� �ڷ���

CHAR(14) == CHAR(14 BYTE)

-- DDL
CREATE TABLE tbl_char
(
    aa char
    ,bb char(3)
    , cc char(3 char)
);


SELECT *
FROM tabs
WHERE table_name LIKE '%CHAR%';

DESC tbl_char;
-- ���ο� ���ڵ�(��)�� �߰�
INSERT INTO tbl_char(aa,bb,cc) VALUES('a','aaa','aaa');
INSERT INTO tbl_char(aa,bb,cc) VALUES('a','��','�츮');
INSERT INTO tbl_char(aa,bb,cc) VALUES('a','�츮','�츮');
COMMIT;

SELECT *
FROM tbl_char;

DROP TABLE tbl_char;
COMMIT;
NCHAR[(SIZE)} == N + CHAR[(SIZE)]

NCHAR == NCHAR(1)

CREATE TABLE tbl_nchar
(
    aa char(3)
    ,bb char(3 char)
    , cc nchar(3)
);
INSERT INTO tbl_nchar(aa,bb,cc) VALUES('ȫ','�浿','ȫ�浿');
SELECT *
FROM tbl_nchar;

DROP TABLE tbl_nchar;
-- char / nchar - �������� 2000byte
-- VARCHAR2(size[BYTE | CHAR])
VARCHAR2(SIZE BYTE|CHAR) ��������

char(5 byte)     [a][b][c][][]
varchar2(5 byte) [a][b][c]
VARCHAR2 == VARCHAR2(1) == VARCHAR2(1 BYTE) 4000byte

-- N+VAR+CHAR2(size)
NVARCHAR2 == NVARCHAR2(1) = '��' 'a'
4000 byte





