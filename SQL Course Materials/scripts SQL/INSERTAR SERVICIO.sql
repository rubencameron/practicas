DECLARE
  V_MENSAJE VARCHAR2(2000);

BEGIN
      HORAS_TURNOS_CON_CRED_CI (292979,
                                NULL ,
                                NULL,
                                V_MENSAJE,
                                'LLEGADA');
END;


--ROLLBACK;


SELECT * FROM TURNO_CONSULTORIO WHERE ID_TURNO = 292979;

SELECT * FROM TURNO_CONSULTORIO WHERE pac_id_paciente = 138216;

SELECT * FROM srv WHERE tur_con_id_turno = 292979;

UPDATE TURNO_CONSULTORIO SET  emp_id_empresa = 999009 WHERE ID_TURNO = 292979 AND  pac_id_paciente = 138216;

COMMIT;


SELECT *
FROM





