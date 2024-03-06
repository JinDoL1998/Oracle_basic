-- SCOTT

-- [%TYPE 형변수]
-- [%ROWTYPE 형변수]
-- [RECORD형 변수]

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

-- 2) 익명프로시저 작성+테스트(%ROWTYPE 형 변수)
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

-- 3) 익명프로시저 작성+테스트 ( RECORD형 변수 )
DECLARE
-- *부서번호, 부서명, 사원번호, 사원명, 급여 새로운 하나의 자료형 선언
-- (사용자 정의 구조에 타입 선언)
    TYPE EmpDeptType IS RECORD
    (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE,
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        pay NUMBER
    );
    -- 변수 선언
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
-- EXCEPTION
END;

-- 4) 익명프로시저 작성+테스트 ( RECORD형 변수 )
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

-- 5) 커서
--1) 커서 ? PL/SQL의 실행블럭 안에서 실행되는 SELECT문 의미
--2) 커서의 2가지 종류
--    ㄱ. 묵시적 커서 : SELECT문의 실행 결과가 1개, FOR문 SELECT문
--        ( 자동 )
--    ㄴ. 명시적 커서 : SELECT문의 실행 결과가 여러개
--        (1) CURSOR 선언 - 실행할 SELECT문을 작성 
--        (2) OPEN        - 작성된 SELECT문이 실행되는 과정
--        (3) FETCH       - 커서로부터 여러개의 레코드 읽어와서 처리하는 과정
--                - LOOP문(반복문) 사용
--                  [커서 속성을 사용]
--                  %ROWCOUNT 속성
--                  %FOUND 속성
--                  %NOTFOUND 속성
--                  %ISOPEN 속성
--        (4) CLOSE
    
-- 예)

SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno;
-- [커서 + 익명프로시저 작성테스트]
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
   -- 1) 커서 선언
   CURSOR edcursor IS (
     SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     FROM dept d JOIN emp e ON d.deptno = e.deptno
   );
BEGIN
   -- 2) 커서 OPEN
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
   -- 4) 커서 CLOSE
   CLOSE edcursor;
--EXCEPTION
END;

-- ㄱ.[암시적 커서 + 익명프로시저 작성] FOR문 사용
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
  -- 커서선언
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

-- ㄴ.[암시적 커서 + 익명프로시저 작성] FOR문 사용
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

-- [저장 프로시저(STORED PROCEDURE)]
--CREATE OR REPLACE PROCEDURE 프로시저명
--(
--    매개변수(argument, parameter),
--    매개변수(argument, parameter)
--    P
--)
--IS
--    V;
--    V;
--BEGIN
--EXCEPTION 
--END;

-- [익명 프로시저]
--DECLARE
--    변수, 상수 선언
--BEGIN
--    실행 블럭
--EXCEPTION
--    예외 처리 블럭
--END


-- 저장 프로시저를 실행하는 3가지 방법
--1) EXECUTE 문으로 실행
--2) 익명프로시저에서 호출해서
--3) 또 다른 저장프로시저에서 호출해서 실행

-- 서브쿼리를 사용해서 테이블 생성
CREATE TABLE tbl_emp
AS
(SELECT * FROM emp);

SELECT *
FROM tbl_emp;

-- 저장(stored) 프로시저 : up_
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

-- Procedure UP_DELTBLEMP이(가) 컴파일되었습니다.
-- [ UP_DELTBLEMP ] 실행
--1) EXECUTE 문으로 실행
EXECUTE UP_DELTBLEMP; -- X
EXECUTE UP_DELTBLEMP(7369);
EXECUTE UP_DELTBLEMP(empno => 7369);

SELECT * 
FROM tbl_emp;
--2) 익명프로시저에서 호출해서
BEGIN
    UP_DELTBLEMP(7566);
END;
--3) 또 다른 저장프로시저에서 호출해서 실행
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
AS
BEGIN
    UP_DELTBLEMP(7521);
END up_DELTBLEMP_test;

EXEC UP_DELTBLEMP_TEST;

-- [문제1] dept -> tbl_dept 테이블 생성
CREATE TABLE tbl_dept
AS
(
    SELECT *
    FROM dept
);

-- [문제2] tbl_dept 테이블에 deptno 칼럼에 PK 제약조건 설정
ALTER TABLE tbl_dept
add constraint PK_TBLDEPT_DEPTNO PRIMARY KEY(deptno);

-- [문제3] 명시적 커서 + tbl_dept 테이블을 SELECT 저장 프로시저 생성
-- 실행
-- up_seltbldept
-- 매개변수 X, 변수는 명시적 커서 선언
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

-- 문제4) 새로운 부서를 추가하는 저장 프로시저 UP_INSTBLDEPT
--      deptno          시퀀스
--      dname, loc

SELECT *
FROM user_sequences;
--      4-1) seq_deptno 시퀀스 생성 50/10/NOCYCLE/NO캐시/90

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
-- Procedure UP_INSTBLDEPT이(가) 컴파일되었습니다.

EXEC UP_SELTBLDEPT;
EXEC UP_INSTBLDEPT('QC', 'SEOUL');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL', pdname=>'QC');
EXEC UP_INSTBLDEPT(pdname=>'QC2');
EXEC UP_INSTBLDEPT(ploc=>'SEOUL');
EXEC UP_INSTBLDEPT();

SELECT *
FROM tbl_dept;

-- 문제) up_seltbldept, up_instbldept
--      [up_updtbldept]
EXEC up_updtbldept;
EXEC up_updtbldept(50, 'A', 'B');  -- dname, loc
EXEC up_updtbldept(pdeptno=>50, pdname=>'QC3'); --loc
EXEC up_updtbldept(pdeptno=>50, pdname=>'SEOUL'); --loc

-- ㄱ.
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
    -- 수정 전의 원래 dname, loc
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

-- ㄴ.
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



-- ㄷ.
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


-- 풀이 ㄱ) UP_SELTBLDEPT 모든 부서 조회.., 명시적 커서
SELECT * FROM tbl_emp; 
-- 해당되는 부서원들만 조회하는 저장 프로시저 작성
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
-- Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.

EXEC UP_SELTBLEMP;
EXEC UP_SELTBLEMP(30);


-- [풀이 2] up_updtbldept 모든부서조회 + 명시적 커서
-- tbl_emp; 부서번호를 매개변수로해서 해당되는 부서원들만 조회하는 저장 프로시저 작성
-- [커서 파라미터를 이용하는 방법]
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
-- Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.

-- [풀이 3] up_updtbldept 모든부서조회 + 명시적 커서
-- tbl_emp; 부서번호를 매개변수로해서 해당되는 부서원들만 조회하는 저장 프로시저 작성
-- [FOR문을 이용하는 방법]
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
--Procedure UP_SELTBLEMP이(가) 컴파일되었습니다.


-- 문제) tbl_dept 테이블의 레코드 삭제하는 up_deltbldept 작성
-- 프로시저를 작성, 50, 60, 70, 80 삭제
-- 삭제할 부서번호를 매개변수로 받아야 한다.

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

-- 저장 프로시저
-- 입력용 매개변수 IN
-- 출력용 매개변수 OUT
-- 입.출력용 매개변수 IN OUT
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
-- Procedure UP_SELINSA이(가) 컴파일되었습니다.

DECLARE
    vname insa.name%TYPE;
    vrrn VARCHAR2(14);
BEGIN
    UP_SELINSA(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE(vname || ' , ' || vrrn);
--EXCEPTION
END;

-- 입/출력용 매개변수 IN OUT을 알아보자
-- 예) 주민등록번호 14자리를 입력용 매개변수로 사용
--     앞자리 6자리를 출력용 매개변수로 사용
CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2 -- VARCHAR2(크기) X
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

-- 저장 함수(Stored Function)
CREATE OR REPLACE FUNCTION 저장함수명
(
    p파라미터,
    p파라미터,
)
RETURN 리턴자료형
IS
    v변수명;
    v변수명;
BEGIN



    RETURN 리턴값;
EXCEPTION
END;

-- 예제1) 저장함수 (주민등록번호를 매개변수 남자/여자 문자열 반환하는 함수)
SELECT num, name, ssn
, DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,'남자','여자') gender -- 주민등록번호를 사용해서 성별
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
        vgender := '남자';
    ELSE
        vgender := '여자';
    END IF;
    RETURN vgender;
--EXCEPTION
END;


SELECT name, ssn
, current_year - birth_year + DECODE(s, 1, -1, -1, 0, 0, -1) || '세' "만 나이"
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

-- [문제] 만나이 구하기 나의 풀이
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

--선생님 풀이 (만나이 구하기) 
CREATE OR REPLACE FUNCTION uf_age
(
   prrn IN VARCHAR2 
  ,ptype IN NUMBER --  1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS
   ㄱ NUMBER(4);  -- 올해년도
   ㄴ NUMBER(4);  -- 생일년도
   ㄷ NUMBER(1);  -- 생일 지남 여부    -1 , 0 , 1
   vcounting_age NUMBER(3); -- 세는 나이 
   vamerican_age NUMBER(3); -- 만 나이 
BEGIN
   -- 만나이 = 올해년도 - 생일년도    생일지남여부X  -1 결정.
   --       =  세는나이 -1  
   -- 세는나이 = 올해년도 - 생일년도 +1 ;
   ㄱ := TO_CHAR(SYSDATE, 'YYYY');
   ㄴ := CASE 
          WHEN SUBSTR(prrn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(prrn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(prrn,1,2);
   ㄷ :=  SIGN(TO_DATE(SUBSTR(prrn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (생일X)
   
   vcounting_age := ㄱ - ㄴ +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ㄷ, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ㄷ
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
, SCOTT.UF_AGE(ssn) 만나이
FROM insa;


-- 예) 주민등록번호 -> 1998.01.20(화) 형식의 문자열로 반환하는 함수

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
, SCOTT.UF_BIRTH(ssn) 생일
FROM insa;

-- [문제]
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





