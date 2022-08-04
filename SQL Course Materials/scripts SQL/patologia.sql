SELECT DISTINCT TO_NUMBER(T.ID_TUBO||N.DEPART_ID_DEPARTAMENTO) ID_TUBO,
'N
D15
R230,10
B50,40,0,1,3,3,75,B,"'||PP.ID_PED_PATOLOGICO||'"
A20,5,0,3,1,1,N,"'||PP.NOMBRE_RESULTADO||'"
A10,152,0,4,1,1,R,"'||PAC.FECHA_NACIMIENTO||'"
A160,175,0,2,1,1,N,"'||PP.CI||'"
A180,130,0,2,1,1,N,"'||PP.FECHA_TOMA_MUESTRA||'"
A200,157,0,2,1,1,N,""
P'||T.COPIAS COD_BARRA
FROM TUBO T, NOMEN_AUX NA, NOMEN N, DET_PEDIDO_PATOLOGICO DP, PAC PAC, PEDIDO_PATOLOGICO PED, DEPARTAMENTO D
WHERE PED.PAC_ID_EXPEDIENTE = PAC.ID_EXPEDIENTE
AND       N.DEPART_ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
AND       PED.ID_PEDIDO = 130
AND       DP.PED_ID_PEDIDO = PED.ID_PEDIDO
AND       DP.NOMEN_CODIGO = N.CODIGO
AND       N.CODIGO_LSR = NA.CODIGO(+)
AND       NVL(NA.TUO_ID_TUBO, N.TUO_ID_TUBO) = T.ID_TUBO

--CONTRASENA PARA EL PACIENTE
UNION ALL
SELECT DISTINCT 999999,
CASE WHEN PED.FECHA_SEG_PROMESA IS NOT NULL THEN
'N
D15
R230,10
A20,5,0,3,1,1,N,"'||PED.NOMBRE_RESULTADO||'"
B50,30,0,1,3,3,45,B,"'||PED.ID_PEDIDO||'"
A1,100,0,3,1,1,N,"'||'Fecha 1ra.Prom:'||TO_CHAR(PED.FECHA_PROMESA,'DD/MM/RR HH24:MI')||'"
A1,120,0,3,1,1,N,"'||'Fecha 2da.Prom:'||TO_CHAR(PED.FECHA_SEG_PROMESA,'DD/MM/RR HH24:MI')||'"
A1,140,0,3,1,1,N,"'||'Medico: '||
SUBSTR(DECODE(PED.PREST_ID_PRESTADOR,
                               NULL, DECODE(PED.PRESTADOR,
                                                          NULL, (SELECT DISTINCT P.RAZON_SOCIAL
                                                                      FROM DETALLE_PEDIDO DD, PREST P
                                                                      WHERE DD.PED_ID_PEDIDO = PED.ID_PEDIDO
                                                                      AND       DD.PREST_ID_PRESTADOR = P.ID_PRESTADOR
                                                                      AND       ROWNUM < 2)||(SELECT DISTINCT DD.PRESTADOR
                                                                                                               FROM DETALLE_PEDIDO DD
                                                                                                               WHERE DD.PED_ID_PEDIDO = PED.ID_PEDIDO
                                                                                                              AND        ROWNUM < 2),
                                                                     PED.PRESTADOR),
                                           PR.RAZON_SOCIAL), 1, 25)||'"
A20,165,0,4,1,1,R,"'||'LC"
A160,177,0,2,1,1,N,"'||
DECODE(PED.TIPO_SALA,
                'AMBULATORIO', 'AMB',
                'EMER', 'EME',
                'ENDO', 'END',
                'HAB', 'HAB',
                'NUR', 'NUR',
                'QUIR', 'QUIR',
                'RECUP', 'REC',
                'TERINT', 'TERINT',
                'URG', 'URG',
                'UTI', 'UTI',
                'UTIN', 'UTIN')
||PED.NRO_SALA_SSR_LC||'-'||CASE WHEN PED.NRO_SALA_SSR_LC IS NULL THEN PED.TIPO_ENTREGA ELSE NULL END||
'"
A180,162,0,2,1,1,N,"'||PED.NRO_PACIENTE_DIA||'-'||TO_CHAR(PED.FECHA, 'DD/MM/RR HH24:MI')||'"
A200,157,0,2,1,1,N,""
P1'
ELSE
'N
D15
R230,10
A20,5,0,3,1,1,N,"'||PED.NOMBRE_RESULTADO||'"
B50,30,0,1,3,3,45,B,"'||PED.ID_PEDIDO||'"
A1,100,0,3,1,1,N,"'||'Fecha 1ra.Prom:'||TO_CHAR(PED.FECHA_PROMESA,'DD/MM/RR HH24:MI')||'"
A1,120,0,3,1,1,N,"'||'Medico: '||
SUBSTR(DECODE(PED.PREST_ID_PRESTADOR,
                               NULL, DECODE(PED.PRESTADOR,
                                                          NULL, (SELECT DISTINCT P.RAZON_SOCIAL
                                                                      FROM DETALLE_PEDIDO DD, PREST P
                                                                      WHERE DD.PED_ID_PEDIDO = PED.ID_PEDIDO
                                                                      AND       DD.PREST_ID_PRESTADOR = P.ID_PRESTADOR
                                                                      AND       ROWNUM < 2)||(SELECT DISTINCT DD.PRESTADOR
                                                                                                               FROM DETALLE_PEDIDO DD
                                                                                                               WHERE DD.PED_ID_PEDIDO = PED.ID_PEDIDO
                                                                                                              AND        ROWNUM < 2),
                                                                     PED.PRESTADOR),
                                           PR.RAZON_SOCIAL), 1, 25)||'"
A20,165,0,4,1,1,R,"'||'LC"
A160,177,0,2,1,1,N,"'||
DECODE(PED.TIPO_SALA,
                'AMBULATORIO', 'AMB',
                'EMER', 'EME',
                'ENDO', 'END',
                'HAB', 'HAB',
                'NUR', 'NUR',
                'QUIR', 'QUIR',
                'RECUP', 'REC',
                'TERINT', 'TERINT',
                'URG', 'URG',
                'UTI', 'UTI',
                'UTIN', 'UTIN')
||PED.NRO_SALA_SSR_LC||'-'||CASE WHEN PED.NRO_SALA_SSR_LC IS NULL THEN PED.TIPO_ENTREGA ELSE NULL END||
'"
A180,162,0,2,1,1,N,"'||PED.NRO_PACIENTE_DIA||'-'||TO_CHAR(PED.FECHA, 'DD/MM/RR HH24:MI')||'"
A200,157,0,2,1,1,N,""
P1'
END
 COD_BARRA
FROM PEDIDO PED, PAC PAC, PREST PR
WHERE PED.PAC_ID_EXPEDIENTE = PAC.ID_EXPEDIENTE
AND       PED.ID_PEDIDO = 130
AND       PED.TIPO_SALA = 'AMBULATORIO'
AND       PED.PREST_ID_PRESTADOR = PR.ID_PRESTADOR(+)
ORDER BY 1   ;




SELECT *
FROM MASTER.DET_PEDIDO_PATOLOGICO ;



 SELECT *
 FROM ANAMNESIS.PEDIDO_PATALOGICO ;



     SELECT *
     FROM PAC
     WHERE pac_id_expediente







SELECT  PP.ID_PED_PATOLOGICO,
'N
D15
R230,10
B50,40,0,1,3,3,75,B,"'||PP.nombre_informe||'"
A20,5,0,3,1,1,N,"'||P.fecha_nacimiento||'"
A10,152,0,4,1,1,R,"'||PP.CI||'"
A160,175,0,2,1,1,N,"'||PP.FECHA_TOMA_MUESTRA||'"
A180,130,0,2,1,1,N,"''"
A200,157,0,2,1,1,N,"''"'
FROM  PEDIDO_PATOLOGICO PP,
      DET_PEDIDO_PATOLOGICO DPP,
      PAC P
WHERE pp.pac_id_expediente = P.id_expediente



SELECT *
FROM MASTER.PEDIDO_PATOLOGICO



SELECT *
FROM PAC








