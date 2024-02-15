SELECT *
FROM tabs;

-- HR ������ �����ϰ� �ִ� ���̺� ���� ��ȸ
SELECT *
FROM tabs
ORDER BY TABLE_NAME ASC;

--COUNTRIES
DESC countries;
COUNTRY_ID   NOT NULL CHAR(2)       ����ID
COUNTRY_NAME          VARCHAR2(40)  ������
REGION_ID             NUMBER        ���ID
SELECT *
FROM countries;

--DEPARTMENTS - �μ� ���̺�(�μ���ȣ, �μ���, ������ID, ��ġID)
DESC departments;

--EMPLOYEES - ������̺�(���ID, �̸�, ��, �̸���, ����ȣ, �Ի�����, ��ID, SAL ���)
SELECT *
FROM employees;

--JOBS - �� ���̺�(��ID, ���̸�, �ּ�SAL, �ִ�SAL)
SELECT *
FROM jobs;

--JOB_HISTORY - ���? (���ID, ������, ������, ��ID, �μ�ID)
DESC job_history;
SELECT *
FROM job_history;

--LOCATIONS
DESC locations;
LOCATION_ID    NOT NULL NUMBER(4)       ��ġ��ȣ
STREET_ADDRESS          VARCHAR2(40)    �ּ�
POSTAL_CODE             VARCHAR2(12)    �����ȣ
CITY           NOT NULL VARCHAR2(30)    ����
STATE_PROVINCE          VARCHAR2(25)    ��
COUNTRY_ID              CHAR(2)         ����ID

SELECT *
FROM locations

--REGIONS - "��� ����' ���� �ִ� ���̺�
DESC regions;
REGION_ID   NOT NULL NUMBER         ����
REGION_NAME          VARCHAR2(25)   ���ڿ�    ���

SELECT *
FROM regions;

SELECT *
FROM employees;

-- ���� ���̺��� �����ȣ, ��� �̸�, �Ի����� Į�� ���(��ȸ)
-- first_name, last_name = name Į������ ���
-- 01722. 00000 -  "invalid number"
-- ORA-00904: " ": invalid identifier
SELECT employee_id 
, first_name || ' ' || last_name �̸� -- '�̸�'
, CONCAT ( CONCAT(first_name, ' '), last_name) AS "NAME"
, hire_date 
FROM employees;

DESC EMPLOYEES;













