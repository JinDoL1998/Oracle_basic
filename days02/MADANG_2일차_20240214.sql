-- MADANG
SELECT *
FROM tabs;

DESC imported_book;
DESC book;

SELECT *
FROM book;
FROM imported_book;

SELECT name "�̸�", phone "��ȭ��ȣ"
,NVL(phone, '����ó ����') "��ȭ��ȣ"
,NVL(phone, 0) "��ȭ��ȣ" -- ���� 0�� �ڵ����� ���ڿ��� ��ȯ�ؼ� ���
FROM customer;