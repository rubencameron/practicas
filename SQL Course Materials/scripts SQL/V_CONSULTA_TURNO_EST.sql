PROMPT CREATE OR REPLACE VIEW anamnesis.v_consulta_turno_est
CREATE OR REPLACE VIEW anamnesis.v_consulta_turno_est (
  id_turno,
  id_paciente,
  nombre_apellidos,
  ci,
  fecha_turno,
  estado_turno,
  id_empresa,
  id_equipo,
  equipo,
  id_prestador,
  prestador,
  empresa,
  grupo,
  secuencia,
  comentario,
  descripcion_sala,
  descripcion_recepcion,
  nro_recepcion,
  tipo,
  dia,
  telefono,
  telefono_celular,
  id_sucursal
) AS
SELECT TC.ID_TURNO,
       TC.PAC_ID_PACIENTE ID_PACIENTE,
       P.NOMBRES||', '||APELLIDOS NOMBRE_APELLIDOS,
       P.CI CI,
       TC.FECHA_TURNO FECHA_TURNO,
       TC.ESTADO_TURNO ESTADO_TURNO,
       TC.EMP_ID_EMPRESA ID_EMPRESA,
       TC.EQUIPO_ID_EQUIPO ID_EQUIPO,
       E.DESCRIPCION EQUIPO,
       TC.PREST_ID_PRESTADOR ID_PRESTADOR,
       PR.CONTACTO_APELLIDO||' '||PR.RAZ_SOC_NOMBRE PRESTADOR,
       E.RAZ_SOC EMPRESA,
       TC.ID_GRUPO_ASM GRUPO,
       TC.SECUENCIA_ASM SECUENCIA,
       DECODE(TC.LLEGADA,
	               NULL, 'AUSENTE !',
	                     'ASISTIO  ') comentario,
       S.DESCRIPCION DESCRIPCION_SALA,
       CASE WHEN TC.EQUIPO_ID_EQUIPO IN (40,41,42,43,50,60,63) THEN 'Recepción de Fisioterpia Amb. SS1' ELSE R.DESCRIPCION END DESCRIPCION_RECEPCION,
       R.NRO_RECEPCION,
       CASE WHEN TC.INTERVALO IS NULL THEN 'ENTRE PTE.'ELSE 'AGENDADO'END TIPO,
       DIA_LETRA_FECHA(TC.FECHA_TURNO) DIA,
       TC.TELEFONO,
       TC.TELEFONO_CELULAR,
       TC.SUCURSAL_ID_SUCURSAL
FROM  SALA S, RECEPCION R, PAC P, EMP E, PRESTADOR PR, EQUIPO E, TURNO_CONSULTORIO TC
WHERE P.ID_PACIENTE = TC.PAC_ID_PACIENTE
AND   E.ID_EMPRESA = TC.EMP_ID_EMPRESA
AND   TC.PREST_ID_PRESTADOR = PR.ID_PRESTADOR
AND   TC.EQUIPO_ID_EQUIPO = E.ID_EQUIPO(+)
AND   TC.SALA_ID_SALA = S.ID_SALA
AND   S.REC_ID_RECEPCION = R.ID_RECEPCION(+)
/

GRANT SELECT ON anamnesis.v_consulta_turno_est TO r_gerente;
GRANT SELECT ON anamnesis.v_consulta_turno_est TO r_gerente_adm;
GRANT SELECT ON anamnesis.v_consulta_turno_est TO r_recepcion_consultorio;





