PROMPT CREATE OR REPLACE PROCEDURE anamnesis.envia_mail_tiempo_med_rac_sem
CREATE OR REPLACE PROCEDURE anamnesis.envia_mail_tiempo_med_rac_sem(P_TIPO VARCHAR2)
IS                                 --
--exec anamnesis.envia_mail_tiempo_med_rac_sem
V_ID_SUCURSAL       NUMBER(20);
V_SUCURSAL          SUCURSAL.DESCRIPCION%TYPE;
V_EMAIL              VARCHAR2(2000);
V_MAIL              VARCHAR2(1000);
V_ASUNTO            VARCHAR2(200);
V_ENTER             VARCHAR2(100);
V_MENSAJE           VARCHAR2 (32767);
V_MENSAJE1          VARCHAR2 (32767);
V_MENSAJE2          VARCHAR2 (32767);
V_MENSAJE3          VARCHAR2 (32767);
V_MENSAJE4          VARCHAR2 (32767);
V_MENSAJE5          VARCHAR2 (32767);
V_PARAMETRO         VARCHAR2(500);
V_ITEM              NUMBER(20);
V_MENSAJE_1          VARCHAR2 (32767);
V_MENSAJE_2          VARCHAR2 (32767);
V_MENSAJE_3          VARCHAR2 (32767);
V_MENSAJE_4          VARCHAR2 (32767);
V_MENSAJE_5          VARCHAR2 (32767);
V_MENSAJE_6          VARCHAR2 (32767);
V_MENSAJE_7          VARCHAR2 (32767);
V_MENSAJE_8          VARCHAR2 (32767);
V_MENSAJE_9          VARCHAR2 (32767);
V_MENSAJE_10         VARCHAR2 (32767);
V_MENSAJE_11         VARCHAR2 (32767);
V_MENSAJE_12         VARCHAR2 (32767);
V_MENSAJE_13         VARCHAR2 (32767);
V_MENSAJE_14         VARCHAR2 (32767);
V_MENSAJE_15         VARCHAR2 (32767);
V_MENSAJE_16         VARCHAR2 (32767);
V_MENSAJE_17         VARCHAR2 (32767);
V_MENSAJE_18         VARCHAR2 (32767);
V_MENSAJE_19         VARCHAR2 (32767);
V_MENSAJE_20         VARCHAR2 (32767);
V_VALOR              VARCHAR2(2000);
V_PARA               VARCHAR2(2000);
V_TOTAL              NUMBER(20);
V_ORDEN              NUMBER(20);
V_GRUPOS             VARCHAR2(200);
V_CANTIDAD_TOTAL     NUMBER(20);
V_FECHA              DATE;
V_FECHA_ACTUAL       DATE;
V_FECHA_DESDE        DATE;
V_FECHA_HASTA        DATE;
V_FECHA_NACIMIENTO   VARCHAR2(50);
V_EDAD               NUMBER(20);
MAIL_ID UTL_SMTP.CONNECTION;


CURSOR S IS
SELECT  ID_SUCURSAL,
        DESCRIPCION
FROM    SUCURSAL
WHERE   id_sucursal = 2
ORDER BY 1;

BEGIN

    V_FECHA_ACTUAL :=TRUNC(SYSDATE, 'DD');
    V_FECHA_DESDE := TRUNC(V_FECHA_ACTUAL -7, 'DD');
    V_FECHA_HASTA := TRUNC(V_FECHA_ACTUAL -1, 'DD');
    OPEN s;
    FETCH s INTO V_ID_SUCURSAL, V_SUCURSAL;
    BEGIN
      WHILE S%FOUND
      LOOP
       V_ENTER := CHR(10);
       V_ITEM := 1;
       V_TOTAL := 0;
       V_MENSAJE_1 := NULL;
       V_MENSAJE_2 := NULL;
       V_MENSAJE_3 := NULL;
       V_MENSAJE_4 := NULL;
       V_MENSAJE_5 := NULL;
       V_MENSAJE_6 := NULL;
       V_MENSAJE_7 := NULL;
       V_MENSAJE_8 := NULL;
       V_MENSAJE_9 := NULL;
       V_MENSAJE_10 := NULL;
       V_MENSAJE_11 := NULL;
       V_MENSAJE_12 := NULL;
       V_MENSAJE_13 := NULL;
       V_MENSAJE_14 := NULL;
       V_MENSAJE_15 := NULL;
       V_MENSAJE_16 := NULL;
       V_MENSAJE_17 := NULL;
       V_MENSAJE_18 := NULL;
       V_MENSAJE_19 := NULL;
       V_MENSAJE_20 := NULL;


      DECLARE CURSOR C IS
      SELECT ORDEN,
             GRUPOS,
             SUM(CANTIDAD_TOTAL) CANTIDAD_TOTAL,
             FECHA_NACIMIENTO,
             EDAD
      FROM(
          SELECT  CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10  THEN 1
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN 2
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN 3
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440)              > 30 THEN 4
                  ELSE
                    NULL
                  END ORDEN,

                  CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10  THEN  '5 A 10 Minutos'
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN  '11 A 20 Minutos'
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN  '21 A 30 Minutos'
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) > 30 THEN               'Mayor A 30 Minutos'
                  ELSE
                    NULL
                  END GRUPOS,
                  COUNT(*) CANTIDAD_TOTAL,
                  CALCULAR_EDAD(P.FECHA_NACIMIENTO) FECHA_NACIMIENTO,
                  TRUNC((MONTHS_BETWEEN(SYSDATE, P.FECHA_NACIMIENTO))/12) EDAD
          FROM    CONSULTA C, PAC P, PROCEDIMIENTO_CONSULTA PRO
          WHERE   C.PAC_ID_PACIENTE = P.ID_PACIENTE
          AND    C.PROC_CONS_ID_PROCEDIMIENTO_CON = PRO.ID_PROCEDIMIENTO_CONSULTA(+)
          AND    ESTADO != 'CANCELADO'
          AND    SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
          AND    Trunc(C.FECHA_CONSULTA, 'hh24') between  V_FECHA_DESDE AND V_FECHA_HASTA
          AND    Nvl(PRO.EVALUAR_TIEMPO_ESPERA, 'SI') != 'NO'
          AND    TRUNC((MONTHS_BETWEEN(SYSDATE, P.FECHA_NACIMIENTO))/12) <= 17
          AND    P_TIPO = 'PEDIATRICO'
          GROUP BY  CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10 THEN 1
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN 2
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN 3
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) > 30 THEN 4
                    ELSE
                      NULL
                    END,

                    CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10  THEN  '5 A 10 Minutos'
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN  '11 A 20 Minutos'
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN '21 A 30 Minutos'
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) > 30 THEN 'Mayor A 30 Minutos'
                    ELSE
                      NULL
                    END,
                    p.FECHA_NACIMIENTO
          UNION ALL
          SELECT  CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10  THEN 1
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN 2
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN 3
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440)              > 30 THEN 4
                  ELSE
                    NULL
                  END ORDEN,

                  CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10  THEN  '5 A 10 Minutos'
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN  '11 A 20 Minutos'
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN  '21 A 30 Minutos'
                       WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) > 30 THEN               'Mayor A 30 Minutos'
                  ELSE
                    NULL
                  END GRUPOS,
                  COUNT(*) CANTIDAD_TOTAL,
                  CALCULAR_EDAD(P.FECHA_NACIMIENTO) FECHA_NACIMIENTO,
                  TRUNC((MONTHS_BETWEEN(SYSDATE, P.FECHA_NACIMIENTO))/12) EDAD
          FROM    CONSULTA C, PAC P, PROCEDIMIENTO_CONSULTA PRO
          WHERE   C.PAC_ID_PACIENTE = P.ID_PACIENTE
          AND    C.PROC_CONS_ID_PROCEDIMIENTO_CON = PRO.ID_PROCEDIMIENTO_CONSULTA(+)
          AND    ESTADO != 'CANCELADO'
          AND    SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
          AND    Trunc(C.FECHA_CONSULTA, 'hh24') between  V_FECHA_DESDE AND V_FECHA_HASTA
          AND    Nvl(PRO.EVALUAR_TIEMPO_ESPERA, 'SI') != 'NO'
          AND    TRUNC((MONTHS_BETWEEN(SYSDATE, P.FECHA_NACIMIENTO))/12) > 17
          AND    P_TIPO = 'ADULTOS'
          GROUP BY  CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10 THEN 1
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN 2
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN 3
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) > 30 THEN 4
                    ELSE
                      NULL
                    END,

                    CASE WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 5 AND 10  THEN  '5 A 10 Minutos'
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 11 AND 20 THEN  '11 A 20 Minutos'
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) BETWEEN 21 AND 30 THEN '21 A 30 Minutos'
                         WHEN ((TRUNC(c.FECHA_SIGNOS_VITALES,'MI') - TRUNC(C.FECHA_CONSULTA,'MI')) * 1440) > 30 THEN 'Mayor A 30 Minutos'
                    ELSE
                      NULL
                    END,
                    P.FECHA_NACIMIENTO,
                    TRUNC((MONTHS_BETWEEN(SYSDATE, P.FECHA_NACIMIENTO))/12)
        )
        WHERE  GRUPOS IS NOT NULL
        GROUP BY ORDEN,
                 GRUPOS,
                 FECHA_NACIMIENTO,
                 EDAD
        ORDER BY    1, 5;

      BEGIN
          OPEN C;
          FETCH C INTO  V_ORDEN,
                        V_GRUPOS,
                        V_CANTIDAD_TOTAL,
                        V_FECHA_NACIMIENTO,
                        V_EDAD
                        ;

            V_MENSAJE := '<HTML>';
            V_MENSAJE := V_MENSAJE||'<FONT FACE="VERDANA">'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'<TABLE BORDER="1">'||V_ENTER;
            V_FECHA := SYSDATE -1 ;
            V_MENSAJE := V_MENSAJE||'<TR><TD align="center" colspan="3" bgcolor = "#C0C0C0"><B>Fecha: '||To_Char(Trunc(V_FECHA_DESDE), 'dd/mm/rr')||' Al '||to_char(Trunc(V_FECHA_HASTA), 'dd/mm/rr')||'</B></TD>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'</TR>'||V_ENTER;

            V_MENSAJE := V_MENSAJE||'<TR><TD align="center" colspan="3" bgcolor = "#C0C0C0"><B>Medición Semanal RAC '||P_TIPO||'</B></TD>';
            V_MENSAJE := V_MENSAJE||'</TR>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'</TR>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT  size=2 COLOR="black"><B>Orden<BR></FONT></TD>';
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT  size=2 COLOR="black"><B>Consultas con Espera de RAC</B></FONT></TD>';
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT  size=2 COLOR="black"><B>Cantidad</B></FONT></TD>';
            V_MENSAJE := V_MENSAJE||'</TR>';

        WHILE C%FOUND
    	    LOOP

        IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_1 IS NULL THEN
            V_MENSAJE_1 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_1 IS NOT NULL AND V_MENSAJE_2 IS NULL THEN
            V_MENSAJE_2 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_2 IS NOT NULL AND V_MENSAJE_3 IS NULL THEN
            V_MENSAJE_3 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_3 IS NOT NULL AND V_MENSAJE_4 IS NULL THEN
            V_MENSAJE_4 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_4 IS NOT NULL AND V_MENSAJE_5 IS NULL THEN
            V_MENSAJE_5 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_5 IS NOT NULL AND V_MENSAJE_6 IS NULL THEN
            V_MENSAJE_6 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_6 IS NOT NULL AND V_MENSAJE_7 IS NULL THEN
            V_MENSAJE_7 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_7 IS NOT NULL AND V_MENSAJE_8 IS NULL THEN
            V_MENSAJE_8 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_8 IS NOT NULL AND V_MENSAJE_9 IS NULL THEN
            V_MENSAJE_9 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_9 IS NOT NULL AND V_MENSAJE_10 IS NULL THEN
            V_MENSAJE_10 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_10 IS NOT NULL AND V_MENSAJE_11 IS NULL THEN
            V_MENSAJE_11 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;
            IF Length(V_MENSAJE) > 31000 AND V_MENSAJE_11 IS NOT NULL AND V_MENSAJE_12 IS NULL THEN
            V_MENSAJE_12 := V_MENSAJE;
              V_MENSAJE := '';
            END IF;

            V_MENSAJE := V_MENSAJE||'<TR>';
--            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=2>'||V_ORDEN||'</FONT></TD>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=2>'||V_GRUPOS||'</FONT></TD>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=2>'||TO_CHAR(V_CANTIDAD_TOTAL, '999G990')||'</FONT></TD>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=2>'||REPLACE(V_FECHA_NACIMIENTO, 'Ñ', '&Ntilde;')||'</FONT></TD>'||V_ENTER;
            V_MENSAJE := V_MENSAJE||'</TR>'||V_ENTER;

            V_ITEM := V_ITEM +1;
            V_TOTAL := V_TOTAL + V_CANTIDAD_TOTAL;

          FETCH C INTO  V_ORDEN,
                        V_GRUPOS,
                        V_CANTIDAD_TOTAL,
                        V_FECHA_NACIMIENTO,
                        V_EDAD
                        ;


          END LOOP;
          CLOSE C;
     END;

      V_MENSAJE := V_MENSAJE||'<TR>';
      V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor = "#C0C0C0"><FONT size=2><B>TOTAL</B></FONT></TD>'||V_ENTER;
      V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor = "#C0C0C0"><FONT size=2>'||To_Char(V_TOTAL, '999G990')||'</FONT></TD>'||V_ENTER;
      V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor = "#C0C0C0"><FONT size=2><B></B></FONT></TD>'||V_ENTER;
      V_MENSAJE := V_MENSAJE||'</TR>'||V_ENTER;

      --dbms_output.put_line(Length(v_mensaje));
      V_MENSAJE := V_MENSAJE||'</TABLE>';
      V_MENSAJE := V_MENSAJE||'</FONT>';
      V_MENSAJE := V_MENSAJE||'</HTML>';

      IF V_MENSAJE IS NOT NULL THEN

          MAIL_ID := DEMO_MAIL.BEGIN_MAIL(

                          SENDER     => 'anamnesis@lacosta.com.py',

                          RECIPIENTS => 'mauro.mendoza@asismed.com.py',--obt_correos_avisos_aut(70, v_id_sucursal),

                          SUBJECT    => 'Medicion Semanal RAC'||'-'||V_SUCURSAL,

                          MIME_TYPE =>DEMO_MAIL.MULTIPART_MIME_TYPE);

          DEMO_MAIL.ATTACH_TEXT( MAIL_ID, ' ' , 'TEXT/HTML' );--'AQUÍ SE ESCRIBE SI QUIERO ENVIAR UN TEXTO

          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_1);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_2);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_3);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_4);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_5);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_6);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_7);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_8);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_9);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_10);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_11);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_12);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_13);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_14);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_15);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_16);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_17);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_18);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_19);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE_20);
          DEMO_MAIL.WRITE_TEXT( MAIL_ID, V_MENSAJE);

          DEMO_MAIL.END_MAIL( MAIL_ID );

     END IF;
    FETCH S INTO V_ID_SUCURSAL, V_SUCURSAL;
    END LOOP;

   CLOSE S;

  END;
END;
/

