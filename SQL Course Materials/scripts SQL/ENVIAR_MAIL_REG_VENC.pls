PROMPT CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_reg_venc
CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_reg_venc
IS

v_mes               VARCHAR2(20);
v_mes_ant           VARCHAR2(20);
v_id_persona        NUMBER(20);
v_personal          VARCHAR2(100);
v_nro_registro      NUMBER(20);
v_fecha_vencimiento DATE;
v_entra             VARCHAR2 (2);
v_mail              VARCHAR2(1000);
v_asunto            VARCHAR2(1000);
V_MENSAJE           VARCHAR2(32767);
v_enter             VARCHAR2(10);
V_ID_SUCURSAL       NUMBER    (20);
V_SUCURSAL          SUCURSAL.DESCRIPCION%TYPE;
V_SUC               VARCHAR2(2);
V_RECIPIENTS        VARCHAR2(200);
V_CANT_MES          NUMBER(20);
mail_id utl_smtp.connection;
CURSOR S IS
SELECT ID_SUCURSAL
FROM   SUCURSAL
ORDER BY 1;
BEGIN
    OPEN S;
    FETCH S INTO V_ID_SUCURSAL;
    BEGIN
     WHILE S%FOUND
     LOOP
        IF V_ID_SUCURSAL = 2 THEN
          V_SUC := 'NO';
          V_CANT_MES := 0;
        ELSIF V_ID_SUCURSAL = 5 THEN
          V_SUC := 'NO';
          V_CANT_MES := 0;
        ELSE
          V_SUC := 'SI' ;
          V_CANT_MES := 2;
        END IF;
 -- IF To_Number(To_Char(SYSDATE, 'DD')) IN (1, 15) THEN
      DECLARE CURSOR C IS
        SELECT  MES,
                ID_PERSONA,
                PERSONAL,
                NRO_REGISTRO,
                FECHA_VENCIMIENTO
        FROM  (SELECT LTrim(RTrim(CASE WHEN Trunc(FECHA_VENC_REGISTRO, 'MM') = TRUNC(SYSDATE, 'MM') THEN MES_LETRA_FECHA(FECHA_VENC_REGISTRO)
                                       WHEN V_CANT_MES = 2 AND V_ID_SUCURSAL =4  THEN 'PROXIMOS A VENCER' ELSE 'MESES ANTERIORES' END)) MES,
                  ID_PERSONA,
                  APELLIDOS||' '||NOMBRES PERSONAL,
                  NRO_REGISTRO,
                  FECHA_VENC_REGISTRO FECHA_VENCIMIENTO
            FROM   PERSONA_RRHH
            WHERE  FECHA_VENC_REGISTRO IS NOT NULL
            AND    OBT_DATO_PER_RRHH_SUC(ID_PERSONA, V_ID_SUCURSAL, 'CARGO_ID_CARGO', NULL, NULL, NULL, NULL) != 54
            AND    Trunc(FECHA_VENC_REGISTRO, 'DD') <= Trunc(Add_Months(SYSDATE,V_CANT_MES), 'DD')
            AND    Nvl(ESTADO, 'ACTIVO') = 'ACTIVO'
            AND    VERIFICA_PER_SUC_SJ(ID_PERSONA) = V_SUC

            UNION ALL

            SELECT LTrim(RTrim(CASE WHEN Trunc(FECHA_VENC_REGISTRO, 'MM') = TRUNC(SYSDATE, 'MM') THEN MES_LETRA_FECHA(FECHA_VENC_REGISTRO)
                                    WHEN V_CANT_MES = 2 AND V_ID_SUCURSAL =4 THEN 'PROXIMOS A VENCER' ELSE 'MESES ANTERIORES' END)) MES,
                  ID_PERSONA,
                  APELLIDOS||' '||NOMBRES PERSONAL,
                  NRO_REGISTRO,
                  FECHA_VENC_REGISTRO FECHA_VENCIMIENTO
            FROM   PERSONA_RRHH
            WHERE  FECHA_VENC_REGISTRO IS NOT NULL
            AND    Trunc(FECHA_VENC_REGISTRO, 'DD') <= Trunc(Add_Months(SYSDATE,V_CANT_MES), 'DD')
            AND    Nvl(ESTADO, 'ACTIVO') = 'ACTIVO'
            AND    OBT_DATO_PER_RRHH_SUC(ID_PERSONA, V_ID_SUCURSAL, 'CARGO_ID_CARGO', NULL, NULL, NULL, NULL) = 54
            AND    VERIFICA_MED_SUC(ID_PERSONA,V_ID_SUCURSAL) = 'SI' )

       ORDER BY FECHA_VENCIMIENTO, ID_PERSONA ;

      BEGIN
        OPEN C;
        FETCH C INTO  v_mes,
                      v_id_persona,
                      v_personal,
                      v_nro_registro,
                      v_fecha_vencimiento;

        v_enter := Chr(13);

        V_MENSAJE := '<HTML>';
        V_MENSAJE := V_MENSAJE||'<FONT FACE="VERDANA">';
        V_MENSAJE := V_MENSAJE||'<TABLE BORDER="1">';
        V_MENSAJE := V_MENSAJE||'<TR>';
        V_MENSAJE := V_MENSAJE||'<TD colspan="4"><FONT size=1.5><center><B>VENCIMIENTO DE REGISTROS</B></FONT></center></TD>';
        V_MENSAJE := V_MENSAJE||'</TR>';
        V_MENSAJE := V_MENSAJE||'<TR>';
        V_MENSAJE := V_MENSAJE||'<TD width="1%" align="center"><FONT size=1.5 COLOR="black">Legajo</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="10%" align="center"><FONT size=1.5 COLOR="black">Personal</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="2%" align="center"><FONT size=1.5 COLOR="black">Nro.Reg.</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="2%" align="center""><FONT size=1.5 COLOR="black">Vencimiento</FONT></TD>';

        V_MENSAJE := V_MENSAJE||'<TR>';
        V_MENSAJE := V_MENSAJE||'<TD colspan="4"><FONT size=1.5 COLOR="blue"><b>'||v_mes||'</b></FONT></TD>';
        V_MENSAJE := V_MENSAJE||'</TR>';

        v_mes_ant := v_mes;

        WHILE C%FOUND
        LOOP
         v_entra:= 'SI';
          IF v_mes_ant = v_mes then
            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0><center>'||To_Char(v_id_persona)||'</center></FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0>'||v_personal||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0><center>'||To_Char(v_nro_registro)||'</center></FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0 '||CASE WHEN Trunc(v_fecha_vencimiento, 'DD') < Trunc(SYSDATE, 'DD') THEN ' COLOR="red"' ELSE '' END||'><center>'||To_Char(v_fecha_vencimiento, 'dd-mm-rr')||'</center></FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'</TR>';
          ELSE
            v_mes_ant := v_mes;

            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD colspan="4"><FONT size=1.5 COLOR="blue"><b>'||v_mes||'</b></FONT></TD>';
            V_MENSAJE := V_MENSAJE||'</TR>';

            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0><center>'||To_Char(v_id_persona)||'</center></FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0>'||v_personal||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0><center>'||To_Char(v_nro_registro)||'</center></FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0 '||CASE WHEN Trunc(v_fecha_vencimiento, 'DD') < Trunc(SYSDATE, 'DD') THEN ' COLOR="red"' ELSE '' END||'><center>'||To_Char(v_fecha_vencimiento, 'dd-mm-rr')||'</center></FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'</TR>';
          END IF;

          FETCH C INTO  v_mes,
                        v_id_persona,
                        v_personal,
                        v_nro_registro,
                        v_fecha_vencimiento;
        END LOOP;
        CLOSE C;

        IF v_mensaje IS NOT NULL AND V_ENTRA = 'SI' THEN
          V_MENSAJE := V_MENSAJE||'</TABLE>';
          V_MENSAJE := V_MENSAJE||'</FONT>';
          V_MENSAJE := V_MENSAJE||'</HTML> .';
            IF V_ID_SUCURSAL = 2 THEN
              V_RECIPIENTS := 'gustavo.britos@lacosta.com.py,laura.galeano@lacosta.com.py,rrhh.lc@lacosta.com.py';
              V_SUCURSAL := 'Sanatorio La Costa';
            ELSIF V_ID_SUCURSAL = 5 THEN
              V_RECIPIENTS := 'jazmin.lopez@husl.com.py';
              V_SUCURSAL := 'Sanatorio San Lorenzo';
            ELSE
              V_RECIPIENTS := 'christian.wolscham@santajulia.com.py,auxiliar.rrhh@santajulia.com.py,direccion.medica@santajulia.com.py,jefatura.enfermeria@santajulia.com.py';
              V_SUCURSAL := 'Sanatorio Santa Julia';
            END IF;

                mail_id := demo_mail.begin_mail(
                                sender     => 'lacosta@lacosta.com.py',
                                recipients => V_RECIPIENTS,
                                subject    => 'VENCIMIENTO DE  REGISTROS '||V_SUCURSAL,
                                mime_type =>demo_mail.MULTIPART_MIME_TYPE);
                demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aquí se escribe si quiero enviar un texto
                demo_mail.write_text( mail_id, V_MENSAJE);
                IF V_MENSAJE IS NOT NULL THEN
                  demo_mail.end_mail( mail_id );
                END IF;


        END IF;
      END;
 -- END IF;
  FETCH S INTO V_ID_SUCURSAL;
    V_MENSAJE:= NULL;

  END LOOP;
  CLOSE S;


ENVIAR_MAIL_CI_VENC;
END;
END;
/

