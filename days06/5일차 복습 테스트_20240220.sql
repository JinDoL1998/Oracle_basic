-- SCOTT
--2.emp 테이블에서 급여와 평균급여를 구하고
--   각 사원의 급여-평균급여를 소수점 3자리에서 올림,반올림,내림해서 아래와 
--   같이 조회하는 쿼리를 작성하세요.
-- [1]
SELECT ename, pay, ROUND(avg_pay,2) avg_pay
, CEIL((pay - avg_pay)*100)/100  "차 올림"
, ROUND((pay - avg_pay),2) "차 반올림"
, TRUNC((pay - avg_pay), 2) "차 내림"
FROM(
    SELECT ename, sal+NVL(comm, 0) pay
    ,ROUND((SELECT AVG(sal+NVL(comm, 0)) FROM emp),3) avg_pay
    FROM emp
);

-- [2]
WITH temp AS(
            SELECT ename, sal+NVL(comm,0) pay
            , (SELECT AVG(sal+NVL(comm,0)) FROM emp) avg_pay
            FROM emp
            )
SELECT ename, pay, ROUND(avg_pay,2)
, CEIL((t.pay - t.avg_pay) * 100) / 100 "차 올림"
, ROUND(t.pay - t.avg_pay, 2) "차 반올림"
, TRUNC(t.pay - t.avg_pay, 2) "차 내림"
FROM temp t;

--2-2. emp 테이블에서 급여와 평균급여를 구하고
--    각 사원의 급여가 평균급여 보다 많으면 "많다"
--                   평균급여 보다 적으면 "적다"라고 출력
-- [1]
SELECT ename, pay, avg_pay
, NVL2(NULLIF(SIGN(pay - avg_pay), 1), '적다', '많다')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    ,ROUND((SELECT AVG(sal+NVL(comm, 0))FROM emp),2) avg_pay
    FROM emp
    );

--3. insa 테이블에서 남자사원수, 여자사원수를 출력 
--[ 실행결과 ]
-- 성별        사원수
--남자사원수	31
--여자사원수	29
--[1]
SELECT REPLACE(REPLACE(gender,0,'여자'), 1, '남자') || '사원수' 성별
, COUNT(*) 사원수
FROM(
    SELECT name, MOD(SUBSTR(ssn, 8, 1),2) gender
    FROM insa
    )
GROUP BY gender;

--insa 테이블에서 모든 사원들을 14명씩 팀을 만드면 총 몇 팀이 나올지를 쿼리로 작성하세요. 
SELECT CEIL(COUNT(*) / 14)
FROM insa;


--6. emp 테이블에서 최고 급여자, 최저 급여자 정보 모두 조회
--  [실행결과]
--empno   ename   job     mgr     hiredate   pay      deptno  etc
--7369	SMITH	CLERK	 7902	 80/12/17	 800	    20   최고급여자
--7839	KING	PRESIDENT		 81/11/17	 5000		10   최저급여자

-- [1]
SELECT empno, ename, job, mgr, hiredate
,sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) IN (  SELECT MAX(sal+NVL(comm,0)) max_pay, 
                        MIN(sal+NVL(comm,0)) min_pay FROM emp ); --X
WHERE sal+NVL(comm,0) IN (
                   (SELECT MAX(sal+NVL(comm,0)) max_pay FROM emp)
                  , (SELECT MIN(sal+NVL(comm,0)) min_pay FROM emp) 
      );  
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) FROM emp)
OR sal+NVL(comm,0) = (SELECT MIN(sal+NVL(comm,0)) FROM emp);


SELECT empno, ename, job, mgr, hiredate
,sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) FROM emp)
UNION
SELECT empno, ename, job, mgr, hiredate
,sal+NVL(comm,0) pay, deptno
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MIN(sal+NVL(comm,0)) FROM emp);


--7.  emp 테이블에서 
--   comm 이 400 이하인 사원의 정보 조회
--  ( 조건 : comm 이 null 인 사원도 포함 )
-- LNNVL() 함수
-- LNNVL(null) => true
SELECT ename, sal, comm
FROM emp
WHERE LNNVL(comm >= 400);

--8. emp 테이블에서 [각 부서별] 급여(pay)를 가장 많이 받는 사원의 정보 출력.    
--   ㄱ. Correlated Subquery(상호연관 서브쿼리) 사용해서 풀기
SELECT *
FROM emp p
WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) 
                         FROM emp c WHERE deptno = p.deptno);
                         
-- 9. emp 테이블에서 30번 부서만 PAY를 계산 후 막대그래프를 아래와 같이 그리는 쿼리 작성
--( 필요한 부분은 결과 분석하세요~    PAY가 100 단위당 # 한개 , 반올림처리 )
--[실행결과]
--DEPTNO ENAME  PAY     BAR_LENGTH      
------------ ---------- ---------- ----------
--30	BLAKE	2850	29	 #############################
--30	MARTIN	2650	27	 ###########################
--30	ALLEN	1900	19	 ###################
--30	WARD	1750	18	 ##################
--30	TURNER	1500	15	 ###############
--30	JAMES	950	    10	 ##########                 

SELECT deptno, ename, pay
,RPAD(CEIL(pay/100), CEIL(pay/100) ,'#') "BAR_LENGTH"
FROM(    
    SELECT deptno, ename, sal+NVL(comm,0) pay
    FROM emp
)
WHERE deptno = 30
ORDER BY pay DESC;

-- 13. emp 에서 평균PAY 보다 같거나 큰 사원들만의 급여합을 출력.
-- [1]
SELECT ename, sal, comm, sal+NVL(comm,0) pay
, ROUND((SELECT AVG(sal+NVL(comm,0)) FROM emp),5) avg_pay
FROM emp
WHERE sal+NVL(comm,0) >= (
                            ROUND((SELECT AVG(sal+NVL(comm,0)) FROM emp),5) 
                            );
                            
-- [2]




-- 17. insa 테이블에서
-- 사원번호(num) 가  1002 인 사원의 주민번호의 월,일만을 오늘날짜로 수정하세요.
--                              ssn = '80XXXX-1544236'    
SELECT num, name, ssn
,SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7)
FROM insa
WHERE num = 1002;  

UPDATE insa
SET ssn = SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7)
WHERE num = 1002;

COMMIT;

SELECT num, name, ssn
FROM insa
WHERE num = 1002;

SELECT SYSDATE
,TO_CHAR(SYSDATE, 'YYYY') year
,TO_CHAR(SYSDATE, 'MM') MONTH
,TO_CHAR(SYSDATE, 'DD') "DATE"
,TO_CHAR(SYSDATE, 'DY') day
,TO_CHAR(SYSDATE, 'MM.DD') md
FROM dual;
-- 17-2 insa 테이블에서 오늘을 기준으로 생일이 지남 여부를 출력하는 쿼리를 작성하세요 . 
SELECT name, ssn , SYSDATE
,SUBSTR(ssn,3,4) ssn_md
,SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) "생일" -- 양수(생일 후) , 0 (오늘), 음수 (생일 전)
,REPLACE(REPLACE(REPLACE(SIGN( TO_DATE( SUBSTR( ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)),-1,'지남'),0,'오늘'),1,'안지남') ㄹ

FROM insa;

--18. emp 테이블의 ename, pay , 최대pay값 5000을 100%로 계산해서
--   각 사원의 pay를 백분률로 계산해서 10% 당 별하나(*)로 처리해서 출력
--   ( 소숫점 첫 째 자리에서 반올림해서 출력 )
-- [1]
SELECT ename, pay, max_pay
,pay/max_pay * 100 || '%' "퍼센트"
, RPAD(ROUND(pay/max_pay * 10),ROUND(pay/max_pay * 10)+1, '*') "별 갯수"
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    , (SELECT MAX(sal+NVL(comm,0)) FROM emp) max_pay
    FROM emp
);

-- [2]
WITH t AS(
SELECT ename, sal+NVL(comm, 0) pay
,(SELECT SUM(sal+NVL(comm,0)) FROM emp) sum_pay
FROM emp
)
SELECT t.ename, t.pay, t.sum_pay
,ROUND(t.pay/t.sum_pay * 100,2) || '%' percent
,ROUND(t.pay/t.sum_pay * 100) star_count
,RPAD(' ', (t.pay/t.sum_pay * 100)+1, '*') star_graph
FROM t;



























