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

-- EXISTS ���� 4-16 p.229
SELECT SUM(saleprice), AVG(saleprice), MAX(saleprice), MIN(saleprice)
FROM orders;

DESC orders;

-- ��� ������ �� �Ǹűݾ�
SELECT SUM(saleprice)
FROM orders;

-- ���ѹα� �� üũ
SELECT *
FROM customer
WHERE address LIKE '���ѹα�%'; -- custid 2,3,5

-- ���ѹα� ������ �� �Ǹűݾ� ��ȸ
SELECT SUM(saleprice) --custid, saleprice
FROM orders
WHERE custid IN (2,3,5);

