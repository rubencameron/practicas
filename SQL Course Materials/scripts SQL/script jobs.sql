Servicios pendientes sin facturar Sucursal La costa

SELECT *
FROM anamnesis.anam_captura_inventario
WHERE id_articulo = '2699'
ORDER BY hora desc;

SELECT*
FROM DBA_SOURCE
WHERE Upper(TEXT) LIKE '%SANDRA.LEZCANO%';

SELECT

SELECT *
FROM dba_jobs
WHERE Upper (WHAT) LIKE '%MAIL_SRV_PENDIENTES%';


SELECT Trunc(SYSDATE, 'MI') + (30 / (24*60))
FROM dual;


SELECT (Trunc(SYSDATE, 'dd') + (1 / 1440) * 7 * 60) + 1
FROM dual;


SELECT Trunc(SYSDATE, 'HH24' ) + (1 / 1440 * 240)
FROM dual;


SELECT *
FROM dba_jobs
WHERE Upper (WHAT) LIKE '%SARA%';


SELECT *
FROM persona
WHERE Upper (nombres) LIKE  '%SHIRLEY%';

 SELECT *
 FROM perfil
 WHERE usuario = '';

 SHIRLEY