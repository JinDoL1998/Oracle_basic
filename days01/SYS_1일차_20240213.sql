-- �ּ� ó�� (Ctrl + /)
-- ��� ����� ���� ��ȸ
-- ���� �밳 ���� ������ ������ ���Ѵ�. (����)
-- keyword(�����)�� �빮�ڷ� �Է��ϵ��� ���Ѵ�. (����)
-- ���̺��, �÷����� �ҹ��� ���(����)
-- ������ (��, �ٸ���) ����
SELECT  * 
FROM    all_users; -- Ctrl + Enter, F5

-- �����߿� ����� ���� ����, ����, ���� -- 
-- 1) scorr ���� ����, ����, ����
--   (1) scorr ���� ���� Ȯ��
SELECT  * 
FROM    all_users;

-- (2) scorr ���� ����
CREATE USER scott 
IDENTIFIED BY tiger;

-- (3) scorr ���� ��й�ȣ 1234 ����
ALTER USER scott IDENTIFIED BY tiger;

-- (4) scorr ���� ����
DROP USER scorr CASCADE;

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



