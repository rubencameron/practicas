PROMPT CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_hoja_qx
CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_hoja_qx
IS

v_mensaje          varchar2(32767);
v_mensaje1         varchar2(32767);
v_mensaje2         varchar2(32767);
v_mensaje3         varchar2(32767);
v_mensaje4         varchar2(32767);
v_mensaje5         varchar2(32767);
v_mensaje6         varchar2(32767);
v_mensaje7         varchar2(32767);
v_mensaje8         varchar2(32767);
v_mensaje9         varchar2(32767);
v_mensaje10        varchar2(32767);
v_mensaje11        varchar2(32767);
v_mensaje12        varchar2(32767);
v_mensaje13        varchar2(32767);
v_mensaje14        varchar2(32767);
v_mensaje15        varchar2(32767);
v_mensaje16        varchar2(32767);
v_mensaje17        varchar2(32767);
v_mensaje18        varchar2(32767);
v_mensaje19        varchar2(32767);
v_enter            varchar2(10);
v_enviar           varchar2(5);
v_asunto           varchar2(4000);
v_id_hoja          NUMBER(20);
v_fecha_hoja       DATE;
v_fecha_cirugia    VARCHAR2(50);
v_paciente         VARCHAR2(100);
v_cirugia          VARCHAR2(100);
V_ID_SUCURSAL      NUMBER    (20);
V_SUCURSAL         SUCURSAL.DESCRIPCION%TYPE;

MAIL_ID UTL_SMTP.CONNECTION;

CURSOR S IS
SELECT ID_SUCURSAL,
       DESCRIPCION
FROM   SUCURSAL
ORDER BY 1;

BEGIN

OPEN S;
FETCH S INTO V_ID_SUCURSAL, V_SUCURSAL;
BEGIN
WHILE S%FOUND
LOOP
    V_ENVIAR := 'NO';
    DECLARE CURSOR C IS
            select h.id_hoja,
                  h.fecha_hoja,
                  CASE WHEN h.inicio_cirugia IS NOT NULL THEN to_char(h.inicio_cirugia, 'dd/mm/rr hh24:mi')||' hasta '||To_Char(h.fin_cirugia, 'dd/mm/rr hh24:mi') ELSE '<pre> </pre>' END,
                  CASE WHEN p.id_paciente IS NOT NULL THEN p.id_paciente||' '||p.apellidos||', '||p.nombres ELSE '<pre> </pre>' END paciente,
                  h.cirugia_id_cirugia||' '||c.descripcion
            from   cirugia c,
                  pac p,
                  hoja_quirofano h
            where  h.cirugia_id_cirugia = c.id_cirugia(+)
            and    h.pac_id_paciente = p.id_paciente(+)
            and    h.estado_hoja = 'ACTIVO'
            and    h.sucursal_id_sucursal = v_id_sucursal
            and    h.fecha_hoja between To_Date('01-01-14', 'dd-mm-rr') AND To_Date(TO_CHAR(SYSDATE - 1, 'dd-mm-rr')||' 23:59', 'dd-mm-rr hh24:mi')
            and    exists(select *
                          from   det_hoja_quirofano d
                          where  d.hoja_id_hoja = h.id_hoja
                        )
            order by fecha_hoja;

    BEGIN
      v_enter := chr(10);
      open c;
        fetch c into v_id_hoja,
                    v_fecha_hoja,
                    v_fecha_cirugia,
                    v_paciente,
                    v_cirugia;

            V_MENSAJE := '<HTML>';
            V_MENSAJE := V_MENSAJE||'<FONT FACE="VERDANA">';
            V_MENSAJE := V_MENSAJE||'<TABLE BORDER="1">';
            V_MENSAJE := V_MENSAJE||'<TR><TD colspan="5"><center><B>Hoja Qx pendientes desde 01/01/14 al '||To_Char(To_Date(TO_CHAR(SYSDATE - 1, 'dd-mm-rr')||' 23:59', 'dd-mm-rr hh24:mi'), 'dd/mm/rr')||' '||V_SUCURSAL||' '||'</B></TD></TR>';
            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2><B>Id Hoja</FONT></B></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2><B>Fecha Hoja</FONT></B></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2><B>Fecha Cirugia</FONT></B></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2><B>Paciente</FONT></B></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2><B>Cirugia</FONT></B></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'</TR>';

      WHILE C%FOUND
        LOOP
            V_ENVIAR := 'SI';
            IF Length(v_mensaje) > 31000 AND v_mensaje1 IS NULL THEN
              v_mensaje1 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('1');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje1 IS NOT NULL AND v_mensaje2 IS NULL THEN
              v_mensaje2 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('28');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje2 IS NOT NULL AND v_mensaje3 IS NULL THEN
              v_mensaje3 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('29');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje3 IS NOT NULL AND v_mensaje4 IS NULL THEN
              v_mensaje4 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('30');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje4 IS NOT NULL AND v_mensaje5 IS NULL THEN
              v_mensaje5 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('31');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje5 IS NOT NULL AND v_mensaje6 IS NULL THEN
              v_mensaje6 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('34');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje6 IS NOT NULL AND v_mensaje7 IS NULL THEN
              v_mensaje7 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('33');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje7 IS NOT NULL AND v_mensaje8 IS NULL THEN
              v_mensaje8 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('35');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje8 IS NOT NULL AND v_mensaje9 IS NULL THEN
              v_mensaje9 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('36');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje9 IS NOT NULL AND v_mensaje10 IS NULL THEN
              v_mensaje10 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje10 IS NOT NULL AND v_mensaje11 IS NULL THEN
              v_mensaje11 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje11 IS NOT NULL AND v_mensaje12 IS NULL THEN
              v_mensaje12 := v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje12 IS NOT NULL AND v_mensaje13 IS NULL THEN
              v_mensaje13:= v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje13 IS NOT NULL AND v_mensaje14 IS NULL THEN
              v_mensaje14:= v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje14 IS NOT NULL AND v_mensaje15 IS NULL THEN
              v_mensaje15:= v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            IF Length(v_mensaje) > 31000 AND v_mensaje16 IS NOT NULL AND v_mensaje17 IS NULL THEN
              v_mensaje17:= v_mensaje;
              v_mensaje := '';
              Dbms_Output.PUT_LINE('37');
            END IF;

            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||v_id_hoja||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.2>'||To_Char(v_fecha_hoja, 'dd/mm/rr')||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.2>'||v_fecha_cirugia||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.2>'||v_paciente||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.2>'||v_cirugia||'</FONT></TD>'||v_enter;


          FETCH C INTO v_id_hoja,
                        v_fecha_hoja,
                        v_fecha_cirugia,
                        v_paciente,
                        v_cirugia;
        END LOOP;
      CLOSE C;
          V_MENSAJE := V_MENSAJE||'</TABLE>';
          V_MENSAJE := V_MENSAJE||'</FONT>';
          V_MENSAJE := V_MENSAJE||'</HTML> .';

          v_asunto := 'Hojas Qx no procesadas';

          IF V_ENVIAR = 'SI' THEN
             IF V_ID_SUCURSAL = 2 THEN
                mail_id := demo_mail.begin_mail(
                          sender     => 'lacosta@lacosta.com.py',
                          recipients => 'jefatura.farmacia@lacosta.com.py',
                          subject    => v_asunto,
                          mime_type  => demo_mail.MULTIPART_MIME_TYPE);
                demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aqui se escribe si quiero enviar un texto

                demo_mail.write_text( mail_id, v_mensaje1||v_mensaje2);
                demo_mail.write_text( mail_id, v_mensaje3||v_mensaje4);
                demo_mail.write_text( mail_id, v_mensaje5||v_mensaje6);
                demo_mail.write_text( mail_id, v_mensaje7||v_mensaje8);
                demo_mail.write_text( mail_id, v_mensaje9||v_mensaje10);
                demo_mail.write_text( mail_id, v_mensaje11||v_mensaje12);
                demo_mail.write_text( mail_id, v_mensaje13||v_mensaje14);
                demo_mail.write_text( mail_id, v_mensaje15||v_mensaje16);
                demo_mail.write_text( mail_id, v_mensaje17||v_mensaje);
             ELSE
                mail_id := demo_mail.begin_mail(
                          sender     => 'lacosta@lacosta.com.py',
                          recipients => 'willian.zarate@santajulia.com.py',
                          subject    => v_asunto,
                          mime_type  => demo_mail.MULTIPART_MIME_TYPE);
                demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aqui se escribe si quiero enviar un texto

                demo_mail.write_text( mail_id, v_mensaje1||v_mensaje2);
                demo_mail.write_text( mail_id, v_mensaje3||v_mensaje4);
                demo_mail.write_text( mail_id, v_mensaje5||v_mensaje6);
                demo_mail.write_text( mail_id, v_mensaje7||v_mensaje8);
                demo_mail.write_text( mail_id, v_mensaje9||v_mensaje10);
                demo_mail.write_text( mail_id, v_mensaje11||v_mensaje12);
                demo_mail.write_text( mail_id, v_mensaje13||v_mensaje14);
                demo_mail.write_text( mail_id, v_mensaje15||v_mensaje16);
                demo_mail.write_text( mail_id, v_mensaje17||v_mensaje18);
                demo_mail.write_text( mail_id, v_mensaje19||v_mensaje);

             END IF;
            IF V_MENSAJE IS NOT NULL THEN
              demo_mail.end_mail( mail_id );
            END IF;
          END IF;
    END;
      FETCH S INTO V_ID_SUCURSAL, V_SUCURSAL;
      END LOOP;
      CLOSE S;
   END;
END;

/

