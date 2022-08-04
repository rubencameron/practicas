SELECT *
FROM   equipo E,
       turno_rx RX,
       turno_consultorio TC
WHERE  RX.turno_cons_id_turno = TC.id_turno
AND    TC.equipo_id_equipo = E.id_equipo
AND    E.tipo_estudio IN ('PET', 'RADIOTERAPIA', 'BRAQUITERAPIA')
AND    rx.id_turno_rx = 25331;
;
SELECT * FROM equipo;



SELECT FECHA_HABIL_SIGUIENTE(SYSDATE) FROM DUAL;

function CF_FECHA_RETIROFormula return Date is
V_DUMMY CHAR(1);
V_I NUMBER(20);
V_FECHA DATE;
begin
  BEGIN
		  SELECT '1'
		  INTO   V_DUMMY
			FROM   equipo E,
			       turno_rx RX,
			       turno_consultorio TC
			WHERE  RX.turno_cons_id_turno = TC.id_turno
			AND    TC.equipo_id_equipo = E.id_equipo
			AND    E.tipo_estudio IN ('PET', 'RADIOTERAPIA', 'BRAQUITERAPIA')
			AND    rx.id_turno_rx = :ID_TURNO_RX_C;

			V_I := 1;
			V_FECHA := NVL(:FECHA_REALIZACION_C, SYSDATE);
			WHILE V_I <= 3
			LOOP
				  V_FECHA := FECHA_HABIL_SIGUIENTE(V_FECHA);
				  V_I := V_I + 1;
			END LOOP;

			RETURN(V_FECHA);
  EXCEPTION
  	  WHEN NO_DATA_FOUND THEN
  	       RETURN(NVL(:FECHA_REALIZACION_C, SYSDATE));
  END;
end;