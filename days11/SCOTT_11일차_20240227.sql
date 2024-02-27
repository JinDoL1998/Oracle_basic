-- scott

-- 계층적 질의(hierarchical query)
-- 관계형 데이터베이스는 2차원(행/열) 테이블 구조에 의해 모든 데이터를 저장한다.
--  int[] m = new int[3] 열
--  int[][] m = new int[3][4] 행/열
SELECT *
FROM dept;

--실무에서는 기업의 조직도, 집안의 족보처럼 계층적인 데이터 구조를 많이 사용하고 있다.
--따라서 평면적인 구조를 가지는 테이블에서도 계층적인 데이터를 저장하여 조회할 수 있는 방법이 필요하다.
-- 관계형 데이터베이스에서도 데이터간의 부모-자식 관계를 표현할 수 있는 [컬럼]을 지정하여 계층적인 관계를 표현할 수 있다.
-- 예) 쇼핑몰 사이트 구현 대분류/중분류/소분류 : 1개 테이블(계층 구조), 3개 테이블 구현
-- 하나의 테이블에서 계층적인 구조를 표현하는 관계를 순환관계(recursive relationship)라고 한다.

-- emp테이블 계층구조                                                           
--      ㄴ 부모-자식 관계를 표현할 수 있는 [컬럼] : mgr 컬럼
SELECT *
FROM emp;

-- ORA-01788: CONNECT BY clause required in this query block
SELECT LEVEL        -- (암기)
FROM dual
CONNECT BY LEVEL <= 31;

--SELECT 	[LEVEL] {*,컬럼명 [alias],...}
--	FROM	테이블명
--	WHERE	조건
--	START WITH 조건
--	CONNECT BY [PRIOR 컬럼1명  비교연산자  컬럼2명]
--		또는 
--		   [컬럼1명 비교연산자 PRIOR 컬럼2명]

SELECT mgr, empno
,LPAD(' ', (LEVEL-1)*3) || ename
,LEVEL
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr; -- PRIOR 자식 = 부모; top-down 출력형식
--CONNECT BY PRIOR mgr = empno; -- PRIOR 부모 = 자식; bottom-up 출력형식

--다음은 mgr=7698인 BLAKE를 메니저로 둔 empno를 나열한 예이다.
SELECT mgr,empno,ename,LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr IS NULL
CONNECT BY PRIOR empno=mgr;

-- 예) 학과/학부/단가대학
-- 동일개념: 대/중/소분류
create table tbl_test(
deptno number(3) not null primary key,
dname varchar2(30) not null,
college number(3),
loc varchar2(10)
);

INSERT INTO tbl_test VALUES (101, '컴퓨터공학과', 100, '1호관');
INSERT INTO tbl_test VALUES (102, '멀티미디어학과', 100, '2호관');
INSERT INTO tbl_test VALUES (201, '전자공학과', 200, '3호관');
INSERT INTO tbl_test VALUES (202, '기계공학과', 200, '4호관');
INSERT INTO tbl_test(deptno, dname, college) VALUES (100, '정보미디어학부', 200);
INSERT INTO tbl_test(deptno, dname, college) VALUES (200, '메카트로닉스학부', 10);
INSERT INTO tbl_test(deptno, dname) VALUES (10, '공과대학');
 
SELECT deptno, dname, college, LEVEL
FROM tbl_test
START WITH deptno = 10
CONNECT BY PRIOR deptno = college;

SELECT LPAD('ㄴ', (LEVEL-1)*3) || dname 
FROM tbl_test
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;

SELECT LPAD('ㄴ', (LEVEL-1)*3) || dname 
FROM tbl_test
WHERE dname != '정보미디어학부'
START WITH college IS NULL
CONNECT BY PRIOR deptno = college AND dname != '정보미디어학부';

-- 1. START WITH 절
-- 2. CONNECT BY 절 : 계층형 구조가 어떤 식으로 연결되는지를 기술하는 구문
-- PRIOR 연산자 : 
-- 3. CONNECT_BY_ROOT : 계층형 쿼리에서 최상위 로우(행)을 반환하는 연산자
-- 4. CONNECT_BY_ISLEAF : CONNECT BY 조건에 정의된 관계에 따라 해당 행이 최하위 자식행
--                        이면 1, 그렇지 않으면 0 반환하는 의사 컬럼
-- 5. SYS_CONNECT_BY_PATH(column, char) : 루트 노드에서 시작해서 자신의 행까지
--                                        연결 경로를 반환하는 함수
-- 6. CONNECT_BY_ISCYCLE : 루프(반복) 알고리즘 의사컬럼. 1/0 출력

SELECT e.empno
    ,LPAD(' ', 3*(LEVEL-1)) || e.ename
    ,LEVEL
    ,d.dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno
START WITH e.mgr IS NULL
CONNECT BY PRIOR e.empno = e.mgr;
--
SELECT e.empno
    ,LPAD(' ', 3*(LEVEL-1)) || e.ename
    ,LEVEL
    ,e.deptno
    ,CONNECT_BY_ROOT ename
    ,CONNECT_BY_ISLEAF -- 의사컬럼
    ,SYS_CONNECT_BY_PATH(ename, '/') -- 각 ename 단계의 경로 출력
FROM emp e
START WITH e.mgr IS NULL
CONNECT BY PRIOR e.empno = e.mgr;

--
SELECT e.empno
    ,LPAD(' ', 3*(LEVEL-1)) || e.ename
    ,LEVEL
    ,d.dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno
START WITH e.mgr IS NULL
CONNECT BY PRIOR e.empno = e.mgr;

-- 뷰(VIEW)
--【형식】
--	CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름
--		[(alias[,alias]...]
--	AS subquery
--	[WITH CHECK OPTION]
--	[WITH READ ONLY];

--옵션 설 명 
--OR REPLACE 같은 이름의 뷰가 있을 경우 무시하고 다시 생성 
--FORCE 기본 테이블의 유무에 상관없이 뷰를 생성 
--NOFORCE 기본 테이블이 있을 때만 뷰를 생성 
--ALIAS 기본 테이블의 컬럼이름과 다르게 지정한 뷰의 컬럼명 부여 
--WITH CHECK OPTION 뷰에 의해 access될 수 있는 행(row)만이 삽입, 수정 가능 
--WITH READ ONLY DML 작업을 제한(단지 읽는 것만 가능) 

SELECT car_id, car_type, fee
FROM(
    SELECT car.car_id, car.car_type, daily_fee, discount_Rate
    , daily_fee * (1 - DISCOUNT_RATE/100) * 30 fee
    FROM CAR_RENTAL_COMPANY_CAR car JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY history ON car.car_id = history.car_id
    JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN plan ON car.car_type = plan.car_type
    WHERE TO_CHAR(end_date,'YYYY-MM-DD') <= '2022-11-01'
    AND DURATION_TYPE LIKE '30%'
    )
WHERE car_type IN ('세단', 'SUV') AND fee BETWEEN 500000 AND 2000000
GROUP BY car_id, car_type, fee
ORDER BY fee DESC, car_type ASC, car_id DESC;

-- 실습
-- 자주 아래와 같은 쿼리를 사용
SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON p.b_id = b.b_id
            JOIN gogaek g ON g.g_id = p.g_id;
            
-- 뷰생성
-- ORA-01031: insufficient privileges
-- SCOTT 계정이 뷰 생성할 권한이 없다.
CREATE OR REPLACE VIEW panView
-- (별칭...)
AS

    SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON p.b_id = b.b_id
                JOIN gogaek g ON g.g_id = p.g_id
ORDER BY p_date DESC
;
-- 뷰를 정의하는 subquery에는 ORDER BY 절을 포함할 수 없다.

SELECT *
FROM user_sys_privs;

SELECT *
FROM panView
ORDER BY p_date DESC;

DESC panView;

SELECT SUM(p_su)
FROM panView;

SELECT text
FROM user_views;

DROP view panView;

-- 뷰 목록 조회
SELECT *
FROM tab
WHERE tabtype = 'VIEW';
FROM tabs;

-- 뷰 사용 -> DML 작성(실습0
-- ㄴ 단순뷰
-- ㄴ 복합뷰
CREATE TABLE testa (
   aid     NUMBER                  PRIMARY KEY
    ,name   VARCHAR2(20) NOT NULL
    ,tel    VARCHAR2(20) NOT NULL
    ,memo   VARCHAR2(100)
);

CREATE TABLE testb (
    bid NUMBER PRIMARY KEY
    ,aid NUMBER CONSTRAINT fk_testb_aid 
            REFERENCES testa(aid)
            ON DELETE CASCADE
    ,score NUMBER(3)
);

INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;

SELECT * FROM testa;
SELECT * FROM testb;

-- 1. 뷰 생성(단순뷰)
CREATE OR REPLACE VIEW aView
AS
    SELECT aid, name, tel --memo
    FROM testa;

-- 2. DML 실행 (INSERT)
-- ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")
INSERT INTO testa(aid, name, memo) VALUES(5,'f','5');
INSERT INTO testa(aid, name, tel) VALUES(5,'f','5');
COMMIT;

SELECT * FROM testa;

-- 뷰 delete 가능
DELETE FROM aView
WHERE aid = 5;
COMMIT;

UPDATE aView
SET tel = '44'
WHERE aid = 4;
COMMIT;

CREATE OR REPLACE VIEW abView
AS
    SELECT 
        a.aid, name, tel    -- testa
        ,bid, score         -- testb
    FROM testa a JOIN testb b ON a.aid = b.aid
;

SELECT *
FROM abView;
-- 복합뷰를 사용해서 INSERT X
-- SQL 오류: ORA-01779: cannot modify a column which maps to a non key-preserved table
INSERT INTO abView(aid, name, tel, bid, score)
VALUES(10, 'x', 55, 20, 70);
-- 동시에 두 개의 테이블에 각각의 칼럼값들이 INSERT 할 수 없다.
-- 복합뷰를 사용해서 UPDATE : 한 테이블의 내용만 수정
UPDATE abView
SET score = 99
WHERE bid = 1;
ROLLBACK;

DELETE FROM abview
WHERE aid = 1;

SELECT * FROM aView;
SELECT * FROM abView;

CREATE OR REPLACE VIEW bVIEW
AS 
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
    WITH CHECK OPTION CONSTRAINT CK_bView_score
    ;

SELECT bid, aid, score FROM testb;
SELECT bid, aid, score FROM bView;

-- 3 -> 70점으로 수정
UPDATE bView
--SET score = 70
SET score 98
WHRE bid = 3;

DROP VIEW bView;
DROP VIEW abView;
DROP TABLE test

-- 뷰 : 물리적 뷰(MATERIALIZED VIEW) -실제 데이터를 가지고 있는 뷰
CREATE OR REPLACE VIEW ;

-- 문제. 년도, 월, 고객코드, 고객명, 판매금액 합(녀도별 월(
-- (년도, 월 오름차순 ) 뷰로 작성
-- gogaekView
CREATE OR REPLACE VIEW gogaekView
AS
    SELECT TO_CHAR(p_date, 'YYYY') 년도
        , TO_CHAR(p_date, 'MM') 월
        , g_id 고객코드
        , g_name 고객명
        , SUM(price * p_su) 판매금액합
    FROM panmai p JOIN gogaek g USING(g_id) JOIN danga d USING(b_id)
    GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g_id, g_name
    ORDER BY 년도, 월;

SELECT * FROM gogaekView;

DROP VIEW gogaekView;


--1. DB모델링 정의
--    1) 데이터베이스(Database) ? 서로 관련된 데이터의 집합(모임)
--    2) DB모델링 ? 현실 세계의 업무적인 프로세스를 물리적으로 DB화 시키는 과정
--        예) 스타벅스에서 음료 주문( 현실 세계의 업무 프로세스 )
--        음료(상품) 검색 -> 주문 -> 결재 -> 대기 -> 상품 픽업

--2. DB 모델링 과정(단계, 순서)
--    1) 업무 프로세스(요구분석서 작성) -> 2) 개념적 DB모델링(ERD작성)
--              ↑                                  ↓
--    4) 물리적 DB 모델링             ←   3) 논리적 DB모델링(스키마,정규화)
--    역정규화,
--    인덱서
--    DBMS(오라클) 타입,크기 등등

--3. DB모델링 과정(1단계) - 업무 분석 -> 요구분석서 작성
--    1) 관련 분야에 대한 기본 지식과 상식 필요
--    2) 신입사원의 입장에서 업무 자체와 프로세스 파악, 분석 필요
--    3) 우선, 실제 문서(서류, 장표, 보고서 등등)를 수집하고 분석. p.316
--    4) 담당자 인터뷰, 설문조사 등등
--    5) 비슷한 업무 처리하는 DB분석
--    6) 백그라운드 프로세스 파악
--    7) 사용자 요구사항 분석

--한빛 마트의 데이터베이스를 위한 요구 사항 명세서
--① 한빛 마트에 회원으로 가입하려면 회원아이디, 비밀번호, 이름, 나이, 직업을 입력해야 한다.
--② 가입한 회원에게는 등급과 적립금이 부여된다.
--③ 회원은 회원아이디로 식별한다.
--④ 상품에 대한 상품번호, 상품명, 재고량, 단가 정보를 유지해야 한다.
--⑤ 상품은 상품번호로 식별한다.
--⑥ 회원은 여러 상품을 주문할 수 있고, 하나의 상품을 여러 회원이 주문할 수 있다.
--⑦ 회원이 상품을 주문하면 주문에 대한 주문번호, 주문수량, 배송지, 주문일자 정보를 유지해야 한다.
--⑧ 각 상품은 한 제조업체가 공급하고, 제조업체 하나는 여러 상품을 공급할 수 있다.
--⑨ 제조업체가 상품을 공급하면 공급일자와 공급량 정보를 유지해야 한다.
--⑩ 제조업체에 대한 제조업체명, 전화번호, 위치, 담당자 정보를 유지해야 한다.
--⑪ 제조업체는 제조업체명으로 식별한다.
--⑫ 회원은 게시글을 여러 개 작성할 수 있고, 게시글 하나는 한 명의 회원만 작성할 수 있다.
--⑬ 게시글에 대한 글번호, 글제목, 글내용, 작성일자 정보를 유지해야 한다.
--⑭ 게시글은 글번호로 식별한다.

--3. DB 모델링 과정(2단계) - 개념적 DB모델링(ERD작성)
--    1) 개념적 DB 모델링 ? DB 모델링 함에 있어 가장 먼저 해애ㅑ될 일은
--                        사용자가 필요로하는 데이터가 무었인지 파악
--                        어떤 데이터를 DB에 저장해야되는지 충분히 분석
--                         ->
--                        업무 분석, 사용자 요구 분석등을 통해서
--                        수집된 현실 세계의 정보들을 사람들이 이해할 수 있는
--                        명화한 형태로 표현하는 단계를 "개념적 DB모델링" 이라고 한다
--    2) 명확한 형태로 표현하는 방법 : 1976년 P.Chen 제안
--        개체(Entity) - 직사각형, 관계 모델을 그래프 형식으로 알아보기 쉽게 표현 -> ER-Diagram(ERD)
--            ㄴ 실체(Entity) : 업무 수행을 위해 데이터로 관리되어져야할 사람, 사물, 장소, 사건 등을 "실체"한다
--            ㄴ 구축하고자 하는 업무의 목적, 범위 전력에 따라 데이터로 관리되어져야할 항목을 파악하는 것이 매우 중요하다.
--            ㄴ 실체는 학생, 교수 등과 같이 물리적으로 존재하는 유형
--                      학과, 과목 등과 같이 개념적으로 존재하는 무형.
--            ㄴ 실체는 테이블로 정의된다.
--            ㄴ 실체는 인스턴스라 불리는 개별적인 객체들의 집합이다.
--                예) 과목(실체) : 오라클과목, 자바과목, JSP과목
--                    학과(실체) : 컴공과, 전공과 등등 인스턴스의 집합.
--            ㄴ 실체를 파악하는 요령(가장 중요)
--                예) 학원에서는 학생들의 출결상태와 성적들을 과목별로 관리하기를 원하고 있다 (라고 업무 분석한 내용)
--        속성(Attitude) - 타원형
--          ㄴ 속성 ? 저장할 필요가 있는 실체에 대한 정보
--              즉, 속성은 실체의 성질, 분류, 수량, 상태, 특징, 특성 등등 세부항목을 의미한다
            ㄴ 속성 설정 시 가장 중요한 부분은 관리의 목적과 활용 방향에 맞는 속성의 설정.
            ㄴ 속성의 갯수는 10개 내외가 좋다
            ㄴ 속성은 컬럼으로 정의된다.
            ㄴ 속성의 유형
                1) 기초 속성 - 원래 갖고 있는 속성
                    예) 사원실체 - 사원번호 속성, 사원명 속성, 주민등록번호 속성, 입사일자 속성
                2) 추출 속성 - 기초 속성으로 계산해서 얻어질 수 있는 속성
                    예) 기초 속성 주민등록번호에서 생일, 성별, 나이 속성 등등
                        판매금액 속성 = 단가 * 판매수량
                3) 설계 속성 - 실제로는 존재하지 않으나 시스템의 효율성을 위해 설계자가 임의로 부여하는 속성
                    예) 주문상태
            ㄴ 속성 도메인 성정
                1) 속성이 가질 수 있는 값들의 범위, 세부적인 업무, 제약조건 등 특성을 정의한 것.
                예) 성적(E)- 국어(A) 속성의 범위 0 ~ 100 정수
                        kor NUMBER(3) DEFAULT 0 CHECK (kor BETWEEN 0 AND 100)
                2) 도메인 설정은 추후 개발 및 실체를 DB로 생성할 때 사용되는 산출물이다.
                3) 도메인 정의 시에는 속성의 이름, 자료형, 크기, 제약조건 등등. 파악
                4) 도메인 무결성
            ㄴ 식별자(Identifier): 대표적인 속성
                1) 한 실체 내에서 각각의 인스턴스를 구분할 수 있는 유일한 단일 속성, 속성 그룹
                2) 식별자가 없으면 데이터를 수정, 삭제할 때 문제가 발생한다.
                3) 식별자의 종류
                    (1) 후보키(Candidate Key)
                        실체에 각각의 인스턴스를 구분할 수 있는 속성
                        예) 학생실체(E) 주민번호, 학번, 이메일, 전화번호 등등
                            인스턴스 - 홍길동 ...
                                    - 김길동 ...
                    (2) 기본키(Primary Key)
                        후보키 중에 대표적인 가장 적합한 후보키를 기본키
                        업무적인 효율성, 활용도, 길이(크기) 등등 파악해서 후보키 중에 하나를 기본키로 설정한다.
                    (3) 대체키(Alternate Key)
                        후보키 - 기본키 = 나머지 후보키
                        - INDEX(인덱스)로 활용된다.
                    (4) 복합키(Composite Key)
                    (5) 대리키(Surrogate Key)
                        - 학번을 기본키로 사용하자고 결정은 했지만
                        - 식별자가 너무 길거나 여러 개의 복합키로 구성되어 있는 경우 인위적으로 추가한 식별자(인공키)
                        - 전교생이 30명... (순번:일련번호 1~30), 성능, 효율성을 높이겠다.
                          역정규화 작업
--        ㄷ. 개체 관계(Relational) - 마름모
            업무의 연관성에 따라서 실체들 간의 관계 설정
            예) 부서 실쳬(E)             <소속관계>      사원실체(E)
                부서번호속성(식별자)                     사원번호(식별자)
                부서명속성                              사원명
                지역명속성                              입사일자
                
            예) 학생(E) <가름침관계>    교수(E)
            예) 상품(E) 실선<주문관계>  고객(E)
            
            ㄴ 관계표현
                1) 두 개체간의 실선으로 연결하고 관계를 부여한다
                2) 관계 차수 표현(    부서E -01-------0N-사원E )
                                     1  :   1
                                     N  :   M(다대다) 상품E  N0 <주문> 0M   고객E
                3) 선택성 표현
--        연결(링크) - 실선
--        https://terms.naver.com/entry.naver?docId=3431225&cid=58430&categoryId=58430&expCategoryId=58430
        3. 모델링 과정(3단계) - 논리적 DB 모델링
--        https://terms.naver.com/entry.naver?docId=3431227&cid=58430&categoryId=58430&expCategoryId=58430
            ㄴ 개념적 모델링의 결과물(ERD) -> 릴레이션(테이블) 스키마 생성(변환) + 정규화 작업
                                            관계스키마           생성
            ㄴ 부모테이블과 자식테이블 구분
                - 관계형 데이터 모델
                - 예) 부서(dept)   <소속관계>  사원(emp)     생성 순서
                        부모                  자식  
                - 예) 고객         <주문관계>  상품          생성 순서X, 관계 주체
            ㄴ 기본키(PK)와 외래키(FK)
            ㄴ (암기)
               식별관계  (실선) : 부모테이블의 PK가 자식테이블의 PK로 전이되는 것
               비식별관계(점선) : 부모테이블의 PK가 자식테이블의 FK로 전이되는 것
               
            (1) ERD -> 5가지 규칙(매핑룰) -> 릴레이션 스키마 생성(변환) + 이상현상 발생
                                                                    -> 정규화 과정
                ㄱ. 규칙1: 모든 개체(E)는 릴레이션(Table)으로 변환한다.
                        개체 -> 테이블
                        속성 -> 컬럼
                        식별자 -> 기본키
                ㄴ. 규칙2: 다대다(n:m) 관계는 릴레이션으로 변환한다.
                    고객 N    <주문>    M 상품
                ㄷ. 규칙3 : 일대다(1:n) 관계는 외래키로 표현한다.
                ㄹ. 규칙4 : 일대일(1:1) 관계를 외래키로 표현한다
                ㅁ. 규칙5 : 다중 값 속성은 릴레이션으로 변환한다
            
            