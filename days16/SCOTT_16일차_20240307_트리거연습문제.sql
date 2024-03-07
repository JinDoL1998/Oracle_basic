-- SCOTT
-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명        VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격     NUMBER
  ,재고수량       NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;

SELECT * FROM 상품;

--문제1) 입고 테이블에 상품이 입고가 되면 자동으로 상품 테이블의 재고수량이  update 되는 트리거 생성 + 확인
-- 입고 테이블에 데이터 입력
-- ut_insipgo
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);

SELECT * FROM 입고;
SELECT * FROM 상품;
SELECT * FROM 판매;

CREATE OR REPLACE TRIGGER ut_insipgo
AFTER
INSERT ON 입고
FOR EACH ROW
DECLARE
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
    
--EXCEPTION
END;

----------------------------------------------------------------------
--문제2) 입고 테이블에서 입고가 수정되는 경우    상품테이블의 재고수량 수정. 
-- 트리거명 : ut_updipgo
UPDATE 입고 
SET 입고수량 = 30 
WHERE 입고번호 = 5;
COMMIT;

SELECT * FROM 입고;
SELECT * FROM 상품;
SELECT * FROM 판매;
ROLLBACK;

CREATE OR REPLACE TRIGGER ut_updipgo
AFTER
UPDATE ON 입고
FOR EACH ROW
DECLARE
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
--EXCEPTION
END;

-- 문제3) 입고테이블에서 입고가 취소되어서 입고 삭제. 상대 테이블의 재고수량 수정.
-- dt_delipgo
DELETE FROM 입고
WHERE 입고번호 = 5;
COMMIT;
ROLLBACK;
SELECT * FROM 입고;
SELECT * FROM 상품;

CREATE OR REPLACE TRIGGER dt_delipgo
BEFORE
DELETE ON 입고 
FOR EACH ROW
DECLARE
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드 = :OLD.상품코드;
--EXCEPTION
END;


-- 문제4) 판매테이블에 판매가 되면 (INSERT)
-- 상품테이블의 재고수량이 수정
ut_insPan
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
                (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT;

SELECT * FROM 판매;
SELECT * FROM 상품;


CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
INSERT ON 판매
FOR EACH ROW
DECLARE
    vqty 상품.재고수량%TYPE;
BEGIN
    SELECT 재고수량 INTO vqty
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;

    IF vqty < :NEW.판매수량 THEN
        RAISE_APPLICATION_ERROR(-20007, '재고수량 부족으로 판매 오류');
    ELSE
        UPDATE 상품
        SET 재고수량 = 재고수량 - :NEW.판매수량
        WHERE 상품코드 = :NEW.상품코드;
    END IF;    
--EXCEPTION
END;

-- 문제5) 판매번호 1   판매수량 5->10
UPDATE 판매 
SET 판매수량 = 150 
WHERE 판매번호 = 1;

SELECT * FROM 판매;
SELECT * FROM 상품;
ROLLBACK;
-- 상품 테이블에도 재고수량 수정 트리거
--ut_updPan
CREATE OR REPLACE TRIGGER ut_updpan
BEFORE
UPDATE ON 판매
FOR EACH ROW
DECLARE
    vqty 상품.재고수량%TYPE;
BEGIN
    IF (vqty + :OLD.판매수량) < :NEW.판매수량 THEN
        RAISE_APPLICATION_ERROR(-20007, '재고수량 부족으로 판매 오류');
    ELSE
        UPDATE 상품
        SET 재고수량 = 재고수량 + :OLD.판매수량 - :NEW.판매수량
        WHERE 상품코드 = :NEW.상품코드;
    END IF;
--EXCEPTION
END;


-- 문제) 판매번호 1   (AAAAA 10) 판매 취소 (DELETE)
-- 상품테이블에 재고수량 수정
--ut_delPan

DELETE FROM 판매
WHERE 판매번호 = 1;
SELECT * FROM 판매;
SELECT * FROM 상품;

CREATE OR REPLACE TRIGGER ut_delPan
AFTER
DELETE ON 판매
FOR EACH ROW
DECLARE
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 + :OLD.판매수량
    WHERE 상품코드 = :OLD.상품코드;
--EXCEPTION
END;
--------------------------------------------------------------------------------------












