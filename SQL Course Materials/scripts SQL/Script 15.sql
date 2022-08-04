SELECT Trunc(SYSDATE, 'HH24' ) + 1
FROM dual



 SELECT Trunc(SYSDATE, 'HH24' ) + (1 / 1440 * 240)
FROM dual

BEGIN
  sys.dbms_ijob.remove(4014);
COMMIT;
END;


SELECT *
FROM DBA_JOBS
WHERE Upper (what) LIKE '%ENVIAR_MAIL_CONS_EST%'
ORDER BY 1 DESC;



SELECT *
FROM ubicacion_contrato
ORDER BY 3 desc;


                                   221740