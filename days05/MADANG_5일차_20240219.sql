-- MADANG

SELECT EXTRACT(MONTH FROM orderdate) "month",
      COUNT(orderdate) "Orders"
FROM orders -- 1. �ֹ����̺��� 
GROUP BY EXTRACT(month FROM orderdate) -- 2. �ֹ� ������ �׷�
ORDER BY 'Orders' DESC; 

SELECT *
FROM orders;

