-- SCOTT
CREATE TABLE tbl_emp(
id NUMBER PRIMARY KEY, 
name VARCHAR2(10) NOT NULL,
salary  NUMBER,
bonus NUMBER DEFAULT 100);

INSERT INTO tbl_emp(id,name,salary) VALUES(1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) VALUES(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) VALUES(1003,'kim',140);
COMMIT;

SELECT * FROM tbl_emp;

CREATE TABLE tbl_bonus
(
    id NUMBER
    , bonus NUMBER DEFAULT 100
);

insert into tbl_bonus(id) (select e.id from tbl_emp e);

SELECT * FROM tbl_bonus;

INSERT INTO tbl_bonus VALUES(1004, 50);
COMMIT;

-- ���� 1)
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN 
    UPDATE SET b.bonus = b.bonus + e.salary * 0.01
WHEN NOT MATCHED THEN 
    INSERT (b.id, b.bonus) VALUES(e.id, e.salary*0.01);

SELECT * FROM tbl_bonus;

-- ���� 2)
CREATE TABLE tbl_merge1
(
    id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
    , pay NUMBER
    , sudang NUMBER
);

CREATE TABLE tbl_merge2
(
    id NUMBER PRIMARY KEY 
    ,sudang NUMBER
);


INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (1, 'a', 100, 10);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (2, 'b', 150, 20);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (3, 'c', 130, 0);

INSERT INTO tbl_merge2 (id, sudang) VALUES(2, 5);
INSERT INTO tbl_merge2 (id, sudang) VALUES(3, 10);
INSERT INTO tbl_merge2 (id, sudang) VALUES(4, 20);

SELECT * FROM tbl_merge1;
SELECT * FROM tbl_merge2;

-- ���� : tbl_merge1(�ҽ�) -> tbl_merge2(Ÿ��) ����
--          1                     INSERT
--          2                     UPDATE

MERGE INTO tbl_merge2 m2
USING(SELECT id, sudang FROM tbl_merge1) m1
ON (m2.id = m1.id)
WHEN MATCHED THEN
    UPDATE SET m2.sudang = m2.sudang + m1.sudang
WHEN NOT MATCHED THEN
    INSERT (m2.id, m2.sudang) VALUES (m1.id, m1.sudang); 

COMMIT;
SELECT * FROM tbl_merge1;
SELECT * FROM tbl_merge2;

DROP TABLE tbl_merge1 PURGE;
DROP TABLE tbl_merge2 PURGE;

DROP TABLE tbl_emp PURGE;
DROP TABLE tbl_bonus PURGE;

-- [��������(Constraint)]
-- scott�� �����ϰ� �ִ� ���̺� ��ȸ
SELECT * 
FROM user_tables;

-- SCOTT�� �����ϰ� �ִ� �������� ��ȸ
SELECT * 
FROM user_constraints;

-- SCOTT�� �����ϰ� �ִ� emp ���̺� ������ �������� ��ȸ
SELECT * 
FROM user_constraints
WHERE table_name = UPPER('emp');

-- ��ü ���Ἲ(Entity Intergrity)
-- ��ü ���Ἲ�� ����, �� ������ �⺻ Ű���� ����(�ߺ�)��
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
-- ���������� ���̺� I/U/D �ҋ��� ��Ģ���� ���
--            data integrity(������ ���Ἲ)�� ����
INSERT INTO dept VALUES(10, 'QC', 'SEOUL'); -- ��ü ���Ἲ(Entity Integrity)�� ����

-- ���� ���Ἲ(Relational Integrity)
UPDATE emp
SET deptno = 90
WHERE empno = 7369;

-- ������ ���Ἲ
DESC emp;

INSERT INTO emp(empno) VALUES(9999);
--ORA-01400: cannot insert NULL into ("SCOTT"."EMP"."EMPNO")
INSERT INTO emp(ename) VALUES('admin');
SELECT * FROM emp;
ROLLBACK;

-- ���������� �����ϴ� �ñ⿡ ���� 
-- ��. CREATE TABLE �� : ���̺� ���� + �������� �߰�/����
--      1) IN-LINE ��������     (== �÷� ����)   �������� ���
--           �� NOT NULL �������� ����
--      2) OUT-OF-LINE �������� (== ���̺� ����) �������� ���
--           �� �� �� �̻��� �÷��� �ϳ��� ���������� ������ ��
    
--    [��� �޿� ���� ���̺�]
--    �޿����ݳ�¥ + ȸ��ID => PK(����Ű)
--    (������ȭ)
--    ����(PK) �޿����޳�¥ ȸ��ID �޿��� ...
--    1 20240125    7369  3000000
--    2 20240125    7666  3000000
--    3 20240125    8223  2000000
--    : 
--    15 20240225    7369  3000000
--    16 20240225    7666  3000000
--    17 20240225    8223  2000000
    
--    U/D
--    WHERE ���� �޿����޳�¥ = '20240125 AND ȸ��ID = 8223
--    => WHERE ���� = 3;
          
-- ��. ALTER TABLE �� : ���̺� ���� + �������� �߰�/����

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = NULL
WHERE empno = 7839;
COMMIT;

-- �ǽ�) CREATE TABLE ������ COLUMN LEVEL ������� �������� �����ϴ� ��
DROP TABLE tbl_constraint1;
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY -- SYS_XXXXXX
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL 
    -- dept ���̺��� deptno(PK) =========> deptno �÷����� ����
    -- �ܷ�Ű, ����Ű
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT UK_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)
    , city VARCHAR2(20) CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('����', '�뱸', '����'))
);

SELECT *
FROM user_constraints
WHERE table_name LIKE '%CONSTRAIN%';

-- �������� ��Ȱ��ȭ/Ȱ��ȭ
-- city ���� �뱸 ����  üũ��������
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY;  --��Ȱ��ȭ
--ENABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY; --Ȱ��ȭ

-- �������� ���� --
--1) PK �������� ����
ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;

ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_TBLCONSTRAINT1_EMPNO;
--CASCADE �ɼ� �߰� : FOREIGN KEY 

--2) CH
ALTER TABLE tbl_constraint1
DROP CONSTRAINT CK_TBLCONSTRAINT1_CITY;

--3) UK
ALTER TABLE tbl_constraint1
DROP CONSTRAINT UK_TBLCONSTRAINT1_EMAIL;

ALTER TABLE tbl_constraint1
DROP UNIQUE(email);


-- �ǽ�2) CREATE TABLE ������ TABLE LEVEL ������� �������� �����ϴ� ��
CREATE TABLE tbl_constraint2
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY -- SYS_XXXXXX
    empno NUMBER(4) NOT NULL  -- NOT NULL�� �÷��������θ� �߰�
    , ename VARCHAR2(20) NOT NULL 
    -- dept ���̺��� deptno(PK) =========> deptno �÷����� ����
    -- �ܷ�Ű, ����Ű
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city VARCHAR2(20) 
    
--  , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno, ename) --> ����Ű�� ���̺������θ� �߰�
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno)
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    , CONSTRAINT CK_tblconstraint2_kor CHECK(kor BETWEEN 0 AND 100)
    , CONSTRAINT CK_tblconstraint2_city CHECK(city IN ('����', '�뱸', '����'))
);

SELECT *
FROM user_constraints
WHERE table_name LIKE '%INT2';

DROP TABLE tbl_constraint1 PURGE;

-- �ǽ�3) ALTER TABLE ������ �������� �����ϴ� ��
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);

--ALTER TABLE ���̺��
--ADD [CONSTRAINT �������Ǹ�] ��������Ÿ�� (�÷���);

--1) empno �÷��� PK �������� �߰�...
ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY (empno);

--2) deptno �÷��� FK �������� �߰�...
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;

DELETE FROM dept
WHERE deptno = 10;

DESC dept;

--CREATE TABLE emp
--(
--    deptno NUMBER(2) C ���� [F K(deptno)] R d(deptno) ON DELETE CASCADE
--    deptno NUMBER(2) C ���� [F K(deptno)] R d(deptno) ON DELETE SET NULL -> NULL�� �ٰ���
--);

--> ON DELETE CASCADE / ON DELETE SET NULL �ǽ�
--1)emp -> tbl_emp ����
-- 2) dept -> tbl_dept ����

CREATE TABLE tbl_emp
AS
(
    SELECT *
    FROM emp
);

CREATE TABLE tbl_dept
AS
(
    SELECT *
    FROM dept
);

ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tblconstraint_deptno PRIMARY KEY(deptno);

ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblconstraint_empno PRIMARY KEY(empno);

-- ����) tbl_emp ���̺� deptno �÷��� PK ���� + ON DELETE CASCADE �ɼ��� �߰�
ALTER TABLE tbl_emp
ADD CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE CASCADE;

-- ����) tbl_emp ���̺� deptno �÷��� PK ���� + ON DELETE CASCADE �ɼ��� �߰�
ALTER TABLE tbl_emp
ADD CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE SET NULL;

SELECT *
FROM tbl_dept;

SELECT *
FROM tbl_emp;

DELETE FROM dept
WHERE deptno = 30;

DELETE FROM tbl_dept
WHERE deptno = 30;

DROP TABLE tbl_dept;


CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

-- �ܰ����̺�( å�� ���� )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (�ĺ����� ***)
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
                                REFERENCES book(b_id)
                                ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- å�� ���� �������̺�
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;

 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

--
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   

-- 1) EQUI JOIN
-- [����] åID, å����, ���ǻ�(C_name), �ܰ� �÷� ���
-- book : [b_id(PK), title, c_name]
-- danga : b_id(PK,FK), [price]
--    ��. ����Ŭ���� natural join �̶�� �θ���
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- ��������

-- ��. 
    SELECT b.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id; -- ��������

-- ��.
    SELECT b.b_id, title, c_name, price
    FROM book b JOIN danga d ON b.b_id = d.b_id; -- ��������

-- ��. USING�� ��� : book.b_id(��ü��.�÷���)X, b.b_id(��Ī��.�÷���) X
    SELECT b_id, title, c_name, price
    FROM book JOIN danga USING(b_id); -- ��������
    
-- ��. 
    SELECT b_id, title, c_name, price
    FROM book NATURAL JOIN danga; -- ��������
    
-- [����] åID, å����, �Ǹż���, �ܰ�, ������, �Ǹűݾ� ���
-- ��. ���� ��,�� �������Ǯ��
SELECT b.b_id, b.title, d.price, g.g_name
, d.price * p.p_su "�Ǹűݾ�"
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id;


-- ��. JOIN-ON ���� Ǯ��
SELECT b.b_id, b.title, d.price, g.g_name
,d.price * p.p_su "�Ǹűݾ�"
FROM book b JOIN danga d ON b.b_id = d.b_id
JOIN panmai p ON b.b_id = p.b_id
JOIN gogaek g ON p.g_id = g.g_id;

-- ��. USING�� ����ؼ� Ǯ��
SELECT b_id, title, price, g_name
, price * p_su "�Ǹűݾ�"
FROM book JOIN danga USING(b_id) 
JOIN panmai USING(b_id)
JOIN gogaek USING(g_id);

-- NON-EQUI JOIN
-- ������ ���� X
-- BETWEEN ~ AND ������ ���
SELECT ename, sal, grade, losal || ' - ' || hisal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;



SELECT *
FROM emp;
SELECT *
FROM dept;

-- emp / dept JOIN
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno; -- EQUI JOIN
--      NULL        10/20/30/40
-- 11�� KING ��� X 

-- OUTER JOIN
--��. LEFT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno;

SELECT d.deptno, ename, hiredate
FROM dept d, emp e
WHERE d.deptno = e.deptno(+);

--��. RIGHT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d RIGHT OUTER JOIN emp e ON d.deptno = e.deptno;

SELECT d.deptno, ename, hiredate
FROM dept d, emp e
WHERE d.deptno(+) = e.deptno;

--��. FULL OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d FULL OUTER JOIN emp e ON d.deptno = e.deptno;

SELECT d.deptno, ename, hiredate
FROM dept d, emp e
WHERE d.deptno = e.deptno;

-- SELF JOIN
-- �����ȣ, �����, �Ի�����, ���ӻ�� �����ȣ, ���ۻ���� �����
SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename "���ӻ��"
FROM emp a, emp b
WHERE a.mgr = b.empno;

SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename "���ӻ��"
FROM emp a JOIN emp b ON a.mgr = b.empno;

-- CROSS JOIN : ��ī��Ʈ ��
SELECT e.*, d.*
FROM emp e, dept d;

SELECT e.*, d.*
FROM emp e CROSS JOIN dept d;

-- ����) åID, å����, �Ǹż���, �ܰ�, ������(��), �Ǹűݾ�(�Ǹż���*�ܰ�) ��� 
SELECT b.b_id, b.title, p.p_su, d.price, g.g_name
, d.price * p.p_su "�Ǹűݾ�"
FROM book b, panmai p, danga d, gogaek g
WHERE b.b_id = p.b_id AND b.b_id = d.b_id AND p.g_id = g.g_id;

-- ����) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID, å����, ���ǸűǼ�, �ܰ� �÷� ���   )
SELECT b.b_id, b.title
,SUM(p.p_su) ���ǸűǼ�, d.price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, price;


-- ����) �ǸűǼ��� ���� ���� å ���� ��ȸ 
SELECT b_id, title, price
FROM (
    SELECT b.b_id, b.title
    ,SUM(p.p_su) total_panmai_su, d.price
    FROM book b JOIN danga d ON b.b_id = d.b_id
    JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id, b.title, price
) 
WHERE total_panmai_su = (SELECT MAX(SUM(p_su)) FROM panmai
                        GROUP BY b_id);



-- ����) ���� �ǸűǼ��� ���� ���� å(������ ��������)
--      (  åID, å����, ���� )
SELECT b_id, title, p_su
FROM(
    SELECT p.b_id, title, p_su
    ,RANK() OVER(ORDER BY p_su DESC) rank
    FROM panmai p JOIN book b ON p.b_id = b.b_id
    WHERE TO_CHAR(p_date,'YYYY') = 2024
    )
WHERE rank = 1;

-- 1) TOP-N �м� ���
;
SELECT t.*
FROM ( 
        SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id 
        GROUP BY b.b_id, title, price
        ORDER BY ���ǸűǼ� DESC
) t
--WHERE ROWNUM BETWEEN 3 AND 5; -- ����
--WHERE ROWNUM <= 3;
WHERE ROWNUM = 1;

-- 2) RANK ���� �Լ� ..

WITH t AS (
    SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
       , RANK() OVER( ORDER BY SUM( p_su  ) DESC ) �Ǹż���
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id 
    GROUP BY b.b_id, title, price
)
SELECT *
FROM t
--WHErE �Ǹż��� BETWEEN 3 AND 5;
--WHErE �Ǹż��� <= 3;
WHErE �Ǹż��� = 1;

-- ����) book ���̺��� �ǸŰ� �� ���� ���� å�� ���� ��ȸ
SELECT b.b_id, title, NVL(p_su,0) �Ǹż���
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
WHERE p_su IS NULL;



-- ����) book ���̺��� �ǸŰ� �� ���� �ִ� å�� ���� ��ȸ
--      ( b_id, title, price  �÷� ��� )
-- [1]
SELECT b.b_id, title, price
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NOT NULL;

-- [2]
SELECT DISTINCT b.b_id, title, price
FROM book b, panmai p, danga d
WHERE b.b_id = p.b_id AND d.b_id = b.b_id; 

-- ����) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)
SELECT g.g_id, g_name, SUM(price)
FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY g_name, g.g_id;

-- ����) �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
SELECT year, month, SUM(p_su) �Ǹ���Ȳ
FROM(
    SELECT b.b_id, title, p_su
    ,TO_CHAR(p_date, 'YYYY') year
    ,TO_CHAR(p_date, 'MM') month
    FROM book b JOIN panmai p ON b.b_id = p.b_id
    )
GROUP BY year, month;

-- ����) ������ �⵵�� �Ǹ���Ȳ ���ϱ�
SELECT g_name, year, SUM(p_su) �Ǹ���Ȳ
FROM(
    SELECT b.b_id, title, p_su, g_name
    ,TO_CHAR(p_date, 'YYYY') year
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN gogaek g ON p.g_id = g.g_id
    )
GROUP BY g_name, year;


-- ����) å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )

SELECT *
FROM(
    SELECT b.b_id, title, price, sum(p_su) ���ǸűǼ�
    ,price * sum(p_su) ���Ǹűݾ�
    FROM book b, danga d, panmai p
    WHERE b.b_id = d.b_id AND b.b_id = p.b_id
    GROUP BY b.b_id, title, price
    )
WHERE ���Ǹűݾ� >= 15000;


----------------------------------------------------------------------------
-- Ǯ�� [2]
--����) åID, å����, �Ǹż���, �ܰ�, ������(��), �Ǹűݾ�(�Ǹż���*�ܰ�) ��� 
-- book   : b_id, title
-- panmai : p_su
-- danga  : price
-- gogaek : g_name
 
 
-- ����) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID, å����, ���ǸűǼ�, �ܰ� �÷� ���   )
-- book   : b_id, title
-- danga  : price
-- panmai : p_su
 
 SELECT b.b_id, title , price, SUM( p_su )  ���ǸűǼ�
 FROM  book b JOIN  panmai p ON b.b_id = p.b_id
              JOIN danga d ON  b.b_id = d.b_id
 GROUP BY   b.b_id, title , price
 ORDER BY  b.b_id;
 
 --
SELECT DISTINCT b.b_id åID, title ����, price �ܰ� 
   --, p_su �Ǹż���
, (SELECT SUM(p_su) FROM panmai WHERE b_id = b.b_id) ���ǸűǼ�
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id;
      
-- ����) �ǸűǼ��� ���� ���� å ���� ��ȸ 
 
WITH t
AS 
  (
  SELECT b.b_id, title , price, SUM( p_su )  ���ǸűǼ�
 FROM  book b JOIN  panmai p ON b.b_id = p.b_id
              JOIN danga d ON  b.b_id = d.b_id
 GROUP BY   b.b_id, title , price
 ORDER BY  b.b_id
 ), 
 s AS (
 SELECT t.*
   , RANK() OVER( ORDER BY  ���ǸűǼ� DESC ) �Ǹż���
 FROM t
 )
 SELECT s.*
 FROM s
 WHERE �Ǹż��� = 1;
 
 --
 -- 1) TOP-N �м� ���
;
SELECT t.*
FROM ( 
        SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id 
        GROUP BY b.b_id, title, price
        ORDER BY ���ǸűǼ� DESC
) t
WHERE ROWNUM BETWEEN 3 AND 5; -- ����
WHERE ROWNUM <= 3;
WHERE ROWNUM = 1;

-- 2) RANK ���� �Լ� ..

WITH t AS (
    SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
       , RANK() OVER( ORDER BY SUM( p_su  ) DESC ) �Ǹż���
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id 
    GROUP BY b.b_id, title, price
)
SELECT *
FROM t
WHErE �Ǹż��� BETWEEN 3 AND 5;
WHErE �Ǹż��� <= 3;
WHErE �Ǹż��� = 1;
 
-- ����) ���� �ǸűǼ��� ���� ���� å(������ ��������)
--      (  åID, å����, ���� )

SELECT ROWNUM ����, t.*
FROM ( 
    SELECT  p.b_id, title , SUM( p_su  ) �Ǹż���
    FROM panmai p, book b
    WHERE TO_CHAR(p_date, 'YYYY') = 2024 AND b.b_id = p.b_id
    GROUP BY p.b_id, title
    ORDER BY �Ǹż��� DeSC
 ) t 

-- ����) book ���̺��� �ǸŰ� �� ���� ���� å�� ���� ��ȸ
 -- å ���� : 9���� ����
 -- (ANTI JOIN : NOT IN ����)
 SELECT b.b_id, title, price
 FROM book b JOIN danga d ON b.b_id = d.b_id
 WHERE b.b_id NOT IN ( SELECT DISTINCT b_id    
 FROM panmai );
 
 -- MINUS  ������ SET(����)������...
 
-- ����) book ���̺��� �ǸŰ� �� ���� �ִ� å�� ���� ��ȸ
--      ( b_id, title, price  �÷� ��� )
  SELECT DISTINCT b.b_id,title, price
  FROM book b , panmai p, danga d
  WHERE b.b_id = p.b_id AND b.b_id = d.b_id;
  
  -- EXISTS -- SEMI JOIN  
  SELECT b.b_id, title, price
 FROM book b JOIN danga d ON b.b_id = d.b_id
 WHERE b.b_id  IN ( SELECT DISTINCT b_id    
 FROM panmai );
      
-- ����) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)
 SELECT g.g_id, g_name,  SUM(p_su) 
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY g.g_id, g_name ;
 
-- ����) �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
 SELECT  TO_CHAR( p_date, 'YYYY') p_year, TO_CHAR( p_date, 'MM' ) p_month,   SUM(p_su)
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY  TO_CHAR( p_date, 'YYYY') , TO_CHAR( p_date, 'MM')
 ORDER BY p_year, p_month;
 
-- ����) ������ �⵵�� �Ǹ���Ȳ ���ϱ�
-- panmai : p_date, p_su
-- gogaek : g_id, g_name
 
 SELECT p_date
 FROM panmai;
 
 SELECT g_name , TO_CHAR( p_date, 'YYYY') p_year,  SUM(p_su)
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY g_name , TO_CHAR( p_date, 'YYYY') 
 ORDER BY g_name, p_year;
 
-- ����) å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )
     
     SELECT b.b_id, title, price, SUM( p_su  ) ���ǸűǼ�
           , SUM ( p_su) * price ���Ǹűݾ�
     FROM book b JOIN danga d ON b.b_id = d.b_id 
                JOIN panmai p ON b.b_id = p.b_id
     GROUP BY   b.b_id, title, price
     HAVING SUM ( p_su) * price >= 15000
     ORDER BY   b.b_id;


