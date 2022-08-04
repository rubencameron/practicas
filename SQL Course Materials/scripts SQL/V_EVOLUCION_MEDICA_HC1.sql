PROMPT CREATE OR REPLACE VIEW anamnesis.v_evolucion_medica_hc
CREATE OR REPLACE VIEW anamnesis.v_evolucion_medica_hc (
  sucursal,
  id_evolucion,
  id_internado,
  id_paciente,
  fecha_evolucion,
  nro_habitacion,
  tipo,
  id_prestador,
  prestador,
  estado,
  ci,
  id_grupo,
  secuencia,
  descripcion,
  nombres,
  apellidos,
  tipo_hoja_enf,
  peso_paciente,
  diagnostico,
  id_habitacion,
  edad,
  tipo_prestador,
  sexo,
  fecha_grabacion
) AS
SELECT 'LC' SUCURSAL,
       E.ID_EVOLUCION,
       E.INTERNADO_ID_INTERNADO,
       E.PAC_ID_PACIENTE,
       E.FECHA_EVOLUCION,
       E.NRO_HABITACION,
       E.TIPO,
       E.PREST_ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       E.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       E.DESCRIPCION,
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF(NVL(E.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       E.PESO_PACIENTE,
       CASE WHEN E.TIPO IN('EVOLUCION MEDICA', 'EVOLUCION MEDICA NURSERY', 'EVOLUCION ENFERMERIA', 'EVOLUCION ENFERMERIA NURSERY') THEN E.DIAGNOSTICO ELSE '' END  DIAGNOSTICO,
       E.HABITACION_ID_HABITACION,
       TRUNC(MONTHS_BETWEEN (SYSDATE, P.FECHA_NACIMIENTO)/12) EDAD,
       Decode(E.TIPO_PRESTADOR, 'MT', 'MEDICO TRATANTE',
                                'MG', 'MEDICO GUARDIA',
                                'ENF', 'ENFERMERIA',
                                'NINGUNO', 'INDEFINIDO') TIPO_PRESTADOR,
       P.SEXO,
       E.FECHA_GRABACION
FROM   PRESTADOR PR,
       PAC P,
       EVOLUCION_MEDICA E
WHERE  E.PAC_ID_PACIENTE = P.ID_PACIENTE
AND    E.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND    E.TIPO != 'HOJA TERMICA'
UNION ALL
SELECT 'LC' SUCURSAL,
       E.ID_EVOLUCION,
       E.INTERNADO_ID_INTERNADO,
       E.PAC_ID_PACIENTE,
       E.FECHA_EVOLUCION,
       E.NRO_HABITACION,
       'HOJA TERMICA' TIPO,
       E.PREST_ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       E.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       E.DESCRIPCION,
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF(NVL(E.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       E.PESO_PACIENTE,
       CASE WHEN E.TIPO IN('EVOLUCION MEDICA', 'EVOLUCION MEDICA NURSERY', 'EVOLUCION ENFERMERIA', 'EVOLUCION ENFERMERIA NURSERY') THEN E.DIAGNOSTICO ELSE '' END  DIAGNOSTICO,
       E.HABITACION_ID_HABITACION,
       TRUNC(MONTHS_BETWEEN (SYSDATE, P.FECHA_NACIMIENTO)/12) EDAD,
       Decode(E.TIPO_PRESTADOR, 'MT', 'MEDICO TRATANTE',
                                'MG', 'MEDICO GUARDIA',
                                'ENF', 'ENFERMERIA',
                                'NINGUNO', 'INDEFINIDO') TIPO_PRESTADOR,
       P.SEXO,
       E.FECHA_GRABACION
FROM   PRESTADOR PR,
       PAC P,
       EVOLUCION_MEDICA E
WHERE  E.PAC_ID_PACIENTE = P.ID_PACIENTE
AND    E.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND    E.TIPO = 'HOJA ENFERMERIA'
UNION ALL
SELECT 'SSR' SUCURSAL,
       E.ID_EVOLUCION,
       E.INTERNADO_ID_INTERNADO,
       E.PAC_ID_PACIENTE,
       E.FECHA_EVOLUCION,
       E.NRO_HABITACION,
       E.TIPO,
       E.PREST_ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       E.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       E.DESCRIPCION,
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF_SSR(NVL(E.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       E.PESO_PACIENTE,
       CASE WHEN E.TIPO IN('EVOLUCION MEDICA', 'EVOLUCION MEDICA NURSERY', 'EVOLUCION ENFERMERIA', 'EVOLUCION ENFERMERIA NURSERY') THEN E.DIAGNOSTICO ELSE '' END  DIAGNOSTICO,
       E.HABITACION_ID_HABITACION,
       TRUNC(MONTHS_BETWEEN (SYSDATE, P.FECHA_NACIMIENTO)/12) EDAD,
       Decode(E.TIPO_PRESTADOR, 'MT', 'MEDICO TRATANTE',
                                'MG', 'MEDICO GUARDIA',
                                'ENF', 'ENFERMERIA',
                                'NINGUNO', 'INDEFINIDO') TIPO_PRESTADOR,
       P.SEXO ,
       E.FECHA_GRABACION
FROM   PRESTADOR@SSR PR,
       PAC@SSR P,
       EVOLUCION_MEDICA@SSR E
WHERE  E.PAC_ID_PACIENTE = P.ID_PACIENTE
AND    E.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND    E.TIPO != 'HOJA TERMICA'
UNION ALL
SELECT 'SSR' SUCURSAL,
       E.ID_EVOLUCION,
       E.INTERNADO_ID_INTERNADO,
       E.PAC_ID_PACIENTE,
       E.FECHA_EVOLUCION,
       E.NRO_HABITACION,
       'HOJA TERMICA' TIPO,
       E.PREST_ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       E.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       E.DESCRIPCION,
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF_SSR(NVL(E.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       E.PESO_PACIENTE,
       CASE WHEN E.TIPO IN('EVOLUCION MEDICA', 'EVOLUCION MEDICA NURSERY', 'EVOLUCION ENFERMERIA', 'EVOLUCION ENFERMERIA NURSERY') THEN E.DIAGNOSTICO ELSE '' END  DIAGNOSTICO,
       E.HABITACION_ID_HABITACION,
       TRUNC(MONTHS_BETWEEN (SYSDATE, P.FECHA_NACIMIENTO)/12) EDAD,
       Decode(E.TIPO_PRESTADOR, 'MT', 'MEDICO TRATANTE',
                                'MG', 'MEDICO GUARDIA',
                                'ENF', 'ENFERMERIA',
                                'NINGUNO', 'INDEFINIDO') TIPO_PRESTADOR,
       P.SEXO,
       E.FECHA_GRABACION
FROM   PRESTADOR@SSR PR,
       PAC@SSR P,
       EVOLUCION_MEDICA@SSR E
WHERE  E.PAC_ID_PACIENTE = P.ID_PACIENTE
AND    E.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND    E.TIPO = 'HOJA ENFERMERIA'
UNION ALL
SELECT 'ASM' SUCURSAL,
       E.ID_EVOLUCION,
       E.INTERNADO_ID_INTERNADO,
       E.PAC_ID_PACIENTE,
       E.FECHA_EVOLUCION,
       E.NRO_HABITACION,
       E.TIPO,
       E.PREST_ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       E.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       E.DESCRIPCION,
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF_ASM(NVL(E.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       E.FECHA_GRABACION
FROM   PRESTADOR@SANASM PR,
       PAC@SANASM P,
       EVOLUCION_MEDICA@SANASM E
WHERE  E.PAC_ID_PACIENTE = P.ID_PACIENTE
AND    E.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND    E.TIPO != 'HOJA TERMICA'
UNION ALL
SELECT 'ASM' SUCURSAL,
       E.ID_EVOLUCION,
       E.INTERNADO_ID_INTERNADO,
       E.PAC_ID_PACIENTE,
       E.FECHA_EVOLUCION,
       E.NRO_HABITACION,
       'HOJA TERMICA' TIPO,
       E.PREST_ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       E.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       E.DESCRIPCION,
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF_ASM(NVL(E.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       E.FECHA_GRABACION
FROM   PRESTADOR@SANASM PR,
       PAC@SANASM P,
       EVOLUCION_MEDICA@SANASM E
WHERE  E.PAC_ID_PACIENTE = P.ID_PACIENTE
AND    E.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND    E.TIPO = 'HOJA ENFERMERIA'
UNION ALL
SELECT 'LC' SUCURSAL,
       T.ID_TECNICA_QX,
       T.INTERNADO_ID_INTERNADO,
       T.PAC_ID_PACIENTE,
       T.FECHA,
       --To_Date(to_char(T.FECHA, 'dd-mm-rr')||' '||to_Char(T.FECHA_GRABACION, 'HH24:MI'), 'DD-MM-RR HH24:MI'),
       I.HABITACION_ID_HABITACION,
       'TECNICA QUIRURGICA' TIPO,
       T.PREST_CIRUJANO,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       T.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       UPPER(T.DESCRIPCION_TECNICA),
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF(NVL(I.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       NULL,
       NULL,
       NULL,
       TRUNC(MONTHS_BETWEEN (SYSDATE, P.FECHA_NACIMIENTO)/12) EDAD,
       NULL,
       P.SEXO,
       T.FECHA
FROM   PRESTADOR          PR,
       PAC                P,
       INTERNADO          I,
       TECNICA_QUIRURGICA T
WHERE  T.PREST_CIRUJANO          = PR.ID_PRESTADOR
AND    T.PAC_ID_PACIENTE         = P.ID_PACIENTE
AND    T.INTERNADO_ID_INTERNADO  = I.ID_INTERNADO
UNION ALL
SELECT 'SSR' SUCURSAL,
       T.ID_TECNICA_QX,
       T.INTERNADO_ID_INTERNADO,
       T.PAC_ID_PACIENTE,
       T.FECHA,
       --To_Date(to_char(T.FECHA, 'dd-mm-rr')||' '||to_Char(T.FECHA_GRABACION, 'HH24:MI'), 'DD-MM-RR HH24:MI'),
       I.HABITACION_ID_HABITACION,
       'TECNICA QUIRURGICA' TIPO,
       T.PREST_CIRUJANO,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       T.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       UPPER(T.DESCRIPCION_TECNICA),
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF(NVL(I.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       NULL,
       NULL,
       NULL,
       TRUNC(MONTHS_BETWEEN (SYSDATE, P.FECHA_NACIMIENTO)/12) EDAD,
       NULL,
       P.SEXO,
       T.FECHA
FROM   PRESTADOR@SSR          PR,
       PAC@SSR                P,
       INTERNADO@SSR          I,
       TECNICA_QUIRURGICA@SSR T
WHERE  T.PREST_CIRUJANO          = PR.ID_PRESTADOR
AND    T.PAC_ID_PACIENTE         = P.ID_PACIENTE
AND    T.INTERNADO_ID_INTERNADO  = I.ID_INTERNADO
UNION ALL
SELECT 'ASM' SUCURSAL,
       T.ID_TECNICA_QX,
       T.INTERNADO_ID_INTERNADO,
       T.PAC_ID_PACIENTE,
       T.FECHA,
       --To_Date(to_char(T.FECHA, 'dd-mm-rr')||' '||to_Char(T.FECHA_GRABACION, 'HH24:MI'), 'DD-MM-RR HH24:MI'),
       I.HABITACION_ID_HABITACION,
       'TECNICA QUIRURGICA' TIPO,
       T.PREST_CIRUJANO,
       PR.CONTACTO_APELLIDO||', '||PR.RAZ_SOC_NOMBRE,
       T.ESTADO,
       P.CI,
       P.ID_GRUPO,
       P.SECUENCIA,
       UPPER(T.DESCRIPCION_TECNICA),
       P.NOMBRES,
       P.APELLIDOS,
       OBT_TIPO_HOJA_ENF(NVL(I.HABITACION_ID_HABITACION, 9999)) TIPO_HOJA_ENF,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       T.FECHA
FROM   PRESTADOR@SANASM          PR,
       PAC@SANASM                P,
       INTERNADO@SANASM          I,
       TECNICA_QUIRURGICA@SANASM T
WHERE  T.PREST_CIRUJANO          = PR.ID_PRESTADOR
AND    T.PAC_ID_PACIENTE         = P.ID_PACIENTE
AND    T.INTERNADO_ID_INTERNADO  = I.ID_INTERNADO
UNION ALL
SELECT  NULL, --sucursal
        id_fisio,
        null,--ID INTERNADO
        id_expediente,
        fecha_turno,
        NULL,
        'EVOLUCION KINESICA - CMLC',
        NULL,--id_prestador
        null,--prestador
        'ACTIVO',
        CI,
        NULL,
        NULL,
        NULL,
        NULL,
        paciente,
        NULL, --tipo hoja
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        fecha_turno
FROM    v_hce_fisio_kinesio

/

GRANT SELECT ON anamnesis.v_evolucion_medica_hc TO r_enfermeria;
GRANT SELECT ON anamnesis.v_evolucion_medica_hc TO r_gerente;
GRANT SELECT ON anamnesis.v_evolucion_medica_hc TO r_gerente_adm;




