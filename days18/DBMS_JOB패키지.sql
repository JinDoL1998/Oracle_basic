-- SCOTT  
--(��) :  Ʈ�����, ��ȣȭ, [�����ٷ�]
 1) DBMS_JOB ��Ű��                  *****
 2) DBMS_SCHEDULER ��Ű�� ( 10g ���� )
--
1) ���α׷� �غ�( ���̺�, ���� ���ν���, ���� �Լ� ) 
2) ������ ����
3) �� ����/����/����
-- ��)
CREATE TABLE tbl_job(
   seq NUMBER
   ,  insert_date DATE
);
--
CREATE OR REPLACE PROCEDURE up_job
IS
  vseq NUMBER;
BEGIN
  SELECT NVL(MAX(seq),0)+1  INTO vseq
  FROM tbl_job;
  
  INSERT INTO tbl_job VALUES ( vseq , SYSDATE );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE( SQLERRM );
END;
-- Procedure UP_JOB ��(��) �����ϵǾ����ϴ�.

-- 1) �� ��� : DBMS_JOB.SUMMIT 
DBMS_JOB.SUMMIT 
(
   job           OUT      �� ��ϵ� �Ŀ� ���ȣ
   what           IN      ����� ���α׷�(SQL, PL/SQL )
   next_date              ���� ����� ��¥(�ð�) SYSDATE
   interaval              ���� ���� �ֱ�
   no_parse               ���ν����� �Ľ� ����   FALSE
   instance               ���� ����Ҷ� �� ���� �����ų�� �ִ� Ư���ν��Ͻ�  0
   force
)
-- �͸����ν������� �� ���..
DECLARE
  vjob_no NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(
         job => vjob_no
       , what => 'UP_JOB;'
       , next_date => SYSDATE
       -- , interval => 'SYSDATE + 1'  �Ϸ翡 �� ��  ���ڿ� ����
       -- , interval => 'SYSDATE + 1/24'
       , interval => 'SYSDATE + 1/24/60' -- �� �� ����
       -- , interval => 'NEXT_DAY(TRUNC(SYSDATE),'�Ͽ���') + 15/24'
       --    ���� �Ͽ��� ����3�� ����.
       -- , interval => 'LAST_DAY(TRUNC(SYSDATE)) + 18/24 + 30/60/24'
       --    �ſ� ������ ����   6�� 30�� ����..
    );
    COMMIT;
     DBMS_OUTPUT.PUT_LINE( '�� ��ϵ� ��ȣ : ' || vjob_no );
END;

SELECT seq, TO_CHAR( insert_date, 'DL TS'  )
FROM tbl_job;

-- 
SELECT *
FROM user_jobs;
-- �� ����  :  DBMS_JOB.BROKEN
BEGIN
  DBMS_JOB.BROKEN( 1, true);
  COMMIT;
END;
-- �� �����
BEGIN
  DBMS_JOB.BROKEN( 1, false);
  COMMIT;
END;
-- �� �Ӽ� ���� : DBMS_JOB.CHANGE
-- �ֱ⿡ ������� ���� : DBMS_JOB.RUN( ���ȣ )
BEGIN
  DBMS_JOB.RUN( 1 );
 COMMIT;
END;
-- �� ����
BEGIN
  DBMS_JOB.REMOVE(1);
  COMMIT;
END; 









