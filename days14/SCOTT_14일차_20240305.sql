-- SCOTT

-- [%TYPE ������]
-- [%ROWTYPE ������]
-- [RECORD�� ����]

SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369;

DECLARE
    vdeptno dept.deptno%TYPE;
    vdname dept.dname%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vpay emp.sal%TYPE;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vdname || ', ' || vempno || ', ' || vename || ', ' || vpay);
-- EXCEPTION
END;

SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369;

-- 2) �͸����ν��� �ۼ�+�׽�Ʈ(%ROWTYPE �� ����)
DECLARE
    vdrow dept%ROWTYPE;
    verow emp%ROWTYPE;
    vpay emp.sal%TYPE;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vdrow.deptno || ', ' || vdrow.dname || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay);
-- EXCEPTION
END;

-- 3) �͸����ν��� �ۼ�+�׽�Ʈ ( RECORD�� ���� )
DECLARE
-- *�μ���ȣ, �μ���, �����ȣ, �����, �޿� ���ο� �ϳ��� �ڷ��� ����
-- (����� ���� ������ Ÿ�� ����)
    TYPE EmpDeptType IS RECORD
    (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE,
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        pay NUMBER
    );
    -- ���� ����
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
-- EXCEPTION
END;

-- 4) �͸����ν��� �ۼ�+�׽�Ʈ ( RECORD�� ���� )
--ORA-06512: at line 12
--01422. 00000 -  "exact fetch returns more than requested number of rows"
--*Cause:    The number specified in exact fetch is less than the rows returned.
--*Action:   Rewrite the query or change number of rows requested
DECLARE
    TYPE EmpDeptType IS RECORD
    (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE,
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        pay NUMBER
    );
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        --INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno;
--    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
-- EXCEPTION
END;

-- 5) Ŀ��
--1) Ŀ�� ? PL/SQL�� ����� �ȿ��� ����Ǵ� SELECT�� �ǹ�
--2) Ŀ���� 2���� ����
--    ��. ������ Ŀ�� : SELECT���� ���� ����� 1��, FOR�� SELECT��
--        ( �ڵ� )
--    ��. ����� Ŀ�� : SELECT���� ���� ����� ������
--        (1) CURSOR ���� - ������ SELECT���� �ۼ� 
--        (2) OPEN        - �ۼ��� SELECT���� ����Ǵ� ����
--        (3) FETCH       - Ŀ���κ��� �������� ���ڵ� �о�ͼ� ó���ϴ� ����
--                - LOOP��(�ݺ���) ���
--                  [Ŀ�� �Ӽ��� ���]
--                  %ROWCOUNT �Ӽ�
--                  %FOUND �Ӽ�
--                  %NOTFOUND �Ӽ�
--                  %ISOPEN �Ӽ�
--        (4) CLOSE
    
-- ��)

SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno;
-- [Ŀ�� + �͸����ν��� �ۼ��׽�Ʈ]
DECLARE
   TYPE EmpDeptType  IS RECORD
  (
      deptno dept.deptno%TYPE,
      dname dept.dname%TYPE,
      empno emp.empno%TYPE,
      ename emp.ename%TYPE,
      pay NUMBER
  ); 
  vderow EmpDeptType;
   -- 1) Ŀ�� ����
   CURSOR edcursor IS (
     SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     FROM dept d JOIN emp e ON d.deptno = e.deptno
   );
BEGIN
   -- 2) Ŀ�� OPEN
   OPEN edcursor;
   -- 3) FETCH
   -- while(true){ if() break;  }
   LOOP
     FETCH edcursor INTO vderow; 
     EXIT WHEN edcursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( edcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname 
      || ', ' ||  vderow.empno  || ', ' || vderow.ename  ||
      ', ' ||  vderow.pay );  
   END LOOP;
   -- 4) Ŀ�� CLOSE
   CLOSE edcursor;
--EXCEPTION
END;

-- ��.[�Ͻ��� Ŀ�� + �͸����ν��� �ۼ�] FOR�� ���
DECLARE
   TYPE EmpDeptType  IS RECORD
  (
      deptno dept.deptno%TYPE,
      dname dept.dname%TYPE,
      empno emp.empno%TYPE,
      ename emp.ename%TYPE,
      pay NUMBER
  ); 
  vderow EmpDeptType;
  -- Ŀ������
   CURSOR edcursor IS (
     SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     FROM dept d JOIN emp e ON d.deptno = e.deptno
   );
BEGIN
    -- FOR i IN [REVERSE]1..10
    FOR i vderow IN edcursor
    LOOP   
     DBMS_OUTPUT.PUT( edcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname 
      || ', ' ||  vderow.empno  || ', ' || vderow.ename  ||
      ', ' ||  vderow.pay );  
    END LOOP;
    --EXCEPTION
END;

-- ��.[�Ͻ��� Ŀ�� + �͸����ν��� �ۼ�] FOR�� ���
DECLARE
BEGIN
    FOR vderow IN (            
                     SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
                     FROM dept d JOIN emp e ON d.deptno = e.deptno
                    )
    LOOP   
     DBMS_OUTPUT.PUT_LINE( vderow.deptno || ', ' || vderow.dname 
      || ', ' ||  vderow.empno  || ', ' || vderow.ename  ||
      ', ' ||  vderow.pay );  
    END LOOP;
    --EXCEPTION
END;

-- [���� ���ν���(STORED PROCEDURE)]
--CREATE OR REPLACE PROCEDURE ���ν�����
--(
--    �Ű�����(argument, parameter),
--    �Ű�����(argument, parameter)
--    P
--)
--IS
--    V;
--    V;
--BEGIN
--EXCEPTION 
--END;

-- [�͸� ���ν���]
--DECLARE
--    ����, ��� ����
--BEGIN
--    ���� ��
--EXCEPTION
--    ���� ó�� ��
--END


-- ���� ���ν����� �����ϴ� 3���� ���
--1) EXECUTE ������ ����
--2) �͸����ν������� ȣ���ؼ�
--3) �� �ٸ� �������ν������� ȣ���ؼ� ����

-- ���������� ����ؼ� ���̺� ����
CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);

SELECT *
FROM tbl_emp;

-- ����(stored) ���ν��� : up_
DELETE FROM tbl_emp
WHERE empno = 9999;

CREATE OR REPLACE PROCEDURE up_deltblemp
(
    -- pempno NUMBER(4) X
    -- pempno NUMBER O
    -- pempno IN tbl_emp.empno%TYPE
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
    -- ROLLBACK
END;

-- Procedure UP_DELTBLEMP��(��) �����ϵǾ����ϴ�.
-- [ UP_DELTBLEMP ] ����
--1) EXECUTE ������ ����
EXECUTE UP_DELTBLEMP; -- X
EXECUTE UP_DELTBLEMP(7369);
EXECUTE UP_DELTBLEMP(empno => 7369);

SELECT * 
FROM tbl_emp;
--2) �͸����ν������� ȣ���ؼ�
BEGIN
    UP_DELTBLEMP(7566);
END;
--3) �� �ٸ� �������ν������� ȣ���ؼ� ����
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
AS
BEGIN
    UP_DELTBLEMP(7521);
END up_DELTBLEMP_test;

EXEC UP_DELTBLEMP_TEST;

-- [����1] dept -> tbl_dept ���̺� ����
CREATE TABLE tbl_dept
AS
(
    SELECT *
    FROM dept
);

-- [����2] tbl_dept ���̺� deptno Į���� PK �������� ����
ALTER TABLE tbl_dept
add constraint PK_TBLDEPT_DEPTNO PRIMARY KEY(deptno);

-- [����3] ����� Ŀ�� + tbl_dept ���̺��� SELECT ���� ���ν��� ����
-- ����
-- up_seltbldept
-- �Ű����� X, ������ ����� Ŀ�� ����
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
   vdrow tbl_dept%ROWTYPE;
   CURSOR dcursor IS (
                         SELECT deptno, dname, loc
                         FROM tbl_dept
                       );
BEGIN 
   OPEN dcursor; 
   LOOP
     FETCH dcursor INTO vdrow; 
     EXIT WHEN dcursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( dcursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
   END LOOP; 
   CLOSE dcursor;
--EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- ����4) ���ο� �μ��� �߰��ϴ� ���� ���ν��� UP_INSTBLDEPT
--      deptno          ������
--      dname, loc

SELECT *
FROM user_sequences;
--      4-1) seq_deptno ������ ���� 50/10/NOCYCLE/NOĳ��/90

CREATE SEQUENCE seq_deptno
INCREMENT BY 10
START WITH 50
MAXVALUE 90
NOCYCLE
NOCACHE;

CREATE OR REPLACE PROCEDURE UP_INSTBLDEPT
(
    pdname IN tbl_dept.dname%TYPE := NULL
    , ploc IN tbl_dept.loc%TYPE DEFAULT NULL
)
IS
    -- vdeptno tbl_dept.deptno%TYPE;
BEGIN
--    SELECT MAX(deptno) INTO vdeptno
--    FROM tbl_dept;
--    vdeptno := vdeptno + 10;
--    
--    INSERT INTO tbl_dept(deptno, dname, loc)
--    VALUES(vdeptno, pdname, ploc);
--    COMMIT;

    INSERT INTO tbl_dept(deptno, dname, loc)
    VALUES(SEQ_DEPTNO.NEXTVAL, pdname, ploc);
    COMMIT;
END;
-- Procedure UP_INSTBLDEPT��(��) �����ϵǾ����ϴ�.

EXEC UP_SELTBLDEPT;
EXEC UP_INSTBLDEPT('QC', 'SEOUL');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL', pdname=>'QC');
EXEC UP_INSTBLDEPT(pdname=>'QC2');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL');
EXEC UP_INSTBLDEPT();

SELECT *
FROM tbl_dept;

-- ����) up_seltbldept, up_instbldept
--      [up_updtbldept]
EXEC up_updtbldept;
EXEC up_updtbldept(50, 'A', 'B');  -- dname, loc
EXEC up_updtbldept(pdeptno=>50, pdname=>'QC3'); --loc
EXEC up_updtbldept(pdeptno=>50, pdname=>'SEOUL'); --loc

-- ��.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
  vdname tbl_dept.dname%TYPE;
  vloc   tbl_dept.loc%TYPE;
BEGIN
    -- ���� ���� ���� dname, loc
    SELECT dname, loc INTO vdname, vloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    
    IF pdname IS NULL AND ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = vdname, loc = vloc
       WHERE deptno = pdeptno;
    ELSIF pdname IS NULL THEN
       UPDATE tbl_dept
       SET dname = vdname, loc = ploc
       WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = pdname, loc = vloc
       WHERE deptno = pdeptno;    
    ELSE
      UPDATE tbl_dept
       SET dname = pdname, loc = ploc
       WHERE deptno = pdeptno; 
    END IF;    
    COMMIT;
-- EXCEPTION
END;

-- ��.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
BEGIN
    IF pdname IS NULL AND ploc IS NULL THEN
    ELSIF pdname IS NULL THEN
       UPDATE tbl_dept
       SET loc = ploc
       WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
       UPDATE tbl_dept
       SET dname = pdname
       WHERE deptno = pdeptno;    
    ELSE
      UPDATE tbl_dept
       SET dname = pdname, loc = ploc
       WHERE deptno = pdeptno; 
    END IF;    
    COMMIT;
-- EXCEPTION
END; 



-- ��.
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno  tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE  := NULL
    , ploc   tbl_dept.loc%TYPE    := NULL
)
IS
BEGIN
    UPDATE tbl_dept
    SET dname = NVL(pdname,dname)
        , loc = CASE
                    WHEN ploc IS NULL THEN loc
                    ELSE ploc
                END
    WHERE deptno = pdeptno;   
    COMMIT;
-- EXCEPTION
END;

ROLLBACK;


-- Ǯ�� ��) UP_SELTBLDEPT ��� �μ� ��ȸ.., ����� Ŀ��
SELECT * FROM tbl_emp; 
-- �ش�Ǵ� �μ����鸸 ��ȸ�ϴ� ���� ���ν��� �ۼ�
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
    
)
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor IS (
                         SELECT *
                         FROM tbl_emp
                         WHERE deptno = NVL(pdeptno, 10)
                       );
BEGIN 
   OPEN ecursor; 
   LOOP
     FETCH ecursor INTO verow; 
     EXIT WHEN ecursor%NOTFOUND;     
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;
-- Procedure UP_SELTBLEMP��(��) �����ϵǾ����ϴ�.

EXEC UP_SELTBLEMP;
EXEC UP_SELTBLEMP(30);


-- [Ǯ�� 2] up_updtbldept ���μ���ȸ + ����� Ŀ��
-- tbl_emp; �μ���ȣ�� �Ű��������ؼ� �ش�Ǵ� �μ����鸸 ��ȸ�ϴ� ���� ���ν��� �ۼ�
-- [Ŀ�� �Ķ���͸� �̿��ϴ� ���]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
    
)
IS
   verow tbl_emp%ROWTYPE;
   CURSOR ecursor(cdeptno tbl_emp.deptno%TYPE) IS (
                         SELECT*
                         FROM tbl_emp
                         WHERE deptno = NVL(cdeptno, 10)
                       );
BEGIN
   OPEN ecursor(pdeptno);
   LOOP
     FETCH ecursor INTO verow;
     EXIT WHEN ecursor%NOTFOUND;
     DBMS_OUTPUT.PUT( ecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename
      || ', ' ||  verow.hiredate);
   END LOOP; 
   CLOSE ecursor;
--EXCEPTION
END;
-- Procedure UP_SELTBLEMP��(��) �����ϵǾ����ϴ�.

-- [Ǯ�� 3] up_updtbldept ���μ���ȸ + ����� Ŀ��
-- tbl_emp; �μ���ȣ�� �Ű��������ؼ� �ش�Ǵ� �μ����鸸 ��ȸ�ϴ� ���� ���ν��� �ۼ�
-- [FOR���� �̿��ϴ� ���]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
    
)
IS
BEGIN
    FOR verow IN(
                SELECT*
                FROM tbl_emp
                WHERE deptno = NVL(pdeptno, 10)
                )
    LOOP
    DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename
      || ', ' ||  verow.hiredate);
    END LOOP;
--EXCEPTION
END;
--Procedure UP_SELTBLEMP��(��) �����ϵǾ����ϴ�.


-- ����) tbl_dept ���̺��� ���ڵ� �����ϴ� up_deltbldept �ۼ�
-- ���ν����� �ۼ�, 50, 60, 70, 80 ����
-- ������ �μ���ȣ�� �Ű������� �޾ƾ� �Ѵ�.

EXEC up_deltbldept(50);
EXEC up_deltbldept(60);
EXEC up_deltbldept(70);
EXEC up_deltbldept(80);
SELECT * FROM tbl_dept;

CREATE OR REPLACE PROCEDURE up_deltbldept
(
    pdeptno tbl_dept.deptno%TYPE
)
IS
BEGIN
    DELETE tbl_dept
    WHERE deptno = pdeptno;
    COMMIT;
END;

-- ���� ���ν���
-- �Է¿� �Ű����� IN
-- ��¿� �Ű����� OUT
-- ��.��¿� �Ű����� IN OUT
SELECT num, name, ssn
FROM insa
WHERE num = 1001; -- IN
--
CREATE OR REPLACE PROCEDURE up_selinsa
(
    pnum IN insa.num%TYPE
    ,pname OUT insa.name%TYPE
    ,pssn OUT VARCHAR2
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    SELECT name, ssn INTO vname, vssn
    FROM insa
    WHERE num = pnum;
    
    pname := vname;
    pssn := SUBSTR(vssn, 1, 8) || '******';
--EXCEPTION
END;
-- Procedure UP_SELINSA��(��) �����ϵǾ����ϴ�.

DECLARE
    vname insa.name%TYPE;
    vrrn VARCHAR2(14);
BEGIN
    UP_SELINSA(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE(vname || ' , ' || vrrn);
--EXCEPTION
END;

-- ��/��¿� �Ű����� IN OUT�� �˾ƺ���
-- ��) �ֹε�Ϲ�ȣ 14�ڸ��� �Է¿� �Ű������� ���
--     ���ڸ� 6�ڸ��� ��¿� �Ű������� ���
CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2 -- VARCHAR2(ũ��) X
)
IS
BEGIN
    pssn := SUBSTR(pssn, 1, 6);
--EXCEPTION
END;

DECLARE
    vssn VARCHAR2(14) := '761230-1700001';
BEGIN
    UP_SSN(vssn);
    DBMS_OUTPUT.PUT_LINE(vssn);
END;

-- ���� �Լ�(Stored Function)
CREATE OR REPLACE FUNCTION �����Լ���
(
    p�Ķ����,
    p�Ķ����,
)
RETURN �����ڷ���
IS
    v������;
    v������;
BEGIN



    RETURN ���ϰ�;
EXCEPTION
END;

-- ����1) �����Լ� (�ֹε�Ϲ�ȣ�� �Ű����� ����/���� ���ڿ� ��ȯ�ϴ� �Լ�)
SELECT num, name, ssn
, DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,'����','����') gender -- �ֹε�Ϲ�ȣ�� ����ؼ� ����
, SCOTT.UF_GENDER(ssn) gender
FROM insa;



CREATE OR REPLACE FUNCTION uf_gender
(
    pssn IN VARCHAR2
)
RETURN VARCHAR2
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD(SUBSTR(pssn, 8, 1),2) = 1 THEN
        vgender := '����';
    ELSE
        vgender := '����';
    END IF;
    RETURN vgender;
--EXCEPTION
END;


SELECT name, ssn
, current_year - birth_year + DECODE(s, 1, -1, -1, 0, 0, -1) || '��' "�� ����"
, uf_age
FROM(
    SELECT ssn, name
    ,CASE
        WHEN gender IN (1,2) THEN '19' || year
        WHEN gender IN (3,4) THEN '20' || year
        ELSE '18' || year
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

uf_age(ssn);

-- [����] ������ ���ϱ� ���� Ǯ��
CREATE OR REPLACE FUNCTION uf_age
(
    pssn IN VARCHAR2
)
RETURN NUMBER
IS
    vbirthyear NUMBER;
    vcurrentyear NUMBER;
    vamericanage NUMBER;
BEGIN
    IF SUBSTR(pssn, 8, 1) = 1 OR SUBSTR(pssn, 8, 1) = 2 THEN
        vbirthyear :=  '19' || SUBSTR(pssn,1,2);
    ELSIF SUBSTR(pssn, 8, 1) = 3 OR SUBSTR(pssn, 8, 1) = 4 THEN 
        vbirthyear := '20' || SUBSTR(pssn,1,2);
    ELSE
        vbirthyear := '18' || SUBSTR(pssn,1,2);
    END IF;
    
    vcurrentyear := TO_CHAR(SYSDATE, 'YYYY');
    
    IF SIGN(SYSDATE - TO_DATE(SUBSTR(pssn, 3, 4), 'MMDD')) < 0 THEN
        vamericanage := vcurrentyear - vbirthyear - 1;
    ELSIF SIGN(SYSDATE - TO_DATE(SUBSTR(pssn, 3, 4), 'MMDD')) = 0 THEN
        vamericanage := vcurrentyear - vbirthyear;
    ELSE
        vamericanage := vcurrentyear - vbirthyear + 1;
    END IF;

    RETURN vamericanage;
--EXCEPTION
END;

--������ Ǯ�� (������ ���ϱ�) 
CREATE OR REPLACE FUNCTION uf_age
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
END;


SELECT name, ssn
, SCOTT.UF_AGE(ssn) ������
FROM insa;


-- ��) �ֹε�Ϲ�ȣ -> 1998.01.20(ȭ) ������ ���ڿ��� ��ȯ�ϴ� �Լ�

SELECT name, ssn, SCOTT.UF_BIRTH(ssn)
FROM insa;

CREATE OR REPLACE FUNCTION uf_birth
(
    pssn VARCHAR2
)
RETURN VARCHAR2
IS
    vcentury NUMBER(2); --18, 19, 20
    vbirth VARCHAR(20);
BEGIN
    vbirth := SUBSTR(pssn, 1, 6);
    vcentury := CASE
                    WHEN SUBSTR(pssn, 8, 1) IN(1,2,5,6) THEN 19
                    WHEN SUBSTR(pssn, 8, 1) IN(3,4,7,8) THEN 20
                    ELSE 18
                END;
    vbirth := vcentury || vbirth; 
    vbirth := TO_CHAR(TO_DATE(vbirth, 'YYYYMMDD'), 'YYYY.MM.DD(DY)');
    RETURN vbirth;
--EXCEPTION
END;

SELECT name
, SCOTT.UF_BIRTH(ssn) ����
FROM insa;

-- [����]
SELECT POWER(2,3), POWER(2,-3)
   ,SCOTT.UF_POWER(2,3), SCOTT.UF_POWER(2,-3)
FROM dual;


CREATE OR REPLACE FUNCTION uf_power
(
    pnum NUMBER
    ,psnum NUMBER
)
RETURN NUMBER
IS
    vresult NUMBER := 1;
    vexp NUMBER;
BEGIN
    vexp := ABS(psnum);
    
    FOR i IN 1.. vexp
    LOOP
        vresult := vresult * pnum;
    END LOOP;
    
    IF psnum < 0 THEN
        RETURN 1/vresult;
    ELSE
        RETURN vresult;
    END IF;
END;





