-- scott
-- 패키지
-- ㄴ 자주 사용되는 여러 PROCEDURE, FUNCTION 들을 하나의 PACKAGE 묶어서 관리에 편리토록
-- DBMS 출력
DBMS_OUTPUT.PUT();
DBMS_OUTPUT.PUT_LINE();


-- 패키지의 명세서 부분
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


-- Package EMPLOYEE_PKG이(가) 컴파일되었습니다.
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
END uf_age;
  
END employee_pkg; 

-- TODO.
 SELECT name, ssn
 , employee_pkg.uf_age(ssn,1) age
 FROM insa;
 
 --------------------------------------------------------------------------------
 -- 동적 SQL ***
 
-- 동적 배열
int [] m;  -- 배열의 크기 X
int size = 10;
m = new int[size];

-- 동적 SQL(쿼리)
예) 일반적인 게시판에서 검색
 1) 제목으로 검색 WHERE title LIKE '%검색어%'
 2) 작성자로 검색 WHERE writer LIKE '%검색어%'
 3) 내용으로 검색 WHERE content LIKE '%검색어%'    
 4) 제목 + 내용으로 검색 WHERE title LIKE '%검색어%' OR content LIKE '%검색어%'
 
-- 실행 시점에 SQL이 미 결정 상태
-- 1) 동적 쿼리(SQL)를 사용하는 3가지 경우
--      ㄱ. 컴파일 시에 SQL문장이 확정되지 않은 경우( 가장 많이 사용하는 경우 )
--      예) WHERE 조건절...
--      ㄴ. PL/SQL 블럭안에서 DDL문을 사용하는 경우
--      CREATE, ALTER, DROP
--      예) 지정한 컬럼으로 동적으로 게시판 테이블 생성.
--          필요시 마다 여러개의 게시판 테이블 생성
--      ㄷ. PL/SQL 블럭안에서
--          ALTER SYSTEM/SESSIOn 명령어를 사용할 경우
        
-- 2) PL/SQL 동적 쿼리를 사용하는 2가지 방법.
--      ㄱ. DBMS_SQL 패키지 X
--      ㄴ. EXECUTE IMMEDIATE 문
--        형식)
--          EXEC[UTE] IMMEDIATE 동적쿼리문
--          [INTO 변수명, 변수명...]
--          [USING [IN/OUT/IN OUT] 파라미터, 파라미터...]

-- 3) 예
-- 익명 프로시적 문법.
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

-- 저장 프로시저
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

-- Procedure UP_NDSEMP이(가) 컴파일되었습니다.


-- 저장 프로시저 2
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


-- 예제2. dept 테이블에 새로운 부서 추가하는 저장 프로시저( 동적 쿼리 사용 )
-- 예제2. dept 테이블에 새로운 부서 추가하는 저장 프로시저( 동적 쿼리 사용 )
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
   DBMS_OUTPUT.PUT_LINE('INSERT 성공!!!');
END;

-- Procedure UP_NDSINSDEPT이(가) 컴파일되었습니다.
EXEC UP_NDSINSDEPT('QC', 'SEOUL');

DELETE FROM dept WHERE deptno = 50;
COMMIT;


-- 동적SQL -- DDL문 사용 예제..
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

-- OPEN - FOR문 : 동적 쿼리 실행 -> 실행결과물(여러개의 레코드) + 커서 처리..
CREATE OR REPLACE PROCEDURE up_ndsSelEmp
(
    pdeptno emp.deptno%TYPE
)
IS
    vsql VARCHAR2(2000);
    vcur SYS_REFCURSOR; -- 커서 타입으로 변수 선언 9i REF CURSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE deptno = :pdeptno ';
    
    -- EXECUTE IMMEDIATE stmt INTO X USING 파라미터...
    -- OPEN - FOR 문
    OPEN vcur FOR vsql USING pdeptno;
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vrow.empno || ' ' || vrow.ename);
    END LOOP;
    CLOSE vcur;
END;
-- Procedure UP_NDSSELEMP이(가) 컴파일되었습니다.

EXEC up_ndsSelEmp(30);
EXEC up_ndsSelEmp(20);

-- emp 테이블에서 검색 기능 구현
-- 1) 검색 조건 : 부서번호, 사원명, 잡
-- 2) 검색어    :
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
    psearchCondition NUMBER -- 1. 부서번호, 2.사원명, 3.잡
    , psearchWord VARCHAR2
)
IS
    vsql VARCHAR2(2000);
    vcur SYS_REFCURSOR; -- 커서 타입으로 변수 선언 9i REF CURSOR
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
    
    -- OPEN - FOR 문
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
