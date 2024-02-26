-- SCOTT
CREATE TABLE tbl_emp(
id NUMBER PRIMARY KEY, 
name VARCHAR2(10) NOT NULL,
salary  NUMBER,
bonus NUMBER DEFAULT 100);

INSERT INTO tbl_emp(id,name,salary) VALUES(1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) VALUES(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) VALUES(1003,'kim',140);
COMMIT;

SELECT * FROM tbl_emp;

CREATE TABLE tbl_bonus
(
    id NUMBER
    , bonus NUMBER DEFAULT 100
);

insert into tbl_bonus(id) (select e.id from tbl_emp e);

SELECT * FROM tbl_bonus;

INSERT INTO tbl_bonus VALUES(1004, 50);
COMMIT;

-- 병합 1)
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN 
    UPDATE SET b.bonus = b.bonus + e.salary * 0.01
WHEN NOT MATCHED THEN 
    INSERT (b.id, b.bonus) VALUES(e.id, e.salary*0.01);

SELECT * FROM tbl_bonus;

-- 병합 2)
CREATE TABLE tbl_merge1
(
    id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
    , pay NUMBER
    , sudang NUMBER
);

CREATE TABLE tbl_merge2
(
    id NUMBER PRIMARY KEY 
    ,sudang NUMBER
);


INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (1, 'a', 100, 10);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (2, 'b', 150, 20);
INSERT INTO tbl_merge1 (id, name, pay, sudang) VALUES (3, 'c', 130, 0);

INSERT INTO tbl_merge2 (id, sudang) VALUES(2, 5);
INSERT INTO tbl_merge2 (id, sudang) VALUES(3, 10);
INSERT INTO tbl_merge2 (id, sudang) VALUES(4, 20);

SELECT * FROM tbl_merge1;
SELECT * FROM tbl_merge2;

-- 병합 : tbl_merge1(소스) -> tbl_merge2(타겟) 병합
--          1                     INSERT
--          2                     UPDATE

MERGE INTO tbl_merge2 m2
USING(SELECT id, sudang FROM tbl_merge1) m1
ON (m2.id = m1.id)
WHEN MATCHED THEN
    UPDATE SET m2.sudang = m2.sudang + m1.sudang
WHEN NOT MATCHED THEN
    INSERT (m2.id, m2.sudang) VALUES (m1.id, m1.sudang); 

COMMIT;
SELECT * FROM tbl_merge1;
SELECT * FROM tbl_merge2;

DROP TABLE tbl_merge1 PURGE;
DROP TABLE tbl_merge2 PURGE;

DROP TABLE tbl_emp PURGE;
DROP TABLE tbl_bonus PURGE;

-- [제약조건(Constraint)]
-- scott이 소유하고 있는 테이블 조회
SELECT * 
FROM user_tables;

-- SCOTT이 소유하고 있는 제약조건 조회
SELECT * 
FROM user_constraints;

-- SCOTT이 소유하고 있는 emp 테이블에 설정된 제약조건 조회
SELECT * 
FROM user_constraints
WHERE table_name = UPPER('emp');

-- 개체 무결성(Entity Intergrity)
-- 개체 무결성에 위배, 즉 동일한 기본 키값이 동일(중복)됨
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
-- 제약조건은 테이블에 I/U/D 할떄의 규칙으로 사용
--            data integrity(데이터 무결성)을 위배
INSERT INTO dept VALUES(10, 'QC', 'SEOUL'); -- 개체 무결성(Entity Integrity)에 위배

-- 참조 무결성(Relational Integrity)
UPDATE emp
SET deptno = 90
WHERE empno = 7369;

-- 도메인 무결성
DESC emp;

INSERT INTO emp(empno) VALUES(9999);
--ORA-01400: cannot insert NULL into ("SCOTT"."EMP"."EMPNO")
INSERT INTO emp(ename) VALUES('admin');
SELECT * FROM emp;
ROLLBACK;

-- 제약조건을 생성하는 시기에 따라 
-- ㄱ. CREATE TABLE 문 : 테이블 생성 + 제약조건 추가/삭제
--      1) IN-LINE 제약조건     (== 컬럼 레벨)   제약조건 방법
--           ㄴ NOT NULL 제약조건 설정
--      2) OUT-OF-LINE 제약조건 (== 테이블 레벨) 제약조건 방법
--           ㄴ 두 개 이상의 컬럼에 하나의 제약조건을 설정할 때
    
--    [사원 급여 지급 테이블]
--    급여지금날짜 + 회원ID => PK(복합키)
--    (역정규화)
--    순번(PK) 급여지급날짜 회원ID 급여액 ...
--    1 20240125    7369  3000000
--    2 20240125    7666  3000000
--    3 20240125    8223  2000000
--    : 
--    15 20240225    7369  3000000
--    16 20240225    7666  3000000
--    17 20240225    8223  2000000
    
--    U/D
--    WHERE 순번 급여지급날짜 = '20240125 AND 회원ID = 8223
--    => WHERE 순번 = 3;
          
-- ㄴ. ALTER TABLE 문 : 테이블 수정 + 제약조건 추가/삭제

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = NULL
WHERE empno = 7839;
COMMIT;

-- 실습) CREATE TABLE 문에서 COLUMN LEVEL 방식으로 제약조건 설정하는 예
DROP TABLE tbl_constraint1;
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY -- SYS_XXXXXX
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL 
    -- dept 테이블의 deptno(PK) =========> deptno 컬럼으로 참조
    -- 외래키, 참조키
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT UK_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)
    , city VARCHAR2(20) CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('서울', '대구', '대전'))
);

SELECT *
FROM user_constraints
WHERE table_name LIKE '%CONSTRAIN%';

-- 제약조건 비활성화/활성화
-- city 서울 대구 대전  체크제약조건
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY;  --비활성화
--ENABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY; --활성화

-- 제약조건 삭제 --
--1) PK 제약조건 삭제
ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;

ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_TBLCONSTRAINT1_EMPNO;
--CASCADE 옵션 추가 : FOREIGN KEY 

--2) CH
ALTER TABLE tbl_constraint1
DROP CONSTRAINT CK_TBLCONSTRAINT1_CITY;

--3) UK
ALTER TABLE tbl_constraint1
DROP CONSTRAINT UK_TBLCONSTRAINT1_EMAIL;

ALTER TABLE tbl_constraint1
DROP UNIQUE(email);


-- 실습2) CREATE TABLE 문에서 TABLE LEVEL 방식으로 제약조건 설정하는 예
CREATE TABLE tbl_constraint2
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY -- SYS_XXXXXX
    empno NUMBER(4) NOT NULL  -- NOT NULL은 컬럼레벨으로만 추가
    , ename VARCHAR2(20) NOT NULL 
    -- dept 테이블의 deptno(PK) =========> deptno 컬럼으로 참조
    -- 외래키, 참조키
    , deptno NUMBER(2) 
    , email VARCHAR2(150) 
    , kor NUMBER(3) 
    , city VARCHAR2(20) 
    
--  , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno, ename) --> 복합키는 테이블레벨으로만 추가
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno)
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    , CONSTRAINT CK_tblconstraint2_kor CHECK(kor BETWEEN 0 AND 100)
    , CONSTRAINT CK_tblconstraint2_city CHECK(city IN ('서울', '대구', '대전'))
);

SELECT *
FROM user_constraints
WHERE table_name LIKE '%INT2';

DROP TABLE tbl_constraint1 PURGE;

-- 실습3) ALTER TABLE 문에서 제약조건 설정하는 예
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);

--ALTER TABLE 테이블명
--ADD [CONSTRAINT 제약조건명] 제약조건타입 (컬럼명);

--1) empno 컬럼에 PK 제약조건 추가...
ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY (empno);

--2) deptno 컬럼에 FK 제약조건 추가...
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;

DELETE FROM dept
WHERE deptno = 10;

DESC dept;

--CREATE TABLE emp
--(
--    deptno NUMBER(2) C 제약 [F K(deptno)] R d(deptno) ON DELETE CASCADE
--    deptno NUMBER(2) C 제약 [F K(deptno)] R d(deptno) ON DELETE SET NULL -> NULL로 줄건지
--);

--> ON DELETE CASCADE / ON DELETE SET NULL 실습
--1)emp -> tbl_emp 생성
-- 2) dept -> tbl_dept 생성

CREATE TABLE tbl_emp
AS
(
    SELECT *
    FROM emp
);

CREATE TABLE tbl_dept
AS
(
    SELECT *
    FROM dept
);

ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tblconstraint_deptno PRIMARY KEY(deptno);

ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblconstraint_empno PRIMARY KEY(empno);

-- 문제) tbl_emp 테이블에 deptno 컬럼에 PK 설정 + ON DELETE CASCADE 옵션을 추가
ALTER TABLE tbl_emp
ADD CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE CASCADE;

-- 문제) tbl_emp 테이블에 deptno 컬럼에 PK 설정 + ON DELETE CASCADE 옵션을 추가
ALTER TABLE tbl_emp
ADD CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE SET NULL;

SELECT *
FROM tbl_dept;

SELECT *
FROM tbl_emp;

DELETE FROM dept
WHERE deptno = 30;

DELETE FROM tbl_dept
WHERE deptno = 30;

DROP TABLE tbl_dept;


CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***)
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
                                REFERENCES book(b_id)
                                ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;

 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

--
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   

-- 1) EQUI JOIN
-- [문제] 책ID, 책제목, 출판사(C_name), 단가 컬럼 출력
-- book : [b_id(PK), title, c_name]
-- danga : b_id(PK,FK), [price]
--    ㄱ. 오라클에선 natural join 이라고 부른다
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- 조인조건

-- ㄴ. 
    SELECT b.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id; -- 조인조건

-- ㄷ.
    SELECT b.b_id, title, c_name, price
    FROM book b JOIN danga d ON b.b_id = d.b_id; -- 조인조건

-- ㄹ. USING절 사용 : book.b_id(객체명.컬럼명)X, b.b_id(별칭명.컬럼명) X
    SELECT b_id, title, c_name, price
    FROM book JOIN danga USING(b_id); -- 조인조건
    
-- ㅁ. 
    SELECT b_id, title, c_name, price
    FROM book NATURAL JOIN danga; -- 조인조건
    
-- [문제] 책ID, 책제목, 판매수량, 단가, 서점명, 판매금액 출력
-- ㄱ. 위의 ㄱ,ㄴ 방법으로풀기
SELECT b.b_id, b.title, d.price, g.g_name
, d.price * p.p_su "판매금액"
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id;


-- ㄴ. JOIN-ON 구문 풀기
SELECT b.b_id, b.title, d.price, g.g_name
,d.price * p.p_su "판매금액"
FROM book b JOIN danga d ON b.b_id = d.b_id
JOIN panmai p ON b.b_id = p.b_id
JOIN gogaek g ON p.g_id = g.g_id;

-- ㄷ. USING절 사용해서 풀기
SELECT b_id, title, price, g_name
, price * p_su "판매금액"
FROM book JOIN danga USING(b_id) 
JOIN panmai USING(b_id)
JOIN gogaek USING(g_id);

-- NON-EQUI JOIN
-- 일정한 관계 X
-- BETWEEN ~ AND 연산자 사용
SELECT ename, sal, grade, losal || ' - ' || hisal
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;



SELECT *
FROM emp;
SELECT *
FROM dept;

-- emp / dept JOIN
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno; -- EQUI JOIN
--      NULL        10/20/30/40
-- 11행 KING 사원 X 

-- OUTER JOIN
--ㄱ. LEFT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno;

SELECT d.deptno, ename, hiredate
FROM dept d, emp e
WHERE d.deptno = e.deptno(+);

--ㄴ. RIGHT OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d RIGHT OUTER JOIN emp e ON d.deptno = e.deptno;

SELECT d.deptno, ename, hiredate
FROM dept d, emp e
WHERE d.deptno(+) = e.deptno;

--ㄷ. FULL OUTER JOIN
SELECT d.deptno, ename, hiredate
FROM dept d FULL OUTER JOIN emp e ON d.deptno = e.deptno;

SELECT d.deptno, ename, hiredate
FROM dept d, emp e
WHERE d.deptno = e.deptno;

-- SELF JOIN
-- 사원번호, 사원명, 입사일자, 직속상사 사원번호, 직송상사의 사원명
SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename "직속상사"
FROM emp a, emp b
WHERE a.mgr = b.empno;

SELECT a.empno, a.ename, a.hiredate, a.mgr, b.ename "직속상사"
FROM emp a JOIN emp b ON a.mgr = b.empno;

-- CROSS JOIN : 데카르트 곱
SELECT e.*, d.*
FROM emp e, dept d;

SELECT e.*, d.*
FROM emp e CROSS JOIN dept d;

-- 문제) 책ID, 책제목, 판매수량, 단가, 서점명(고객), 판매금액(판매수량*단가) 출력 
SELECT b.b_id, b.title, p.p_su, d.price, g.g_name
, d.price * p.p_su "판매금액"
FROM book b, panmai p, danga d, gogaek g
WHERE b.b_id = p.b_id AND b.b_id = d.b_id AND p.g_id = g.g_id;

-- 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )
SELECT b.b_id, b.title
,SUM(p.p_su) 총판매권수, d.price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, price;


-- 문제) 판매권수가 가장 많은 책 정보 조회 
SELECT b_id, title, price
FROM (
    SELECT b.b_id, b.title
    ,SUM(p.p_su) total_panmai_su, d.price
    FROM book b JOIN danga d ON b.b_id = d.b_id
    JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id, b.title, price
) 
WHERE total_panmai_su = (SELECT MAX(SUM(p_su)) FROM panmai
                        GROUP BY b_id);



-- 문제) 올해 판매권수가 가장 많은 책(수량을 기준으로)
--      (  책ID, 책제목, 수량 )
SELECT b_id, title, p_su
FROM(
    SELECT p.b_id, title, p_su
    ,RANK() OVER(ORDER BY p_su DESC) rank
    FROM panmai p JOIN book b ON p.b_id = b.b_id
    WHERE TO_CHAR(p_date,'YYYY') = 2024
    )
WHERE rank = 1;

-- 1) TOP-N 분석 방법
;
SELECT t.*
FROM ( 
        SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id 
        GROUP BY b.b_id, title, price
        ORDER BY 총판매권수 DESC
) t
--WHERE ROWNUM BETWEEN 3 AND 5; -- 주의
--WHERE ROWNUM <= 3;
WHERE ROWNUM = 1;

-- 2) RANK 순위 함수 ..

WITH t AS (
    SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
       , RANK() OVER( ORDER BY SUM( p_su  ) DESC ) 판매순위
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id 
    GROUP BY b.b_id, title, price
)
SELECT *
FROM t
--WHErE 판매순위 BETWEEN 3 AND 5;
--WHErE 판매순위 <= 3;
WHErE 판매순위 = 1;

-- 문제) book 테이블에서 판매가 된 적이 없는 책의 정보 조회
SELECT b.b_id, title, NVL(p_su,0) 판매수량
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
WHERE p_su IS NULL;



-- 문제) book 테이블에서 판매가 된 적이 있는 책의 정보 조회
--      ( b_id, title, price  컬럼 출력 )
-- [1]
SELECT b.b_id, title, price
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NOT NULL;

-- [2]
SELECT DISTINCT b.b_id, title, price
FROM book b, panmai p, danga d
WHERE b.b_id = p.b_id AND d.b_id = b.b_id; 

-- 문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
SELECT g.g_id, g_name, SUM(price)
FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY g_name, g.g_id;

-- 문제) 년도, 월별 판매 현황 구하기
SELECT year, month, SUM(p_su) 판매현황
FROM(
    SELECT b.b_id, title, p_su
    ,TO_CHAR(p_date, 'YYYY') year
    ,TO_CHAR(p_date, 'MM') month
    FROM book b JOIN panmai p ON b.b_id = p.b_id
    )
GROUP BY year, month;

-- 문제) 서점별 년도별 판매현황 구하기
SELECT g_name, year, SUM(p_su) 판매현황
FROM(
    SELECT b.b_id, title, p_su, g_name
    ,TO_CHAR(p_date, 'YYYY') year
    FROM book b JOIN panmai p ON b.b_id = p.b_id
                JOIN gogaek g ON p.g_id = g.g_id
    )
GROUP BY g_name, year;


-- 문제) 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )

SELECT *
FROM(
    SELECT b.b_id, title, price, sum(p_su) 총판매권수
    ,price * sum(p_su) 총판매금액
    FROM book b, danga d, panmai p
    WHERE b.b_id = d.b_id AND b.b_id = p.b_id
    GROUP BY b.b_id, title, price
    )
WHERE 총판매금액 >= 15000;


----------------------------------------------------------------------------
-- 풀이 [2]
--문제) 책ID, 책제목, 판매수량, 단가, 서점명(고객), 판매금액(판매수량*단가) 출력 
-- book   : b_id, title
-- panmai : p_su
-- danga  : price
-- gogaek : g_name
 
 
-- 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )
-- book   : b_id, title
-- danga  : price
-- panmai : p_su
 
 SELECT b.b_id, title , price, SUM( p_su )  총판매권수
 FROM  book b JOIN  panmai p ON b.b_id = p.b_id
              JOIN danga d ON  b.b_id = d.b_id
 GROUP BY   b.b_id, title , price
 ORDER BY  b.b_id;
 
 --
SELECT DISTINCT b.b_id 책ID, title 제목, price 단가 
   --, p_su 판매수량
, (SELECT SUM(p_su) FROM panmai WHERE b_id = b.b_id) 총판매권수
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id;
      
-- 문제) 판매권수가 가장 많은 책 정보 조회 
 
WITH t
AS 
  (
  SELECT b.b_id, title , price, SUM( p_su )  총판매권수
 FROM  book b JOIN  panmai p ON b.b_id = p.b_id
              JOIN danga d ON  b.b_id = d.b_id
 GROUP BY   b.b_id, title , price
 ORDER BY  b.b_id
 ), 
 s AS (
 SELECT t.*
   , RANK() OVER( ORDER BY  총판매권수 DESC ) 판매순위
 FROM t
 )
 SELECT s.*
 FROM s
 WHERE 판매순위 = 1;
 
 --
 -- 1) TOP-N 분석 방법
;
SELECT t.*
FROM ( 
        SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai p ON b.b_id = p.b_id 
        GROUP BY b.b_id, title, price
        ORDER BY 총판매권수 DESC
) t
WHERE ROWNUM BETWEEN 3 AND 5; -- 주의
WHERE ROWNUM <= 3;
WHERE ROWNUM = 1;

-- 2) RANK 순위 함수 ..

WITH t AS (
    SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
       , RANK() OVER( ORDER BY SUM( p_su  ) DESC ) 판매순위
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id 
    GROUP BY b.b_id, title, price
)
SELECT *
FROM t
WHErE 판매순위 BETWEEN 3 AND 5;
WHErE 판매순위 <= 3;
WHErE 판매순위 = 1;
 
-- 문제) 올해 판매권수가 가장 많은 책(수량을 기준으로)
--      (  책ID, 책제목, 수량 )

SELECT ROWNUM 순위, t.*
FROM ( 
    SELECT  p.b_id, title , SUM( p_su  ) 판매수량
    FROM panmai p, book b
    WHERE TO_CHAR(p_date, 'YYYY') = 2024 AND b.b_id = p.b_id
    GROUP BY p.b_id, title
    ORDER BY 판매수량 DeSC
 ) t 

-- 문제) book 테이블에서 판매가 된 적이 없는 책의 정보 조회
 -- 책 종류 : 9가지 종류
 -- (ANTI JOIN : NOT IN 구문)
 SELECT b.b_id, title, price
 FROM book b JOIN danga d ON b.b_id = d.b_id
 WHERE b.b_id NOT IN ( SELECT DISTINCT b_id    
 FROM panmai );
 
 -- MINUS  차집합 SET(집합)연산자...
 
-- 문제) book 테이블에서 판매가 된 적이 있는 책의 정보 조회
--      ( b_id, title, price  컬럼 출력 )
  SELECT DISTINCT b.b_id,title, price
  FROM book b , panmai p, danga d
  WHERE b.b_id = p.b_id AND b.b_id = d.b_id;
  
  -- EXISTS -- SEMI JOIN  
  SELECT b.b_id, title, price
 FROM book b JOIN danga d ON b.b_id = d.b_id
 WHERE b.b_id  IN ( SELECT DISTINCT b_id    
 FROM panmai );
      
-- 문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
 SELECT g.g_id, g_name,  SUM(p_su) 
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY g.g_id, g_name ;
 
-- 문제) 년도, 월별 판매 현황 구하기
 SELECT  TO_CHAR( p_date, 'YYYY') p_year, TO_CHAR( p_date, 'MM' ) p_month,   SUM(p_su)
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY  TO_CHAR( p_date, 'YYYY') , TO_CHAR( p_date, 'MM')
 ORDER BY p_year, p_month;
 
-- 문제) 서점별 년도별 판매현황 구하기
-- panmai : p_date, p_su
-- gogaek : g_id, g_name
 
 SELECT p_date
 FROM panmai;
 
 SELECT g_name , TO_CHAR( p_date, 'YYYY') p_year,  SUM(p_su)
 FROM panmai p JOIN gogaek g ON p.g_id = g.g_id
 GROUP BY g_name , TO_CHAR( p_date, 'YYYY') 
 ORDER BY g_name, p_year;
 
-- 문제) 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )
     
     SELECT b.b_id, title, price, SUM( p_su  ) 총판매권수
           , SUM ( p_su) * price 총판매금액
     FROM book b JOIN danga d ON b.b_id = d.b_id 
                JOIN panmai p ON b.b_id = p.b_id
     GROUP BY   b.b_id, title, price
     HAVING SUM ( p_su) * price >= 15000
     ORDER BY   b.b_id;


