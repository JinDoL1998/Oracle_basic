SELECT * 
FROM emp
WHERE ename LIKE '%' || UPPER('la') || '%';
WHERE REGEXP_LIKE(ename, 'la', 'i');
WHERE ename LIKE UPPER('%lA%');

SELECT ename
, REPLACE(ename, 'LA', '<span style="color:red">LA</span>')
FROM emp;

-- insa 테이블에서 남자는 'X', 여자는 'O' 로 성별(gender) 출력하는 쿼리 작성 
-- [1]
SELECT t.name, t.ssn
--,t.gender
-- If문 PL/SQL
,REPLACE( REPLACE( t.gender, 1, 'O' ), 0, 'X')
FROM( -- INLINE VIEW
    SELECT name, ssn
    , MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)t;

-- [2]
--NULLIF(첫값, 두값)
--첫값 == 두값    null 반환
--첫값 != 두값    첫값을 반환
SELECT ename,job
    ,lengthb(ename),lengthb(job)
    ,NULLIF(lengthb(ename),lengthb(job)) nullif_result
FROM emp 
WHERE deptno=20;

SELECT name
,LENGTH(name)
,LENGTHB(name)
FROM insa;

SELECT NAME, SSN
, NVL2(NULLIF(MOD(SUBSTR(SSN, 8, 1), 2), 1), 'O', 'X') GENDER
FROM INSA;

SELECT *
FROM emp
WHERE REGEXP_LIKE(ename, 'king', 'i');

 INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC', 'SEOUL'); 
commit;
UPDATE dept
SET dname = dname || '2', loc = 'POHANG'
WHERE dname = 'QC';

SELECT * FROM dept;


DELETE dept
WHERE deptno = 50;
COMMIT;

DESC insa;
SELECT name, ibsadate
--,TO_CHAR(ibsadate, 'YYYY.MM.DD(DY)')
,TO_CHAR(ibsadate, 'YYYY')
FROM insa
--WHERE TO_CHAR(ibsadate,'YYYY') >= 2000;
--WHERE ibsadate >= '2000.01.01';
WHERE EXTRACT(YEAR FROM ibsadate) >= 2000;

-- dual 설명
SELECT SYSDATE
FROM ;

-- 산술연산자
SELECT 5+3, 5-3, 5/3, MOD(5,3)
-- ORA-01476: divisor is equal to zero
SELECT 5/0
SELECT MOD(5,0)
FROM dual;

-- PUBLIC SYNONYM 생성
-- ORA-01031: insufficient privileges
CREATE SYNONYM arirang
FOR scott.emp;

-- REPLACE() 함수
SELECT name, ssn
, REPLACE(ssn, '-')
FROM insa;
--SUBSTR(ssn, 1, 6) || SUBSTR(ssn, 8) ssn

SELECT
TO_DATE('2024', 'YYYY')
, TO_DATE('2024/03', 'YYYY/MM') 
, TO_DATE('2024/05/21')
FROM dual;

SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '[김|이]')
AND REGEXP_LIKE(ssn, '^7[0-9]12');

-- YY와 RR의 차이점:
-- RR과 YY는 둘다 년도의 마지막 두자리를 출력해 주지만, 
-- 현재 system상의 세기와 나타내고자 하는 년도의 세기를 비교할 했을 때 출력되는 값이 다르다.
-- RR은 시스템상(1900년대)의 년도를 기준으로 하여 
-- 이전 50년도에서 이후 49년까지는 기준년도와 가까운 1850년도에서 1949년도까지의 값으로 표현하고, 
-- 이 범위를 벗아날 경우 다시 2100년을 기준으로 이전 50년도에서 이후 49년까지의 값을 출력한다.

-- YY는 무조건 system상의 년도를 따른다.
SELECT TO_CHAR(SYSDATE, 'CC')
FROM dual;

SELECT 
'05/01/10' -- 문자열
, TO_CHAR(TO_DATE('05/01/10', 'YY/MM/DD'), 'YYYY') date_YY
, TO_CHAR(TO_DATE('05/01/10', 'RR/MM/DD'), 'RRRR') date_RR
FROM dual;

SELECT 
'97/01/10' -- 문자열
, TO_CHAR(TO_DATE('97/01/10', 'YY/MM/DD'), 'YYYY') date_YY
, TO_CHAR(TO_DATE('97/01/10', 'RR/MM/DD'), 'RRRR') date_RR
FROM dual;

SELECT name, ibsadate
FROM insa;

-- ORDER BY 절
-- 1차적으로 부서별로 오름차순 정렬 후
-- 2차적으로 pay 내림차순
SELECT deptno, ename, sal+NVL(comm, 0) pay
FROM emp
ORDER BY 1 ASC, 3 DESC;  --OREDER BY deptno ASC, pay DESC;

--오라클 연산자 (operator) 정리
-- 1) 비교 연산자 : WHERE 절에서 숫자, 날짜, 문자 크기나 순서를 비교하는 연산자
--              =, !=, ^=, <> > < >= <=
--      ANY, SOME, ALL : 비교연산자 동시에 SQL 연산자
--      TRUE, FALSE, NULL 반환
SELECT ename, sal
FROM emp
WHERE sal = null;
WHERE sal <= 1250;
WHERE sal < 1250;
WHERE sal >= 1250;
WHERE sal > 1250;
WHERE sal != 1250;
WHERE sal = 1250;

--ANY
--SOME
--ALL
-- emp 테이블에서 평균급여보다 많이 받는 사원들의 정보를 조회
-- 1. emp 테이블의 평균 급여? avg() 집계함수, 그룹함수
SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp;

SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= (SELECT AVG(sal+NVL(comm,0)) avg_pay
                            FROM emp);
-- WHERE sal+NVL(comm,0) >= 2260.416666666666666666666667;
-- [문제] 각 부서별 평균 급여보다 많이 받는 사원들의 정보를 조회.
SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 10; -- 10번 부서원들 평균

SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 20; -- 20번 부서원들 평균

SELECT AVG(sal+NVL(comm,0)) avg_pay
FROM emp
WHERE deptno = 30; -- 30번 부서원들 평균

SELECT *
FROM emp
WHERE deptno = 10 AND sal+NVL(comm,0) >= 2916.666666666666666666
UNION
SELECT *
FROM emp
WHERE deptno = 20 AND sal+NVL(comm,0) >= 2258.333333333333333333
UNION
SELECT *
FROM emp
WHERE deptno = 30 AND sal+NVL(comm,0) >= 1933.333333333333333333;

-- [문제] 30번 부서의 최고 급여보다 많이 받는 사원들의 정보를 조회.
SELECT *
FROM emp
--WHERE sal+NVL(comm,0) > (ALL (sal+NVL(comm,0) max_pay_30
--                            FROM emp
--                            WHERE deptno = 30));
WHERE sal+NVL(comm,0) > (SELECT MAX(sal+NVL(comm,0)) max_pay_30
                            FROM emp
                            WHERE deptno = 30);

SELECT ename,empno 
FROM emp
WHERE deptno=10 AND job='CLERK';

SELECT ename,empno 
FROM emp
where deptno NOT IN(10,30);

WITH temp AS (SELECT sal+NVL(comm,0) pay FROM emp)
SELECT MAX(pay)
,MIN(pay)
,AVG(pay)
,SUM(pay)
FROM temp;

WITH temp AS (SELECT sal+NVL(comm,0) pay FROM emp)
SELECT MAX(pay)
,MIN(pay)
,AVG(pay)
,SUM(pay)
FROM temp;

-- 상관 서브 쿼리(correlated subquery)
-- [1]사원 전체에서 최고 급여를 받는 사원의 정보를 조회, 사원명, 사원번호, 급여액, 부서번호
SELECT empno, ename, sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
                            FROM emp
                            );
                    
SELECT deptno, empno, ename, sal+NVL(comm,0) pay
FROM emp
ORDER BY pay ASC;

-- [2]각 부서별 최고 급여를 받는 사원의 정보를 조회(출력)
SELECT empno, ename, sal+NVL(comm,0) pay, deptno
FROM emp p
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
                            FROM emp c
                            WHERE deptno = p.deptno)
ORDER BY deptno ASC;

-- 각 부서별 평균보다 큰 부서원들 정보 조회
SELECT deptno,ename,sal
-- ****** ORA-00937: not a single-group group function
-- 집계합수는 SELECT절에서 일반칼럼들이랑 같이 못씀
,(SELECT AVG(sal) FROM emp WHERE deptno = t1.deptno)
FROM emp t1
WHERE sal > (SELECT AVG(sal)
            FROM emp t2
            WHERE t2.deptno=t1.deptno)
ORDER BY deptno ASC;          

--UNION                            
--SELECT empno, ename, sal+NVL(comm,0) pay, deptno
--FROM emp
--WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
--                            FROM emp
--                            WHERE deptno = 20)
--UNION                            
--SELECT empno, ename, sal+NVL(comm,0) pay, deptno
--FROM emp
--WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay
--                            FROM emp
--                            WHERE deptno = 30)
--ORDER BY deptno;

-- 2) 
--오라클 함수 (function) 정리
--
--오라클 자료형(data type) 정리















