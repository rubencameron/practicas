--PARA SABER QUIEN MODIFICO COPIAR EVENTID

SELECT *
FROM   anamnesis.DDL_EVENTS_SQL
WHERE  UPPER(SQLTEXT) LIKE '%PICCARDOR%'
ORDER BY 1 DESC

--PEGAR EVENTID

SELECT *
FROM   anamnesis.DDL_EVENTS
WHERE  EVENTID =  451041