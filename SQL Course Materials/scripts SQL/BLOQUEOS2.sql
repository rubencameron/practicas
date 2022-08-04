--Para solucionar el designer
GRANT AQ_ADMINISTRATOR_ROLE, MGMT_USER TO REPOS;

ALTER SYSTEM FLUSH SHARED_POOL;     --LIMPIAR

purge recyclebin;

SELECT 'ALTER SYSTEM KILL SESSION '||''''||S.SID||', '||S.SERIAL#||''''||' IMMEDIATE;' MATA
FROM  V$SESSION S
WHERE USERNAME = ;

--bloqueo select
SELECT 'ALTER SYSTEM KILL SESSION '||''''||a.SID||', '||a.SERIAL#||''''||' IMMEDIATE;' MATA,
       a.sid,
       a.serial#,
       a.username,
       a.last_call_et,
       to_char(sysdate-a.last_call_et/24/60/60,'hh24:mi:ss') started,
       trunc(a.last_call_et/60) || ' mins, ' || mod(a.last_call_et,60) || ' secs' dur,
       trunc(a.last_call_et/60) minutos,
       mod(a.last_call_et,60) segundos,
       b.sql_text,
       b.sql_fulltext
from v$sql b, v$session a
where a.status = 'ACTIVE'
and   a.sql_address = b.address(+)
AND   a.username IS NOT NULL
--AND   mod(a.last_call_et,60) > 20
ORDER BY minutos DESC, segundos desc;



--bloqueo de usuarios
SELECT s.username||CASE WHEN s.username IN ('FJUAN', 'SAGUILAR', 'BMABEL', 'FJORGE', 'URSULA', 'ZAIDA', 'BRIZUELAF') THEN ' - GERENTE!!!' ELSE NULL END usuario,
       s.lockwait,
       l.cTIME time_seg,
       Round(l.cTIME / 60) time_min,
       s.BLOCKING_SESSION_STATUS BLOCK_SES_STAT,
       decode(L.TYPE,'TM','TABLE','TX','Record(s)') TYPE_LOCK,
       decode(L.REQUEST,0,'NO','YES') WAIT,
       S.OSUSER OSUSER_LOCKER,
       S.PROCESS PROC_LOCK,
       S.USERNAME DBUSER_LOCKER,
       O.OBJECT_NAME OBJECT_NAME,
       'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||' IMMEDIATE;' MATA,
       s.logon_time,
       s.sid,
      (SELECT DISTINCT p.spid "PROCESS ID" FROM v$process p where p.addr=s.paddr AND ROWNUM < 2) proccess
FROM v$lock l, dba_objects o, v$session s
WHERE l.ID1 = o.OBJECT_ID
AND   s.SID = l.SID
--AND   o.owner = 'FARMEDIC'
--AND   o.owner = 'CENCOM'
AND   O.OWNER IN ('ASISMEDIC', 'MASTER', 'ANAMNESIS','FARMEDIC','CENCOM')
AND   s.username IS NOT null
--AND   l.TYPE in ('TM','TX')
ORDER BY Decode(s.lockwait, NULL, 1, 0) desc, l.ctime DESC, s.username;

---- nuevo bloqueo                                                                                      ALTER SYSTEM KILL SESSION '61, 18989' IMMEDIATE;
SELECT (SELECT DISTINCT d.object_name
        FROM v$lock v, dba_objects d
        WHERE v.TYPE = 'TM'
        AND   v.id1 = d.object_id
        AND   v.sid = s1.sid
        AND   InStr((SELECT Lower(sqlarea.sql_text)
                     from v$sqlarea sqlarea, v$session sesion
                     where sesion.sql_hash_value = sqlarea.hash_value
                     and   sesion.sql_address    = sqlarea.address
                     and   sesion.username is not NULL
                     AND   sesion.sid            = s2.sid) , Lower(d.object_name)) > 0
                     AND   ROWNUM < 2) obj,

       s1.username||CASE WHEN s1.username IN ('FJUAN', 'SAGUILAR', 'BMABEL', 'FJORGE', 'URSULA', 'ZAIDA', 'BRIZUELAF') THEN ' - GERENTE!!!' ELSE NULL END usu_q_bloq,
       --s1.machine pc_que_bloquea,
      (select distinct p.spid "process id" from v$process p where p.addr=s1.paddr and rownum < 2) proceso,
       s1.sid sid_q_bloq,

       round(l1.ctime / 60) hace_min,
       l1.ctime hace_seg,

       s2.username||CASE WHEN s2.username IN ('FJUAN', 'SAGUILAR', 'BMABEL', 'FJORGE', 'URSULA', 'ZAIDA', 'BRIZUELAF') THEN ' - GERENTE!!!' ELSE NULL END  usu_bloqueado,
       s2.sid sid_bloqueada,

      (SELECT sqlarea.sql_text
       from v$sqlarea sqlarea, v$session sesion
       where sesion.sql_hash_value = sqlarea.hash_value
       and   sesion.sql_address    = sqlarea.address
       and   sesion.username is not NULL
       AND   sesion.sid = s2.sid) sql_text_bloqueado,

       to_char(sysdate-s2.last_call_et/24/60/60,'hh24:mi:ss') comenzo,
       trunc(s2.last_call_et/60) || ' mins, ' || mod(s2.last_call_et,60) || ' secs' dur,
       trunc(s2.last_call_et/60) minutos,
       mod(s2.last_call_et,60) segundos,

       --s2.blocking_session_status block_ses_stat,
       decode(l1.type,'TM','TABLE','TX','Record(s)') type_lock,
       --decode(l1.request,0,'NO','YES') wait,

       'ALTER SYSTEM KILL SESSION '||''''||s1.SID||', '||s1.SERIAL#||''''||' IMMEDIATE;' MATA
FROM v$lock l1, v$session s1, v$lock l2, v$session s2
WHERE s1.sid=l1.sid AND s2.sid=l2.sid
AND   l1.BLOCK=1 AND l2.request > 0
AND   l1.id1 = l2.id1
AND   l1.id2 = l2.id2;
--------------------------------------



SELECT USERNAME, Count(*)
FROM v$session s
WHERE STATUS !='ACTIVE'
GROUP BY USERNAME
ORDER BY 2 DESC;

--por usuario
SELECT DISTINCT 'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||' IMMEDIATE;'
FROM v$session s
WHERE S.USERNAME IN( 'MASTER','SANATORIO','WEB','','')
AND STATUS !='ACTIVE';


select distinct substr(s.username,1,11) "ORACLE USER",
                p.spid "PROCESS ID",
                p.pid "PROCESS ID1",
                s.SID,
                s.SERIAL#,
                s.USERNAME,
                'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||';' MATA,
                s.logon_time
--SELECT DISTINCT 'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||' immediate;' MATA
from v$process p, v$session s, v$access a
where a.sid=s.sid
and   p.addr=s.paddr
AND   s.username IS NOT NULL
--AND   s.username = 'VILLALBAC'
AND   s.logon_time < Trunc(SYSDATE, 'dd');

--los killed que hay que eliminar
SELECT s.username,
       s.lockwait,
      s.BLOCKING_SESSION_STATUS BLOCK_SES_STAT,
       S.OSUSER OSUSER_LOCKER,
       S.PROCESS PROC_LOCK,
       S.USERNAME DBUSER_LOCKER,
       'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||';' MATA,
       s.logon_time,
       s.sid,
      (SELECT DISTINCT p.spid "PROCESS ID" FROM v$process p where p.addr=s.paddr AND ROWNUM < 2) proccess
--SELECT DISTINCT 'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||' immediate;'
FROM v$session s
WHERE s.username IS NOT null
AND   s.status = 'KILLED'
ORDER BY Decode(s.lockwait, NULL, 1, 0) desc, s.username;

--por usuario
SELECT DISTINCT 'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||' IMMEDIATE;'
FROM v$session s
WHERE s.username = 'DOMINGUEZA';

ALTER SYSTEM KILL SESSION '1240, 43697' immediate;
ALTER SYSTEM KILL SESSION '1567, 41251' immediate;

--bloqueo de stored procedure y funciones
SELECT D.*,
      (SELECT V.USERNAME
       FROM V$SESSION V
       WHERE V.SID = D.SESSION_ID) USERNAME,
      (SELECT 'ALTER SYSTEM KILL SESSION '||''''||V.SID||', '||V.SERIAL#||''''||' IMMEDIATE;'
       FROM V$SESSION V
       WHERE V.SID = D.SESSION_ID) MATA
FROM DBA_LOCK_INTERNAL D
WHERE UPPER(D.LOCK_ID1) LIKE UPPER('%ENVIA_RESULTADOS_LAB_DIG%')
AND   D.LOCK_TYPE != 'CURSOR DEFINITION LOCK'
ORDER BY 5;

--Sesion por SPID
select distinct substr(s.username,1,11) "ORACLE USER",
                p.spid "PROCESS ID",
                p.pid "PROCESS ID1",
                s.SID,
                s.SERIAL#,
                s.USERNAME,
                s.status,
                'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||';' MATA
from v$process p, v$session s
where p.addr=s.paddr
AND   p.spid = 7336;

select distinct substr(s.username,1,11) "ORACLE USER",
                p.spid "PROCESS ID",
                p.pid "PROCESS ID1",
                s.SID,
                s.SERIAL#,
                s.USERNAME,
                s.status,
                SELECT 'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||';' MATA
from v$process p, v$session s
where p.addr=s.paddr;
--AND   p.spid
AND   S.USERNAME = 'ASISMEDIC';

iostat -xk 5;

SELECT SYSDATE FROM dual;

--para el error ora-01591 lock held by in-doubt distributed transaction solution
select * from dba_2pc_pending;
select * from dba_2pc_neighbors;
select * from pending_trans$;
select * from pending_sessions$;
select * from pending_sub_sessions$;

SELECT * --'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||';' MATA
FROM v$session s
WHERE s.status ='ACTIVE'
ORDER BY 2 ;

SELECT *
FROM master.cg_code_controls;

ALTER SYSTEM DISABLE DISTRIBUTED RECOVERY;

COMMIT FORCE '36.11.117154';

ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;

ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;

