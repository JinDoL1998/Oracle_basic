-- SCOTT
SELECT *
FROM user_tables;
FROM tabs;

SELECT * 
FROM dba_users;

-- SCHEMA?
-- SESSION ?
-- TABLESPACE ?

-- SQL -- DQL : SELECT 문
-- 하나 이상의 테이블, 뷰로 부터 데이터를 가져올 때 사용하는 문
【형식】
    [subquery_factoring_clause] subquery [for_update_clause];

【subquery 형식】
   {query_block ?
    subquery {UNION [ALL] ? INTERSECT ? MINUS }... ? (subquery)} 
   [order_by_clause] 

【query_block 형식】
   SELECT [hint] [DISTINCT ? UNIQUE ? ALL] select_list
   FROM {table_reference ? join_clause ? (join_clause)},...
     [where_clause] 
     [hierarchical_query_clause] 
     [group_by_clause]
     [HAVING condition]
     [model_clause]

【subquery factoring_clause형식】
   WITH {query AS (subquery),...}

-- (시험)
-- SELECT문은 몇개의 절로 나뉜다. (암기) + 처리순서 반드시 암기
(1) WITH 절
  (6) SELECT 절
(2) FROM 절
(3) WHERE 절
(4) GROUP BY 절
(5) HAVING 절
  (7) ORDER BY 절

--
FROM 조회할대상 == 테이블(table), 뷰(view)
--
SELECT *
FROM tabs; -- 뷰
FROM emp;  -- 테이블

-- emp 테이블 어떤 컬럼으로 이루어져 있는 지 확인 ? 
--         ( 테이블 구조 확인 )

DESCRIBE scott.emp;
DESCRIBE emp;
DESC emp;
이름       널?       유형           
-------- -------- ------------ 
EMPNO 사원번호    NOT NULL NUMBER(4) 널 허용x == 필수입력사항 NUMBER(4) 4자리 정수
ENAME 사원명             VARCHAR2(10) 문자열(10바이트)
JOB 잡               VARCHAR2(9)  문자열(9바이트)
MGR 직속상사 전화번호               NUMBER(4) 4자리 정수
HIREDATE 입사일자          DATE 날짜        
SAL 기본급               NUMBER(7,2)  소수점 2자리 실수
COMM 커미션              NUMBER(7,2)  소수점 2자리 실수
DEPTNO 부서번호            NUMBER(2)   2자리 정수

-- scott이 소유하는 테이블 확인
SELECT *
FROM tabs;

-- SELECT문 키워드 : DISTINCT, ALL, AS 사용가능
SELECT * -- * : 모든 칼럼을 조회
SELECT emp.*
FROM emp;

-- emp 테이블의 사원번호, 사원명, 입사일자만 조회
SELECT empno, ename, hiredate
FROM emp;

-- emp 테이블의 job 칼럼만 조회
SELECT ALL job -- ALL 출력할 칼럼이 중복이 되더라도 모두 출력 : 기본값
FROM emp;

-- DISTINCT : 출력할 칼럼이 중복이 될 때 한번만 출력(암기)
SELECT DISTINCT job
FROM emp;

-- SELECT ALL empno, ename, hiredate
SELECT DISTINCT empno, ename, hiredate
FROM emp;

CREATE VIEW view_emp AS SELECT FROM emp ;
select '이름은'''|| ename || '''이고, 직업은 ' || job || ' 이다.' AS "직원정보"
from emp;











