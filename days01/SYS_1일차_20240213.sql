-- �ּ� ó�� (Ctrl + /)
-- ��� ����� ���� ��ȸ
-- ���� �밳 ���� ������ ������ ���Ѵ�. (����)
-- keyword(�����)�� �빮�ڷ� �Է��ϵ��� ���Ѵ�. (����)
-- ���̺��, �÷����� �ҹ��� ���(����)
-- ������ (��, �ٸ���) ����
SELECT  * 
FROM    all_users; -- Ctrl + Enter, F5

-- �����߿� ����� ���� ����, ����, ���� -- 
-- 1) scott ���� ����, ����, ����
--   (1) scott ���� ���� Ȯ��
SELECT  * 
FROM    all_users;

-- (2) scott ���� ����
CREATE USER scott 
IDENTIFIED BY tiger;

-- (3) scott ���� ��й�ȣ 1234 ����
ALTER USER scott IDENTIFIED BY tiger;

-- (4) scott ���� ����
DROP USER scott CASCADE;

-- (5) SYS �ְ������ ������ CREATE SESSION �����ͺ��̽� ����(����) �ý��� ������ SCOTT �����ο�.
GRANT CREATE SESSION TO SCOTT;

GRANT CREATE SESSION TO student_role;
GRANT student_role TO scott;

-- DDL( CREATE, DROP, ALTER )
-- CREATE USER, DROP USER, ALTER USER
-- CREATE TABLESPACE, DROP TABLESPACE, ALTER TABLESPACE
-- CREATE ROLE, DROP ROLE, ALTER ROLE

-- ����Ŭ ��ġ �ÿ� �̸� ���ǵ� ��(role) Ȯ���ϴ� ����(sql)�� �ۼ��ϼ���
SELECT *
FROM dba_roles;

SELECT grantee,privilege 
FROM DBA_SYS_PRIVS 
WHERE grantee = 'CONNECT';

-- SCOTT ���� + ���� ���̺� �߰�
-- C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql ��������

-- [����]SCOTT���� ���� �Ŀ� scott.sql �����ؼ� ������� ���̺��� Ȯ��
SELECT * 
FROM tabs;

-- db ������ ��� ���̺��� ����� db������ �����̾�� �Ѵ�.
SELECT *
FROM dba_tables;
-- COUNT() ����Ŭ �Լ�
-- SELECT COUNT(*)
SELECT *
FROM dictionary;

-- SYS --
DROP USER madang CASCADE;
CREATE USER madang IDENTIFIED BY madang DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PROFILE DEFAULT;
GRANT CONNECT, RESOURCE TO madang;
GRANT CREATE VIEW, CREATE SYNONYM TO madang;
GRANT UNLIMITED TABLESPACE TO madang;
ALTER USER madang ACCOUNT UNLOCK;

SELECT *
FROM all_users
ORDER BY username DESC;

-- DB ���� Ȯ�� --
-- 1) HR ������ ��й�ȣ�� lion���� �����ϰ�
-- 2) + �� ������ Ŭ�� - HR ����
-- 3) HR ������ �����ϰ� �ִ� ���̺� ����� ��ȸ
SELECT *
FROM all_tables
ORDER BY OWNER ASC;

PASSWORD HR;
ALTER USER HR ACCOUNT UNLOCK;






