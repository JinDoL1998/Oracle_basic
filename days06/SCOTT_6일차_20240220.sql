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
, TO_CHAR(SYSDATE, 'CC')
, TO_CHAR(SYSDATE, 'DDD') -- 올해 지난 날짜
FROM dual;







