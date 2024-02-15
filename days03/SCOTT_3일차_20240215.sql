-- SCOTT
--subquery란 쿼리내에 또다른 쿼리를 수행하는 것이다.
--즉 SELECT 문에 또다른 SELECT 문이 들어 있는 경우이며, FROM 절에 subquery가 있으면 이를 inline view라 하고, WHERE 절에 subquery가 있으면 이를 Nested subquery라 한다.
--그런데, Nested subquery중에서 참조되는 컬럼의 관계가 parent/child관계를 가지는 컬럼이 있으면
-- 이를 correlated subquery(상관 서브쿼리)라 한다.
--
--subquery는 다음과 같은 목적으로 사용됨
--
--? INSERT 또는 CREATE TABLE 문에서 넣을 행을 정의하기 위해
--? CREATE VIEW 또는 CREATE MATERIALIZED VIEW 문에서 view 또는 materialized view에 포함시킬 행을 정의하기 위해
--? UPDATE 문에서 갱신할 행을 정의하기 위해
--? SELECT, UPDATE, DELETE 문의 WHERE절, HAVING 절, START WITH 절의 조건을 정의하기 위해
--? 쿼리에 의해 동작될 테이블을 정의하기 위해



SELECT *
FROM user_sys_privs; -- 시스템 권한 UNLOMITED TABLESPACE : 무한정 테이블스페이스 사용

SELECT *
FROM user_role_privs; -- 롤
--SCOTT	CONNECT	NO	YES	NO
--SCOTT	RESOURCE	NO	YES	NO

DESC insa;

SELECT e.*
,sal + NVL(comm, 0) pay
--,COALESCE(sal + comm, sal, 0) pay
FROM emp e
WHERE deptno != 30 AND COALESCE(sal + comm, sal, 0) BETWEEN 1000 AND 3000
ORDER BY ename ASC;

-- WITH 절 사용
WITH temp AS (
 SELECT e.*
 ,sal + NVL(comm, 0) pay
 FROM emp e)
SELECT t.*
FROM temp t
WHERE t.deptno != 30 AND t.pay BETWEEN 1000 AND 3000
ORDER BY ename ASC;

-- 인라인 뷰
SELECT t.*
FROM(
 SELECT e.*
 ,sal + NVL(comm, 0) pay
 FROM emp e
) t
WHERE t.deptno != 30 AND t.pay BETWEEN 1000 AND 3000
ORDER BY ename ASC;

SELECT empno, ename
,NVL(TO_CHAR(mgr), 'CEO') mgr
FROM emp;

SELECT num, name, tel
,NVL2(tel, 'O', 'X') tel -- 자바 제어문 IF문 사용. PL/SQL
FROM insa
WHERE buseo IN '개발부';

SELECT * 
 FROM insa
 WHERE city NOT IN ('서울', '인천', '경기')
 ORDER BY city;

-- [문제] emp테이블에서 입사일자 hiredate가 81년도인 사원 정보 조회
-- 비교 연산자 : 숫자, 문자, 날짜
-- [1]
SELECT *
FROM emp
WHERE hiredate BETWEEN '81-01-01' AND '81-12-31';

-- [2] DATE -> 입사년도만 얻어오기
-- 오늘 날짜의 년/월/일 출력 : DATE(초), TIMESTAMP(나노세컨드, 시간대)
SELECT SYSDATE,  CURRENT_TIMESTAMP
,EXTRACT( YEAR FROM SYSDATE )2024
,TO_CHAR(SYSDATE, 'YYYY') "2024"
,TO_CHAR(SYSDATE, 'YY')
,TO_CHAR(SYSDATE, 'YEAR')
FROM dual;

SELECT ename, hiredate
FROM emp
WHERE EXTRACT(YEAR FROM hiredate) hireyear
, WHERE TO_CHAR(hireyear, 'yyyy') = '1981';

-- [3]
SELECT ename, hiredate
,SUBSTR(hiredate, 1, 2) year
FROM emp;

SELECT 'abcdefg'
,SUBSTR('abcdefg', 1, 2) --ab 1 첫문자
,SUBSTR('abcdefg', 0, 2) --ab 0 첫문자
,SUBSTR('abcdefg', 3) --cdefg 
,SUBSTR('abcdefg', -5, 3) --cdefg 뒤에서부터 5번째에서 3개
,SUBSTR('abcdefg', -1) --g 맨 뒷글자
FROM dual;

-- [문제] insa테이블에서 사원명, 주민등록번호 , 년도, 월, 일 성별 출력
DESC insa;

SELECT name, ssn
,SUBSTR(ssn, 1, 2) YEAR
,SUBSTR(ssn, 3,2) MONTH
,SUBSTR(ssn, 5,2) "DATE"
,SUBSTR(ssn, 8,1) GENDER
FROM insa;

-- 오라클의 예약어 : DATE 
SELECT *
FROM dictionary
WHERE table_name LIKE 'D%';

SELECT name
,CONCAT(SUBSTR(ssn,1,8), '*******') RRN
FROM insa
-- WHERE SUBSTR(ssn,1,2) BETWEEN 70 AND 79;
WHERE TO_NUMBER(SUBSTR(ssn,1,2)) BETWEEN 70 AND 79;
-- EXTRACT( YEAR FROM 날짜 );

SELECT name
,CONCAT(SUBSTR(ssn,1,8), '*******') RRN
,TO_DATE(SUBSTR(ssn, 0, 2), 'YY')
FROM insa;

-- LIKE SQL 연산자 설명
-- 문자와 패턴 일치 여부 체크하는 연산자
-- 검색 값에 대한 wildcard(%,_) 사용
-- % : 0~여러개의 문자
-- _ : 한개의 문자
-- wildcard(%,_)를 일반문자처럼 사용하려면 ESCAPE 옵션을 사용하라

-- [문제] insa테이블에서 70년대생만 아래와 같이 출력
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7%';

-- [문제] insa테이블에서 12월생만 아래와 같이 출력
SELECT name, ssn
,SUBSTR(ssn, 3, 2) MONTH
,TO_DATE(SUBSTR(ssn, 3, 2), 'MM')
FROM insa
--WHERE SUBSTR(ssn, 3, 2) = '12';
WHERE EXTRACT(MONTH FROM TO_DATE(SUBSTR(ssn, 3, 2), 'MM')) = 12;

SELECT name, ssn
,SUBSTR(ssn, 1, 4)
,TO_DATE(SUBSTR(ssn, 1, 4),'YYMM')
,EXTRACT(MONTH FROM TO_DATE(SUBSTR(ssn, 1, 4),'YYMM')) MONTH
FROM insa;

SELECT name, ssn
FROM insa
WHERE ssn LIKE '__12%';

-- [문제] insa 테이블에서 김씨 성을 가진 사원 모두 출력
SELECT name, ssn
FROM insa
WHERE name LIKE '_김_'; -- 이름 3글자고 가운데가 김
WHERE name LIKE '%김_'; -- 이름 끝에서 두번째가 김
WHERE name LIKE '_김%'; -- 이름 속에 두번째 문자가 '김'
WHERE name LIKE '%김%'; -- 이름 속에 '김'문자가 있으면 출력
WHERE name NOT LIKE '김%';

-- 출신도가 서울, 부산, 대구 이면서 전화번호에 5 또는 7이 포함된 자료 출력하되 
-- 부서명의 마지막 부는 출력되지 않도록함. (이름, 출신도, 부서명, 전화번호)
DESC insa;
SELECT name, city, buseo, LENGTH(buseo) , tel
, SUBSTR(buseo, 1, LENGTH(buseo)-1)
FROM insa
WHERE city IN ('서울', '부산', '대구')
AND tel LIKE '%5%' OR  tel LIKE '%7%';

-- LIKE 연산자의 ESCAPE 옵션 설명
-- dept 테이블 구조 확인
DESC dept;
SELECT deptno, dname, loc
FROM dept;
--10	ACCOUNTING	NEW YORK
--20	RESEARCH	DALLAS
--30	SALES	CHICAGO
--40	OPERATIONS	BOSTON

-- SQL 5가지 ; DQL, DDL, DML, DCL 
-- DML(INSERT) 새로운 부서 추가...
DESC dept;
--INSERT INTO 테이블명 [(컬럼명, 컬럼명....)] VALUES (값, 값...);
--COMMIT;
INSERT INTO dept(deptno, dname, loc) VALUES (50, 'QC100%T', 'SEOUL');
COMMIT;

SELECT *
FROM dept;
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
--             유일성 제약 조건      PK_DEPT
INSERT INTO dept(deptno, dname, loc) VALUES (50, '한글_나라', 'COREA');
INSERT INTO dept(deptno, dname, loc) VALUES (60, '한글_나라', 'COREA');

-- [문제] dept 테이블에서 부서명 검색을 하는데 부서명에 _ 이 있는 부서 정보를 조회
--                                        부서명에 _ 이 있는 부서 정보를 조회
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';
WHERE dname LIKE '%\_%' ESCAPE '\';

-- DML(INSERT, UPDATE, DELET) + 완료 COMMIT, 취소 ROLLBACK
--UPDATE (스키마).테이블명
--SET 컬럼 = 값, 컬럼 = 값...
--[WHERE 조건절;] -- 모든 레코드를 수정하겠다
UPDATE scott.dept
SET loc = 'XXX';

UPDATE scott.dept
SET loc = 'DALLAS'
WHERE deptno = 20;

UPDATE scott.dept
SET loc = 'COREA', DNAME='한글나라'
WHERE deptno = 60;

-- [문제] 30번 부서명, 지역명 -> 60번 부서명, 지역명으로 UPDATE 하자..
-- ORA-00936: missing expression
UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 30), loc = (SELECT loc FROM dept WHERE deptno = 30)
WHERE deptno = 60;

SELECT * FROM dept;
ROLLBACK;

UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 30)
WHERE deptno = 60;
COMMIT;

-- DML(DELETE)
DELETE FROM [스키마.]테이블명
[WHERE 조건절;] - 모든 레코드 삭제

-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
DELETE FROM dept
WHERE deptno IN (50, 60);
-- 
SELECT *
FROM emp;

-- [문제] emp 테이블에서 sal의 10%를 인상해서 새로운 sal로 수정
SELECT *
FROM emp;

UPDATE emp 
SET sal = sal * 1.1;
ROLLBACK;

-- LIKE SQL 연산자 :   % _ 패턴기호
-- REGEXP_LIKE 함수 : 정규표현식
-- [문제] insa 테이블에서 성이 김씨, 이씨 사원 조회
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7[0-9]12');
WHERE REGEXP_LIKE(name, '^[^김이]');
WHERE REGEXP_LIKE(name, '[경자]%');
WHERE REGEXP_LIKE(name, '^(김|이)');
WHERE REGEXP_LIKE(name, '^[김이]');
WHERE name LIKE '김%' OR name LIKE '이%';
WHERE SUBSTR(name, 1, 1) IN ('김', '이');

-- [문제] insa 테이블에서 70년대 남자 사원만 조회..
-- 성별 1,3,5,7,9 남자
-- 나머지 함수 MOD()
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d{5}-[13579]');
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8, 1), 2) = 1;


