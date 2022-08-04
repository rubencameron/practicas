
/*SELECT To_Char(sysdate, 'DD-MM-RR HH24:MI:SS') FECHA , USER, 'P.'||to_char((SELECT Count(*) FROM dato_parametro)) TERMINAL,(SELECT Count(*) FROM dato_errores) SESION,'Errores 'NOTES,' ' OBS FROM DUAL
UNION ALL
SELECT  FECHA , ORACLE_USER, TERMINAL, SESION, NOTES, OBS
FROM (
*/
SELECT To_Char(DATETIME, 'DD-MM-RR HH24:MI:SS') FECHA , ORACLE_USER, TERMINAL, SESION, NOTES, OBS FROM
DATO_ERRORES
--DATO_ERROR_hasta_200603
DATO_PARAMETRO
WHERE (1=1)
   AND DATETIME > SYSDATE-1
AND oracle_user LIKE '%'||Upper('GIMENEZA')||'%'
--AND obs LIKE '%No puede modificar una factura impresa%'
--AND obs LIKE '%disparador %'
--AND notes = 'CONECTADO'
--AND notes = 'MOTOR'
--AND notes = 'PERMISO'
--AND notes = 'CONSULTA'
--AND  obs LIKE '%identificador no válido%'
--AND  obs LIKE '%No puede modificar estado de factura tiene Nota de Credito activo%'
--AND Trunc(DATETIME,'HH24') = To_Date('10-01-06 06:00:00','DD-MM-RR HH24:MI:SS')
--AND  obs LIKE 'ERROR NO REGISTRADO: ERR_TYPE%'
   and obs NOT LIKE 'O-1403: no se han encontrado datos%'
   and obs NOT LIKE 'FRM-50016%' AND obs NOT LIKE 'FRM-40202%' AND obs NOT LIKE 'FRM-50025%' AND obs NOT LIKE 'FRM-40100%'
   AND obs NOT LIKE 'FRM-41008%' AND obs NOT LIKE 'FRM-40510%' AND obs NOT LIKE 'FRM-50012%' AND obs NOT LIKE 'FRM-41026%'
   AND obs NOT LIKE 'FRM-40508%' AND obs NOT LIKE 'FRM-40401%' AND obs NOT LIKE 'FRM-40735%' AND obs NOT LIKE 'FRM-41009%'
   AND obs NOT LIKE 'FRM-40102%' AND obs NOT LIKE 'FRM-40654%' AND obs NOT LIKE 'FRM-40212%' AND obs NOT LIKE 'FRM-40501%'
   AND obs NOT LIKE 'FRM-41361%' AND obs NOT LIKE 'FRM-40509%' AND obs NOT LIKE 'FRM-40403%' AND obs NOT LIKE 'FRM-40200%'
   AND obs NOT LIKE 'FRM-41051%' AND obs NOT LIKE 'FRM-40403%' AND obs NOT LIKE 'FRM-40403%' AND obs NOT LIKE 'FRM-40200%'
   AND obs NOT LIKE 'FRM-40602%' AND obs NOT LIKE 'FRM-41353%' AND obs NOT LIKE 'FRM-41049%' AND obs NOT LIKE 'FRM-40200%'
   AND obs NOT LIKE 'FRM-41830%' AND obs NOT LIKE 'FRM-50013%' AND obs NOT LIKE 'FRM-40405%' AND obs NOT LIKE 'FRM-40112%'
   AND obs NOT LIKE 'FRM-40207%' AND obs NOT LIKE 'FRM-50004%' AND obs NOT LIKE 'FRM-40105%' AND obs NOT LIKE 'FRM-40112%'
   AND obs NOT LIKE '%code=40202%' AND obs NOT LIKE '%code=41009%'  AND obs NOT LIKE '%code=41361%' AND obs NOT LIKE '%code=40202%'
   AND obs NOT LIKE '%code=40405%' AND obs NOT LIKE '%code=40105%'  AND obs NOT LIKE '%code=40202%' AND obs NOT LIKE '%code=40202%'
   AND obs NOT LIKE '%code=40401%' AND obs NOT LIKE '%code=40654%'  AND obs NOT LIKE '%code=41830%' AND obs NOT LIKE '%code=40200%'
   AND obs NOT LIKE '%code=41008%' AND obs NOT LIKE '%code=40112%'  AND obs NOT LIKE '%code=40403%' AND obs NOT LIKE '%code=50016%'
   AND obs NOT LIKE '%code=40212%' AND obs NOT LIKE '%code=41803%'  AND obs NOT LIKE '%code=41026%' AND obs NOT LIKE '%code=41016%'
   AND obs NOT LIKE '%code=41032%' AND obs NOT LIKE '%code=50025%'  AND obs NOT LIKE '%code=40102%' AND obs NOT LIKE '%code=41802%'
   AND obs NOT LIKE '%code=40222%' AND obs NOT LIKE '%code=40737%'  AND obs NOT LIKE '%code=40207%' AND obs NOT LIKE '%code=41105%'
   AND obs NOT LIKE '%code=40602%' AND obs NOT LIKE '%code=40356%'  AND obs NOT LIKE '%code=40602%' AND obs NOT LIKE '%code=40505%'
   AND obs NOT LIKE '%code=40209%' AND obs NOT LIKE '%code=40358%'  AND obs NOT LIKE '%code=41047%' AND obs NOT LIKE '%code=50014%'
   AND obs NOT LIKE '%code=40501%' AND obs NOT LIKE '%code=40735%'  AND obs NOT LIKE '%code=50012%' AND obs NOT LIKE '%code=50004%'
   AND obs NOT LIKE '%code=40100%' AND obs NOT LIKE '%code=41214%'  AND obs NOT LIKE '%code=40029%' AND obs NOT LIKE '%code=41214%'
   AND obs NOT LIKE '%code=40209%' AND obs NOT LIKE '%code=41051%'  AND obs NOT LIKE '%code=41353%' AND obs NOT LIKE '%code=40101%'
   AND obs NOT LIKE '%code=41213%' AND obs NOT LIKE '%code=41051%'  AND obs NOT LIKE '%code=41353%' AND obs NOT LIKE '%code=40101%'
   AND obs NOT LIKE 'FRM-41047%' AND obs NOT LIKE 'FRM-41106%'  AND obs NOT LIKE 'FRM-40505%' AND obs NOT LIKE 'FRM-40222%'
--AND obs NOT LIKE '%No existe precio de venta como antecedente%'
--AND sesion = 95432
  ORDER BY DATETIME DESC

   --)










