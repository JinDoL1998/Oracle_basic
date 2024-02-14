-- SYS
CREATE USER scott 
IDENTIFIED BY tiger;

GRANT CREATE SESSION TO SCOTT;

 select a.spid, b.name, c.server, c.type
 from v$process a, v$bgprocess b, v$session c
 where b.PADDR(+) = a.ADDR AND a.ADDR = c.PADDR
 AND b.NAME is NULL;
 
 -- 테이블스페이스 조회(확인) --
 --SELECT tablespace_name, file_name
 SELECT *
 FROM dba_data_files
 ORDER BY file_id ASC;
 
 SELECT  tablespace_name,status
 FROM DBA_TABLESPACES;