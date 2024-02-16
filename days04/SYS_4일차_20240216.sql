-- SYS
SELECT *
FROM dba_tables
WHERE owner = UPPER('scott');
--
SELECT *
FROM arirang;
FROM scott.emp;
--SYNONYM ARIRANG이(가) 생성되었습니다.
CREATE PUBLIC SYNONYM  arirang
FOR scott.emp;
-- SYNONYM ARIRANG이(가) 삭제되었습니다.
DROP PUBLIC SYNONYM arirang;

-- 시노님 조회
SELECT *
FROM all_synonyms
WHERE synonym_name LIKE 'ARI%';
-- PUBLIC	ARIRANG	SCOTT	EMP	