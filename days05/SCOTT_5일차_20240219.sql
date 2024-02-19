SELECT *
,REPLACE(ename, 'LA', '<span color = red></span>')
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i');

--[1]
SELECT empno, ename, deptno, sal+NVL(comm,0) pay
FROM emp
WHERE sal+NVL(comm,0) = (SELECT MIN(sal+NVL(
comm,0)) max_pay
                         FROM emp
                         );

--[2]
-- SQL ������: ALL, SOME, ANY
SELECT empno, ename, deptno, sal+NVL(comm,0) pay
FROM emp
WHERE sal+NVL(comm, 0) <= ALL(SELECT sal+NVL(comm, 0) FROM emp);

-- 4-2. emp ���̺��� �� �μ��� ����� ��ȸ
-- [1] SET(����) ������ : ������( UNION/UNION ALL )
SELECT '10' deptno, COUNT(*) CNT
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '20', COUNT(*)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT '30', COUNT(*)
FROM emp
WHERE deptno = 30;

-- [2] scalar ��������
SELECT DISTINCT deptno
      ,(
      SELECT COUNT(*) 
      FROM emp c
      WHERE c.deptno = p.deptno
      ) cnt
FROM emp p
ORDER BY deptno ASC;

-- [3] GROUP BY ��
SELECT deptno, COUNT(*) CNT
        , sum(sal + NVL(comm, 0)) sum
        , ROUND(AVG(sal + NVL(comm, 0)),2) avg
        , MAX(sal + NVL(comm, 0)) max
        , MIN(sal + NVL(comm, 0)) min
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- pay�� ����ű�� ���� -- (�ϱ�)
SELECT deptno, empno, ename, sal+ NVL(comm,0) pay
        ,(SELECT COUNT(*) + 1
        FROM emp c
        WHERE c. sal+NVL(comm,0) > p.sal+NVL(comm,0) 
        ) pay_rank
FROM emp p
ORDER BY pay DESC;

-- [SET ���� ������]
-- 1) ������ (UNION, UNION ALL)
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
--UNION -- 6���� �ߺ��ȴ�. �����ϰ� 1���� ����
UNION ALL -- 23�� �ߺ��Ǵ°� ��� ����
SELECT name, city, buseo
FROM insa
WHERE city = '��õ';

-- 2) ������ (MINUS)
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
MINUS
SELECT name, city, buseo
FROM insa
WHERE city = '��õ';

-- 3) ������ (INTERSECT)
-- ���ߺ� �̸鼭 ��õ�� ������� �ľ�
-- [1]
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�' AND city = '��õ'; -- 6��

-- [2]
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city = '��õ';

-- [SET(����) �����ڸ� ����� �� ������ ��]
-- ORA-01790: expression must have same datatype as corresponding expression
-- ORA-01789: query block has incorrect number of result columns
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
--UNION  
UNION ALL 
SELECT name, city--, basicpay
FROM insa
WHERE city = '��õ';

-- insa���̺��� ������� + emp ���̺��� ��� ���� ��� ���
SELECT buseo, num, name, ibsadate, basicpay, sudang
FROM insa
UNION ALL
SELECT TO_CHAR(deptno), empno, ename, hiredate, sal, comm
FROM emp;

-- [������ ���� ������]
-- PRIOR, CONNECT_BY_ROOT

-- [���� ������] ||

-- [��� ������] +, -, /, *
--              ������ ���ϴ� ������ X
--              ������ ���ϴ� �Լ� MOD(5,3)*****  5-3 * FLOOR(5/3)
--              ������ ���ϴ� �Լ� REMAINDER(5,3) 5-3 * ROUND(5/3)

SELECT 
-- 10/0 -- ORA-01476: divisor is equal to zero
-- 'A' / 2 -- ORA-01722: invalid number
MOD(10,0)
FROM dual;

--IS [NOT] NAN    NOT A NUMBER
--IS [NOT] INFINITE


-- ����Ŭ �Լ�(function)
-- 1. ������ �������� �����ϰ� ���ְ� �������� ���� �����ϴµ� ���Ǵ� ���� �Լ��� �Ѵ�. 
--    �Ϲ������� �־��� ������(�μ�)�� ó���ϰ� �� ����� ��ȯ�ϴ� ����� �����Ѵ�
-- 2. ���� : ������ �Լ�, ������ �Լ�

SELECT LOWER(ename)
FROM emp;

SELECT COUNT(*)
FROM emp;

-- [���� �Լ�] --
-- 1) ROUND(number) ���ڰ��� Ư�� ��ġ���� �ݿø��Ͽ� �����Ѵ�. 
SELECT 3,141592
, ROUND(3.141592)   -- �Ҽ��� ù ��° �ڸ����� �ݿø�
, ROUND(3.141592, 2)
, ROUND(1234.5678, -1)
, ROUND(1234.5678, -2)
, ROUND(1234.5678, -3)
FROM dual;

-- [����] emp ���̺��� pay, ��ձ޿�, �ѱ޿�, ����� ���
-- ORA-00937: not a single-group group function
-- ���� �Լ��� �Ϲ� Į����� ���� SELECT �Ұ�
SELECT emp.*
, sal+NVL(comm, 0) pay
--, COUNT(*) �����
, (SELECT COUNT(*) FROM emp) cnt
, (SELECT SUM(sal + NVL(comm,0)) FROM emp) total_pay
-- ��� �޿� ����ؼ� �Ҽ��� 2�ڸ� ���� �������
, (SELECT ROUND(AVG(sal + NVL(comm,0)),2) FROM emp) avg_pay
FROM emp;

--TRUNC(number) ���ڰ��� Ư�� ��ġ���� �����Ͽ� �����Ѵ�. 
--CEIL ���ڰ��� �Ҽ��� ù°�ڸ����� �ø��Ͽ� �������� �����Ѵ�. 
--FLOOR ���ڰ��� �Ҽ��� ù°�ڸ����� �����Ͽ� �������� �����Ѵ�. 
--MOD ���������� �����Ѵ�. 
--ABS ���ڰ��� ���밪�� �����Ѵ�. 
--SIGN ���ڰ��� ��ȣ�� ���� 1, 0, -1�� ������ �����Ѵ�. 
--POWER(n1,n2) n1^n2�� ���������� �����Ѵ�. 
--SQRT(n) n�� ������ ���� �����Ѵ�. 
--SIN(n) n�� sine ���� �����Ѵ�. 
--COS(n) n�� cosine ���� �����Ѵ�. 
--TAN(n) n�� tangent ���� �����Ѵ�. 
--SINH(n) n�� hyperbolic sine ���� �����Ѵ�. 
--COS(n) n�� hyperbolic cosine ���� �����Ѵ�. 
--TAN(n) n�� hyperbolic tangent ���� �����Ѵ�. 
--LOG(a,b) ���� a�� b�� ���� ���� �����Ѵ�. ��, ���� ���� ���� ���� �� ��������� �˸� 
--LN(n) n�� �ڿ��α� ���� �����Ѵ�. 

-- [�����Լ�]
SELECT COUNT(*) -- NULL ���� ������ ������ ��ȯ
      ,COUNT(empno)
      ,COUNT(deptno)
      ,COUNT(sal)
      ,COUNT(hiredate)
      ,COUNT(comm)
FROM emp;

-- ��� Ŀ�̼� ?
--SELECT AVG(comm) -- 550
SELECT SUM(comm) / COUNT(*) -- 183.33333
FROM emp;

-- TRUNC(��¥, ����), FLOOR(����) �����ϴ� 2���� �Լ�
-- ������? �� ��° ��������
-- TRUNC()�� Ư�� ��ġ���� ���� ����
-- FLOOR()�� �Ҽ��� ù ��° �ڸ����� ���踸 ����
SELECT 3.141592
,TRUNC(3.141592)    -- �Ҽ��� ù ��° �ڸ����� ����
,TRUNC(3.141592, 0) -- �Ҽ��� ù ��° �ڸ����� ����
,FLOOR(3.141592)

,TRUNC(3.141592, 3)
,FLOOR(3.141592 * 1000) / 1000
,TRUNC(13.141592, -1)
FROM dual;
-- CEIL() �Ҽ��� ù��° �ڸ����� �ø�(����)�ϴ� �Լ�
SELECT CEIL(3.141592)
FROM dual;
-- 3.141592�� �Ҽ��� �� ��° �ڸ����� �ø�
SELECT CEIL(3.141592 * 100) / 100
FROM dual;
-- �������� ���� ����� �� CEIL() �ø�(����)�Լ��� ����Ѵ�
-- �� �Խñ�(���)��
-- �� �������� ����� �Խñ�(���)�� : 5
SELECT COUNT(*)
FROM emp;
SELECT CEIL((SELECT COUNT(*)
        FROM emp)/5) ��������
FROM dual;

SELECT *
FROM emp
ORDER BY sal+NVL(comm,0) DESC;

-- ABS() ���밪 ���ϴ� �Լ�
SELECT ABS(100), ABS(-100)
FROM dual;

-- SIGN() ���ڰ��� ��ȣ�� ���� 1, 0, -1�� ������ �����Ѵ�
SELECT SIGN(100), SIGN(0), SIGN(-100)
FROM dual;

-- [����] emp ���̺��� ��ձ޿��� ���ؼ� 
--�� ����� �޿�(pay)�� ��� �޿����� ������ "��ձ޿����� ����" ���
--                                ������ "��ձ޿����� ����" ���
-- [1]
SELECT s.*, '����'
FROM emp s
WHERE sal + NVL(comm,0) > (SELECT AVG(sal + NVL(comm,0)) avg_pay
                            FROM emp)
UNION
SELECT s.*, '����'
FROM emp s
WHERE sal + NVL(comm,0) < (SELECT AVG(sal + NVL(comm,0)) avg_pay
                            FROM emp);
                            
-- [2]
SELECT ename, sal+NVL(comm,0) pay
--,(SELECT AVG(sal+NVL(comm,0)) FROM emp) avg_pay
--,sal+NVL(comm,0) - (SELECT AVG(sal+NVL(comm,0)) FROM emp) avg_pay
,SIGN(sal+NVL(comm,0) - (SELECT AVG(sal+NVL(comm,0)) FROM emp)) ��
, REPLACE(REPLACE(SIGN(sal+NVL(comm,0) - (SELECT AVG(sal+NVL(comm,0)) FROM emp)),-1, '����'), 1, '����') ��ձ޿�����
FROM emp;

--[3]
SELECT ename, pay, avg_pay
,NVL2(NULLIF(SIGN(pay - avg_pay), 1), '����', '����')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    ,ROUND((SELECT AVG(sal+NVL(comm,0)) FROM emp),2) avg_pay
    FROM emp
);

-- POWER()
SELECT POWER(2,3), POWER(2,-3)
FROM dual;

SELECT SQRT(2)
FROM dual;

-- [���� �Լ�] --
-- INSTR()
SELECT INSTR('Corea','e') 
FROM dual;

SELECT INSTR('corporate floor','or',3,2) 
,INSTR('corporate floor','or')
,INSTR('corporate floor','or',-3,2) -- �ڿ��� 3��° ���� 2��° ���� or ���ڿ�
FROM dual;

SELECT '02-1234-5678' hp
,INSTR('02-1234-5678', '-', -1, 2)
, SUBSTR('02-1234-5678', 1, INSTR('02-1234-5678', '-')-1) a --010
, SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-')+1,
                        INSTR('02-1234-5678', '-', -1)-1 - INSTR('02-1234-5678', '-')) b   --1234
, SUBSTR('02-1234-5678', INSTR('02-1234-5678', '-',-1)+1, 4) c --5678
FROM dual;

DESC tbl_tel;

SELECT *
FROM tbl_tel;

INSERT INTO tbl_tel (tel, name) VALUES('063)469-4567', 'ū����');
INSERT INTO tbl_tel (tel, name) VALUES('052)1456-4567', 'ū����');
COMMIT;

-- ������ȣ / ���ڸ� ��ȭ��ȣ / ���ڸ� ��ȭ��ȣ
SELECT tbl_tel.*
,INSTR(tel, '-')
,INSTR(tel,')')
,SUBSTR(tel, 1, INSTR(tel,')')-1) ������ȣ
,SUBSTR(tel, INSTR(tel,')')+1, INSTR(tel, '-')-INSTR(tel,')')-1) ���ڸ�
,SUBSTR(tel, INSTR(tel,'-')+1) ���ڸ�
FROM tbl_tel;

-- RPAD / LPAD
-- PAD == �� ��� ��, �ſ� ���� ��, �е�
-- ����) RPAD(expr1, n [,expr2])

SELECT ename, pay
,RPAD(pay, 10, '*')
,LPAD(pay, 10)
,LPAD(pay, 10, '*')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
    FROM emp
    )t;

-- RTRIM()/LTRIM()/TRIM()
-- ����) RTRIM(char[, set])
SELECT '   admin     '
, '[' || '   admin     ' || ']'
, '[' || RTRIM('   admin     ') || ']'
, '[' || LTRIM('   admin     ') || ']'
, '[' || TRIM('   admin     ') || ']'
FROM dual;

SELECT RTRIM('BROWINGyxXxy','xy') a
-- , TRIM('xyBROWINGyxXxyxyxyxyxy','xy') b -- ORA-00907: missing right parenthesis
,RTRIM(LTRIM('xyBROWINGyxXxyxyxyxy','xy'), 'xy') c
FROM dual;

-- ASCII()
SELECT ename
, SUBSTR(ename, 1, 1)
, ASCII(SUBSTR(ename, 1, 1)) "�ƽ�Ű�ڵ� ��"
, CHR(ASCII(SUBSTR(ename, 1, 1))) "���� ��ȯ"
FROM emp;

SELECT ASCII('A'), ASCII('a'), ASCII('0')
FROM dual;

-- GREATEST(), LEAST() ������ ����, ���� �� ���� ū, ���� ���� �����ϴ� �Լ�
SELECT GREATEST(3,5,2,4,1)
,GREATEST('R','A','E','Z')
,LEAST(3,5,2,4,1)
,LEAST('R','A','E','Z')
FROM dual;

-- VSIZE()
SELECT ename
, VSIZE(ename)
, VSIZE('ȫ�浿')
, VSIZE('a')
, VSIZE('��')
FROM emp;

-- ��¥ �Լ�
SELECT SYSDATE
, ROUND(SYSDATE) a -- �� �ݿø�/ �� ��¥ ������ �������� �ݿø�
, ROUND(SYSDATE, 'DD') b -- �� �ݿø�/ 24/02/20 ������ �������� ��¥ �ݿø�
, ROUND(SYSDATE, 'MONTH') c -- �� �ݿø�/ 24/03/01 �� ���� 15�� �������� �ݿø�
, ROUND(SYSDATE, 'YEAR') d -- �� �ݿø� / 
FROM dual;

SELECT SYSDATE
, TO_CHAR(SYSDATE, 'YYYY.MM.DD HH.MI.SS') a --2024.02.19 03.38.32
, TRUNC(SYSDATE)
, TRUNC(SYSDATE , 'DD') c
, TO_CHAR(TRUNC(SYSDATE), 'YYYY.MM.DD HH24.MI.SS') b
, TRUNC(SYSDATE, 'MONTH') d -- 24/02/[01] �� ������ ����
, TRUNC(SYSDATE, 'YEAR') e -- 24/[01]/[01] �� ������ ����
FROM dual;

--��¥ + ���� ��¥ ��¥�� �ϼ��� ���Ͽ� ��¥ ��� 
SELECT SYSDATE + 100 --24/05/29 
FROM dual;

--��¥ - ���� ��¥ ��¥�� �ϼ��� ���Ͽ� ��¥ ��� 
SELECT SYSDATE - 30 --24/01/20 
FROM dual;

--��¥ + ����/24 ��¥ ��¥�� �ð��� ���Ͽ� ��¥ ��� 
-- 2�ð� �Ŀ� ������ (���)
SELECT SYSDATE
    ,TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS')
    ,SYSDATE + 2/24
    ,TO_CHAR(SYSDATE + 2/24, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

--��¥ - ��¥ �ϼ� ��¥�� ��¥�� ���Ͽ� �ϼ� ��� 
-- [����] �Ի��� ��¥���� ���� ��¥���� �ٹ��� �ϼ� ����?
SELECT ename
,hiredate
,SYSDATE
,TRUNC(SYSDATE+1) - TRUNC(hiredate) || '��' �ٹ��ϼ�-- ��¥ - ��¥
FROM emp;

SELECT TO_DATE('2024-02-18')
, SYSDATE
,TRUNC(SYSDATE) - TRUNC(TO_DATE('2024-02-18')) || '��' �ٹ��ϼ�
FROM dual;

-- [����] 24�⵵ 2�� ������ ��¥ �� �ϱ��� ?
-- [1]
SELECT SYSDATE a -- 24/02/19
--, TRUNC(SYSDATE, 'DD') --�ð�, ��, �� ����
, TRUNC(SYSDATE, 'MONTH') b
-- 1�� ���ϱ�
--, ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1)
, ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) -1
, TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) -1, 'DD') "2�� ������ ��¥"
FROM dual;

-- [2]
SELECT SYSDATE
-- �Ű����� ��¥�� ������ ��¥ ��ü�� ��ȯ�ϴ� �Լ�
,LAST_DAY(SYSDATE)
,TO_CHAR(LAST_DAY(SYSDATE), 'DD') "�̹��� ������ ��¥"
FROM dual;

-- [����] �����Ϸκ��� ���ó�¥���� �� �� : 
-- 2023.12.29 ����
SELECT CEIL(SYSDATE - TO_DATE('2023/12/29'))
FROM dual;

-- [����] ���ó�¥���� �����ϱ��� ���� �� �� : 
-- 2024.06.14 ����

SELECT 
TRUNC(SYSDATE,'DAY')
,ABS(CEIL(SYSDATE - TO_DATE('2024/06/14')))
FROM dual;

-- NEXT DAY() �Լ�
SELECT SYSDATE
, TO_CHAR(SYSDATE, 'YYYY/MM/DD (DY)') a
, TO_CHAR(SYSDATE, 'YYYY/MM/DD (DAY)') b
-- ���� ����� �ݿ��ϳ� ���...
, NEXT_DAY(SYSDATE, '�ݿ���') "���� ����� �ݿ���"
, NEXT_DAY(SYSDATE, '��') "������ ������"
FROM dual;

-- [����] 4�� ù��° ȭ���� ������
SELECT TO_DATE('2024-04-01')
--, NEXT_DAY(TO_DATE('2024-04-01')-1, 'ȭ')
, NEXT_DAY(TO_DATE('2024-04-01')-1, '��')
FROM dual;

-- MONTHS_BETWEEN() �� ��¥ ������ ���� ���� ��ȯ�ϴ� �Լ�
SELECT ename, hiredate
, SYSDATE
, CEIL(ABS( hiredate - SYSDATE )) �ٹ��ϼ�
, MONTHS_BETWEEN(SYSDATE, hiredate) �ٹ�������
, ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)/12, 2) �ٹ����
FROM emp;

SELECT SYSDATE
,CURRENT_DATE
,CURRENT_TIMESTAMP
FROM dual;

-- [��ȯ�Լ�]
-- 1) TO_NUMBER() : ���� -> ���ڷ� ��ȯ
SELECT '12'
,TO_NUMBER('12') "12"
,100 - '12'
,'100' - '12'
FROM dual;

-- 2) TO_CHAR(��¥, ����)
-- [����] insa ���̺��� pay�� ���ڸ� ���� �޸��� ��� �տ� ��ȭ��ȣ�� ������
SELECT num, name, basicpay, sudang
,basicpay + sudang pay
,TO_CHAR(basicpay + sudang, 'L9,999,999.99') "\pay"
FROM insa;

SELECT 12345
, TO_CHAR(12345) a-- '12345'
, TO_CHAR(12345, '99,999') b-- '12,345'
, TO_CHAR(12345, '9,999') b-- '#####'
, TO_CHAR(12345, '99,999.00') c-- '12,345.00'
, TO_CHAR(12345, '99,999.99') d-- '12,345.00'
, TO_CHAR(12345.125, '99,999.00') e-- '12,345.12'
FROM dual;

SELECT TO_CHAR(-100, '999PR')
, TO_CHAR(-100, '999MI')
, TO_CHAR(-100, 'S999')
, TO_CHAR(100, 'S999')
FROM dual;

SELECT * FROM emp;


