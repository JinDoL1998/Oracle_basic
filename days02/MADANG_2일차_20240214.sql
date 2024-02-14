-- MADANG
SELECT *
FROM tabs;

DESC imported_book;
DESC book;

SELECT *
FROM book;
FROM imported_book;

SELECT name "이름", phone "전화번호"
,NVL(phone, '연락처 없음') "전화번호"
,NVL(phone, 0) "전화번호" -- 숫자 0을 자동으로 문자열로 변환해서 출력
FROM customer;