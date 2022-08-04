--Bloque Actual
SELECT *
FROM PERSONA
WHERE USUARIO = 'ETEOFILO';
         ALTER SYSTEM KILL SESSION '5610, 36291' IMMEDIATE;


SELECT(SELECT DISTINCT d.object_name
        FROM   v$lock v,
               dba_objects d
        WHERE  v.TYPE = 'TM'
        AND    v.id1 = d.object_id
        AND    v.sid = s1.sid
        AND    InStr((SELECT Lower(sqlarea.sql_text)
                      from   v$sqlarea sqlarea,
                             v$session sesion
                      where  sesion.sql_hash_value = sqlarea.hash_value
                      and    sesion.sql_address = sqlarea.address
                      and    sesion.username is not NULL
                      AND    sesion.sid = s2.sid) , Lower(d.object_name)) > 0
                      AND    ROWNUM < 2) obj,
       s1.username usu_q_bloq,
       --s1.machine pc_que_bloquea,
       (select distinct p.spid "process id"
        from   v$process p
        where  p.addr = s1.paddr
        and    rownum < 2) proceso,
       s1.sid sid_q_bloq,
       round(l1.ctime / 60) hace_min,
       l1.ctime hace_seg,
       s2.username usu_bloqueado,
       s2.sid sid_bloqueada,
       (SELECT sqlarea.sql_fulltext
        from   v$sqlarea sqlarea,
               v$session sesion
        where  sesion.sql_hash_value = sqlarea.hash_value
        and    sesion.sql_address    = sqlarea.address
        and    sesion.username is not NULL
        AND    sesion.sid = s2.sid) sql_text_bloqueado,
       to_char(sysdate-s2.last_call_et/24/60/60,'hh24:mi:ss') comenzo,
       trunc(s2.last_call_et/60) || ' mins, ' || mod(s2.last_call_et,60) || ' secs' dur,
       trunc(s2.last_call_et/60) minutos,
       mod(s2.last_call_et,60) segundos,
       --s2.blocking_session_status block_ses_stat,
       decode(l1.type,'TM','TABLE','TX','Record(s)') type_lock,
       --decode(l1.request,0,'NO','YES') wait,
       'ALTER SYSTEM KILL SESSION '||''''||s1.SID||', '||s1.SERIAL#||''''||' IMMEDIATE;' MATA
FROM   v$lock l1,
       v$session s1,
       v$lock l2,
       v$session s2
WHERE  s1.sid=l1.sid AND s2.sid=l2.sid
AND    l1.BLOCK=1 AND l2.request > 0
AND    l1.id1 = l2.id1
AND    l1.id2 = l2.id2
ORDER BY 5 DESC;


SELECT   'ALTER SYSTEM KILL SESSION '||''''||a.SID||', '||a.SERIAL#||''''||' IMMEDIATE;' MATA,
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
from     v$sql b,
         v$session a
where    a.status = 'ACTIVE'
and      a.sql_address = b.address(+)
AND      a.username IS NOT NULL
--AND      mod(a.last_call_et,60) > 20
ORDER BY minutos DESC,
         segundos desc;




--Bloqueo Viejo
SELECT s.username,
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
       'ALTER SYSTEM KILL SESSION '||''''||s.SID||', '||s.SERIAL#||''''||'IMMEDIATE;' MATA,
       s.logon_time,
       s.sid,
      (SELECT DISTINCT p.spid "PROCESS ID" FROM v$process p where p.addr=s.paddr AND ROWNUM < 2) proccess
FROM v$lock l, dba_objects o, v$session s
WHERE l.ID1 = o.OBJECT_ID
AND   s.SID = l.SID
AND   O.OWNER = 'ANAMNESIS'
AND   s.username IS NOT NULL
--AND   O.OBJECT_NAME = 'PAC'
--AND   s.username = 'OSVALDO'
--AND   l.TYPE in ('TM','TX')
ORDER BY Decode(s.lockwait, NULL, 1, 0) desc, l.ctime DESC, s.username;


select d.*,
      (SELECT v.username
       FROM v$session v
       WHERE v.sid = d.session_id) username,
      (SELECT 'ALTER SYSTEM KILL SESSION '||''''||v.SID||', '||v.SERIAL#||''''||' immediate;'
       FROM v$session v
       WHERE v.sid = d.session_id) mata
from dba_lock_internal d
where /*UPPER(d.lock_id1) like UPPER('%PRODUCTIVIDAD_PRESTADOR%')
AND */  d.lock_type != 'Cursor Definition Lock'
ORDER BY 5;




SELECT *--v$session
FROM v$session
WHERE username = 'PEREZMA'



SELECT *                                      serial#
FROM DBA_users
WHERE username = 'PEREZMA'


ALTER USER PEREZMA account LOCK;