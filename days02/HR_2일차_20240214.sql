SELECT *
FROM tabs;

-- HR 계정이 소유하고 있는 테이블 정보 조회
SELECT *
FROM tabs
ORDER BY TABLE_NAME ASC;

--COUNTRIES
DESC countries;
COUNTRY_ID   NOT NULL CHAR(2)       국가ID
COUNTRY_NAME          VARCHAR2(40)  국가명
REGION_ID             NUMBER        대륙ID
SELECT *
FROM countries;

--DEPARTMENTS - 부서 테이블(부서번호, 부서명, 관리자ID, 위치ID)
DESC departments;

--EMPLOYEES - 사원테이블(사원ID, 이름, 성, 이메일, 폰번호, 입사일자, 잡ID, SAL 등등)
SELECT *
FROM employees;

--JOBS - 잡 테이블(잡ID, 잡이름, 최소SAL, 최대SAL)
SELECT *
FROM jobs;

--JOB_HISTORY - 경력? (사원ID, 시작일, 종료일, 잡ID, 부서ID)
DESC job_history;
SELECT *
FROM job_history;

--LOCATIONS
DESC locations;
LOCATION_ID    NOT NULL NUMBER(4)       위치번호
STREET_ADDRESS          VARCHAR2(40)    주소
POSTAL_CODE             VARCHAR2(12)    우편번호
CITY           NOT NULL VARCHAR2(30)    도시
STATE_PROVINCE          VARCHAR2(25)    주
COUNTRY_ID              CHAR(2)         국가ID

SELECT *
FROM locations

--REGIONS - "대륙 정보' 갖고 있는 테이블
DESC regions;
REGION_ID   NOT NULL NUMBER         숫자
REGION_NAME          VARCHAR2(25)   문자열    대륙

SELECT *
FROM regions;

SELECT *
FROM employees;

-- 위의 테이블에서 사원번호, 사원 이름, 입사일자 칼럼 출력(조회)
-- first_name, last_name = name 칼럼으로 출력
-- 01722. 00000 -  "invalid number"
-- ORA-00904: " ": invalid identifier
SELECT employee_id 
, first_name || ' ' || last_name 이름 -- '이름'
, CONCAT ( CONCAT(first_name, ' '), last_name) AS "NAME"
, hire_date 
FROM employees;

DESC EMPLOYEES;













