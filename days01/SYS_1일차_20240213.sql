-- 주석 처리 (Ctrl + /)
-- 모든 사용자 계정 조회
-- 절은 대개 줄을 나누어 쓰도고 권한다. (권장)
-- keyword(예약어)는 대문자로 입력하도록 권한다. (권장)
-- 테이블명, 컬럼명은 소문자 사용(권장)
-- 가독성 (탭, 줄맞춤) 권장
SELECT  * 
FROM    all_users; -- Ctrl + Enter, F5

-- 수업중에 사용할 계정 생성, 수정, 삭제 -- 
-- 1) scott 계정 생성, 수정, 삭제
--   (1) scott 계정 유무 확인
SELECT  * 
FROM    all_users;

-- (2) scott 계정 생성
CREATE USER scott 
IDENTIFIED BY tiger;

-- (3) scott 계정 비밀번호 1234 수정
ALTER USER scott IDENTIFIED BY tiger;

-- (4) scott 계정 삭제
DROP USER scott CASCADE;

-- (5) SYS 최고관리자 계정이 CREATE SESSION 데이터베이스 접속(연결) 시스템 권한을 SCOTT 계정부여.
GRANT CREATE SESSION TO SCOTT;

GRANT CREATE SESSION TO student_role;
GRANT student_role TO scott;

-- DDL( CREATE, DROP, ALTER )
-- CREATE USER, DROP USER, ALTER USER
-- CREATE TABLESPACE, DROP TABLESPACE, ALTER TABLESPACE
-- CREATE ROLE, DROP ROLE, ALTER ROLE

-- 오라클 설치 시에 미리 정의된 롤(role) 확인하는 쿼리(sql)을 작성하세요
SELECT *
FROM dba_roles;

SELECT grantee,privilege 
FROM DBA_SYS_PRIVS 
WHERE grantee = 'CONNECT';

-- SCOTT 계정 + 샘플 테이블 추가
-- C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql 샘플파일

-- [문제]SCOTT으로 접속 후에 scott.sql 실행해서 만들어진 테이블을 확인
SELECT * 
FROM tabs;

-- db 계정의 모든 테이블을 볼라면 db관리자 계정이어야 한다.
SELECT *
FROM dba_tables;
-- COUNT() 오라클 함수
-- SELECT COUNT(*)
SELECT *
FROM dictionary;

-- SYS --
DROP USER madang CASCADE;
CREATE USER madang IDENTIFIED BY madang DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PROFILE DEFAULT;
GRANT CONNECT, RESOURCE TO madang;
GRANT CREATE VIEW, CREATE SYNONYM TO madang;
GRANT UNLIMITED TABLESPACE TO madang;
ALTER USER madang ACCOUNT UNLOCK;

SELECT *
FROM all_users
ORDER BY username DESC;

-- DB 계정 확인 --
-- 1) HR 계정의 비밀번호를 lion으로 수정하고
-- 2) + 새 접속을 클릭 - HR 접속
-- 3) HR 계정이 소유하고 있는 테이블 목록을 조회
SELECT *
FROM all_tables
ORDER BY OWNER ASC;

PASSWORD HR;
ALTER USER HR ACCOUNT UNLOCK;






