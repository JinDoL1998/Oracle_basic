-- ����1) ��ȣ,�̸�,��,��,��,����,���,���,����� �����ϴ� tbl_score ���̺� ����
--       (num, name, kor, eng, mat, tot, avg, rank, grade ) 
CREATE TABLE tbl_score
(num NUMBER
, name VARCHAR2(30)
, kor NUMBER
, eng NUMBER
, mat NUMBER
, tot NUMBER
, avg NUMBER
, rank NUMBER
, grade VARCHAR2(1)
);

-- ����2) ��ȣ�� �⺻Ű�� ����
ALTER TABLE tbl_score
ADD CONSTRAINT PK_TBLSCORE_NUM PRIMARY KEY(NUM);

-- ����3) seq_tblscore ������ ����
CREATE SEQUENCE seq_tblscore
INCREMENT BY 1
START WITH 1001
NOCYCLE
NOCACHE;

-- ����4) �л� �߰��ϴ� ���� ���ν��� ����
EXEC up_insertscore(1001, 'ȫ�浿', 89,44,55 );
EXEC up_insertscore(1002, '�����', 49,55,95 );
EXEC up_insertscore(1003, '�赵��', 90,94,95 );
SELECT * FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_insertscore
(
    pnum IN tbl_score.num%TYPE := NULL
    ,pname IN tbl_score.name%TYPE := NULL
    ,pkor IN tbl_score.kor%TYPE := NULL
    ,peng IN tbl_score.eng%TYPE := NULL
    ,pmat IN tbl_score.mat%TYPE := NULL
)
IS
    vtot NUMBER(3);
    vavg NUMBER(5,2);
    vgrade CHAR(1 CHAR);
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot / 3;
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B'; 
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;
    
    INSERT INTO tbl_SCORE(num, name, kor, eng, mat, tot, avg, rank, grade)
    VALUES(SEQ_TBLSCORE.NEXTVAL, pname, pkor, peng, pmat, vtot, vavg, 1, vgrade);
    
    UPDATE tbl_score a
    SET rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
    
    COMMIT;
--EXCEPTION
END;


-- ����5) �л� �����ϴ� ���� ���ν��� ����
EXEC up_updateScore( 1001, 100, 100, 100 );
EXEC up_updateScore( 1001, pkor =>34 );
EXEC up_updateScore( 1001, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1001, peng =>45, pmat => 90 );
SELECT * FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_updateScore
(   
    pnum IN tbl_score.num%TYPE := NULL
    ,pkor IN tbl_score.kor%TYPE := NULL
    ,peng IN tbl_score.eng%TYPE := NULL
    ,pmat IN tbl_score.mat%TYPE := NULL
)
IS
    vtot NUMBER(3);
    vavg NUMBER(5,2);
    vgrade CHAR(1 CHAR);
    
    vkor tbl_score.kor%TYPE;
    veng tbl_score.eng%TYPE;
    vmat tbl_score.mat%TYPE;
BEGIN
    SELECT kor, eng, mat INTO vkor, veng, vmat
    FROM tbl_score
    WHERE num = pnum;

    vtot := NVL(pkor, vkor) + NVL(peng, veng) + NVL(pmat,vmat);
    vavg := vtot / 3;
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B'; 
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;
    
    UPDATE tbl_score
    SET kor = NVL(pkor, vkor)
    , eng = NVL(peng, veng)
    , mat = NVL(pmat, vmat)
    , tot = vtot
    , avg = vavg
    , grade = vgrade
    WHERE num = pnum;
    
    UPDATE tbl_score a
    SET rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
    
    COMMIT;
END;


-- ����6) �л� �����ϴ� ���� ���ν��� ����
-- EXEC UP_DELETESCORE( 1002 );
CREATE OR REPLACE PROCEDURE up_deletescore
(
    pnum IN tbl_score.num%TYPE
)
IS
BEGIN
    DELETE tbl_score
    WHERE num = pnum;
    
    UPDATE tbl_score a
    SET rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
END;

-- ����7) ��� �л� ����ϴ� ���� ���ν��� ����( ����� Ŀ�� ��� )
-- EXEC UP_SELECTSCORE;

CREATE OR REPLACE PROCEDURE up_selectscore
IS
    -- 1) Ŀ�� ����
    CURSOR vcursor IS (SELECT * FROM tbl_score);
    vrow tbl_score%ROWTYPE;
BEGIN
    -- 2) OPEN Ŀ�� ���� ����
    OPEN vcursor;
    -- 3) FETCH Ŀ�� INTO 
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.num || ', ' || vrow.name || ', ' || vrow.kor ||
                            ', ' || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot ||
                            ', ' || vrow.avg || ', ' || vrow.rank || ', ' || vrow.grade);
    END LOOP;
    
    -- 4) CLOSE
    CLOSE vcursor;
END;

EXEC up_selectscore;

-- ���� 7-2) ��� �л� ����ϴ� ���� ���ν��� ����( �Ͻ��� Ŀ�� ��� (== FOR))
CREATE OR REPLACE PROCEDURE up_selectscore
IS
BEGIN
    FOR vrow IN (SELECT * FROM tbl_score)
    LOOP
        DBMS_OUTPUT.PUT_LINE(vrow.num || ', ' || vrow.name || ', ' || vrow.kor ||
                            ', ' || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot ||
                            ', ' || vrow.avg || ', ' || vrow.rank || ', ' || vrow.grade);
    END LOOP;
--EXCEPTION
END;

-- ����8) �л� �˻��ϴ� ���� ���ν��� ����
 EXEC UP_SEARCHSCORE(1001);
CREATE OR REPLACE PROCEDURE up_searchscore
(
    pnum NUMBER
)
IS
    -- 1) Ŀ�� ����
    CURSOR vcursor(cnum NUMBER) IS (SELECT * FROM tbl_score WHERE num = cnum);
    vrow tbl_score%ROWTYPE;
BEGIN
    -- 2) OPEN Ŀ�� ���� ����
    OPEN vcursor(pnum);
    -- 3) FETCH Ŀ�� INTO 
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.num || ', ' || vrow.name || ', ' || vrow.kor ||
                            ', ' || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot ||
                            ', ' || vrow.avg || ', ' || vrow.rank || ', ' || vrow.grade);
    END LOOP;
    
    -- 4) CLOSE
    CLOSE vcursor;
END;


-- 1���� �����(���ڵ�) , �Ͻ��� Ŀ���� ���
CREATE OR REPLACE PROCEDURE up_searchScore
(
   pnum NUMBER  -- �˻��� �л���ȣ(�Ķ����)
)
IS 
  vrow tbl_score%ROWTYPE;
BEGIN
   SELECT *  INTO vrow
   FROM tbl_score 
   WHERE num = pnum;
   
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
   
--EXCEPTION
  -- ROLLBACK;
END;

-- (JDBC, JSP) �ϱ�
-- 1) �Ķ���Ϳ� SELECT�� ���� ������� ������ Ŀ���� �Ű������� �޴´�.
CREATE OR REPLACE PROCEDURE up_selectinsa
(
    pinsacursor SYS_REFCURSOR -- Ŀ�� �ڷ��� 9i ���� REF CURSOR
)
IS
    vname insa.name%TYPE;
    vcity insa.city%TYPE;
    vbasicpay insa.city%TYPE;
BEGIN
    LOOP
        FETCH pinsacursor INTO vname, vcity, vbasicpay;
        EXIT WHEN pinsacursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
    END LOOP;
    CLOSE pinsacursor;
--EXCEPTION
END;
-- Procedure UP_SELECTINSA��(��) �����ϵǾ����ϴ�.

CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
    vinsacursor SYS_REFCURSOR;
BEGIN
    -- OPEN   -FOR ��
    OPEN vinsacursor FOR SELECT name, city, basicpay FROM insa;
    -- �� �ٸ� ���ν��� ȣ��
    UP_SELECTINSA(vinsacursor);
    
--    CLOSE vinsacursor;
--EXCEPTION
END;

EXEC up_selectinsa_test;

-- Ʈ���� ���� ��
DROP TABLE tbl_exam1 PURGE;

CREATE TABLE tbl_exam1
(
    id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
);

DROP TABLE tbl_exam2 PURGE;

CREATE TABLE tbl_exam2
(
    memo VARCHAR2(100)
    , ilja DATE DEFAULT SYSDATE
);

INSERT INTO tbl_exam1 VALUES( 1, 'hong' );
INSERT INTO tbl_exam2(memo) VALUES( 'hong ���� �߰��Ǿ���.' );
COMMIT;

INSERT INTO tbl_exam1 VALUES(2, 'admin');

UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 2;

DELETE tbl_exam1
WHERE id = 1;

SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2;


-- Ʈ���� ����
-- 1) � ��� ���̺� 
-- 2) � �̺�Ʈ(INSERT, UPDATE, DELETE)
-- 3) �۾� ��, �۾� ��
-- 4) �� Ʈ���� �߻� ���� ���
--�����ġ�
--CREATE [OR REPLACE] TRIGGER Ʈ���Ÿ� [BEFORE ? AFTER]
--	  trigger_event ON ���̺��
--	  [FOR EACH ROW [WHEN TRIGGER ����]]
--	DECLARE
--	  ����
--	BEGIN
--	  PL/SQL �ڵ�
--	END;

CREATE OR REPLACE TRIGGER ut_log 
AFTER
INSERT OR UPDATE OR DELETE ON tbl_exam1
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        INSERT INTO tbl_exam2 (memo) VALUES ( :NEW.name || '�߰�...');
    ELSIF UPDATING THEN 
        INSERT INTO tbl_exam2 (memo) VALUES ( :OLD.name || '->' || :NEW.name || '����...');
    ELSIF DELETING THEN 
        INSERT INTO tbl_exam2 (memo) VALUES ( :OLD.name || '����...');
    END IF;
--EXCEPTION
END;

--ORA-04082: NEW or OLD references not allowed in table level triggers

-- �۾���(BEFORE) Ʈ���� ����
-- ��) tbl_exam1 ��� ���̺� DML���� �ٹ��ð�(13�� ~ 18��)�� �Ǵ� �ָ����� ó�� X
CREATE OR REPLACE TRIGGER ut_log_before
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
FOR EACH ROW
BEGIN
    IF TO_CHAR(SYSDATE, 'hh24') < 12 OR TO_CHAR(SYSDATE, 'hh24') > 18
        OR TO_CHAR(SYSDATE, 'DY') IN ('��', '��') THEN
        -- �ڹ� throw �� : ������ ���ܸ� �߻�.
    RAISE_APPLICATION_ERROR(-20001, '�ٹ��ð��� �ƴϱ⿡ DML�۾� ó���� �� ����.');

    END IF;
--EXCEPTION
END;

INSERT INTO tbl_exam1 VALUES(3, 'park');
COMMIT;

DROP TRIGGER ut_log;
DROP TRIGGER ut_log_before;

DROP TABLE tbl_score PURGE;

-- Ʈ���� ����
CREATE TABLE tbl_score
(
    hak     VARCHAR2(10) PRIMARY KEY
    ,name   VARCHAR2(20)
    ,kor    NUMBER(3)
    ,eng    NUMBER(3)
    ,math   NUMBER(3)
);

CREATE TABLE tbl_scorecontent
(
    hak     VARCHAR2(10) PRIMARY KEY
    ,tot    NUMBER(3)
    ,avg    NUMBER(5,2)
    ,rank   NUMBER(3)
    ,grade  CHAR(1)
    
    ,CONSTRAINT FK_tblSCORECONNECT_HAK FOREIGN KEY(hak) REFERENCES tbl_score(hak)
);

EXEC up_insertscore(1001, 'ȫ�浿', 89,44,55 );
EXEC up_insertscore(1002, '�����', 49,55,95 );
EXEC up_insertscore(1003, '�赵��', 90,94,95 );
SELECT * FROM tbl_score;
SELECT * FROM tbl_scorecontent;

CREATE OR REPLACE PROCEDURE up_insertscore
(
     phak   VARCHAR2 
   , pname  VARCHAR2 
   , pkor   NUMBER 
   , peng   NUMBER 
   , pmath   tbl_score.math%TYPE 
)
IS
BEGIN 
  INSERT INTO tbl_score (hak, name, kor, eng,math) 
  VALUES ( phak, pname, pkor, peng, pmath);
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

-- 
DROP  TRIGGER ut_insertscore;

CREATE OR REPLACE TRIGGER ut_insertscore
AFTER 
INSERT ON tbl_score
FOR EACH ROW -- �� ���� Ʈ����  :OLD  :NEW 
DECLARE
  vtot NUMBER(3);
  vavg NUMBER(5,2);
  vgrade CHAR(1);
BEGIN 
  vtot := :NEW.kor + :NEW.eng + :NEW.math;
  vavg := vtot /  3;
  
  IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >= 60 THEN
     vgrade := 'D';   
  ELSE
    vgrade := 'F';
  END IF;
  
  INSERT INTO tbl_scorecontent (hak,tot,avg,rank,grade) 
  VALUES ( :NEW.hak, vtot, vavg,1 , vgrade); 
  
-- EXCEPTION
END;
-- Trigger UT_INSERTSCORE��(��) �����ϵǾ����ϴ�.

-- ����
EXEC up_updateScore( 1001, 100, 100, 100 );
EXEC up_updatescore( 1001, pkor =>34 );
EXEC up_updateScore( 1001, pkor =>34, pmath => 90 );
EXEC up_updateScore( 1001, peng =>45, pmath => 90 );

SELECT * FROM tbl_score;
SELECT * FROM tbl_scorecontent;

-- up_updateSCore; ���ν��� ����
CREATE OR REPLACE PROCEDURE up_updatescore
(
     phak   NUMBER
   , pkor   NUMBER  DEFAULT NULL 
   , peng   NUMBER  DEFAULT NULL
   , pmath  NUMBER DEFAULT NULL
)
IS
BEGIN 
  UPDATE tbl_score
  SET kor = NVL(pkor, kor)
  , eng = NVL(peng, eng)
  , math = NVL(pmath, math)
  WHERE hak = phak;
 
  COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;

-- ut_updateScore; Ʈ���� ����
CREATE OR REPLACE TRIGGER ut_updatescore
AFTER 
UPDATE ON tbl_score
FOR EACH ROW -- �� ���� Ʈ����  :OLD  :NEW 
DECLARE
  vtot NUMBER(3);
  vavg NUMBER(5,2);
  vgrade CHAR(1);
BEGIN 
  vtot := NVL(:NEW.kor, :OLD.kor) + NVL(:NEW.eng, :OLD.eng) + NVL(:NEW.math, :OLD.math);
  vavg := vtot /  3;
  
  IF vavg >= 90 THEN
     vgrade := 'A';
  ELSIF vavg >= 80 THEN
     vgrade := 'B';
  ELSIF vavg >= 70 THEN
     vgrade := 'C';
  ELSIF vavg >= 60 THEN
     vgrade := 'D';   
  ELSE
    vgrade := 'F';
  END IF;
    
    UPDATE tbl_scorecontent 
    SET tot = vtot
    , avg = vavg
    , grade = vgrade
    WHERE hak = :NEW.hak;
    
  
-- EXCEPTION
END;

-- [����] 
EXEC up_deletescore(1002);

SELECT * FROM tbl_score;
SELECT * FROM tbl_scorecontent;

CREATE OR REPLACE PROCEDURE up_deletescore
(
    phak tbl_score.hak%TYPE 
)
IS
BEGIN
    DELETE tbl_score
    WHERE hak = phak;
    COMMIT;
END;

CREATE OR REPLACE TRIGGER ut_deletescore
AFTER
DELETE ON tbl_score
FOR EACH ROW
DECLARE 
BEGIN
    DELETE tbl_scorecontent
    WHERE hak = :OLD.hak;
END;

--CREATE OR REPLACE TRIGGER ut_deletescore
--BEFORE
--DELETE ON tbl_score
--FOR EACH ROW
--DECLARE 
--BEGIN
--    DELETE tbl_scorecontent
--    WHERE hak = :OLD.hak;
--END;

SELECT ename, sal
FROM emp
WHERE sal = 6000;   -- 0
WHERE sal = 800;    -- 1
WHERE sal = 1250;   -- 2

-- EXCEPTION(����, ����)
CREATE OR REPLACE PROCEDURE up_emplist
(
    psal emp.sal%TYPE
)
IS
    vename emp.ename%TYPE;
    vsal emp.sal%TYPE;
BEGIN
    SELECT ename, sal INTO vename, vsal
    FROM emp
    WHERE sal = psal;
    DBMS_OUTPUT.put_LINE(vename || ', ' || vsal);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '> NO_DATA_FOUND.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;

EXEC up_emplist(6000);
EXEC up_emplist(1250);
EXEC up_emplist(800);

-- �̸� ���ǵ��� ���� ���� ó�� ���
INSERT INTO emp(empno, ename, deptno)
VALUES(9999, 'admin', 90);
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found

CREATE OR REPLACE PROCEDURE up_insertemp
(
    pempno emp.empno%TYPE
    ,pename emp.ename%TYPE
    ,pdeptno emp.deptno%TYPE
)
IS
    PARENT_KEY_NOT_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT(PARENT_KEY_NOT_FOUND, -02291);
BEGIN
   INSERT INTO emp(empno, ename, deptno)
   VALUES(pempno, pename, pdeptno);
EXCEPTION
    WHEN PARENT_KEY_NOT_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, '> QUERY FK ����.');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '> NO_DATA_FOUND.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;
-- Procedure UP_INSERTEMP��(��) �����ϵǾ����ϴ�.

EXEC up_insertemp(9999, 'admin', 90);

-- ����� ������ ���� ó�� ���
SELECT COUNT(*)
FROM emp
WHERE sal BETWEEN ? AND ?;

-- ���� COUNT(*) == 0�� ��� ���� ������ ���� ��ü�� �߻���Ű��..
CREATE OR REPLACE PROCEDURE up_myexception
(
    psal NUMBER
)
IS
    vcount NUMBER;
    -- ����� ���� ��ü ����
    ZERO_EMP_COUNT EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO vcount
    FROM emp
    WHERE sal BETWEEN psal-100 AND psal+ 100;
    
    IF vcount = 0 THEN
        -- throw new  ����� ���� ����Ŭ����();
        RAISE ZERO_EMP_COUNT; 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('> ����� : ' || vcount);
    END IF;
EXCEPTION
    WHEN ZERO_EMP_COUNT THEN
        RAISE_APPLICATION_ERROR(-20013, '> QUERY EMP COUNT 0(ZERO)...');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, '> NO_DATA_FOUND.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA TOO_MANY_ROWS FOUND.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, '> QUERY OTHERS EXCEPTION FOUND.');
END;

EXEC up_myexception(122);





