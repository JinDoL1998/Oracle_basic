-- SCOTT
--[����Ŭ DATA TYPE]
--1. CHAR �������� 2000byte
--2. HCHAR �������� 2000byte
--3. VARCHAR �������� 4000byte
--4. NVARCHAR �������� 4000byte
--5. LONG     �������� 2GB

DESC dept;

-- ORA-01438: value larger than specified precision allowed for this column
INSERT INTO dept (deptno, dname, loc) VALUES (100, 'QC', 'SEOUL');
INSERT INTO dept (deptno, dname, loc) VALUES (-20, 'QC', 'SEOUL');
ROLLBACK;

-- 6. NUMBER[(p[,s])]
--          p(���е�) : 1 - 38, ��ü�ڸ���
--          s(�Ը�)   : -84 - 127 �Ҽ��� ���� �ڸ���
--��)
--NUMBER
--DEPTNO NUMBER(2) == NUMBER(2,0) == 2�ڸ� ���� -99 ~ 99 ����
--KOR    NUMBER(3) == NUMBER(3,0) == 3�ڸ� ���� -999 ~ 999 ����
--NUMBER(5,2) 

-- ���� ������ �����ϰ� �߻��ؼ� ����
INSERT INTO �������̺�(kor,eng,math) 
VALUES( SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100) );

-- �й�(PK), �л���, ��,��,��,��,��,�� �÷���
-- 00907. 00000 -  "missing right parenthesis"
CREATE TABLE tbl_score
(
    no      NUMBER(2) NOT NULL PRIMARY KEY -- PK = NN + UK(���ϼ� ��������)
    ,name   VARCHAR2(30) NOT NULL
    ,kor    NUMBER(3)
    ,eng    NUMBER(3)
    ,math   NUMBER(3)
    ,total  NUMBER(3)
    ,avg    NUMBER(5,2)
    ,rank   NUMBER(2)
);

INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (1, 'ȫ�浿', 90, 87, 88.89);
--INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (2, '������', 990, -88, 65);
INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (2, '������', 99, 88, 65);
--INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (3, '�躴��', 1999, 68, 82);
INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (3, '�躴��', 19, 68, 82);

ROLLBACK;
COMMIT;

SELECT *
FROM tbl_score;

UPDATE tbl_score
SET eng = 0
WHERE no = 2;

-- 3���л��� ��/��/��/��/�� �Է� -> ��/��/�� ó��
UPDATE tbl_score
SET total = kor+eng+math, avg = (kor+eng+math)/3, rank = 1;

-- [����] ��� ó���ϴ� UPDATE �� �ۼ�..
UPDATE tbl_score p
SET p.rank = (SELECT COUNT(*)+1 FROM tbl_score c
              WHERE c.total > p.total);

-- FLOAT(p) �����ڷ���, ���������� NUMBER ó��

-- ��¥ �ڷ���
--��. DATE         7 ����Ʈ, ��������, �ʱ��� ����
--��. TIMESTAMP(n) 0-9(nano)
--      TIMESTAMP == TIMESTAMP(6) 00:00:00.000000

-- ���������� ����     ???.png �̹����� ���������� ����
--RAW(SIZE)   2000byte         
--LONG RAW    2GB

-- 
--B+FILE    Binary �����͸� �ܺο� file���·� (264 -1����Ʈ)���� ���� 
--B+LOB    Binary �����͸� 4GB���� ���� (4GB= (232 -1����Ʈ)) 
--C+LOB    Character �����͸� 4GB���� ���� 
--NC+LOB    Unicode �����͸� 4GB���� ���� 

-- COUNT() OVER() ������ ���� ������ ������� ��ȯ
SELECT buseo, name, basicpay
,COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC) a
,SUM(basicpay) OVER(ORDER BY basicpay ASC) b
,SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC) b
,AVG(basicpay) OVER(ORDER BY basicpay ASC) c
,AVG(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC) c
FROM insa;

-- [����] �� ������(city) �޿� ���
SELECT city, name, basicpay
--, AVG(basicpay)
, AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
, basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
FROM insa;

-- [���̺� ����, ����, ����) + ���ڵ� �߰�, ����, ���� --
--1) ���̺� (table) ? ������ �����
--2) DB�𵨸� -> ���̺� ����
--    ��) �Խ����� �Խñ��� �����ϱ� ���� ���̺� ����
--        ��. ���̺�� : tbl_board
--        ��. �����÷�     ������ �÷��� �ڷ���(ũ��)    �����(�ʼ��Է�)   
--            �۹�ȣ(PK)     seq         NUMBER          NOT NULL(NN)
--            �ۼ���         writer      VARCHAR2(20)    NN
--            ��й�ȣ       password    VARCHAR2(15)    NN
--            ����           title       VARCHAR2(100)   NN
--            ����           content     CLOB           
--            �ۼ���         writedate   DATE            DEFAULT SYSDATE
--            ��ȸ��         view_count  NUMBER(10)      DEFAULT 0
--            ���

--�����������ġ�
--CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--      ( 
--        ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
--       [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
--       [,...]  
--      ); 

--��) TEMPORARY �ӽ� ���̺� ����
CREATE TABLE tbl_board
(
 seq        NUMBER          NOT NULL PRIMARY KEY
 ,writer    VARCHAR2(10)    NOT NULL
 ,passwd    VARCHAR2(20)    NOT NULL
 ,title     VARCHAR2(100)   NOT NULL
 ,content   CLOB
 ,regdate   DATE            DEFAULT SYSDATE
);

DESC tbl_board

-- ���̺� ���� : CREATE TABLE (DDL)
-- ���̺� ���� : ALTER TABLE (DDL)
-- ? alter table ... add �÷�     �߰�
-- ? alter table ... modify �÷�  ����
-- ? alter table ... drop[constraint] �������� ����
-- ? alter table ... drop column �÷� ����

-- ���̺� ���� : DROP TABLE (DDL)
SELECT *
FROM tbl_board;

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES                (1, 'ȫ�浿', '1234', 'test-1', 'test-1', SYSDATE);

-- ORA-00001: unique constraint (SCOTT.SYS_C007035) violated
INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES                (2, '�Ǹ���', '1234', 'test-2', 'test-2', SYSDATE);

INSERT INTO tbl_board 
VALUES                (3, '�迵��', '1234', 'test-3', 'test-3', SYSDATE);

INSERT INTO tbl_board (seq, writer, passwd, title, content)
VALUES                (4, '�̵���', '1234', 'test-4', 'test-4');

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES                (5, '�̽���', '1234', 'test-5', 'test-5', null);

COMMIT;

-- ���������̸��� �����ؼ� ���������� ������ �� �ְ�,
-- ���������̸��� �������� ������ SYS_XXXX�̸����� �ڵ� �ο��ȴ�
-- ���������̸� : SCOTT.SYS_C007035
SELECT *
FROM user_constraints
WHERE table_name LIKE '%BOARD';

-- ���̺� ���� : ��ȸ�� �÷�(1��) �߰�...
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0; -- 1�� �÷��� �߰��� ��� () ��ȣ ���� ����

DESC tbl_board;

SELECT *
FROM tbl_board;

INSERT INTO tbl_board(writer,seq,passwd,title)
VALUES               ('�̻���', (SELECT NVL(MAX(seq),0)+1 FROM tbl_board), '1234', 'test-6');
COMMIT;

-- content NULL �ΰ�� "�������" UPDATE
UPDATE tbl_board
SET content = '�������'
WHERE content IS NULL;

SELECT *
FROM tbl_board;

-- �Խ����� �ۼ���(WRITER NOT NULL VARCHAR2(20 -> 40) SIZE Ȯ��)
-- �÷��� �ڷ����� ũ�⸦ ����...
DESC tbl_board;

-- ���������� ������ �� ����. (���� -> ���� �߰�)
-- NOT NULL ���������� �� ����
ALTER TABLE tbl_board
MODIFY (writer VARCHAR2(40));

-- �÷����� ���� (title -> subject) ����
-- Į���̸��� �������� ������ �Ұ���
--ALTER TABLE ���̺�� MODIFY(): X
SELECT title AS subject, content
FROM tbl_board;

ALTER TABLE tbl_board
RENAME COLUMN title TO SUBJECT;

-- ��Ÿ ���� ���� ���� bigo(���) �÷� ���� �߰� -> Į�� ����
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100);

DESC tbl_board;

SELECT *
FROM tbl_board;

ALTER TABLE tbl_board
DROP COLUMN bigo;

-- [���̺��� �̸��� tbl_board -> tbl_test�� ����]
RENAME tbl_board TO chi_test;

SELECT *
FROM tabs;

-- ���̺� �����ϴ� ��� : 6����
-- �� �� ���������� �̿��� ���̺� ����
-- �̹� �����ϴ� ���̺� �̿� -> ���ο� ���̺� ���� + ������(���ڵ�) �߰�

-- ��) emp ���̺��� �̿��ؼ� 30�� �μ������� empno, ename, hiredate, job, ���ο����̺� ����
CREATE TABLE tbl_emp30(no, name, hdate, job, pay)
AS 
(
    SELECT empno, ename, hiredate, job, sal+NVL(comm,0) pay
    FROM emp
    WHERE deptno  = 30
);

DESC tbl_emp30;
SELECT *
FROM tbl_emp30;

-- ���������� ������� �ʴ´�.
-- ��. emp ���̺� �������� Ȯ��
-- ��. tbl_emp30���̺� �������� Ȯ��

SELECT *
FROM tbl_emp30;
-- ���������� ������� �ʴ´�.
-- ��. emp ���̺� ��������_Ȯ��
-- ��. tbl_emp30 ���̺� �������� Ȯ��
SELECT *
FROM user_constraints
WHERE table_name LIKE '%emp30';
----------------------------------------------

-- ��) ���� ���̺��� -> ���ο� ���̺� ���� + ���ڵ� X (���� ���̺��� ������ ����)
CREATE TABLE tbl_emp20 -- (�÷�...)
AS
(
    SELECT *
    FROM emp
    WHERE 1 = 0 -- ������ �׻� ���� --
);

SELECT *
FROM tbl_emp20;
--
DROP TABLE tbl_emp20;

-- [����] emp, dept, salgrade ���̺��� �̿��ؼ�
-- deptno, dname, empno, ename, hiredate, pay, grade �÷���
-- ���� ���ο� ���̺� ����. (tbl_empgrade)
-- (���� ���)

SELECT *
FROM salgrade;

CREATE TABLE tbl_empgrade
AS
(
SELECT d.deptno, d.dname, e.empno, e.ename
, e.hiredate, sal+NVL(comm,0) pay
, s.losal || ' - ' || s.hisal sal_range, grade
FROM dept d JOIN emp e ON d.deptno = e.deptno
            JOIN salgrade s ON sal BETWEEN losal AND hisal
);

SELECT d.deptno, d.dname, e.empno, e.ename
, e.hiredate, sal+NVL(comm,0) pay
, s.losal || ' - ' || s.hisal sal_range, grade
FROM dept d, emp e, salgrade s
WHERE d.deptno = e.deptno AND e.sal BETWEEN s.losal AND hisal;

DROP TABLE tbl_empgrade; -- ������ �̵�
PURGE RECYCLEBIN; -- ������ ����

-- ���̺� ���� + ���� ����(������ ����)
DROP TABLE tbl_empgrade PURGE; -- ���� ���̺� ����

-- INSERT ��
--DML - insert, update, delete
--INSERT INTO ���̺�� [( �÷���, �÷���, ... )] VALUES (�÷���, �÷���...);
--COMMIT;
--ROLLBACK;

-- [MultiTable INSERT��] 4���� ����
CREATE TABLE tbl_dept10 AS ( SELECT * FROM dept WHERE 1=0);
CREATE TABLE tbl_dept20 AS ( SELECT * FROM dept WHERE 1=0);
CREATE TABLE tbl_dept30 AS ( SELECT * FROM dept WHERE 1=0);
CREATE TABLE tbl_dept40 AS ( SELECT * FROM dept WHERE 1=0);
--1) unconditional insert all ������ ���� INSERT ALL   
INSERT ALL
    INTO tbl_dept10 VALUES(deptno, dname, loc)
    INTO tbl_dept20 VALUES(deptno, dname, loc)
    INTO tbl_dept30 VALUES(deptno, dname, loc)
    INTO tbl_dept40 VALUES(deptno, dname, loc)
SELECT deptno, dname, loc
FROM dept;

DROP TABLE tbl_dept40;

SELECT *
FROM tbl_dept40;

--2) conditional insert all   ������ �ִ� INSERT ALL
-- emp -> tbl_emp10, tbl_emp20, tbl_emp30, tbl_emp40
CREATE TABLE tbl_emp10
AS (SELECT * FROM emp WHERE 1 = 0);

CREATE TABLE tbl_emp20
AS (SELECT * FROM emp WHERE 1 = 0);

CREATE TABLE tbl_emp30
AS (SELECT * FROM emp WHERE 1 = 0);

CREATE TABLE tbl_emp40
AS (SELECT * FROM emp WHERE 1 = 0);

INSERT ALL
WHEN deptno = 10 THEN
    INTO tbl_emp10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
WHEN deptno = 20 THEN
    INTO tbl_emp20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
WHEN deptno = 30 THEN
    INTO tbl_emp30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
WHEN deptno = 40 THEN
    INTO tbl_emp40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * FROM emp;

SELECT * FROM tbl_emp40;

--3) conditional(������ �ִ�) first insert
--INSERT FIRST
--    WHEN deptno = 10 THEN
--        INTO tbl_emp10 VALUES()
--    WHEN job = "CLERK" THEN
--        INTO tbl_emp_clerk VALUES()
--SELECT * FROM emp;

--4) pivoting insert          
CREATE TABLE sales( -- �Ǹ� ���̺�
    employee_id       number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2)
);

insert into sales values(1101,4,100,150,80,60,120);
insert into sales values(1102,5,300,300,230,120,150);

COMMIT;

SELECT * FROM sales;

create table sales_data(
  employee_id        number(6),
  week_id            number(2),
  sales              number(8,2)
);

-- Table SALES_DATA��(��) �����Ǿ����ϴ�.
INSERT ALL
    INTO sales_data VALUES(employee_id, week_id, sales_mon)
    INTO sales_data VALUES(employee_id, week_id, sales_tue)
    INTO sales_data VALUES(employee_id, week_id, sales_wed)
    INTO sales_data VALUES(employee_id, week_id, sales_thu)
    INTO sales_data VALUES(employee_id, week_id, sales_fri)
SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri          
FROM sales;

SELECT *
FROM sales_data;
COMMIT;

DROP TABLE tbl_emp40;

-- TRUNCATE ��
DROP TABLE sales; -- ���̺� ��ü�� ����
DELETE FROM sales_data; -- ���̺� �� ��� ���ڵ� ����
SELECT * FROM sales_data;
ROLLBACK;
--
TRUNCATE TABLE sales_data; -- ���̺� ���� ��� ���ڵ� ���� + �ڵ� Ŀ��(���� �Ϸ�)
DROP TABLE sales_data PURGE;

--[����1] insa ���̺��� num, name �÷����� �����ؼ� 
--      ���ο� tbl_score ���̺� ����
--      (  num <= 1005 )
CREATE TABLE tbl_score
AS(
    SELECT num, name
    FROM insa
    WHERE num <= 1005
);
SELECT * FROM tbl_score;

--[����2] tbl_score ���̺�   kor,eng,mat,tot,avg,grade, rank �÷� �߰�
--( ����   ��,��,��,������ �⺻�� 0 )
--(       grade ���  char(1 char) )
--ALTER TABLE tbl_board
--ADD readed NUMBER DEFAULT 0;
ALTER TABLE tbl_score
ADD(
    kor NUMBER DEFAULT 0,
    eng NUMBER DEFAULT 0,
    mat NUMBER DEFAULT 0,
    tot NUMBER DEFAULT 0,
    avg NUMBER,
    grade char(1 char),
    rank NUMBER DEFAULT 1
);
--[����3] 1001~1005 
--  5�� �л��� kor,eng,mat������ ������ ������ ����(UPDATE)�ϴ� ���� �ۼ�.
UPDATE tbl_score
SET kor = TRUNC(SYS.dbms_random.value(0,101)),
    eng = TRUNC(SYS.dbms_random.value(0,101)),
    mat = TRUNC(SYS.dbms_random.value(0,101));
  
--[����4] 1005 �л��� k,e,m  -> 1001 �л��� ������ ���� (UPDATE) �ϴ� ���� �ۼ�.
UPDATE tbl_score
SET (kor,eng,mat) = (SELECT kor, eng, mat 
                     FROM tbl_score
                     WHERE num = 1001)
WHERE num = 1005;
COMMIT;
--[����5] ��� �л��� ����, ����� ����...
--     ( ���� : ����� �Ҽ��� 2�ڸ� )
UPDATE tbl_score
SET tot = kor+eng+mat,
     avg = ROUND((kor+eng+mat)/3,2);
COMMIT;

--[����6] ���(grade) CHAR(1 char)  'A','B','c', 'D', 'F'
--  90 �̻� A
--  80 �̻� B
--  0~59   F  

UPDATE tbl_score
SET grade = CASE
                WHEN avg >= 90 THEN 'A'
                WHEN avg >= 80 THEN 'B'
                WHEN avg >= 70 THEN 'C'
                WHEN avg >= 60 THEN 'D'
                ELSE 'F'
            END;
COMMIT;
SELECT * FROM tbl_score;
--[����7] tbl_score ���̺��� ��� ó��.. ( UPDATE) 
--UPDATE tbl_score p
--SET rank = (SELECT COUNT(*)+1 
--            FROM tbl_score c
--            WHERE c.tot > p.tot); 
UPDATE tbl_score p
SET rank = (    
                SELECT t.r
                FROM (
                    SELECT num, tot, RANK() OVER(ORDER BY tot DESC) r
                    FROM tbl_score
                )t
                WHERE t.num = p.num
            );
COMMIT;

SELECT empno, ename, sal
,ROW_NUMBER() OVER(ORDER BY sal DESC) rn_rank
,RANK() OVER(ORDER BY sal DESC) r_rank
,DENSE_RANK() OVER(ORDER BY sal DESC) dr_rank
FROM emp;

SELECT * 
FROM tbl_score;

-- [����8] ��� �л����� ���� ���� : 30�� �߰�
UPDATE tbl_score
SET eng = CASE
            WHEN eng+30 > 100 THEN 100
            ELSE eng+30
          END;
COMMIT;
SELECT *
FROM tbl_score;

-- [����] 1001 ~ 1005 �л� �߿� ���л��鸸 5���� ����...

UPDATE tbl_score t
SET kor = kor + 5
WHERE t.num = (
            SELECT num
            FROM insa
            WHERE MOD(SUBSTR(ssn,8,1),2) =1 AND t.num = num
            );

UPDATE tbl_score 
SET kor = kor + 5
WHERE num = ANY (SELECT num 
                FROM insa
                WHERE num <= 1005 AND MOD(SUBSTR(MOD(ssn,8,1),2)) = 1);

SELECT *
FROM insa;




