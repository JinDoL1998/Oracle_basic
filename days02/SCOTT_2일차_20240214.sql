-- SCOTT
SELECT *
FROM user_tables;
FROM tabs;

SELECT * 
FROM dba_users;

-- SCHEMA?
-- SESSION ?
-- TABLESPACE ?

-- SQL -- DQL : SELECT ��
-- �ϳ� �̻��� ���̺�, ��� ���� �����͸� ������ �� ����ϴ� ��
�����ġ�
    [subquery_factoring_clause] subquery [for_update_clause];

��subquery ���ġ�
   {query_block ?
    subquery {UNION [ALL] ? INTERSECT ? MINUS }... ? (subquery)} 
   [order_by_clause] 

��query_block ���ġ�
   SELECT [hint] [DISTINCT ? UNIQUE ? ALL] select_list
   FROM {table_reference ? join_clause ? (join_clause)},...
     [where_clause] 
     [hierarchical_query_clause] 
     [group_by_clause]
     [HAVING condition]
     [model_clause]

��subquery factoring_clause���ġ�
   WITH {query AS (subquery),...}

-- (����)
-- SELECT���� ��� ���� ������. (�ϱ�) + ó������ �ݵ�� �ϱ�
(1) WITH ��
  (6) SELECT ��
(2) FROM ��
(3) WHERE ��
(4) GROUP BY ��
(5) HAVING ��
  (7) ORDER BY ��

--
FROM ��ȸ�Ҵ�� == ���̺�(table), ��(view)
--
SELECT *
FROM tabs; -- ��
FROM emp;  -- ���̺�

-- emp ���̺� � �÷����� �̷���� �ִ� �� Ȯ�� ? 
--         ( ���̺� ���� Ȯ�� )

DESCRIBE scott.emp;
DESCRIBE emp;
DESC emp;
�̸�       ��?       ����           
-------- -------- ------------ 
EMPNO �����ȣ    NOT NULL NUMBER(4) �� ���x == �ʼ��Է»��� NUMBER(4) 4�ڸ� ����
ENAME �����             VARCHAR2(10) ���ڿ�(10����Ʈ)
JOB ��               VARCHAR2(9)  ���ڿ�(9����Ʈ)
MGR ���ӻ�� ��ȭ��ȣ               NUMBER(4) 4�ڸ� ����
HIREDATE �Ի�����          DATE ��¥        
SAL �⺻��               NUMBER(7,2)  �Ҽ��� 2�ڸ� �Ǽ�
COMM Ŀ�̼�              NUMBER(7,2)  �Ҽ��� 2�ڸ� �Ǽ�
DEPTNO �μ���ȣ            NUMBER(2)   2�ڸ� ����

-- scott�� �����ϴ� ���̺� Ȯ��
SELECT *
FROM tabs;

-- SELECT�� Ű���� : DISTINCT, ALL, AS ��밡��
SELECT * -- * : ��� Į���� ��ȸ
SELECT emp.*
FROM emp;

-- emp ���̺��� �����ȣ, �����, �Ի����ڸ� ��ȸ
SELECT empno, ename, hiredate
FROM emp;

-- emp ���̺��� job Į���� ��ȸ
SELECT ALL job -- ALL ����� Į���� �ߺ��� �Ǵ��� ��� ��� : �⺻��
FROM emp;

-- DISTINCT : ����� Į���� �ߺ��� �� �� �ѹ��� ���(�ϱ�)
SELECT DISTINCT job
FROM emp;

-- SELECT ALL empno, ename, hiredate
SELECT DISTINCT empno, ename, hiredate
FROM emp;

CREATE VIEW view_emp AS SELECT FROM emp ;
select '�̸���'''|| ename || '''�̰�, ������ ' || job || ' �̴�.' AS "��������"
from emp;











