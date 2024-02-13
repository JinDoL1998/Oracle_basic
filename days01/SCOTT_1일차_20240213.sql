-- (문제)접속자의 소유한 테이블 목록을 조회하는 쿼리
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;
FROM tabs;

-- (문제) tabs?
-- Data dictionary(자료사전)
--  ㄴ 테이블, 뷰

-- (문제) dept테이블 정보를 조회하는 쿼리
SELECT *
FROM scott.dept;
-- 접속자가 scott이니까 스키마(scott) 생략 가능

-- (문제) emp(사원) 테이블 정보를 조회하는 쿼리
SELECT *
FROM emp;