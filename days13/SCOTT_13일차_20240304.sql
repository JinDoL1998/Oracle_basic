-- SCOTT  
--(목) : 설문조사 세미 프로젝트
-- PL/SQL
--------------------------------------------------------------------------------
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
1) 회원 가입/수정/탈퇴 쿼리..
DESC T_MEMBER;
이름            널?       유형            
------------- -------- ------------- 
MEMBERSEQ     NOT NULL NUMBER(4)       PK
MEMBERID      NOT NULL VARCHAR2(20)  
MEMBERPASSWD           VARCHAR2(20)  
MEMBERNAME             VARCHAR2(20)  
MEMBERPHONE            VARCHAR2(20)  
MEMBERADDRESS          VARCHAR2(100) 

  ㄱ. T_MEMBER  -> PK 확인.
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P';
    
  ㄴ.  회원가입
  시퀀스(sequence)  자동으로 번호 발생시키는 객체 == 은행 (번호)
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '관리자', '010-1111-1111', '서울 강남구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  '홍길동', '010-1111-1112', '서울 동작구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '김기수', '010-1111-1341', '경기 남양주시' );
    COMMIT;
  ㄷ. 회원 정보 조회
  SELECT * 
  FROM t_member;
  
  ㄹ. 회원 정보 수정
  로그인 -> (홍길동) -> [내 정보] -> 내 정보 보기 -> [수정] -> [이름][][][][][][] -> [저장]
  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
  ㅁ. 회원 탈퇴
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
  
--------------------------------------------------------------------------------
1) 회원 가입/수정/탈퇴 쿼리..    
   ㄱ. 관리자로 로그인         
   ㄴ. [설문작성] 메뉴 선택
   ㄷ. 설문 작성 페이지로 이동...
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'좋아하는 여배우?'
                          , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5
                          , 0
                          , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
    ㄹ. 설문 항목                  
 
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'배슬기', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'김옥빈', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'아이유', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'김선아', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'홍길동', 0, 1 );      
   COMMIT;
--
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
   ㄷ. 설문 작성 페이지로 이동...
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 2  ,'좋아하는 과목?'
                          , TO_DATE( '2024-02-25 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-03-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 4
                          , 0
                          , TO_DATE( '2024-02-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
    ㄹ. 설문 항목                  
 
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'자바', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'오라클', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
   
   COMMIT;
--
--
   ㄷ. 설문 작성 페이지로 이동...
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'좋아하는 색?'
                          , TO_DATE( '2024-03-25 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-04-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
    ㄹ. 설문 항목                  
 
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'파랑', 0, 3 ); 
   
   COMMIT;
--

SELECT *
FROM t_poll;
SELECT *
FROM t_pollsub; 
 
SELECT MAX(POLLSUBSEQ)+1
FROM t_pollsub;  
   설문 수정, 설문 삭제 query
 
 11:03 수업...
--------------------------------------------------------------------------------
3) 회원이 로그인했습니다.     [ 설문목록페이지  ]
   2 설문 : 좋아하는 과목 "제목" 클릭
SELECT *
FROM t_member;   
  --> 3	kim	1234	김기수 (인증)
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일, itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '시작 전';  

--------------------------------------------------------------------------------  
3)  3(김기수) 로그인 상태 +  2번 설문 참여..( 좋아하는 과목 ) [ 투표 페이지 ]
   업무 프로세스 
   설문 목로페이지에서 설문참여하기 위해서 2번 질문을 클릭
   [설문 보기 페이지]
   1) 2번 설문의 내용이 SELECT-> 출력
       ㄱ. 설문내용 
           질문, 작성자, 작성일, 시작일, 종료일, 상태, 항목수 조회
           SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '종료'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
                  ELSE '시작 전'
               END 상태
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
       ㄴ. 설문항목
           SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
   2) 총참여자수 7명
      배 []
      .  []
      .  []
    -- 2번 설문의 총참여자수   
    SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
    -- 
    SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  막대그래프
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
  
  3) [ 투표하기 ] 버튼 클릭
     - 2질문의 항목을 선택을 해야된다. 
    자바
    오라클 (체크)  PK 7  ( 질문항목  PK 값인 7을 선택)
    HTML5
    JSP
    
    SELECT *
    FROM t_voter;
    -- (1) t_voter
    INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      1   ,  '김기수'      , SYSDATE,   2  ,     7 ,        3 );
    COMMIT;
    
    -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 7;
    
    commit;
    
    SELECT *    
    FROM t_poll;
    
    SELECT *
    FROM t_pollsub;
 
 -------------------------------------------------------------------------------
 【형식】
	CREATE SEQUENCE 시퀀스명
	[ INCREMENT BY 정수]  증가값   10
	[ START WITH 정수]    시작값   50
	[ MAXVALUE n ? NOMAXVALUE]  최대값
	[ MINVALUE n ? NOMINVALUE]  최소값
	[ CYCLE ? NOCYCLE]
	[ CACHE n ? NOCACHE];
  
  예) dept 부서 테이블에 사용할 시퀀스 생성
  SELECT *
  FROM dept;
 
 
  CREATE SEQUENCE seq_deptno
  INCREMENT BY 10
  START WITH 50   
  MAXVALUE  90 
  -- MINVALUE  1
  NOCYCLE 
  NOCACHE;
   
 -- Sequence SEQ_DEPTNO이(가) 생성되었습니다.
 -- 모든 시퀀스 조회
 SELECT *
 FROM user_sequences;
 
 11:05 수업시작~
 --
  CREATE SEQUENCE seq_test;
 -- 
 DROP SEQUENCE seq_test;
 DROP SEQUENCE seq_deptno;
 
 --
-- ORA-08002: sequence SEQ_DEPTNO.CURRVAL is not yet defined in this session
--08002. 00000 -  "sequence %s.CURRVAL is not yet defined in this session"
--*Cause:    sequence CURRVAL has been selected before sequence NEXTVAL
--*Action:   select NEXTVAL from the sequence before selecting CURRVAL
 SELECT seq_deptno.currval  -- nextval 참조하기 때문에   ( 기억 )
 FROM dual;

-- 시퀀스를 사용해서 부서를 추가..
INSERT INTO dept (deptno, dname, loc) VALUES ( seq_deptno.NEXTVAL, 'QC', 'SEOUL'   );
-- ORA-01438: value larger than specified [precision] allowed for this column
-- 이유?  NUMBER( p, [s] )
DESC DEPT;  -- NUMBER(2)
INSERT INTO dept (deptno, dname, loc) VALUES ( seq_deptno.NEXTVAL, 'QC2', 'POHANG'   );
COMMIT; 
SELECT *
FROM dept;
-- 90	90
SELECT   seq_deptno.NEXTVAL, seq_deptno.CURRVAL
FROM dual; 
 
DELETE FROM dept
WHERE deptno >= 50;
COMMIT;

SELECT * 
FROM dept;

-- PL/SQL --
-- PL/SQL = Procedural Language(절차적인 언어) 확장된  SQL
--           상수,변수, 프로시저,함수 ,제어문
-- PL/SQL은 블럭 구조의 언어이다.
--            3가지 종류의 블럭 구조 
[DECLARE]
   --1) 선언 블럭  DECLARE문
BEGIN
   --2) 실행 블럭  BEGIN 문
   /*  PL/SQL의 블럭 안에서 멀티라인 주석처리
   SELECT 문;
   SELECT 문;
   SELECT 문;
   INSERT 문;
   SELECT 문;
   UPDATE 문;
   DELETE 문;
   SELECT 문;
   SELECT 문;
   */
   COMMIT;
[EXCEPTION]
   --3) 예외 처리 블럭  EXCEPTION 문
END;
 
-- PL/SQL의 5가지 종류
--1) 익명 프로시저( Anoymous Procedure ) : DECLARE  로 시작한다.
--  사원번호가 7369 인 사원의 이름,pay 를 얻어와서 변수에 저장하고 출력.
DESC emp;
--오류 보고 -
--ORA-06550: line 4, column 3:
--PLS-00103: Encountered the symbol "," when expecting one of the following:
--
--   := ; not null default character
--06550. 00000 -  "line %s, column %s:\n%s"
--*Cause:    Usually a PL/SQL compilation error.
--*Action:
DECLARE
  -- 변수, 상수 선언하는  선언 블럭
  --   ; 세미콜론 사용
  -- vename VARCHAR2(10);   TYPE형변수로 선언
  vename emp.ename%TYPE; -- 테이블 구조가 자주 변경될 때 사용.
  vpay NUMBER ;
  -- 자바   final double PI = 3.141592;
  -- PLS-00103: Encountered the symbol "=" when expecting one of the following:  
  vpi CONSTANT NUMBER := 3.141592;
BEGIN
  vpay := 0;

  SELECT   ename, sal + NVL(comm,0) pay
     INTO  vename, vpay  -- SELECT, FETCH 문 INTO 구문 사용. 변수값에 할당 2번째 방법     
  FROM emp
  WHERE empno = 7369;  
  -- JAVA  : System.out.println(vename +" " + vpay);
  -- PL/SQL 출력
  -- DBMS_OUTPUT.PUT_LINE('Hello World');  
  DBMS_OUTPUT.PUT_LINE( vename || ' ' || vpay );  
--EXCEPTION
END;

-- 문제) dept 테이블에서 
-- 30번 부서의 부서명을 얻어와서 출력하는  익명프로시저를 작성,테스트
DECLARE
   vdname dept.dname%TYPE;
BEGIN
   SELECT dname INTO vdname
   FROM dept
   WHERE deptno = 30;   
   DBMS_OUTPUT.PUT_LINE('부서명 : ' || vdname );   
-- EXCEPTION
END;

-- 문제) 30번 부서의 지역명을 얻어와서
--    10번 부서의 지역명으로 설정하는 익명프로시저를 작성,테스트
DECLARE
  vloc dept.loc%TYPE;
BEGIN
  SELECT loc INTO vloc
  FROM dept
  WHERE deptno = 30;
  
  UPDATE dept
  SET loc = vloc
  WHERE deptno = 10;
  
  -- COMMIT;
--EXCEPTION
  -- ROLLBACK;
END;
 
SELECT *
FROM dept;

-- [문제] 10번 부서원 중에 최고급여(sal)를 받는 사원의 정보를 출력.(조회)
-- PL/SQL  익명프로시저 작성, 테스트
--1) TOP-N 
SELECT *
FROM (
    SELECT *
    FROM emp
    WHERE deptno = 10
    ORDER BY sal DESC
)
WHERE ROWNUM = 1;
--2) RANK 함수
SELECT *
FROM ( 
    SELECT 
       RANK() OVER(ORDER BY sal DESC ) sal_rank
       , emp.*
    FROM emp
    WHERE deptno = 10
) 
WHERE sal_Rank = 1;
--3) 서브쿼리
SELECT *
FROM emp
WHERE deptno = 10 AND sal = (
                        SELECT MAX(sal)
                        FROM emp
                        WHERE deptno = 10 );

--익명프로시저에 사용.
DECLARE
  vmax_sal_10 emp.sal%TYPE;
  
  vempno emp.empno%TYPE;
  vename emp.ename%TYPE;
  vjob emp.job%TYPE;
  vhiredate emp.hiredate%TYPE;
  vdeptno emp.deptno%TYPE;  
  vsal emp.sal%TYPE;
BEGIN
  SELECT MAX(sal) INTO vmax_sal_10
  FROM emp
  WHERE deptno = 10;
  
  SELECT empno, ename, job, sal, hiredate, deptno
   INTO vempno, vename, vjob, vsal, vhiredate, vdeptno
  FROM emp
  WHERE deptno = 10 AND sal = vmax_sal_10;
  
  DBMS_OUTPUT.PUT_LINE( '사원번호 :'  || vempno );
  DBMS_OUTPUT.PUT_LINE( '사원명 :'    || vename );
  DBMS_OUTPUT.PUT_LINE( '입사일자 :'  || vhiredate );
-- EXCEPTION
END;

--익명프로시저에 사용 2.
DECLARE
  vmax_sal_10 emp.sal%TYPE;
  
  vemp_row emp%ROWTYPE;
BEGIN
  SELECT MAX(sal) INTO vmax_sal_10
  FROM emp
  WHERE deptno = 10;
  
  SELECT empno, ename, job, sal, hiredate, deptno
   INTO vemp_row.empno, vemp_row.ename
     , vemp_row.job, vemp_row.sal
     , vemp_row.hiredate, vemp_row.deptno
  FROM emp
  WHERE deptno = 10 AND sal = vmax_sal_10;
  
  DBMS_OUTPUT.PUT_LINE( '사원번호 :'  || vemp_row.empno );
  DBMS_OUTPUT.PUT_LINE( '사원명 :'    || vemp_row.ename );
  DBMS_OUTPUT.PUT_LINE( '입사일자 :'  || vemp_row.hiredate );
-- EXCEPTION
END;

-- [ 커서( CURSOR ) ]
DECLARE
   vname insa.name%TYPE := '익명';
   vpay NUMBER := 0;
   vmessage VARCHAR2(100);
BEGIN
  -- PL/SQL에서 여러 개의 행을 처리할 때는 반드시 [커서]를 사용해야 된다. (암기)
  SELECT name, basicpay + sudang pay
   INTO vname, vpay
  FROM insa;
  -- WHERE num = 1001;   insa 테이블의 모든 사원 정보 이름,pay 출력
  
  vmessage := vname || + ',  ' || vpay;
  DBMS_OUTPUT.PUT_LINE(vmessage);
--EXCEPTION
END;


--ORA-01422: exact fetch returns more than requested number of rows
--ORA-06512: at line 6
--01422. 00000 -  "exact fetch returns more than requested number of rows"
--*Cause:    The number specified in exact fetch is less than the rows returned.
--*Action:   Rewrite the query or change number of rows requested


--2) 저장 프로시저( Stored Procedure )  대표적인 PL/SQL *****
--3) 저장 함수(Stored Function)
--4) 패키지(package)
--5) 트리거(trigger)


-- 1) 익명프로시저 + 대입연산자 ( := ) , 제어문
DECLARE
   a NUMBER := 1;
   b NUMBER;
   c NUMBER := 0;
BEGIN
   b := 2;
   c := a + b;
   
   DBMS_OUTPUT.PUT_LINE( c );
-- EXCEPTION
END;

-- PL/SQL 안에서 사용하는  제어문의 종류.. -- 
자바)
if(){}
--
IF 조건식 THEN
END IF;

if(){}else{}
--
IF 조건식 THEN
ELSE
END IF;

if(){}
else if(){}
else if(){}
else if(){
}else{}
-- (주의)
IF 조건식 THEN
ELSIF 조건식 THEN
ELSIF 조건식 THEN
ELSIF 조건식 THEN
ELSE
END IF;

-- 문제) 하나의 정수를 입력받아서 홀수/짝수 라고 출력..(익명프로시저)
DECLARE
   vnum NUMBER(4) := 0;
   vresult VARCHAR2(4);
BEGIN
   vnum := :bindNumber; -- 바인드변수
   IF  MOD( vnum , 2 ) = 0 THEN  -- 짝수
     -- DBMS_OUTPUT.PUT_LINE('짝수');
     vresult := '짝수';
   ELSE  -- 홀수
     -- DBMS_OUTPUT.PUT_LINE('홀수');
     vresult := '홀수';
   END IF;
   DBMS_OUTPUT.PUT_LINE( vresult );   
--EXCEPTION
END;

-- 3:00 수업시작~
-- [문제] PL/SQL   IF문 연습문제...
--  국어점수 입력받아서 수우미양가 등급 출력... ( 익명프로시저 )
DECLARE
   vkor NUMBER(3) := 0;
   vgrade VARCHAR2(3) := '수';
BEGIN
   vkor := :bindNumber; -- 바인드변수
   IF  (vkor BETWEEN 90 AND 100) THEN   
     vgrade := '수';
   ELSIF vkor BETWEEN 80 AND 89 THEN   
     vgrade := '우';
   ELSIF vkor BETWEEN 70 AND 79 THEN
     vgrade := '미';
   ELSIF vkor BETWEEN 60 AND 69 THEN
     vgrade := '양';
   ELSIF vkor BETWEEN 0 AND 59 THEN
     vgrade := '가';
   -- ELSE  
     -- 강제로 입력 잘못!! 예외 발생..
   END IF;
   DBMS_OUTPUT.PUT_LINE( vgrade );   
--EXCEPTION
END;

-- [문제] PL/SQL   IF문 연습문제...
--  국어점수 입력받아서 수우미양가 등급 출력... ( 익명프로시저 )
DECLARE
   vkor NUMBER(3) := 0;
   vgrade VARCHAR2(3) := '수';
BEGIN
   vkor := :bindNumber; -- 바인드변수
   IF vkor BETWEEN 0 AND 100  THEN  
      vgrade := CASE   TRUNC( vkor/10 ) 
                    WHEN 10 THEN '수'
                    WHEN 9 THEN '수'
                    WHEN 8 THEN '우'
                    WHEN 7 THEN '미'
                    WHEN 6 THEN '양'
                    ELSE  '가'
                END;  
      DBMS_OUTPUT.PUT_LINE( vgrade );           
   ELSE
     DBMS_OUTPUT.PUT_LINE('국어점수 0~100!!');
   END IF;
--EXCEPTION
END;

-- 1) WHILE LOOP문
자바   while 문 
while(조건식){
} // while

오라클 PL/SQL 
WHILE (조건식) 
LOOP   -- {
   // 실행코딩
END LOOP;  -- }

--문제) 1~10 까지의 합  WHILE 사용 (익명프로시저)
DECLARE
  vi NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
   WHILE ( vi <= 10 )
   LOOP
     IF vi = 10  THEN
       DBMS_OUTPUT.PUT( vi);
     ELSE
       DBMS_OUTPUT.PUT( vi || '+');
     END IF;     
     vsum := vsum + vi;     
     vi := vi + 1; -- i++
   END LOOP;
   DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;
-- 2) LOOP   END LOOP문
자바 
while( true ) {
  if(조건식) break;
  
} 

LOOP
  --
  --
  --
  EXIT WHEN 조건식;
END LOOP;

--문제) 1~10 까지의 합  LOOP ~ END LOOP 사용 (익명프로시저)
DECLARE
  vi NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
   
   LOOP
     IF vi = 10  THEN
       DBMS_OUTPUT.PUT( vi);
     ELSE
       DBMS_OUTPUT.PUT( vi || '+');
     END IF;     
     vsum := vsum + vi;  
     
     EXIT WHEN vi = 10;
     
     vi := vi + 1; -- i++
   END LOOP;
   
   DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;

-- 3) FOR  LOOP문
DECLARE 
  vsum NUMBER := 0;
BEGIN   
   -- FOR i IN [REVERSE] 1..10 LOOP
   FOR i IN REVERSE 1..10 LOOP
       DBMS_OUTPUT.PUT(  i || '+' );
       vsum := vsum + i;  
   END LOOP;  
   DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;

-- GOTO 문 ~~ 
--DECLARE
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 2 처리 ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 1 처리 ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 3 처리 '); 
--EXCEPTION
END;

-- while   구구단 가로 출력
-- for     구구단 세로 출력
-- 구구단(2~9) 출력
1) WHILE LOOP ~ END LOOP  사용  * 2

DECLARE
  vdan NUMBER(2):=2 ;
  vi NUMBER(2) := 1 ;
BEGIN
   -- vdan 2~9
   WHILE vdan <= 9
   LOOP
     -- 1~ 9
     vi := 1; -- ***
     WHILE vi <= 9
     LOOP
        -- 2*1=2
        DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' ' ) );
        vi := vi + 1;
     END LOOP;  
     DBMS_OUTPUT.PUT_LINE('');
     vdan := vdan + 1;
   END LOOP; 

--EXCEPTION
END;

2) FOR LOOP ~ END LOOP  사용    * 2

DECLARE
  -- vdan NUMBER(2):=2 ;
  -- vi NUMBER(2) := 1 ;
BEGIN
  FOR vdan IN 2.. 9
  LOOP
    FOR vi  IN 1.. 9
    LOOP
       DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' ' ) );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
--EXCEPTION
END;




 
 
 
 
 
 
 
