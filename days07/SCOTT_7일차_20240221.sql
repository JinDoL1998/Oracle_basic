-- [1] insa 테이블에서 각 부서별 사원수 조회
-- ㄱ. SET 집합 연산자  UNION, UNION ALL
-- ㄴ. 상관서브쿼리

SELECT buseo, COUNT(*) "사원수"
FROM insa
GROUP BY buseo;

SELECT DISTINCT buseo
, (SELECT COUNT(*) cnt
FROM insa 
WHERE buseo = p.buseo) cnt
FROM insa p;

-- [2] emp 테이블에서 급여의 순서
-- [1] rank()
SELECT *
FROM(
    SELECT empno, ename
    ,sal+NVL(comm,0) pay
    ,RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) rank
    FROM emp
)
WHERE rank <= 3;

-- [2] 로직 
SELECT 
(SELECT COUNT(*)+1 FROM emp c WHERE sal+NVL(comm,0) > (p.sal+NVL(comm,0))) pay_rank
,p.*
FROM emp p
ORDER BY pay_rank;

-- [3] TOP-N
SELECT *
FROM emp;

-- [3] insa 테이블에서 남자사원수, 여자사원수 조회
-- ㄱ. SET
-- ㄴ. GROUP BY
-- ㄷ. DECODE
SELECT COUNT(*) "전체사원수"
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, '남자')) "남자사원수"
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, '여자')) "여자사원수"
FROM insa;

SELECT
 DECODE(MOD(SUBSTR(ssn,8,1),2),1 ,'0')
FROM insa;

SELECT DECODE(gender,1,'남자','여자') "사원수", COUNT(*)
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn,8,1),2) gender
    FROM insa
    )
GROUP BY gender
UNION ALL
SELECT '전체', COUNT(*)
FROM insa;

SELECT COUNT(*)
FROM insa;

-- [4] emp 각 부서별 사원수 조회
SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- [4-2] 위의 실행 결과물에 부서번호가 아니라 부서명이 출력
SELECT dname, COUNT(*)
FROM dept d JOIN emp e ON e.deptno = d.deptno
GROUP BY dname
UNION ALL
SELECT 'OPERATIONS', COUNT(*)
FROM emp
WHERE deptno = 40
ORDER BY dname ASC;

SELECT dname, COUNT(e.deptno)
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY dname;


SELECT COUNT(*)
,COUNT(DECODE(deptno, 10, 'O')) "10"
,COUNT(DECODE(deptno, 20, 'O')) "20"
,COUNT(DECODE(deptno, 30, 'O')) "30"
,COUNT(DECODE(deptno, 40, 'O')) "40"
FROM emp;

-- [5] insa 테이블에서 생일 후, 생일 전, 오늘 생일
-- DECODE 함수 사용
-- ㄱ. 1002번 사원의 주민등록번호 800221-1544236 update 쿼리 실행
SELECT SYSDATE
,TO_CHAR(SYSDATE, 'DD')
FROM dual;

UPDATE insa
SET ssn = SUBSTR(ssn,1,2) || TO_CHAR(SYSDATE,'MMDD') || SUBSTR(ssn, 7)
WHERE num IN (1001, 1002);
COMMIT; 

SELECT num, name, ssn
,DECODE(s,1,'생일전',0,'오늘',-1,'생일 후') s
,CASE s
    WHEN 1 THEN '생일 전'
    WHEN 0 THEN '오늘'
    ELSE '생일 후'
END 별칭
FROM(
    SELECT num, name, ssn
    ,TRUNC(SYSDATE)
    ,SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) s
    ,CASE 
        WHEN TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE) > 0 THEN '생일 전'
        WHEN TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE) = 0 THEN '오늘'
        ELSE '생일 후'
    END 별칭
    FROM insa
);

-- [5-2] emp 테이블에서 10번 부서원 sal 10%인상 20번 부서원 15% 인상, 그 외 부서는 5% 인상
SELECT deptno, ename, sal
,sal*DECODE(deptno, 10, 1.1, 20, 1.15, 1.05) increase_rate
FROM emp;

SELECT deptno, ename, sal 
,CASE
    WHEN deptno = 10 THEN sal*1.1
    WHEN deptno = 20 THEN sal*1.15
    ELSE sal*1.05
END increase_sal
FROM emp;

-- [문제] insa 테이블에서 총사원수, 생일전 사원수, 오늘생일사원수, 생일후 사원수 출력
-- [1]
SELECT COUNT(*)
,COUNT(DECODE(s, 1, '생일')) "생일 전 사원수"
,COUNT(DECODE(s, 0, '생일')) "오늘 생일 사원수"
,COUNT(DECODE(s, -1, '생일')) "생일 후 사원수"
FROM (
    SELECT 
    SIGN(TO_DATE(SUBSTR(ssn, 3, 4),'MMDD') - TRUNC(SYSDATE)) s
    FROM insa
    );

-- [2]
SELECT 
CASE s
    WHEN 1 THEN '생일 전'
    WHEN 0 THEN '오늘 생일'
    ELSE '생일 후'
END 생일여부
, COUNT(*)
FROM (
    SELECT 
    SIGN(TO_DATE(SUBSTR(ssn, 3, 4),'MMDD') - TRUNC(SYSDATE)) s
    FROM insa
    )t
GROUP BY s;

-- [문제] emp 테이블에서 평균 pay 보다 같거나 많은 사원들의 급여합을 출력
-- [1]
WITH a AS (
        SELECT TO_CHAR(AVG(sal+NVL(comm,0)), '9999.00') avg_pay
        FROM emp
    )
    ,b AS (
        SELECT empno, ename, sal+NVL(comm,0) pay
        FROM emp
    )
SELECT '평균 급여 이상 합', SUM(b.pay) "평균 급여 이상 합"
FROM a, b
WHERE b.pay >= a.avg_pay;

-- [2]
SELECT SUM(sal+NVL(comm,0)) pay
FROM emp
WHERE sal+NVL(comm,0) >= (SELECT ROUND(AVG(sal+NVL(comm,0)),2) FROM emp);

-- [3]
SELECT 
    SUM(DECODE( SIGN(pay - avg_pay), 1, pay ))
    , SUM(CASE
        WHEN pay-avg_pay > 0 THEN pay
        ELSE                      NULL
    END)
FROM(
    SELECT empno, ename, sal+NVL(comm,0) pay
            ,(SELECT ROUND(AVG(sal+NVL(comm,0)),2) FROM emp) avg_pay
    FROM emp
);

-- [문제] emp, dept 테이블을 사용해서 
-- 사원이 존재하지 않는 부서의 부서번호, 부서명 출력
-- [1]
SELECT d.deptno, dname
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
WHERE e.empno IS NULL;

-- [2]
SELECT dname, deptno
FROM dept
WHERE deptno = (
            SELECT deptno
            FROM dept
            MINUS
            SELECT DISTINCT deptno
            FROM emp);

SELECT t.deptno, d.dname
FROM dept d JOIN (
            SELECT deptno
            FROM dept
            MINUS
            SELECT DISTINCT deptno
            FROM emp
            ) t
            ON  t.deptno = d.deptno;
            
SELECT p.deptno, p.dname
FROM dept p
--WHERE (SELECT COUNT(*) FROM emp WHERE deptno = p.deptno) = 0;
WHERE EXISTS (SELECT empno FROM emp WHERE deptno = p.deptno);


--SELECT d.deptno, d.dname, COUNT(empno) cnt
--FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno

-- HAVING 절

SELECT d.deptno, d.dname, COUNT(empno) cnt
            FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno
            -- WHERE cnt = 0  -- ORA-00904: "CNT": invalid identifier
            GROUP BY d.deptno, d.dname
            HAVING COUNT(empno) = 0
            ORDER BY d.deptno;

-- [문제] insa 테이블에서 각 부서별 여자사원수를 파악해서 5명이상인 정보 출력
SELECT buseo, COUNT(buseo) cnt
FROM (  
    SELECT num, name, buseo,ssn
    ,MOD(SUBSTR(ssn, 8, 1),2) gender
    FROM insa
)
WHERE gender = 0
GROUP BY buseo
HAVING COUNT(buseo) >= 5;

-- [문제] emp 테이블에서 부서별, job별 사원의 총급여함
SELECT deptno, job
, COUNT(*) cnt
, SUM(sal+NVL(comm,0)) deptno_pay_sum
, AVG(sal+NVL(comm,0)) deptno_pay_avg
, MAX(sal+NVL(comm,0)) deptno_pay_max
, MIN(sal+NVL(comm,0)) deptno_pay_min
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;

-- (암기) Oracle 10g PARTITION OUTER JOIN 구문
WITH t AS(
            SELECT DISTINCT job
            FROM emp
        )
SELECT deptno, t.job, NVL(SUM(sal+NVL(comm,0)),0) d_j_pay_sum
FROM t LEFT OUTER JOIN emp e PARTITION BY(deptno) ON t.job = e.job
GROUP BY deptno, t.job
ORDER BY deptno;

-- GROUPING SETS 절
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT job, COUNT(*)
FROM emp
GROUP BY job;

SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY GROUPING SETS(deptno, job);

-- LISTAGG(함수)
SELECT ename
FROM emp
WHERE deptno = 10;

SELECT ename
FROM emp
WHERE deptno = 20;

SELECT ename
FROM emp
WHERE deptno = 30;

--(암기)
SELECT d.deptno
,NVL(LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename), '사원이 존재하지 않습니다.') "부서별 명단" -- ename의 LIST 목록 집합
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno;

SELECT *
FROM salgrade; -- 급여 등급 테이블
--grade losal   hisal
--1	    700 	1200
--2	    1201	1400
--3	    1401	2000
--4	    2001	3000
--5	    3001	9999
SELECT ename, sal
, CASE
    WHEN sal BETWEEN 700 AND 1200 THEN 1
    WHEN sal BETWEEN 1201 AND 1400 THEN 2
    WHEN sal BETWEEN 1401 AND 2000 THEN 3
    WHEN sal BETWEEN 2001 AND 3000 THEN 4
    WHEN sal BETWEEN 3001 AND 9999 THEN 5
    
  END grade
FROM emp;

-- [salgrade 테이블 + emp 테이블 조인]
-- JOIN ON 구문       NON equal 조인
SELECT ename, sal, losal || '-' || hisal "RANGE", grade
FROM emp JOIN salgrade ON sal BETWEEN losal AND hisal;

-- [정규 표현식 오라클 함수]
SELECT * 
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d');

-- [순위 함수]
-- 1) RANK()
-- 2) DENSE_RANK()
-- 3) PERCENT_RANK()
-- 4) ROW_NUMBER()
-- 5) FIRST() / LAST()

-- [문제] emp 테이블에서 sal 순위 매겨보자
SELECT empno, ename, sal
,RANK() OVER(ORDER BY sal DESC) r_rank
,DENSE_RANK() OVER(ORDER BY sal DESC) d_rank
,ROW_NUMBER() OVER(ORDER BY sal DESC) rn_rank
FROM emp;
--7654	MARTIN	1250	9	9	9
--7521	WARD	1250	9	9	10
--7900	JAMES	950	    11	10	11

SELECT empno, ename, sal, deptno
,RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) r_rank
,DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) d_rank
,ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rn_rank
FROM emp;

-- [문제] emp 테이블에서 각 사원들 급여를 전체 순위, 부서내 순위를 출력
SELECT deptno, ename, pay
,RANK() OVER(ORDER BY pay) total_rank
,RANK() OVER(PARTITION BY deptno ORDER BY pay) dept_rank
FROM(
SELECT deptno,empno, ename, sal+NVL(comm,0) pay
FROM emp
)
ORDER BY deptno ASC;

-- [ROLLUP/CUBE 연산자]
-- insa 테이블에서
-- 남자사원수 : 31명
-- 여자사원수 : 29명
-- 전체사원수 : 60명

-- [1]
SELECT DECODE(gender,1,'남자사원수', 0,'여자사원수') 사원수, COUNT(*) || '명'
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)
GROUP BY gender
UNION ALL
SELECT '전체 사원수', COUNT(*) || '명'
FROM insa;

-- [2]
SELECT COUNT(*)
,COUNT(DECODE())
,COUNT(DECODE())
FROM insa;

-- [3]
SELECT DECODE(gender,1,'남자사원수', 0,'여자사원수', '전체사원수') 사원수, COUNT(*) || '명' "인원 수"
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)
GROUP BY CUBE(gender);
GROUP BY ROLLUP(gender); 

-- 예2)

SELECT buseo, jikwi, COUNT(*) cnt
,SUM(basicpay) 직급별급여합
FROM insa
--GROUP BY ROLLUP(buseo, jikwi) 
--GROUP BY CUBE(buseo, jikwi) 
GROUP BY buseo, ROLLUP(jikwi) 
ORDER BY buseo;

-- [문제] emp 테이블에서 가장 빨리 입사한 사원과 가장 늦게(최근)에 입사한 사원의 정보 조회
--        입사한 차의 일수

SELECT ename, hiredate, d
FROM(
    SELECT ename, hiredate
    ,TO_NUMBER((TO_CHAR(hiredate,'YYMMDD'))) d
    FROM emp 
) e
WHERE e.d = (SELECT MAX(TO_NUMBER((TO_CHAR(hiredate,'YYMMDD')))) FROM emp);

SELECT 
MAX(hiredate)
,MIN(hiredate)
,MAX(hiredate) - MIN(hiredate)
FROM emp;

-- [문제]  insa 테이블에서 각 사원들의 만나이를 계산해서 출력
-- 1) 만나이 = 올해년도 - 생일년도 (생일 안지났으면 -1)
--      ㄱ. 생일 지났는 여부
--      ㄴ. 981223-1XXXXXX
SELECT name, ssn, birth_year, current_year, s
, current_year - birth_year + DECODE(s, 1, -1, -1, 0, 0, -1) || '세' "만 나이"
FROM(
SELECT ssn, name
,CASE
    WHEN gender IN (1,2) THEN '19' || year
    WHEN gender IN (3,4) THEN '20' || year
    WHEN gender IN (8,9) THEN '18' || year
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

-- [2]
SELECT t.name, t.ssn
, 올해년도-생일년도 + CASE S 
                        WHEN 1 THEN -1
                        ELSE 0
                    END 만나이
FROM(
    SELECT name, ssn
    ,TO_CHAR(SYSDATE, 'YYYY') 올해년도
    ,CASE
        WHEN SUBSTR(ssn,8,1) IN (1,2,5,6) THEN 1900
        WHEN SUBSTR(ssn,8,1) IN (3,4,7,8) THEN 2000
        ELSE 1800
    END + SUBSTR(ssn,1,2) 생일년도
    , SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD')-TRUNC(SYSDATE)) s -- 생일전, 오늘생일, 생일후
    FROM insa
    ) t;

SELECT 
TO_CHAR(SYSDATE,'MMDD') 
FROM dual;

SELECT *
FROM insa;



