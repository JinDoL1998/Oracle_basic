-- MADANG
SELECT * 
FROM orders;

SElECT MAX(saleprice)
FROM orders
WHERE custid = 3;

SELECT orderid, custid, saleprice
FROM orders
--WHERE saleprice > ALL (SELECT saleprice
--                        FROM orders
--                        WHERE custid = 3);
                        
WHERE saleprice > (SELECT MAX(saleprice)
                    FROM orders
                    WHERE custid = 3);

-- EXISTS 질의 4-16 p.229
SELECT SUM(saleprice), AVG(saleprice), MAX(saleprice), MIN(saleprice)
FROM orders;

DESC orders;

-- 모든 고객들의 총 판매금액
SELECT SUM(saleprice)
FROM orders;

-- 대한민국 고객 체크
SELECT *
FROM customer
WHERE address LIKE '대한민국%'; -- custid 2,3,5

-- 대한민국 고객들의 총 판매금액 조회
SELECT SUM(saleprice) --custid, saleprice
FROM orders
WHERE custid IN (2,3,5);

