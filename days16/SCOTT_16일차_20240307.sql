-- scott
-- ��Ű��
-- �� ���� ���Ǵ� ���� PROCEDURE, FUNCTION ���� �ϳ��� PACKAGE ��� ������ �����
-- DBMS ���
DBMS_OUTPUT.PUT();
DBMS_OUTPUT.PUT_LINE();


-- ��Ű���� ���� �κ�
CREATE OR REPLACE PACKAGE employee_pkg 
AS 
     PROCEDURE up_printename
     (
       p_empno NUMBER
      ); 
     PROCEDURE up_printsal(p_empno NUMBER); 
     FUNCTION uf_age
     (
       prrn IN VARCHAR2 
      ,ptype IN NUMBER 
     )
     RETURN NUMBER;
END employee_pkg;


-- Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
      procedure UP_PRINTENAME(p_empno number) is 
        l_ename emp.ename%type; 
      begin 
        select ename 
          into l_ename 
          from emp 
          where empno = p_empno; 
       dbms_output.put_line(l_ename); 
     exception 
       when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end UP_PRINTENAME; 
  
   procedure UP_PRINTSAL(p_empno number) is 
     l_sal emp.sal%type; 
   begin 
     select sal 
       into l_sal 
       from emp 
       where empno = p_empno; 
     dbms_output.put_line(l_sal); 
   exception 
     when NO_DATA_FOUND then 
       dbms_output.put_line('Invalid employee number'); 
   end UP_PRINTSAL; 
   
   FUNCTION uf_age
(
   prrn IN VARCHAR2 
  ,ptype IN NUMBER --  1(���� ����)  0(������)
)
RETURN NUMBER
IS
   �� NUMBER(4);  -- ���س⵵
   �� NUMBER(4);  -- ���ϳ⵵
   �� NUMBER(1);  -- ���� ���� ����    -1 , 0 , 1
   vcounting_age NUMBER(3); -- ���� ���� 
   vamerican_age NUMBER(3); -- �� ���� 
BEGIN
   -- ������ = ���س⵵ - ���ϳ⵵    ������������X  -1 ����.
   --       =  ���³��� -1  
   -- ���³��� = ���س⵵ - ���ϳ⵵ +1 ;
   �� := TO_CHAR(SYSDATE, 'YYYY');
   �� := CASE 
          WHEN SUBSTR(prrn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(prrn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(prrn,1,2);
   �� :=  SIGN(TO_DATE(SUBSTR(prrn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (����X)

   vcounting_age := �� - �� +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ��, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ��
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 

-- TODO.
 SELECT name, ssn
 , employee_pkg.uf_age(ssn,1) age
 FROM insa;
 
 --------------------------------------------------------------------------------
 -- ���� SQL ***
 
-- ���� �迭
int [] m;  -- �迭�� ũ�� X
int size = 10;
m = new int[size];

-- ���� SQL(����)
��) �Ϲ����� �Խ��ǿ��� �˻�
 1) �������� �˻� WHERE title LIKE '%�˻���%'
 2) �ۼ��ڷ� �˻� WHERE writer LIKE '%�˻���%'
 3) �������� �˻� WHERE content LIKE '%�˻���%'    
 4) ���� + �������� �˻� WHERE title LIKE '%�˻���%' OR content LIKE '%�˻���%'
 
-- ���� ������ SQL�� �� ���� ����
-- 1) ���� ����(SQL)�� ����ϴ� 3���� ���
--      ��. ������ �ÿ� SQL������ Ȯ������ ���� ���( ���� ���� ����ϴ� ��� )
--      ��) WHERE ������...
--      ��. PL/SQL ���ȿ��� DDL���� ����ϴ� ���
--      CREATE, ALTER, DROP
--      ��) ������ �÷����� �������� �Խ��� ���̺� ����.
--          �ʿ�� ���� �������� �Խ��� ���̺� ����
--      ��. PL/SQL ���ȿ���
--          ALTER SYSTEM/SESSIOn ��ɾ ����� ���
        
-- 2) PL/SQL ���� ������ ����ϴ� 2���� ���.
--      ��. DBMS_SQL ��Ű�� X
--      ��. EXECUTE IMMEDIATE ��
--        ����)
--          EXEC[UTE] IMMEDIATE ����������
--          [INTO ������, ������...]
--          [USING [IN/OUT/IN OUT] �Ķ����, �Ķ����...]

-- 3) ��
-- �͸� ���ν��� ����.
DECLARE
  vsql VARCHAR2(1000);
  
  vdeptno   emp.deptno%TYPE;
  vempno    emp.empno%TYPE;
  vename    emp.ename%TYPE;
  vjob      emp.job%TYPE;
BEGIN
   vsql := 'SELECT deptno, empno, ename, job ';
   vsql := vsql || 'FROM emp ';
   vsql := vsql || 'WHERE empno = 7369 ';
   
   EXECUTE IMMEDIATE vsql
           INTO vdeptno, vempno, vename, vjob;
   DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || 
          vempno || ', ' || vename || ', ' || vjob )     ;   
-- EXCEPTION
END;

-- ���� ���ν���
CREATE OR REPLACE PROCEDURE up_ndsemp
(
   pempno emp.empno%TYPE
)
IS
  vsql VARCHAR2(1000);
  
  vdeptno   emp.deptno%TYPE;
  vempno    emp.empno%TYPE;
  vename    emp.ename%TYPE;
  vjob      emp.job%TYPE;
BEGIN
   vsql := 'SELECT deptno, empno, ename, job ';
   vsql := vsql || 'FROM emp ';
   -- vsql := vsql || 'WHERE empno = pempno '; X
   vsql := vsql || 'WHERE empno = ' || pempno;  
   
   EXECUTE IMMEDIATE vsql
           INTO vdeptno, vempno, vename, vjob;
   DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || 
          vempno || ', ' || vename || ', ' || vjob )     ;   
-- EXCEPTION
END;

-- Procedure UP_NDSEMP��(��) �����ϵǾ����ϴ�.


-- ���� ���ν��� 2
CREATE OR REPLACE PROCEDURE up_ndsemp
(
   pempno emp.empno%TYPE
)
IS
  vsql VARCHAR2(1000);
  
  vdeptno   emp.deptno%TYPE;
  vempno    emp.empno%TYPE;
  vename    emp.ename%TYPE;
  vjob      emp.job%TYPE;
BEGIN
   vsql := 'SELECT deptno, empno, ename, job ';
   vsql := vsql || 'FROM emp ';
   -- vsql := vsql || 'WHERE empno = pempno '; X
   -- vsql := vsql || 'WHERE empno = ' || pempno;  
   vsql := vsql || 'WHERE empno = :pempno' ;  
   
   DBMS_OUTPUT.PUT_LINE(vsql);
   
   EXECUTE IMMEDIATE vsql
           INTO vdeptno, vempno, vename, vjob
           USING IN pempno;
   DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || 
          vempno || ', ' || vename || ', ' || vjob )     ;   
-- EXCEPTION
END;

EXEC UP_NDSEMP( 7369 );


-- ����2. dept ���̺� ���ο� �μ� �߰��ϴ� ���� ���ν���( ���� ���� ��� )
-- ����2. dept ���̺� ���ο� �μ� �߰��ϴ� ���� ���ν���( ���� ���� ��� )
SELECT * 
FROM dept;
--
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
   pdname dept.dname%TYPE := NULL
   , ploc dept.loc%TYPE := NULL
)
IS
   vsql VARCHAR2(1000);
   vdeptno dept.deptno%TYPE;
BEGIN
   SELECT MAX(deptno)+10 INTO vdeptno
   FROM dept;

   vsql := ' INSERT INTO dept ( deptno, dname, loc ) ';
   vsql := vsql || ' VALUES ( :vdeptno, :pdname, :ploc ) ';
   
   EXECUTE IMMEDIATE vsql
   -- INTO 
   USING vdeptno, pdname, ploc;
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('INSERT ����!!!');
END;

-- Procedure UP_NDSINSDEPT��(��) �����ϵǾ����ϴ�.
EXEC UP_NDSINSDEPT('QC', 'SEOUL');

DELETE FROM dept WHERE deptno = 50;
COMMIT;


-- ����SQL -- DDL�� ��� ����..
DECLARE
    vtablename VARCHAR2(100);
    vsql VARCHAR2(1000);
BEGIN
    vtablename := 'tbl_board';
    
    vsql := 'CREATE TABLE ' || vtablename;
    -- vsql := 'CREATE TABLE :vtablename';
    vsql := vsql || '( ';
    vsql := vsql || ' id NUMBER PRIMARY KEY ';
    vsql := vsql || ' ,name VARCHAR2(20) ';
    vsql := vsql || ') ';
    
    EXECUTE IMMEDIATE vsql;
    -- USING vtablename;
END;

SELECT *
FROM tabs;

-- OPEN - FOR�� : ���� ���� ���� -> ��������(�������� ���ڵ�) + Ŀ�� ó��..
CREATE OR REPLACE PROCEDURE up_ndsSelEmp
(
    pdeptno emp.deptno%TYPE
)
IS
    vsql VARCHAR2(2000);
    vcur SYS_REFCURSOR; -- Ŀ�� Ÿ������ ���� ���� 9i REF CURSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE deptno = :pdeptno ';
    
    -- EXECUTE IMMEDIATE stmt INTO X USING �Ķ����...
    -- OPEN - FOR ��
    OPEN vcur FOR vsql USING pdeptno;
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vrow.empno || ' ' || vrow.ename);
    END LOOP;
    CLOSE vcur;
END;
-- Procedure UP_NDSSELEMP��(��) �����ϵǾ����ϴ�.

EXEC up_ndsSelEmp(30);
EXEC up_ndsSelEmp(20);

-- emp ���̺��� �˻� ��� ����
-- 1) �˻� ���� : �μ���ȣ, �����, ��
-- 2) �˻���    :
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
    psearchCondition NUMBER -- 1. �μ���ȣ, 2.�����, 3.��
    , psearchWord VARCHAR2
)
IS
    vsql VARCHAR2(2000);
    vcur SYS_REFCURSOR; -- Ŀ�� Ÿ������ ���� ���� 9i REF CURSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    IF psearchCondition = 1 THEN
        vsql := vsql || ' WHERE deptno = :psearchWord ';
    ELSIF psearchCondition = 2 THEN
        vsql := vsql || ' WHERE REGEXP_LIKE(ename, :psearchWord )';
    ELSIF psearchCondition = 3 THEN
        vsql := vsql || ' WHERE REGEXP_LIKE(job, :psearchWord, ''i'' )';
    END IF;
    
    -- OPEN - FOR ��
    OPEN vcur FOR vsql USING psearchWord;
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vrow.empno || ' ' || vrow.ename || ' ' || vrow.job);
    END LOOP;
    CLOSE vcur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR');
END;

EXEC up_ndsSearchEmp(1, '20');
EXEC up_ndsSearchEmp(2, 'L');
EXEC up_ndsSearchEmp(3, 's');
