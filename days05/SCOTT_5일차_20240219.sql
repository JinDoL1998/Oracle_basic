SELECT *
,REPLACE(ename, 'LA', '<span color = red></span>')
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i');

--[1]
SELECT empno, ename, deptno, sal+NVL(comm,0) pay
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MIN(sal+NVL(
comm,0)) max_pay
                         FROM emp
                         );

--[2]
-- SQL 연산자: ALL, SOME, ANY
SELECT empno, ename, deptno, sal+NVL(comm,0) pay
FROM emp
WHERE sal+NVL(comm, 0) <= ALL(SELECT sal+NVL(comm, 0) FROM emp);

-- 4-2. emp 테이블에서 각 부서별 사원수 조회
-- [1] SET(집계) 연산자 : 합집합( UNION/UNION ALL )
SELECT '10' deptno, COUNT(*) CNT
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '20', COUNT(*)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT '30', COUNT(*)
FROM emp
WHERE deptno = 30;

-- [2] scalar 서브쿼리
SELECT DISTINCT deptno
      ,(
      SELECT COUNT(*) 
      FROM emp c
      WHERE c.deptno = p.deptno
      ) cnt
FROM emp p
ORDER BY deptno ASC;

-- [3] GROUP BY 절
SELECT deptno, COUNT(*) CNT
        , sum(sal + NVL(comm, 0)) sum
        , ROUND(AVG(sal + NVL(comm, 0)),2) avg
        , MAX(sal + NVL(comm, 0)) max
        , MIN(sal + NVL(comm, 0)) min
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- pay로 등수매기기 로직 -- (암기)
SELECT deptno, empno, ename, sal+ NVL(comm,0) pay
        ,(SELECT COUNT(*) + 1
        FROM emp c
        WHERE c. sal+NVL(comm,0) > p.sal+NVL(comm,0) 
        ) pay_rank
FROM emp p
ORDER BY pay DESC;

-- [SET 집합 연산자]
-- 1) 합집합 (UNION, UNION ALL)
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
--UNION -- 6명은 중복된다. 제거하고 1번만 포함
UNION ALL -- 23명 중복되는걸 모두 포함
SELECT name, city, buseo
FROM insa
WHERE city = '인천';

-- 2) 차집합 (MINUS)
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '인천';

-- 3) 교집합 (INTERSECT)
-- 개발부 이면서 인천인 사원들을 파악
-- [1]
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부' AND city = '인천'; -- 6명

-- [2]
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '인천';

-- [SET(집합) 연산자를 사용할 때 주의할 점]
-- ORA-01790: expression must have same datatype as corresponding expression
-- ORA-01789: query block has incorrect number of result columns
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
--UNION  
UNION ALL 
SELECT name, city--, basicpay
FROM insa
WHERE city = '인천';

-- insa테이블의 사원정보 + emp 테이블의 사원 정보 모두 출력
SELECT buseo, num, name, ibsadate, basicpay, sudang
FROM insa
UNION ALL
SELECT TO_CHAR(deptno), empno, ename, hiredate, sal, comm
FROM emp;

-- [계층적 질의 연산자]
-- PRIOR, CONNECT_BY_ROOT

-- [연결 연산자] ||

-- [산술 연산자] +, -, /, *
--              나머지 구하는 연산자 X
--              나머지 구하는 함수 MOD(5,3)*****  5-3 * FLOOR(5/3)
--              나머지 구하는 함수 REMAINDER(5,3) 5-3 * ROUND(5/3)

SELECT 
-- 10/0 -- ORA-01476: divisor is equal to zero
-- 'A' / 2 -- ORA-01722: invalid number
MOD(10,0)
FROM dual;

--IS [NOT] NAN    NOT A NUMBER
--IS [NOT] INFINITE


-- 오라클 함수(function)
-- 1. 복잡한 쿼리문을 간단하게 해주고 데이터의 값을 조작하는데 사용되는 것을 함수라 한다. 
--    일반적으로 주어진 데이터(인수)를 처리하고 그 결과를 반환하는 기능을 수행한다
-- 2. 종류 : 단일행 함수, 복수행 함수

SELECT LOWER(ename)
FROM emp;

SELECT COUNT(*)
FROM emp;

-- [숫자 함수] --
-- 1) ROUND(number) 숫자값을 특정 위치에서 반올림하여 리턴한다. 
SELECT 3,141592
, ROUND(3.141592)   -- 소수점 첫 번째 자리에서 반올림
, ROUND(3.141592, 2)
, ROUND(1234.5678, -1)
, ROUND(1234.5678, -2)
, ROUND(1234.5678, -3)
FROM dual;

-- [문제] emp 테이블에서 pay, 평균급여, 총급여, 사원수 출력
-- ORA-00937: not a single-group group function
-- 집계 함수는 일반 칼럼들과 같이 SELECT 불가
SELECT emp.*
, sal+NVL(comm, 0) pay
--, COUNT(*) 사원수
, (SELECT COUNT(*) FROM emp) cnt
, (SELECT SUM(sal + NVL(comm,0)) FROM emp) total_pay
-- 평균 급여 계산해서 소수점 2자리 까지 출력하자
, (SELECT ROUND(AVG(sal + NVL(comm,0)),2) FROM emp) avg_pay
FROM emp;

--TRUNC(number) 숫자값을 특정 위치에서 절삭하여 리턴한다. 
--CEIL 숫자값을 소숫점 첫째자리에서 올림하여 정수값을 리턴한다. 
--FLOOR 숫자값을 소숫점 첫째자리에서 절삭하여 정수값을 리턴한다. 
--MOD 나머지값을 리턴한다. 
--ABS 숫자값의 절대값을 리턴한다. 
--SIGN 숫자값의 부호에 따라 1, 0, -1의 값으로 리턴한다. 
--POWER(n1,n2) n1^n2한 지수곱값을 리턴한다. 
--SQRT(n) n의 제곱근 값을 리턴한다. 
--SIN(n) n의 sine 값을 리턴한다. 
--COS(n) n의 cosine 값을 리턴한다. 
--TAN(n) n의 tangent 값을 리턴한다. 
--SINH(n) n의 hyperbolic sine 값을 리턴한다. 
--COS(n) n의 hyperbolic cosine 값을 리턴한다. 
--TAN(n) n의 hyperbolic tangent 값을 리턴한다. 
--LOG(a,b) 밑이 a인 b의 지수 값을 리턴한다. 즉, 뒤의 값이 앞의 값의 몇 배수인지를 알림 
--LN(n) n의 자연로그 값을 리턴한다. 

-- [집계함수]
SELECT COUNT(*) -- NULL 값을 포함한 개수를 반환
      ,COUNT(empno)
      ,COUNT(deptno)
      ,COUNT(sal)
      ,COUNT(hiredate)
      ,COUNT(comm)
FROM emp;

-- 평균 커미션 ?
--SELECT AVG(comm) -- 550
SELECT SUM(comm) / COUNT(*) -- 183.33333
FROM emp;

-- TRUNC(날짜, 숫자), FLOOR(숫자) 절삭하는 2가지 함수
-- 차이점? 두 번째 차이점은
-- TRUNC()는 특정 위치에서 절삭 가능
-- FLOOR()는 소수점 첫 번째 자리에서 절삭만 가능
SELECT 3.141592
,TRUNC(3.141592)    -- 소수점 첫 번째 자리에서 절삭
,TRUNC(3.141592, 0) -- 소수점 첫 번째 자리에서 절삭
,FLOOR(3.141592)

,TRUNC(3.141592, 3)
,FLOOR(3.141592 * 1000) / 1000
,TRUNC(13.141592, -1)
FROM dual;
-- CEIL() 소수점 첫번째 자리에서 올림(절삭)하는 함수
SELECT CEIL(3.141592)
FROM dual;
-- 3.141592를 소수점 세 번째 자리에서 올림
SELECT CEIL(3.141592 * 100) / 100
FROM dual;
-- 총페이지 수를 계산할 때 CEIL() 올림(절삭)함수를 사용한다
-- 총 게시글(사원)수
-- 한 페이지에 출력할 게시글(사원)수 : 5
SELECT COUNT(*)
FROM emp;
SELECT CEIL((SELECT COUNT(*)
        FROM emp)/5) 페이지수
FROM dual;

SELECT *
FROM emp
ORDER BY sal+NVL(comm,0) DESC;

-- ABS() 절대값 구하는 함수
SELECT ABS(100), ABS(-100)
FROM dual;

-- SIGN() 숫자값의 부호에 따라 1, 0, -1의 값으로 리턴한다
SELECT SIGN(100), SIGN(0), SIGN(-100)
FROM dual;

-- [문제] emp 테이블의 평균급여를 구해서 
--각 사원의 급여(pay)가 평균 급여보다 많으면 "평균급여보다 많다" 출력
--                                적으면 "평균급여보다 적다" 출력
-- [1]
SELECT s.*, '많다'
FROM emp s
WHERE sal + NVL(comm,0) > (SELECT AVG(sal + NVL(comm,0)) avg_pay
                            FROM emp)
UNION
SELECT s.*, '적다'
FROM emp s
WHERE sal + NVL(comm,0) < (SELECT AVG(sal + NVL(comm,0)) avg_pay
                            FROM emp);
                            
-- [2]
SELECT ename, sal+NVL(comm,0) pay
--,(SELECT AVG(sal+NVL(comm,0)) FROM emp) avg_pay
--,sal+NVL(comm,0) - (SELECT AVG(sal+NVL(comm,0)) FROM emp) avg_pay
,SIGN(sal+NVL(comm,0) - (SELECT AVG(sal+NVL(comm,0)) FROM emp)) 차
, REPLACE(REPLACE(SIGN(sal+NVL(comm,0) - (SELECT AVG(sal+NVL(comm,0)) FROM emp)),-1, '적다'), 1, '많다') 평균급여기준
FROM emp;

--[3]
SELECT ename, pay, avg_pay
,NVL2(NULLIF(SIGN(pay - avg_pay), 1), '적다', '많다')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    ,ROUND((SELECT AVG(sal+NVL(comm,0)) FROM emp),2) avg_pay
    FROM emp
);

-- POWER()
SELECT POWER(2,3), POWER(2,-3)
FROM dual;

SELECT SQRT(2)
FROM dual;

-- [문자 함수] --
-- INSTR()
SELECT INSTR('Corea','e') 
FROM dual;

SELECT INSTR('corporate floor','or',3,2) 
,INSTR('corporate floor','or')
,INSTR('corporate floor','or',-3,2) -- 뒤에서 3번째 에서 2번째 오는 or 문자열
FROM dual;

SELECT '02-1234-5678' hp
,INSTR('02-1234-5678', '-', -1, 2)
, SUBSTR('02-1234-5678', 1, INSTR('02-1234-5678', '-')-1) a --010
, SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-')+1,
                        INSTR('02-1234-5678', '-', -1)-1 - INSTR('02-1234-5678', '-')) b   --1234
, SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-',-1)+1, 4) c --5678
FROM dual;

DESC tbl_tel;

SELECT *
FROM tbl_tel;

INSERT INTO tbl_tel (tel, name) VALUES('063)469-4567', '큰삼촌');
INSERT INTO tbl_tel (tel, name) VALUES('052)1456-4567', '큰삼촌');
COMMIT;

-- 지역번호 / 앞자리 전화번호 / 뒷자리 전화번호
SELECT tbl_tel.*
,INSTR(tel, '-')
,INSTR(tel,')')
,SUBSTR(tel, 1, INSTR(tel,')')-1) 지역번호
,SUBSTR(tel, INSTR(tel,')')+1, INSTR(tel, '-')-INSTR(tel,')')-1) 앞자리
,SUBSTR(tel, INSTR(tel,'-')+1) 뒷자리
FROM tbl_tel;

-- RPAD / LPAD
-- PAD == 덧 대는 것, 매워 넣은 것, 패드
-- 형식) RPAD(expr1, n [,expr2])

SELECT ename, pay
,RPAD(pay, 10, '*')
,LPAD(pay, 10)
,LPAD(pay, 10, '*')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    FROM emp
    )t;

-- RTRIM()/LTRIM()/TRIM()
-- 형식) RTRIM(char[, set])
SELECT '   admin     '
, '[' || '   admin     ' || ']'
, '[' || RTRIM('   admin     ') || ']'
, '[' || LTRIM('   admin     ') || ']'
, '[' || TRIM('   admin     ') || ']'
FROM dual;

SELECT RTRIM('BROWINGyxXxy','xy') a
-- , TRIM('xyBROWINGyxXxyxyxyxyxy','xy') b -- ORA-00907: missing right parenthesis
,RTRIM(LTRIM('xyBROWINGyxXxyxyxyxy','xy'), 'xy') c
FROM dual;

-- ASCII()
SELECT ename
, SUBSTR(ename, 1, 1)
, ASCII(SUBSTR(ename, 1, 1)) "아스키코드 값"
, CHR(ASCII(SUBSTR(ename, 1, 1))) "문자 변환"
FROM emp;

SELECT ASCII('A'), ASCII('a'), ASCII('0')
FROM dual;

-- GREATEST(), LEAST() 나열된 숫자, 문자 중 가장 큰, 작은 값을 리턴하는 함수
SELECT GREATEST(3,5,2,4,1)
,GREATEST('R','A','E','Z')
,LEAST(3,5,2,4,1)
,LEAST('R','A','E','Z')
FROM dual;

-- VSIZE()
SELECT ename
, VSIZE(ename)
, VSIZE('홍길동')
, VSIZE('a')
, VSIZE('한')
FROM emp;

-- 날짜 함수
SELECT SYSDATE
, ROUND(SYSDATE) a -- 일 반올림/ 현 날짜 정오를 기준으로 반올림
, ROUND(SYSDATE, 'DD') b -- 일 반올림/ 24/02/20 정오를 기준으로 날짜 반올림
, ROUND(SYSDATE, 'MONTH') c -- 월 반올림/ 24/03/01 그 달의 15일 기준으로 반올림
, ROUND(SYSDATE, 'YEAR') d -- 년 반올림 / 
FROM dual;

SELECT SYSDATE
, TO_CHAR(SYSDATE, 'YYYY.MM.DD HH.MI.SS') a --2024.02.19 03.38.32
, TRUNC(SYSDATE)
, TRUNC(SYSDATE , 'DD') c
, TO_CHAR(TRUNC(SYSDATE), 'YYYY.MM.DD HH24.MI.SS') b
, TRUNC(SYSDATE, 'MONTH') d -- 24/02/[01] 월 밑으로 절삭
, TRUNC(SYSDATE, 'YEAR') e -- 24/[01]/[01] 년 밑으로 절삭
FROM dual;

--날짜 + 숫자 날짜 날짜에 일수를 더하여 날짜 계산 
SELECT SYSDATE + 100 --24/05/29 
FROM dual;

--날짜 - 숫자 날짜 날짜에 일수를 감하여 날짜 계산 
SELECT SYSDATE - 30 --24/01/20 
FROM dual;

--날짜 + 숫자/24 날짜 날짜에 시간을 더하여 날짜 계산 
-- 2시간 후에 만나자 (약속)
SELECT SYSDATE
    ,TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')
    ,SYSDATE + 2/24
    ,TO_CHAR(SYSDATE + 2/24, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

--날짜 - 날짜 일수 날짜에 날짜를 감하여 일수 계산 
-- [문제] 입사한 날짜부터 오늘 날짜까지 근무한 일수 몇일?
SELECT ename
,hiredate
,SYSDATE
,TRUNC(SYSDATE+1) - TRUNC(hiredate) || '일' 근무일수-- 날짜 - 날짜
FROM emp;

SELECT TO_DATE('2024-02-18')
, SYSDATE
,TRUNC(SYSDATE) - TRUNC(TO_DATE('2024-02-18')) || '일' 근무일수
FROM dual;

-- [문제] 24년도 2월 마지막 날짜 몇 일까지 ?
-- [1]
SELECT SYSDATE a -- 24/02/19
--, TRUNC(SYSDATE, 'DD') --시간, 분, 초 절삭
, TRUNC(SYSDATE, 'MONTH') b
-- 1달 더하기
--, ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1)
, ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) -1
, TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) -1, 'DD') "2월 마지막 날짜"
FROM dual;

-- [2]
SELECT SYSDATE
-- 매개변수 날짜의 마지막 날짜 객체를 반환하는 함수
,LAST_DAY(SYSDATE)
,TO_CHAR(LAST_DAY(SYSDATE), 'DD') "이번달 마지막 날짜"
FROM dual;

-- [문제] 개강일로부터 오늘날짜까지 일 수 : 
-- 2023.12.29 개강
SELECT CEIL(SYSDATE - TO_DATE('2023/12/29'))
FROM dual;

-- [문제] 오늘날짜부터 수료일까지 남은 일 수 : 
-- 2024.06.14 수료

SELECT 
TRUNC(SYSDATE,'DAY')
,ABS(CEIL(SYSDATE - TO_DATE('2024/06/14')))
FROM dual;

-- NEXT DAY() 함수
SELECT SYSDATE
, TO_CHAR(SYSDATE, 'YYYY/MM/DD (DY)') a
, TO_CHAR(SYSDATE, 'YYYY/MM/DD (DAY)') b
-- 가장 가까운 금요일날 약속...
, NEXT_DAY(SYSDATE, '금요일') "가장 가까운 금요일"
, NEXT_DAY(SYSDATE, '월') "다음주 월요일"
FROM dual;

-- [문제] 4월 첫번째 화요일 만나자
SELECT TO_DATE('2024-04-01')
--, NEXT_DAY(TO_DATE('2024-04-01')-1, '화')
, NEXT_DAY(TO_DATE('2024-04-01')-1, '월')
FROM dual;

-- MONTHS_BETWEEN() 두 날짜 사이의 개월 수를 반환하는 함수
SELECT ename, hiredate
, SYSDATE
, CEIL(ABS( hiredate - SYSDATE )) 근무일수
, MONTHS_BETWEEN(SYSDATE, hiredate) 근무개월수
, ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)/12, 2) 근무년수
FROM emp;

SELECT SYSDATE
,CURRENT_DATE
,CURRENT_TIMESTAMP
FROM dual;

-- [변환함수]
-- 1) TO_NUMBER() : 문자 -> 숫자로 변환
SELECT '12'
,TO_NUMBER('12') "12"
,100 - '12'
,'100' - '12'
FROM dual;

-- 2) TO_CHAR(날짜, 숫자)
-- [문제] insa 테이블에서 pay를 세자리 마다 콤마를 출력 앞에 통화기호를 붙이자
SELECT num, name, basicpay, sudang
,basicpay + sudang pay
,TO_CHAR(basicpay + sudang, 'L9,999,999.99') "\pay"
FROM insa;

SELECT 12345
, TO_CHAR(12345) a-- '12345'
, TO_CHAR(12345, '99,999') b-- '12,345'
, TO_CHAR(12345, '9,999') b-- '#####'
, TO_CHAR(12345, '99,999.00') c-- '12,345.00'
, TO_CHAR(12345, '99,999.99') d-- '12,345.00'
, TO_CHAR(12345.125, '99,999.00') e-- '12,345.12'
FROM dual;

SELECT TO_CHAR(-100, '999PR')
, TO_CHAR(-100, '999MI')
, TO_CHAR(-100, 'S999')
, TO_CHAR(100, 'S999')
FROM dual;

SELECT * FROM emp;


