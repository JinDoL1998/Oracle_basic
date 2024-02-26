-- SCOTT
--[오라클 DATA TYPE]
--1. CHAR 고정길이 2000byte
--2. HCHAR 고정길이 2000byte
--3. VARCHAR 가변길이 4000byte
--4. NVARCHAR 가변길이 4000byte
--5. LONG     가변길이 2GB

DESC dept;

-- ORA-01438: value larger than specified precision allowed for this column
INSERT INTO dept (deptno, dname, loc) VALUES (100, 'QC', 'SEOUL');
INSERT INTO dept (deptno, dname, loc) VALUES (-20, 'QC', 'SEOUL');
ROLLBACK;

-- 6. NUMBER[(p[,s])]
--          p(정밀도) : 1 - 38, 전체자리수
--          s(규모)   : -84 - 127 소수점 이하 자리수
--예)
--NUMBER
--DEPTNO NUMBER(2) == NUMBER(2,0) == 2자리 정수 -99 ~ 99 정수
--KOR    NUMBER(3) == NUMBER(3,0) == 3자리 정수 -999 ~ 999 정수
--NUMBER(5,2) 

-- 국어 점수를 랜덤하게 발생해서 저장
INSERT INTO 성적테이블(kor,eng,math) 
VALUES( SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100) );

-- 학번(PK), 학생명, 국,영,수,총,평,등 컬럼명
-- 00907. 00000 -  "missing right parenthesis"
CREATE TABLE tbl_score
(
    no      NUMBER(2) NOT NULL PRIMARY KEY -- PK = NN + UK(유일성 제약조건)
    ,name   VARCHAR2(30) NOT NULL
    ,kor    NUMBER(3)
    ,eng    NUMBER(3)
    ,math   NUMBER(3)
    ,total  NUMBER(3)
    ,avg    NUMBER(5,2)
    ,rank   NUMBER(2)
);

INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (1, '홍길동', 90, 87, 88.89);
--INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (2, '서영학', 990, -88, 65);
INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (2, '서영학', 99, 88, 65);
--INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (3, '김병훈', 1999, 68, 82);
INSERT INTO tbl_score (no, name, kor, eng, math) VALUES (3, '김병훈', 19, 68, 82);

ROLLBACK;
COMMIT;

SELECT *
FROM tbl_score;

UPDATE tbl_score
SET eng = 0
WHERE no = 2;

-- 3명학생의 학/이/국/영/수 입력 -> 총/평/등 처리
UPDATE tbl_score
SET total = kor+eng+math, avg = (kor+eng+math)/3, rank = 1;

-- [문제] 등수 처리하는 UPDATE 문 작성..
UPDATE tbl_score p
SET p.rank = (SELECT COUNT(*)+1 FROM tbl_score c
              WHERE c.total > p.total);

-- FLOAT(p) 숫자자료형, 내부적으로 NUMBER 처리

-- 날짜 자료형
--ㄱ. DATE         7 바이트, 고정길이, 초까지 저장
--ㄴ. TIMESTAMP(n) 0-9(nano)
--      TIMESTAMP == TIMESTAMP(6) 00:00:00.000000

-- 이진데이터 저장     ???.png 이미지를 이진데이터 저장
--RAW(SIZE)   2000byte         
--LONG RAW    2GB

-- 
--B+FILE    Binary 데이터를 외부에 file형태로 (264 -1바이트)까지 저장 
--B+LOB    Binary 데이터를 4GB까지 저장 (4GB= (232 -1바이트)) 
--C+LOB    Character 데이터를 4GB까지 저장 
--NC+LOB    Unicode 데이터를 4GB까지 저장 

-- COUNT() OVER() 질의한 행의 누적된 결과값을 반환
SELECT buseo, name, basicpay
,COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC) a
,SUM(basicpay) OVER(ORDER BY basicpay ASC) b
,SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC) b
,AVG(basicpay) OVER(ORDER BY basicpay ASC) c
,AVG(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC) c
FROM insa;

-- [문제] 각 지역별(city) 급여 평균
SELECT city, name, basicpay
--, AVG(basicpay)
, AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
, basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city ASC)
FROM insa;

-- [테이블 생성, 수정, 삭제) + 레코드 추가, 수정, 삭제 --
--1) 테이블 (table) ? 데이터 저장소
--2) DB모델링 -> 테이블 생성
--    예) 게시판의 게시글을 저장하기 위한 테이블 생성
--        ㄱ. 테이블명 : tbl_board
--        ㄴ. 논리적컬럼     물리적 컬럼명 자료형(크기)    널허용(필수입력)   
--            글번호(PK)     seq         NUMBER          NOT NULL(NN)
--            작성자         writer      VARCHAR2(20)    NN
--            비밀번호       password    VARCHAR2(15)    NN
--            제목           title       VARCHAR2(100)   NN
--            내용           content     CLOB           
--            작성일         writedate   DATE            DEFAULT SYSDATE
--            조회수         view_count  NUMBER(10)      DEFAULT 0
--            등등

--【간단한형식】
--CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--      ( 
--        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
--       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
--       [,...]  
--      ); 

--예) TEMPORARY 임시 테이블 생성
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

-- 테이블 생성 : CREATE TABLE (DDL)
-- 테이블 수정 : ALTER TABLE (DDL)
-- ? alter table ... add 컬럼     추가
-- ? alter table ... modify 컬럼  수정
-- ? alter table ... drop[constraint] 제약조건 삭제
-- ? alter table ... drop column 컬럼 삭제

-- 테이블 삭제 : DROP TABLE (DDL)
SELECT *
FROM tbl_board;

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES                (1, '홍길동', '1234', 'test-1', 'test-1', SYSDATE);

-- ORA-00001: unique constraint (SCOTT.SYS_C007035) violated
INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES                (2, '권맑음', '1234', 'test-2', 'test-2', SYSDATE);

INSERT INTO tbl_board 
VALUES                (3, '김영진', '1234', 'test-3', 'test-3', SYSDATE);

INSERT INTO tbl_board (seq, writer, passwd, title, content)
VALUES                (4, '이동찬', '1234', 'test-4', 'test-4');

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES                (5, '이시은', '1234', 'test-5', 'test-5', null);

COMMIT;

-- 제약조건이름을 지정해서 제약조건을 설정할 수 있고,
-- 제약조건이름을 지정하지 않으면 SYS_XXXX이름으로 자동 부여된다
-- 제약조건이름 : SCOTT.SYS_C007035
SELECT *
FROM user_constraints
WHERE table_name LIKE '%BOARD';

-- 테이블 수정 : 조회수 컬럼(1개) 추가...
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0; -- 1개 컬럼만 추가할 경우 () 괄호 생략 가능

DESC tbl_board;

SELECT *
FROM tbl_board;

INSERT INTO tbl_board(writer,seq,passwd,title)
VALUES               ('이새롬', (SELECT NVL(MAX(seq),0)+1 FROM tbl_board), '1234', 'test-6');
COMMIT;

-- content NULL 인경우 "내용없음" UPDATE
UPDATE tbl_board
SET content = '내용없음'
WHERE content IS NULL;

SELECT *
FROM tbl_board;

-- 게시판의 작성자(WRITER NOT NULL VARCHAR2(20 -> 40) SIZE 확장)
-- 컬럼의 자료형의 크기를 수정...
DESC tbl_board;

-- 제약조건은 수정할 수 없다. (삭제 -> 새로 추가)
-- NOT NULL 제약조건의 한 일종
ALTER TABLE tbl_board
MODIFY (writer VARCHAR2(40));

-- 컬럼명을 수정 (title -> subject) 수정
-- 칼럼이름의 직접적인 변경을 불가능
--ALTER TABLE 테이블명 MODIFY(): X
SELECT title AS subject, content
FROM tbl_board;

ALTER TABLE tbl_board
RENAME COLUMN title TO SUBJECT;

-- 기타 여러 가지 설명 bigo(비고) 컬럼 새로 추가 -> 칼럼 삭제
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100);

DESC tbl_board;

SELECT *
FROM tbl_board;

ALTER TABLE tbl_board
DROP COLUMN bigo;

-- [테이블의 이름을 tbl_board -> tbl_test로 변경]
RENAME tbl_board TO chi_test;

SELECT *
FROM tabs;

-- 테이블 생성하는 방법 : 6가지
-- 그 중 서브쿼리를 이용항 테이블 생성
-- 이미 존재하는 테이블 이용 -> 새로운 테이블 생성 + 데이터(레코드) 추가

-- 예) emp 테이블을 이용해서 30번 부서원들의 empno, ename, hiredate, job, 새로운테이블 생성
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

-- 제약조건은 복사되지 않는다.
-- ㄱ. emp 테이블 제약조건 확인
-- ㄴ. tbl_emp30테이블 제약조건 확인

SELECT *
FROM tbl_emp30;
-- 제약조건은 복사되지 않는다.
-- ㄱ. emp 테이블 제약조건_확인
-- ㄴ. tbl_emp30 테이블 제약조건 확인
SELECT *
FROM user_constraints
WHERE table_name LIKE '%emp30';
----------------------------------------------

-- 예) 기존 테이블을 -> 새로운 테이블 생성 + 레코드 X (기존 테이블의 구조만 복사)
CREATE TABLE tbl_emp20 -- (컬럼...)
AS
(
    SELECT *
    FROM emp
    WHERE 1 = 0 -- 조건절 항상 거짓 --
);

SELECT *
FROM tbl_emp20;
--
DROP TABLE tbl_emp20;

-- [문제] emp, dept, salgrade 테이블을 이용해서
-- deptno, dname, empno, ename, hiredate, pay, grade 컬럼을
-- 가진 새로운 테이블 생성. (tbl_empgrade)
-- (조인 사용)

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

DROP TABLE tbl_empgrade; -- 휴지통 이동
PURGE RECYCLEBIN; -- 휴지통 비우기

-- 테이블 삭제 + 완전 삭제(휴지통 비우기)
DROP TABLE tbl_empgrade PURGE; -- 완전 테이블 삭제

-- INSERT 문
--DML - insert, update, delete
--INSERT INTO 테이블명 [( 컬럼명, 컬럼명, ... )] VALUES (컬럼값, 컬럼값...);
--COMMIT;
--ROLLBACK;

-- [MultiTable INSERT문] 4가지 종류
CREATE TABLE tbl_dept10 AS ( SELECT * FROM dept WHERE 1=0);
CREATE TABLE tbl_dept20 AS ( SELECT * FROM dept WHERE 1=0);
CREATE TABLE tbl_dept30 AS ( SELECT * FROM dept WHERE 1=0);
CREATE TABLE tbl_dept40 AS ( SELECT * FROM dept WHERE 1=0);
--1) unconditional insert all 조건이 없는 INSERT ALL   
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

--2) conditional insert all   조건이 있는 INSERT ALL
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

--3) conditional(조건이 있는) first insert
--INSERT FIRST
--    WHEN deptno = 10 THEN
--        INTO tbl_emp10 VALUES()
--    WHEN job = "CLERK" THEN
--        INTO tbl_emp_clerk VALUES()
--SELECT * FROM emp;

--4) pivoting insert          
CREATE TABLE sales( -- 판매 테이블
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

-- Table SALES_DATA이(가) 생성되었습니다.
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

-- TRUNCATE 문
DROP TABLE sales; -- 테이블 자체가 삭제
DELETE FROM sales_data; -- 테이블 안 모든 레코드 삭제
SELECT * FROM sales_data;
ROLLBACK;
--
TRUNCATE TABLE sales_data; -- 테이블 안의 모든 레코드 삭제 + 자동 커밋(삭제 완료)
DROP TABLE sales_data PURGE;

--[문제1] insa 테이블에서 num, name 컬럼만을 복사해서 
--      새로운 tbl_score 테이블 생성
--      (  num <= 1005 )
CREATE TABLE tbl_score
AS(
    SELECT num, name
    FROM insa
    WHERE num <= 1005
);
SELECT * FROM tbl_score;

--[문제2] tbl_score 테이블에   kor,eng,mat,tot,avg,grade, rank 컬럼 추가
--( 조건   국,영,수,총점은 기본값 0 )
--(       grade 등급  char(1 char) )
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
--[문제3] 1001~1005 
--  5명 학생의 kor,eng,mat점수를 임의의 점수로 수정(UPDATE)하는 쿼리 작성.
UPDATE tbl_score
SET kor = TRUNC(SYS.dbms_random.value(0,101)),
    eng = TRUNC(SYS.dbms_random.value(0,101)),
    mat = TRUNC(SYS.dbms_random.value(0,101));
  
--[문제4] 1005 학생의 k,e,m  -> 1001 학생의 점수로 수정 (UPDATE) 하는 쿼리 작성.
UPDATE tbl_score
SET (kor,eng,mat) = (SELECT kor, eng, mat 
                     FROM tbl_score
                     WHERE num = 1001)
WHERE num = 1005;
COMMIT;
--[문제5] 모든 학생의 총점, 평균을 수정...
--     ( 조건 : 평균은 소수점 2자리 )
UPDATE tbl_score
SET tot = kor+eng+mat,
     avg = ROUND((kor+eng+mat)/3,2);
COMMIT;

--[문제6] 등급(grade) CHAR(1 char)  'A','B','c', 'D', 'F'
--  90 이상 A
--  80 이상 B
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
--[문제7] tbl_score 테이블의 등수 처리.. ( UPDATE) 
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

-- [문제8] 모든 학생들의 영어 점수 : 30점 추가
UPDATE tbl_score
SET eng = CASE
            WHEN eng+30 > 100 THEN 100
            ELSE eng+30
          END;
COMMIT;
SELECT *
FROM tbl_score;

-- [문제] 1001 ~ 1005 학생 중에 남학생들만 5점씩 증가...

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




