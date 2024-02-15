-- SCOTT
--subquery�� �������� �Ǵٸ� ������ �����ϴ� ���̴�.
--�� SELECT ���� �Ǵٸ� SELECT ���� ��� �ִ� ����̸�, FROM ���� subquery�� ������ �̸� inline view�� �ϰ�, WHERE ���� subquery�� ������ �̸� Nested subquery�� �Ѵ�.
--�׷���, Nested subquery�߿��� �����Ǵ� �÷��� ���谡 parent/child���踦 ������ �÷��� ������
-- �̸� correlated subquery(��� ��������)�� �Ѵ�.
--
--subquery�� ������ ���� �������� ����
--
--? INSERT �Ǵ� CREATE TABLE ������ ���� ���� �����ϱ� ����
--? CREATE VIEW �Ǵ� CREATE MATERIALIZED VIEW ������ view �Ǵ� materialized view�� ���Խ�ų ���� �����ϱ� ����
--? UPDATE ������ ������ ���� �����ϱ� ����
--? SELECT, UPDATE, DELETE ���� WHERE��, HAVING ��, START WITH ���� ������ �����ϱ� ����
--? ������ ���� ���۵� ���̺��� �����ϱ� ����



SELECT *
FROM user_sys_privs; -- �ý��� ���� UNLOMITED TABLESPACE : ������ ���̺����̽� ���

SELECT *
FROM user_role_privs; -- ��
--SCOTT	CONNECT	NO	YES	NO
--SCOTT	RESOURCE	NO	YES	NO

DESC insa;

SELECT e.*
,sal + NVL(comm, 0) pay
--,COALESCE(sal + comm, sal, 0) pay
FROM emp e
WHERE deptno != 30 AND COALESCE(sal + comm, sal, 0) BETWEEN 1000 AND 3000
ORDER BY ename ASC;

-- WITH �� ���
WITH temp AS (
 SELECT e.*
 ,sal + NVL(comm, 0) pay
 FROM emp e)
SELECT t.*
FROM temp t
WHERE t.deptno != 30 AND t.pay BETWEEN 1000 AND 3000
ORDER BY ename ASC;

-- �ζ��� ��
SELECT t.*
FROM(
 SELECT e.*
 ,sal + NVL(comm, 0) pay
 FROM emp e
) t
WHERE t.deptno != 30 AND t.pay BETWEEN 1000 AND 3000
ORDER BY ename ASC;

SELECT empno, ename
,NVL(TO_CHAR(mgr), 'CEO') mgr
FROM emp;

SELECT num, name, tel
,NVL2(tel, 'O', 'X') tel -- �ڹ� ��� IF�� ���. PL/SQL
FROM insa
WHERE buseo IN '���ߺ�';

SELECT * 
 FROM insa
 WHERE city NOT IN ('����', '��õ', '���')
 ORDER BY city;

-- [����] emp���̺��� �Ի����� hiredate�� 81�⵵�� ��� ���� ��ȸ
-- �� ������ : ����, ����, ��¥
-- [1]
SELECT *
FROM emp
WHERE hiredate BETWEEN '81-01-01' AND '81-12-31';

-- [2] DATE -> �Ի�⵵�� ������
-- ���� ��¥�� ��/��/�� ��� : DATE(��), TIMESTAMP(���뼼����, �ð���)
SELECT SYSDATE,  CURRENT_TIMESTAMP
,EXTRACT( YEAR FROM SYSDATE )2024
,TO_CHAR(SYSDATE, 'YYYY') "2024"
,TO_CHAR(SYSDATE, 'YY')
,TO_CHAR(SYSDATE, 'YEAR')
FROM dual;

SELECT ename, hiredate
FROM emp
WHERE EXTRACT(YEAR FROM hiredate) hireyear
, WHERE TO_CHAR(hireyear, 'yyyy') = '1981';

-- [3]
SELECT ename, hiredate
,SUBSTR(hiredate, 1, 2) year
FROM emp;

SELECT 'abcdefg'
,SUBSTR('abcdefg', 1, 2) --ab 1 ù����
,SUBSTR('abcdefg', 0, 2) --ab 0 ù����
,SUBSTR('abcdefg', 3) --cdefg 
,SUBSTR('abcdefg', -5, 3) --cdefg �ڿ������� 5��°���� 3��
,SUBSTR('abcdefg', -1) --g �� �ޱ���
FROM dual;

-- [����] insa���̺��� �����, �ֹε�Ϲ�ȣ , �⵵, ��, �� ���� ���
DESC insa;

SELECT name, ssn
,SUBSTR(ssn, 1, 2) YEAR
,SUBSTR(ssn, 3,2) MONTH
,SUBSTR(ssn, 5,2) "DATE"
,SUBSTR(ssn, 8,1) GENDER
FROM insa;

-- ����Ŭ�� ����� : DATE 
SELECT *
FROM dictionary
WHERE table_name LIKE 'D%';

SELECT name
,CONCAT(SUBSTR(ssn,1,8), '*******') RRN
FROM insa
-- WHERE SUBSTR(ssn,1,2) BETWEEN 70 AND 79;
WHERE TO_NUMBER(SUBSTR(ssn,1,2)) BETWEEN 70 AND 79;
-- EXTRACT( YEAR FROM ��¥ );

SELECT name
,CONCAT(SUBSTR(ssn,1,8), '*******') RRN
,TO_DATE(SUBSTR(ssn, 0, 2), 'YY')
FROM insa;

-- LIKE SQL ������ ����
-- ���ڿ� ���� ��ġ ���� üũ�ϴ� ������
-- �˻� ���� ���� wildcard(%,_) ���
-- % : 0~�������� ����
-- _ : �Ѱ��� ����
-- wildcard(%,_)�� �Ϲݹ���ó�� ����Ϸ��� ESCAPE �ɼ��� ����϶�

-- [����] insa���̺��� 70������ �Ʒ��� ���� ���
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7%';

-- [����] insa���̺��� 12������ �Ʒ��� ���� ���
SELECT name, ssn
,SUBSTR(ssn, 3, 2) MONTH
,TO_DATE(SUBSTR(ssn, 3, 2), 'MM')
FROM insa
--WHERE SUBSTR(ssn, 3, 2) = '12';
WHERE EXTRACT(MONTH FROM TO_DATE(SUBSTR(ssn, 3, 2), 'MM')) = 12;

SELECT name, ssn
,SUBSTR(ssn, 1, 4)
,TO_DATE(SUBSTR(ssn, 1, 4),'YYMM')
,EXTRACT(MONTH FROM TO_DATE(SUBSTR(ssn, 1, 4),'YYMM')) MONTH
FROM insa;

SELECT name, ssn
FROM insa
WHERE ssn LIKE '__12%';

-- [����] insa ���̺��� �达 ���� ���� ��� ��� ���
SELECT name, ssn
FROM insa
WHERE name LIKE '_��_'; -- �̸� 3���ڰ� ����� ��
WHERE name LIKE '%��_'; -- �̸� ������ �ι�°�� ��
WHERE name LIKE '_��%'; -- �̸� �ӿ� �ι�° ���ڰ� '��'
WHERE name LIKE '%��%'; -- �̸� �ӿ� '��'���ڰ� ������ ���
WHERE name NOT LIKE '��%';

-- ��ŵ��� ����, �λ�, �뱸 �̸鼭 ��ȭ��ȣ�� 5 �Ǵ� 7�� ���Ե� �ڷ� ����ϵ� 
-- �μ����� ������ �δ� ��µ��� �ʵ�����. (�̸�, ��ŵ�, �μ���, ��ȭ��ȣ)
DESC insa;
SELECT name, city, buseo, LENGTH(buseo) , tel
, SUBSTR(buseo, 1, LENGTH(buseo)-1)
FROM insa
WHERE city IN ('����', '�λ�', '�뱸')
AND tel LIKE '%5%' OR  tel LIKE '%7%';

-- LIKE �������� ESCAPE �ɼ� ����
-- dept ���̺� ���� Ȯ��
DESC dept;
SELECT deptno, dname, loc
FROM dept;
--10	ACCOUNTING	NEW YORK
--20	RESEARCH	DALLAS
--30	SALES	CHICAGO
--40	OPERATIONS	BOSTON

-- SQL 5���� ; DQL, DDL, DML, DCL 
-- DML(INSERT) ���ο� �μ� �߰�...
DESC dept;
--INSERT INTO ���̺�� [(�÷���, �÷���....)] VALUES (��, ��...);
--COMMIT;
INSERT INTO dept(deptno, dname, loc) VALUES (50, 'QC100%T', 'SEOUL');
COMMIT;

SELECT *
FROM dept;
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
--             ���ϼ� ���� ����      PK_DEPT
INSERT INTO dept(deptno, dname, loc) VALUES (50, '�ѱ�_����', 'COREA');
INSERT INTO dept(deptno, dname, loc) VALUES (60, '�ѱ�_����', 'COREA');

-- [����] dept ���̺��� �μ��� �˻��� �ϴµ� �μ��� _ �� �ִ� �μ� ������ ��ȸ
--                                        �μ��� _ �� �ִ� �μ� ������ ��ȸ
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';
WHERE dname LIKE '%\_%' ESCAPE '\';

-- DML(INSERT, UPDATE, DELET) + �Ϸ� COMMIT, ��� ROLLBACK
--UPDATE (��Ű��).���̺��
--SET �÷� = ��, �÷� = ��...
--[WHERE ������;] -- ��� ���ڵ带 �����ϰڴ�
UPDATE scott.dept
SET loc = 'XXX';

UPDATE scott.dept
SET loc = 'DALLAS'
WHERE deptno = 20;

UPDATE scott.dept
SET loc = 'COREA', DNAME='�ѱ۳���'
WHERE deptno = 60;

-- [����] 30�� �μ���, ������ -> 60�� �μ���, ���������� UPDATE ����..
-- ORA-00936: missing expression
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 30), loc = (SELECT loc FROM dept WHERE deptno = 30)
WHERE deptno = 60;

SELECT * FROM dept;
ROLLBACK;

UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 30)
WHERE deptno = 60;
COMMIT;

-- DML(DELETE)
DELETE FROM [��Ű��.]���̺��
[WHERE ������;] - ��� ���ڵ� ����

-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
DELETE FROM dept
WHERE deptno IN (50, 60);
-- 
SELECT *
FROM emp;

-- [����] emp ���̺��� sal�� 10%�� �λ��ؼ� ���ο� sal�� ����
SELECT *
FROM emp;

UPDATE emp 
SET sal = sal * 1.1;
ROLLBACK;

-- LIKE SQL ������ :   % _ ���ϱ�ȣ
-- REGEXP_LIKE �Լ� : ����ǥ����
-- [����] insa ���̺��� ���� �达, �̾� ��� ��ȸ
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7[0-9]12');
WHERE REGEXP_LIKE(name, '^[^����]');
WHERE REGEXP_LIKE(name, '[����]%');
WHERE REGEXP_LIKE(name, '^(��|��)');
WHERE REGEXP_LIKE(name, '^[����]');
WHERE name LIKE '��%' OR name LIKE '��%';
WHERE SUBSTR(name, 1, 1) IN ('��', '��');

-- [����] insa ���̺��� 70��� ���� ����� ��ȸ..
-- ���� 1,3,5,7,9 ����
-- ������ �Լ� MOD()
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]');
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8, 1), 2) = 1;


