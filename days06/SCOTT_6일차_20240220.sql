-- SCOTT
-- [문제] 사원 정보를 출력(부서번호, 부서명, 사원명, 입사일자)
-- dept : deptno, dname, loc
-- emp : deptno, empno, enmae, sla, job, comm, hiredate

SELECT d.deptno, e.ename, e.hiredate, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT d.deptno, e.ename, e.hiredate, d.dname
FROM emp e JOIN dept d ON e.deptno = d.deptno; -- 조인 조건절

-- 14. emp 테이블에서 급여 TOP3 조회
-- TOP-N분석 법 (시험)
SELECT ROWNUM, e.*
FROM(
    SELECT deptno, ename, sal+NVL(comm,0) pay
    FROM emp
    ORDER BY pay DESC
    ) e
WHERE ROWNUM <=3 ;

WHERE ROWNUM BETWEEN 3 AND 5; -- X
WHERE ROWNUM > 3;   -- X 첫번째 값부터 가져올 수 있다

-- [2]
SELECT e.*
FROM(
    SELECT 
    RANK() OVER( ORDER BY sal+NVL(comm,0) DESC) "pay_rank"
    ,empno, ename, hiredate, sal+NVL(comm,0) pay
    FROM emp
) e
WHERE e."pay_rank" = 1;

-- 각 부서별 pay 2등까지 출력 (시험)
SELECT e.*
FROM(
    SELECT 
    deptno
    ,RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC, ename) deptno_pay_rank
    ,empno, ename, hiredate, sal+NVL(comm,0) pay
    FROM emp
) e
WHERE e.deptno_pay_rank BETWEEN 2 AND 3;

---------------------------------------------------------------------------------
--TO_CHAR(NUMBER) : 숫자 -> 문자 변환
--TO_CHAR(DATE) : 날짜 -> 문자 변환
SELECT SYSDATE
, TO_CHAR(SYSDATE, 'CC') a
, TO_CHAR(SYSDATE, 'DDD') b-- 올해 지난 날짜

, TO_CHAR(SYSDATE, 'W') c --08 년중 몇번째 주
, TO_CHAR(SYSDATE, 'W') d -- 3  달중 몇번째 주
, TO_CHAR(SYSDATE, 'IW') e -- 08 1년중 몇째주
FROM dual;

-- ww : 1월1일 부터 7일 간격으로 
SELECT 
TO_CHAR(TO_DATE('2024.01.01'), 'WW') a
,TO_CHAR(TO_DATE('2024.01.02'), 'WW') b
,TO_CHAR(TO_DATE('2024.01.03'), 'WW') c
,TO_CHAR(TO_DATE('2024.01.04'), 'WW') d
,TO_CHAR(TO_DATE('2024.01.05'), 'WW') e
,TO_CHAR(TO_DATE('2024.01.06'), 'WW') f
,TO_CHAR(TO_DATE('2024.01.07'), 'WW') g
,TO_CHAR(TO_DATE('2024.01.08'), 'WW') h
,TO_CHAR(TO_DATE('2024.01.14'), 'WW') i
FROM dual;

-- iw : ISO 표준 주 월요일 ~ 일요일 1주일
SELECT 
TO_CHAR(TO_DATE('2022.01.01'), 'iw') a
,TO_CHAR(TO_DATE('2022.01.02'), 'iw') b
,TO_CHAR(TO_DATE('2022.01.03'), 'iw') c
,TO_CHAR(TO_DATE('2022.01.04'), 'iw') d
,TO_CHAR(TO_DATE('2022.01.05'), 'iw') e
,TO_CHAR(TO_DATE('2022.01.06'), 'iw') f
,TO_CHAR(TO_DATE('2022.01.07'), 'iw') g
,TO_CHAR(TO_DATE('2022.01.08'), 'iw') h
,TO_CHAR(TO_DATE('2022.01.14'), 'iw') i
,TO_CHAR(TO_DATE('2022.01.15'), 'iw') j
FROM dual;

SELECT 
TO_CHAR(SYSDATE, 'BC')
,TO_CHAR(SYSDATE, 'Q') -- 1분기, 2분기, 3분기, 4분기
FROM dual;

SELECT 
TO_CHAR(SYSDATE, 'HH') a
,TO_CHAR(SYSDATE, 'HH24') b
,TO_CHAR(SYSDATE, 'MI') c
,TO_CHAR(SYSDATE, 'SS') d

,TO_CHAR(SYSDATE, 'DY') e
,TO_CHAR(SYSDATE, 'DAY') f

,TO_CHAR(SYSDATE, 'DL') g -- Long 2024년 2월 20일 화요일
,TO_CHAR(SYSDATE, 'DS') h -- Short 2024/02/20
FROM dual;


SELECT ename, hiredate
,TO_CHAR(hiredate, 'DL')
,TO_CHAR(SYSDATE, 'TS')  -- 오후 3:51:27

,TO_CHAR(CURRENT_TIMESTAMP, 'HH24:MI:SS.FF')
FROM emp;

-- [문제] 오늘 날짜를 TO_CHAR() 함수를 사용해서
-- 2024년 02월 20일 오후 xx:xx:xx(화)

SELECT 
SUBSTR(TO_CHAR(SYSDATE,'DL '),1, 13) 
|| TO_CHAR(SYSDATE, 'TS (DY)') "날짜"

, TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" AM HH24:MI:SS (DY)') "접미어 사용"
FROM dual;

SELECT name, ssn
, SUBSTR(ssn, 1, 6)
, TO_DATE(SUBSTR(ssn, 1, 6))
, TO_CHAR(TO_DATE(SUBSTR(ssn, 1, 6)), 'DL')
FROM insa;

SELECT 
TO_DATE('0821', 'MMDD')
,TO_DATE('2023', 'YYYY')
,TO_DATE('202312', 'YYYYMM')
, TO_DATE('23년 01월 12일', 'YY"년" MM"월" DD"일"')
FROM dual;

-- [문제] 수료일 '6/14' 오늘부터 남은 일수 ?
-- ORA-01821: date format not recognized
SELECT SYSDATE
, TO_DATE('6/14', 'MM/DD')
, CEIL(ABS(SYSDATE - TO_DATE('6/14', 'MM/DD')))
FROM dual;

-- [문제] 4자리 부서번호로 출력
SELECT deptno
, LPAD(deptno, 4, '0')
, CONCAT('00', deptno)
, TO_CHAR(deptno, '0999')
FROM emp;

-- java
-- if(a==b) c

-- Oracle 
-- DECODE(a,b,c)

--if(a == b) c
--else d

-- DECODE(a,b,c,d)

--if (a == b) c
--else if (a == d) e
--else if (a == f) g
--else h

-- DECODE(a,b,c, d,e, f,g, h)

-- [문제] insa테이블에서 남자/여자

SELECT name, ssn, gender
, DECODE(gender, 1, '남자', '여자') AS "성별"
FROM(
    SELECT name, ssn
    ,MOD(SUBSTR(ssn, 8, 1),2) gender
    FROM insa
);

SELECT name, ssn, birth_date
,DECODE(birth_date,1,'안지남',0,'오늘',-1,'지남') "생일 지났는가"
FROM(
    SELECT name, ssn
    ,SIGN(TO_DATE(SUBSTR(ssn,3,4), 'MMDD') - TRUNC(SYSDATE)) birth_date
    FROM insa
); 

-- [문제] emp 테이블에서 각 사원의 번호, 이름, 급여 출력
-- 조건) 10번 부서원들은 급여의 15% 인상해서 급여
-- 조건) 20번 부서원들은 급여의 10% 인상해서 급여
-- 조건) 30번 부서원들은 급여의 5% 인상해서 급여

SELECT deptno, empno, ename, pay
,pay * (1+DECODE(deptno, 10, 0.15, 20, 0.1, 30, 0.05)) rate
FROM(
    SELECT deptno, empno, ename, sal+NVL(comm,0) pay
    FROM emp
);