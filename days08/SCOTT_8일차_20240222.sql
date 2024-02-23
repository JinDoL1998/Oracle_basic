
-- 자바       임의의 난수      0.0 <= double Math.random() < 1.0
-- 오라클      dbms_random 패키지     !=   자바 패키지 java.io
--            서로 관련된 PL/SQL(프로시적, 함수)들의 묶음    서로 관련된 클래스들의 묶음 

SELECT
--SYS.dbms_random.value -- 0.0 <=  실수  < 1.0
--,SYS.dbms_random.value(0,100) -- 0.0 <=  실수  < 100
--SYS.dbms_random.string('U', 5) -- Upper(대문자) 자동으로 5개 발생
--SYS.dbms_random.string('X', 5) -- 대문자 + 숫자
SYS.dbms_random.string('P', 5) -- 대문자 + 숫자 + 특수문자
--SYS.dbms_random.string('L', 5) -- Lower(소문자) 
--SYS.dbms_random.string('A',5) -- 알파벳
FROM dual;

-- [문제] 임의의 국어점수를 1개 발생시켜서 출력하세요.
-- [문제] 임의의 로또번호를 1개 발생시켜서 출력하세요
SELECT
TRUNC(SYS.dbms_random.value(0,101)) 국어점수
,TRUNC(SYS.dbms_random.value(1,46)) 로또번호
FROM dual;

-- [피봇(pivot) 설명] (암기)
-- pivot 사전적 의미 : 축을 중심으로 회전시키다
--      ㄴ 모니터 가로/세로 - 피벗 기능
-- SELECT * 
--  FROM (피벗 대상 쿼리문)
-- PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...))

SELECT empno, ename
, job
FROM emp;
-- 각 job별로 사원수가 몇명인지 조회.

SELECT job, COUNT(*)
FROM emp e
GROUP BY ROLLUP(job);

-- 1) 피봇 대상 쿼리문
SELECT job
FROM emp;

-- 2) 피봇 함수 처리
SELECT *
FROM (
    SELECT job
    FROM emp
    )
PIVOT( COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));

SELECT
COUNT(DECODE(job, 'CLERK', 'O')) CLERK
,COUNT(DECODE(job, 'SALESMAN', 'O')) SALESMAN
,COUNT(DECODE(job, 'PRESIDENT', 'O')) PRESIDENT
,COUNT(DECODE(job, 'MANAGER', 'O')) MANAGER
,COUNT(DECODE(job, 'ANALYST', 'O')) ANALYST
FROM emp;

-- 실습2) 월별 입사한 사원의 수를 파악
SELECT *
FROM(
    SELECT
    TO_CHAR(hiredate, 'MM') 입사월
    FROM emp
)
PIVOT(COUNT(입사월) FOR 입사월 IN ('01' AS "1월", '02' "2월",'03' "3월",'04' "4월",'05' "5월",'06' "6월"
                                ,'07' "7월",'08' "8월",'09' "9월",'10' "10월",'11' "11월",'12' "12월"));
                                
SELECT
TO_CHAR(hiredate, 'MM') MONTH
,TO_CHAR(hiredate, 'FMMM') || '월' month
, EXTRACT(MONTH FROM hiredate)|| '월' month
FROM emp;

-- [실습] 연도별 월별 입사 한 사원
SELECT *
FROM(
    SELECT
    TO_CHAR(hiredate, 'YYYY') 입사년
    ,TO_CHAR(hiredate, 'MM') 입사월
    FROM emp
)
PIVOT(COUNT(입사월) FOR 입사월 IN ('01' AS "1월", '02' "2월",'03' "3월",'04' "4월",'05' "5월",'06' "6월"
                                ,'07' "7월",'08' "8월",'09' "9월",'10' "10월",'11' "11월",'12' "12월"));

-- [문제] emp 테이블에서 각 부서별 , job의 사원수를 조회
SELECT *
FROM(
    SELECT
    d.deptno, dname, job
    FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
)
PIVOT(COUNT(job) FOR job IN ('CLERK', 'SALESMAN', 'MANAGER', 'PRESIDENT', 'ANALYST')) 
ORDER BY deptno;

-- 실습)
SELECT job, deptno, sal
FROM emp;
--
SELECT *
FROM (
    SELECT job, deptno, sal
    FROM emp
    )
PIVOT( SUM(sal) FOR deptno IN ('10', '20', '30'));

SELECT *
FROM (
    SELECT job, deptno, sal, ename
    FROM emp
    )
PIVOT( SUM(sal) AS "합계", MAX(sal) AS "최고액", MAX(ename) AS "최고연봉" FOR deptno IN ('10', '20', '30'));

-- RIGHT OUTER JOIN
SELECT
d.deptno, dname, job
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno; -- RIGHT JOIN
--WHERE e.deptno = d.deptno(+); -- LEFT JOIN
--FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno;

-- [문제] emp 테이블에서 sal가 상위 20%에 해당되는 사원의 정보를 조회

SELECT ename, sal_rank
FROM(
    SELECT ename, sal
    ,RANK() OVER(ORDER BY sal DESC) sal_rank
    FROM emp
)
WHERE sal_rank <= (SELECT COUNT(*) FROM emp)*0.2;

-- [문제]
--emp 에서 각 사원의 급여가 전체급여의 몇 %가 되는 지 조회.
--       ( %   소수점 3자리에서 반올림하세요 )
--            무조건 소수점 2자리까지는 출력.. 7.00%,  3.50%     
--
--ENAME             PAY   TOTALPAY 비율     
------------ ---------- ---------- -------
--SMITH             800      27125   2.95%
--ALLEN            1900      27125   7.00%
--WARD             1750      27125   6.45%
--JONES            2975      27125  10.97%
--MARTIN           2650      27125   9.77%
--BLAKE            2850      27125  10.51%
--CLARK            2450      27125   9.03%
--KING             5000      27125  18.43%
--TURNER           1500      27125   5.53%
--JAMES             950      27125   3.50%
--FORD             3000      27125  11.06%
--MILLER           1300      27125   4.79%

SELECT ename, pay, totalpay
, TO_CHAR(ROUND(pay/totalpay * 100,2),999.99) || '%' 비율
FROM(
    SELECT ename, sal+NVL(comm,0) pay,
    (SELECT SUM(sal+NVL(comm,0)) FROM emp) totalpay
    FROM emp
);

-- [문제] insa테이블 
--     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400      2650000          2550000

SELECT * FROM insa;



SELECT DECODE(gender,1,'남자사원수',0,'여자사원수','총사원수') "사원수" 
, COUNT(*), DECODE(gender,1,MAX(pay),0,MAX(pay)) "최대 급여"
, DECODE(gender,1,SUM(pay), 0, SUM(pay)) "급여 합"
FROM(
    SELECT basicpay + sudang pay
    ,MOD(SUBSTR(ssn,8,1),2) gender
    FROM insa
    )
GROUP BY ROLLUP(gender);

SELECT 
COUNT(*) 총사원수
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, '남자')) 남자사원수
,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, '여자')) 여자사원수
,SUM(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, basicpay)) "남사원들의 총급여합"
,SUM(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, basicpay)) "여사원들의 총급여합"
,MAX(DECODE(MOD(SUBSTR(ssn,8,1),2), 1, basicpay)) "남자-max(급여)"
,MAX(DECODE(MOD(SUBSTR(ssn,8,1),2), 0, basicpay)) "여자-max(급여)"
FROM insa;

-- [문제] 순위(RANK) 함수 사용해서 풀기 
--   emp 에서 각 부서별 최고급여를 받는 사원의 정보 출력
--   
--    DEPTNO ENAME             PAY DEPTNO_RANK
------------ ---------- ---------- -----------
--        010 KING             5000           1
--        20 FORD             3000           1
--        30 BLAKE            2850           1

-- [1]
SELECT  deptno, ename
, (SELECT MAX(pay) FROM emp) pay
, deptno_rank
FROM(
    SELECT deptno, ename, sal+NVL(comm,0) pay
    ,RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC ) deptno_rank
    FROM emp
) 
WHERE deptno_rank = 1
ORDER BY deptno ASC;

-- [2]
SELECT t.deptno, e.ename, t.max_pay, 1 DEPTNO_RANK
FROM(
    SELECT deptno, MAX(sal+NVL(comm,0)) max_pay
    FROM emp
    GROUP BY deptno
    ) t, emp e
WHERE t.deptno = e.deptno AND t.max_pay = (e.sal+NVL(e.comm,0))
ORDER BY deptno ASC;

-- [3]
SELECT deptno, ename, pay, deptno_rank
FROM(
    SELECT deptno, ename
    ,sal+NVL(comm,0) pay
    ,RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) pay_rank
    ,RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) deptno_rank
    FROM emp
)
WHERE deptno_rank = 1;

-- [문제] emp 테이블에서
-- 각 부서의 사원수, 부서 총급여함, 부서 평균급여

SELECT d.deptno, COUNT(*) 부서원수
, NVL(SUM(e.sal+NVL(comm,0)),0) 총급여합
, NVL(ROUND(AVG(e.sal+NVL(comm,0)),2),0) 평균
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY d.deptno;

-- [문제] insa 테이블에서 각 부서별 / 출신지역별 / 사원수 몇 명인지 출력(조회)
SELECT buseo, city, COUNT(*) 사원수
FROM insa
GROUP BY buseo, city
ORDER BY buseo, city;

-- insa 테이블에서 각 부서별 / 출신지역별 / 사원수 몇 명인지 출력(조회)
WITH c AS(
        SELECT DISTINCT city
        FROM insa
        )
SELECT buseo, c.city, COUNT(num)
FROM insa i1 PARTITION BY(buseo) RIGHT OUTER JOIN c ON i1.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo, c.city;

-- [문제] 
-- insa 테이블에서 
--[실행결과]
--                                           부서사원수/전체사원수 == 부/전 비율
--                                           부서의 해당성별사원수/전체사원수 == 부성/전%
--                                           부서의 해당성별사원수/부서사원수 == 성/부%
--                                           
--부서명     총사원수 부서사원수   성별  성별사원수   부/전%   부성/전%     성/부%
--개발부       60       14         F       8       23.3%     13.3%     57.1%
--개발부       60       14         M       6       23.3%     10%       42.9%
--기획부       60       7         F       3       11.7%       5%       42.9%
--기획부       60       7         M       4       11.7%     6.7%       57.1%
--영업부       60       16         F       8       26.7%    13.3%       50%
--영업부       60       16         M       8       26.7%    13.3%       50%
--인사부       60       4         M       4       6.7%      6.7%       100%
--자재부       60       6         F       4       10%       6.7%       66.7%
--자재부       60       6         M       2       10%       3.3%       33.3%
--총무부       60       7         F       3       11.7%     5%         42.9%
--총무부       60       7         M    4         11.7%      6.7%       57.1%
--홍보부       60       6         F       3       10%       5%           50%
--홍보부       60       6         M       3       10%       5%           50% 

DESC insa;

SELECT buseo
, COUNT(buseo)
, DECODE(gender,1,'M',0,'F') 성별, COUNT(gender) 성별사원수
,COUNT(buseo)/COUNT(gender) "성/부"
FROM(
    SELECT buseo
    ,MOD(SUBSTR(ssn,8,1),2) gender
    FROM insa
    )
GROUP BY buseo, gender
ORDER BY buseo, gender;

---
SELECT s.*
, ROUND(부서사원수/총사원수 * 100,1) || '%' "부/전%"
, ROUND(성별사원수/총사원수 * 100,1) || '%' "부성/전%"
, ROUND(성별사원수/부서사원수 * 100,1) || '%' "성/부%"
FROM(
    SELECT buseo
    ,(SELECT COUNT(*) FROM insa) 총사원수
    ,(SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) 부서사원수
    ,gender 성별
    ,COUNT(*) 성별사원수
    FROM(
        SELECT buseo, name, ssn
        ,DECODE(MOD(SUBSTR(ssn,8,1),2),1, 'M', 'F') gender
        FROM insa
        )t
    GROUP BY buseo, gender
    ORDER BY buseo, gender
)s;

-- [문제] SMS 인증번호 임의의 6자리 숫자 발생
SELECT SYS.dbms_random.value
        , TRUNC(SYS.dbms_random.value(100000, 1000000))
        , TO_CHAR(TRUNC(SYS.dbms_random.value(10000, 1000000)), '099999')
FROM dual;

SELECT deptno,
TO_CHAR(deptno, '0099')
FROM dept;

-- [문제] LISTAGG 함수
--SELECT LISTAGG(대상컬럼, '구분문자') WITHIN GROUP (ORDER BY 정렬기준컬럼) 
--FROM TABLE명 ;

SELECT d.deptno,
NVL(LISTAGG(ename, '/') WITHIN GROUP (ORDER BY ename), '사원없음')
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno 
GROUP BY d.deptno;

-- [문제] emp 테이블에서 30번 부서의 최고 최저 sal를 받는 사원정보조회

SELECT deptno, ename, hiredate, sal
FROM emp
WHERE sal = (SELECT MIN(DECODE(deptno, 30, sal)) FROM emp)
AND deptno = 30
UNION0
SELECT deptno, ename, hiredate, sal
FROM emp
WHERE sal = (SELECT MAX(DECODE(deptno, 30, sal)) FROM emp)
AND deptno = 30;

--

SELECT deptno, ename, hiredate, sal
FROM (
    SELECT deptno, ename, hiredate, sal,
           RANK() OVER (PARTITION BY deptno ORDER BY sal ASC) AS srtop,
           RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS srlow
    FROM emp
    WHERE deptno = 30
) r
WHERE srtop = 1 OR srlow = 1; 

-- [마지막 문제] emp 테이블에서
--              사원수가 가장 작은 부서명과 사원수
--              사원수가 가장 많은 부서명과 사원수


SELECT MAX(cnt), MIN(cnt)
FROM(
SELECT dname, COUNT(*) cnt
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY dname
);

--WITH a AS ()
--    ,b AS (FROM a)
SELECT d.dname, t.cnt
FROM(
    SELECT dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
    GROUP BY dname
)t RIGHT JOIN dept d ON t.dname = d.dname
GROUP BY d.dname
WHERE t.cnt = (SELECT MAX(cnt) FROM t); 

SELECT t.deptno, cnt
FROM (
    SELECT d.deptno, COUNT(empno) cnt
    ,RANK() OVER(ORDER BY COUNT(empno) ASC) cnt_rank
    FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
    GROUP BY d.deptno
    )t
WHERE t.cnt_rank IN (1, 4);
-- RANK 순위 함수 사용 x
-- MAX(cnt), MIN(cnt)

-- ㄱ.
WITH t AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
    )
SELECT dname, cnt
FROM t
WHERE cnt IN( (SELECT MAX(cnt) FROM t), (SELECT MIN(cnt) FROM t) );

-- ㄴ. WITH 절 이해
WITH a AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
    )
    , b AS(
    SELECT MIN(cnt) mincnt, MAX(cnt) maxcnt
    FROM a
    )
SELECT a.dname, a.cnt
FROM a, b 
WHERE a.cnt IN (b.mincnt, b.maxcnt);

-- ㄷ. 분석함수 : FIRST, LAST
--               ? 집계함수(COUNT, SUM, AVG, MAX, MIN) 와 같이 사용하여
--               주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출하는 함수.
WITH a AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
    )
SELECT MAX(cnt)
      ,MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt ASC) max_dname
      ,MIN(cnt)
      ,MIN(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt ASC) min_dname
FROM a;

-- 분석함수 중에 CUME_DIST() : 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
                -- 분포도 값(비율)  0 <    <= 1
SELECT deptno, ename, sal
, CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) dept_dist
FROM emp;

-- 분석함수 중에 PERCENT_RANK() : 해당 그룹 내의 백분위 순위
--                              0 <=  사이의 값  <= 1
-- 백분위 순위 ? 그룹 안에서 해당 행의 값보다 작은 값의 비율
SELECT deptno, ename, sal
--, PERCENT_RANK() OVER (ORDER BY sal) PERCENT
, PERCENT_RANK() OVER (PARTITION BY deptno ORDER BY sal) PERCENT
FROM emp;

-- NTILE(expr) N타일 : 파티션 별로 expr에 명시된 만큼 분할한 결과를 반환하는 함수
-- 분할하는 수를 버킷(bucket)이라고 한다.
SELECT deptno, ename, sal
, NTILE(4) OVER(ORDER BY sal) ntiles
FROM emp;

SELECT buseo, name, basicpay
,NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay) ntiles
FROM insa;

-- WIDTH_BUCKET(expr, minvalue, maxvalue, numbuckets) == NTILE() 함수만 유사한 분석함수, 차이점( 최소값, 최대값 설정 가능 )
SELECT deptno, ename, sal
, NTILE(4) OVER(ORDER BY sal) ntiles
, WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;

--  필수(컬럼명), 가져올 행의 위치, 값이 없을떄 사용하는 값
-- LAG( expr,       offset,        default_value)
--  ? 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수, 앞(선행 행)
-- LEAD(expr, offset, default_value)
--  ? 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수, 뒤(후행 행)

SELECT deptno, ename, hiredate, sal
,LAG(sal, 1, 0) OVER(ORDER BY hiredate) pre_sal
,LAG(sal, 2, -1) OVER(ORDER BY hiredate) pre_sal
,LEAD(sal, 1, -1) OVER(ORDER BY hiredate) next_sal
FROM emp
WHERE deptno = 30;

-- offset : 몇 행인지, default_value : 바꿀 값

-------------------------------------------------------------------------------
-- [오라클 자료형(data typ)]

-- 1) 문자(열) 저장하는 자료형
형식)
CHAR((SIZE [BYTE|CHAR]))
예)
CHAR(3 CHAR) ? 3문자를 저장하는 자료형, 'abc', '한글세'
CHAR(3 BYTE) ? 3바이트의 문자를 저장하는 자료형 'abc', '한' CHAR(3) == CHAR(3 BYTE)
CHAR == CHAR(1) == CHAR(1 BYTE)
고정길이의 문자 자료향

CHAR(14) == CHAR(14 BYTE)

-- DDL
CREATE TABLE tbl_char
(
    aa char
    ,bb char(3)
    , cc char(3 char)
);


SELECT *
FROM tabs
WHERE table_name LIKE '%CHAR%';

DESC tbl_char;
-- 새로운 레코드(행)을 추가
INSERT INTO tbl_char(aa,bb,cc) VALUES('a','aaa','aaa');
INSERT INTO tbl_char(aa,bb,cc) VALUES('a','한','우리');
INSERT INTO tbl_char(aa,bb,cc) VALUES('a','우리','우리');
COMMIT;

SELECT *
FROM tbl_char;

DROP TABLE tbl_char;
COMMIT;
NCHAR[(SIZE)} == N + CHAR[(SIZE)]

NCHAR == NCHAR(1)

CREATE TABLE tbl_nchar
(
    aa char(3)
    ,bb char(3 char)
    , cc nchar(3)
);
INSERT INTO tbl_nchar(aa,bb,cc) VALUES('홍','길동','홍길동');
SELECT *
FROM tbl_nchar;

DROP TABLE tbl_nchar;
-- char / nchar - 고정길이 2000byte
-- VARCHAR2(size[BYTE | CHAR])
VARCHAR2(SIZE BYTE|CHAR) 가변길이

char(5 byte)     [a][b][c][][]
varchar2(5 byte) [a][b][c]
VARCHAR2 == VARCHAR2(1) == VARCHAR2(1 BYTE) 4000byte

-- N+VAR+CHAR2(size)
NVARCHAR2 == NVARCHAR2(1) = '한' 'a'
4000 byte





