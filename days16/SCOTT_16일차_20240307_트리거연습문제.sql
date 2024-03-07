-- SCOTT
-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,��ǰ��        VARCHAR2(30)  NOT NULL
  ,������        VARCHAR2(30)  NOT NULL
  ,�Һ��ڰ���     NUMBER
  ,������       NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ      NUMBER PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�԰�����     DATE
  ,�԰����      NUMBER
  ,�԰�ܰ�      NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ      NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����      DATE
  ,�Ǹż���      NUMBER
  ,�ǸŴܰ�      NUMBER
);

-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
COMMIT;

SELECT * FROM ��ǰ;

--����1) �԰� ���̺� ��ǰ�� �԰� �Ǹ� �ڵ����� ��ǰ ���̺��� ��������  update �Ǵ� Ʈ���� ���� + Ȯ��
-- �԰� ���̺� ������ �Է�
-- ut_insipgo
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);

SELECT * FROM �԰�;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;

CREATE OR REPLACE TRIGGER ut_insipgo
AFTER
INSERT ON �԰�
FOR EACH ROW
DECLARE
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    
--EXCEPTION
END;

----------------------------------------------------------------------
--����2) �԰� ���̺��� �԰� �����Ǵ� ���    ��ǰ���̺��� ������ ����. 
-- Ʈ���Ÿ� : ut_updipgo
UPDATE �԰� 
SET �԰���� = 30 
WHERE �԰��ȣ = 5;
COMMIT;

SELECT * FROM �԰�;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;
ROLLBACK;

CREATE OR REPLACE TRIGGER ut_updipgo
AFTER
UPDATE ON �԰�
FOR EACH ROW
DECLARE
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰���� + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
--EXCEPTION
END;

-- ����3) �԰����̺��� �԰� ��ҵǾ �԰� ����. ��� ���̺��� ������ ����.
-- dt_delipgo
DELETE FROM �԰�
WHERE �԰��ȣ = 5;
COMMIT;
ROLLBACK;
SELECT * FROM �԰�;
SELECT * FROM ��ǰ;

CREATE OR REPLACE TRIGGER dt_delipgo
BEFORE
DELETE ON �԰� 
FOR EACH ROW
DECLARE
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰����
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
--EXCEPTION
END;


-- ����4) �Ǹ����̺� �ǸŰ� �Ǹ� (INSERT)
-- ��ǰ���̺��� �������� ����
ut_insPan
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
                (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT;

SELECT * FROM �Ǹ�;
SELECT * FROM ��ǰ;


CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
INSERT ON �Ǹ�
FOR EACH ROW
DECLARE
    vqty ��ǰ.������%TYPE;
BEGIN
    SELECT ������ INTO vqty
    FROM ��ǰ
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;

    IF vqty < :NEW.�Ǹż��� THEN
        RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
    ELSE
        UPDATE ��ǰ
        SET ������ = ������ - :NEW.�Ǹż���
        WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    END IF;    
--EXCEPTION
END;

-- ����5) �ǸŹ�ȣ 1   �Ǹż��� 5->10
UPDATE �Ǹ� 
SET �Ǹż��� = 150 
WHERE �ǸŹ�ȣ = 1;

SELECT * FROM �Ǹ�;
SELECT * FROM ��ǰ;
ROLLBACK;
-- ��ǰ ���̺��� ������ ���� Ʈ����
--ut_updPan
CREATE OR REPLACE TRIGGER ut_updpan
BEFORE
UPDATE ON �Ǹ�
FOR EACH ROW
DECLARE
    vqty ��ǰ.������%TYPE;
BEGIN
    IF (vqty + :OLD.�Ǹż���) < :NEW.�Ǹż��� THEN
        RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
    ELSE
        UPDATE ��ǰ
        SET ������ = ������ + :OLD.�Ǹż��� - :NEW.�Ǹż���
        WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    END IF;
--EXCEPTION
END;


-- ����) �ǸŹ�ȣ 1   (AAAAA 10) �Ǹ� ��� (DELETE)
-- ��ǰ���̺� ������ ����
--ut_delPan

DELETE FROM �Ǹ�
WHERE �ǸŹ�ȣ = 1;
SELECT * FROM �Ǹ�;
SELECT * FROM ��ǰ;

CREATE OR REPLACE TRIGGER ut_delPan
AFTER
DELETE ON �Ǹ�
FOR EACH ROW
DECLARE
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ + :OLD.�Ǹż���
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
--EXCEPTION
END;
--------------------------------------------------------------------------------------












