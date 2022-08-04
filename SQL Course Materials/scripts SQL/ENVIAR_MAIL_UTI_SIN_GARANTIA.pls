PROMPT CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_uti_sin_garantia
CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_uti_sin_garantia
IS

v_tipo              VARCHAR2(50);
v_tipo_ant          VARCHAR2(50);
v_nro_habitacion    NUMBER(20);
v_id_paciente       NUMBER(20);
v_paciente          VARCHAR2(100);
v_fecha_ingreso     DATE;
v_saldo             NUMBER(20);
v_empresa           VARCHAR2(100);
v_plan              VARCHAR2(100);
v_medico_tratante   VARCHAR2(500);
v_personal          VARCHAR2(100);
v_mail              VARCHAR2(1000);
v_asunto            VARCHAR2(1000);
V_MENSAJE           VARCHAR2(32767);
v_obs               VARCHAR2(2000);
v_exoneracion       VARCHAR2(4000);
v_enter             VARCHAR2(10);
v_tipo_contrato     NUMBER(20);
V_ID_SUCURSAL       NUMBER    (20);
V_SUCURSAL          SUCURSAL.DESCRIPCION%TYPE;
V_SIN_REGISTRO      VARCHAR2 (2);

mail_id utl_smtp.connection;

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
     V_SIN_REGISTRO := 'NO';
      DECLARE CURSOR C IS
      SELECT 'UTI' TIPO,
             H.NRO_HABITACION,
             I.PAC_ID_PACIENTE,
             P.APELLIDOS||', '||P.NOMBRES,
             (SELECT Max(IH.FECHA)
             FROM   INTERNADO_HABITACION IH
             WHERE  IH.INTERNADO_ID_INTERNADO = I.ID_INTERNADO
             ) FECHA_INGRESO_UTI,
             BUSCAR_SALDO_PAC_X_SUC(I.PAC_ID_PACIENTE, I.SUCURSAL_ID_SUCURSAL) SALDO,
             E.RAZ_SOC EMPRESA,
             PL.DESCRIPCION PLAN,
             OBTENER_MEDICO_TRATANTE(I.ID_INTERNADO) MEDICO_TRATANTE,
             Decode(I.PER_ID_PERSONA, NULL, OBTENER_USUARIO_INTERNADO(I.ID_INTERNADO), PER.USUARIO) PERSONAL,
                  CASE WHEN Nvl(I.EXONERADO_DEP_GARANTIA, 'NO') = 'SI' THEN 'Exonerado '||InitCap(TP.DESCRIPCION) ELSE RPad('<pre> </pre>', 30, ' ') END||'<pre> </pre>'||OBTENER_PAC_GARANTIA_ASM(P.ID_PACIENTE) OBS,
                  OBTENER_PAC_GARANTIA_ASM(P.ID_PACIENTE) EXONERACION,
             DEV_TIPO_CNT_BCP_ASM (P.ID_GRUPO, P.SECUENCIA, P.CI) TIPO_CONTRATO

      FROM   TIPO_PACIENTE TP,
             HABITACION H,
             PERSONA PER,
             PLAN PL,
             EMP E,
             PAC P,
             INTERNADO I
      WHERE  I.HABITACION_ID_HABITACION = H.ID_HABITACION
      AND    I.PAC_ID_PACIENTE = P.ID_PACIENTE
      AND    Nvl(P.EMP_PLAN_EMP_ID_EMPRESA, 13) = E.ID_EMPRESA
      AND    Nvl(P.EMP_PLAN_PLAN_ID_PLAN, 4) = PL.ID_PLAN
      AND    I.PER_ID_PERSONA = PER.ID_PERSONA(+)
      --AND    H.PISO_SUCURSAL_ID_SUCURSAL = OBTENER_SETEO_SUC(USER) comentado ya que con esta funcion no puede recibir la sucursal 4
      AND    P.TIP_PAC_ID_TIPO_PACIENTE = TP.ID_TIPO_PACIENTE(+)
      AND    H.PISO_ID_PISO IN(8, 9, 14, 22) --uti , ucin
      AND    I.FECHA_FIN IS NULL
      AND    I.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
      AND    NOT EXISTS(SELECT *
                        FROM   GARANTIA G
                        WHERE  G.INTERNADO_ID_INTERNADO = I.ID_INTERNADO
                       )
      UNION ALL

      SELECT 'PARTICULAR - SALA' TIPO,
             H.NRO_HABITACION,
             I.PAC_ID_PACIENTE,
             P.APELLIDOS||', '||P.NOMBRES,
             (SELECT Max(IH.FECHA)
             FROM   INTERNADO_HABITACION IH
             WHERE  IH.INTERNADO_ID_INTERNADO = I.ID_INTERNADO
             ) FECHA_INGRESO_UTI,
             BUSCAR_SALDO_PAC_X_SUC(I.PAC_ID_PACIENTE, I.SUCURSAL_ID_SUCURSAL) SALDO,
             E.RAZ_SOC EMPRESA,
             PL.DESCRIPCION PLAN,
             OBTENER_MEDICO_TRATANTE(I.ID_INTERNADO) MEDICO_TRATANTE,
             Decode(I.PER_ID_PERSONA, NULL, OBTENER_USUARIO_INTERNADO(I.ID_INTERNADO), PER.USUARIO) PERSONAL,
                 CASE WHEN Nvl(I.EXONERADO_DEP_GARANTIA, 'NO') = 'SI' THEN 'Exonerado '||InitCap(TP.DESCRIPCION) ELSE RPad('<pre> </pre>', 30, ' ') END||'<pre> </pre>'||OBTENER_PAC_GARANTIA_ASM(P.ID_PACIENTE) OBS,
                 OBTENER_PAC_GARANTIA_ASM(P.ID_PACIENTE) EXONERACION,
             DEV_TIPO_CNT_BCP_ASM (P.ID_GRUPO, P.SECUENCIA, P.CI) TIPO_CONTRATO

      FROM   TIPO_PACIENTE TP,
             HABITACION H,
             PERSONA PER,
             PLAN PL,
             EMP E,
             PAC P,
             INTERNADO I
      WHERE  I.HABITACION_ID_HABITACION = H.ID_HABITACION
      AND    I.PAC_ID_PACIENTE = P.ID_PACIENTE
      AND    Nvl(P.EMP_PLAN_EMP_ID_EMPRESA, 13) = E.ID_EMPRESA
      AND    Nvl(P.EMP_PLAN_PLAN_ID_PLAN, 4) = PL.ID_PLAN
      AND    I.PER_ID_PERSONA = PER.ID_PERSONA(+)
      --AND    H.PISO_SUCURSAL_ID_SUCURSAL = OBTENER_SETEO_SUC(USER) comentado ya que con esta funcion no puede recibir la sucursal 4

      AND    P.TIP_PAC_ID_TIPO_PACIENTE = TP.ID_TIPO_PACIENTE(+)
      AND    H.PISO_ID_PISO NOT IN(8, 9, 14, 22) --uti , ucin
      AND    Nvl(P.EMP_PLAN_EMP_ID_EMPRESA, 13) = 13
      AND    I.FECHA_FIN IS NULL
      AND    I.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
      AND    NOT EXISTS(SELECT *
                        FROM   GARANTIA G
                        WHERE  G.INTERNADO_ID_INTERNADO = I.ID_INTERNADO
                       )
      ORDER BY 1 desc;

      BEGIN
        OPEN C;
        FETCH C INTO  v_tipo,
                      v_nro_habitacion,
                      v_id_paciente,
                      v_paciente,
                      v_fecha_ingreso,
                      v_saldo,
                      v_empresa,
                      v_plan,
                      v_medico_tratante,
                      v_personal,
                      v_obs,
                      v_exoneracion,
                      v_tipo_contrato;

        v_enter := Chr(13);
        v_tipo_ant := 'UTI';

        V_MENSAJE := '<HTML>';
        V_MENSAJE := V_MENSAJE||'<FONT FACE="VERDANA">';
        V_MENSAJE := V_MENSAJE||'<TABLE BORDER="1">';
        V_MENSAJE := V_MENSAJE||'<TR>';
        V_MENSAJE := V_MENSAJE||'<TD colspan="10"><FONT size=1.5><center><B>PACIENTES EN UTI SIN DEPOSITOS EN GARANTIA - CENTRO MEDICO LA COSTA</B></FONT></center></TD>';
        V_MENSAJE := V_MENSAJE||'</TR>';
        V_MENSAJE := V_MENSAJE||'<TR>';
        V_MENSAJE := V_MENSAJE||'<TD width="1.5%" align="center"><FONT size=1.5 COLOR="black">Hab.</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="1.5%" align="center"><FONT size=1.5 COLOR="black">Id.Pac.</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="7%"><FONT size=1.5 COLOR="black">Nombres</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="3%" align="center"><FONT size=1.5 COLOR="black">Fecha Ing.</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD align="right" width="3.5%"><FONT size=1.5 COLOR="black">Saldo</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="3%"><FONT size=1.5 COLOR="black">Empresa</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="3%"><FONT size=1.5 COLOR="black">Plan</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="3%"><FONT size=1.5 COLOR="black">Obs</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="4%"><FONT size=1.5 COLOR="black">Medico Tratante</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'<TD width="3%"><FONT size=1.5 COLOR="black">Personal Adm.</FONT></TD>';
        V_MENSAJE := V_MENSAJE||'</TR>';

        WHILE C%FOUND
        LOOP
          V_SIN_REGISTRO := 'SI';

          if v_tipo_ant != v_tipo then
             V_MENSAJE := V_MENSAJE||'<TR>';
             V_MENSAJE := V_MENSAJE||'<TD colspan="10"><FONT size=1.5><center><B>PACIENTES PARTICULARES EN SALA SIN DEPOSITOS EN GARANTIA - CENTRO MEDICO LA COSTA</B></FONT></center></TD>';
             V_MENSAJE := V_MENSAJE||'</TR>';
             v_tipo_ant := v_tipo;
          end if;

          V_MENSAJE := V_MENSAJE||'<TR>';
          V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.0>'||v_nro_habitacion||'</FONT></TD>'||v_enter;
          V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.0>'||v_id_paciente||'</FONT></TD>'||v_enter;
          --V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0>'||v_paciente||'</FONT></TD>'||v_enter;
          IF Nvl(v_exoneracion, '.') NOT LIKE '%EXON%_%' then
             V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0 color="red">'||v_paciente||'</FONT></TD>'||v_enter;
          ELSE
             V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0>'||v_paciente||'</FONT></TD>'||v_enter;
          END IF;
          V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.0>'||To_Char(v_fecha_ingreso, 'dd-mm-rr hh24:mi')||'</FONT></TD>'||v_enter;
          V_MENSAJE := V_MENSAJE||'<TD align="right"><FONT size=1.0>'||To_Char(v_saldo, '999g999g999')||'</FONT></TD>'||v_enter;
          V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0>'||v_empresa||'</FONT></TD>'||v_enter;
          IF V_TIPO_CONTRATO = 1 THEN
             V_MENSAJE := V_MENSAJE||'<TD align="left"><B><P STYLE="BACKGROUND-COLOR:#22D446"><FONT size=1.0>'||v_plan||'</FONT></B></TD>'||v_enter;
          ELSE
             V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0> '||v_plan||'</FONT></TD>'||v_enter;
          END IF;
          V_MENSAJE := V_MENSAJE||'<TD><FONT size=1.0>'||v_obs||'</FONT></TD>'||v_enter;
          V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0> '||v_medico_tratante||'</FONT></TD>'||v_enter;
          V_MENSAJE := V_MENSAJE||'<TD align="left"><FONT size=1.0> '||v_personal||'</FONT></TD>'||v_enter;
          V_MENSAJE := V_MENSAJE||'</TR>';

          FETCH C INTO  v_tipo,
                        v_nro_habitacion,
                        v_id_paciente,
                        v_paciente,
                        v_fecha_ingreso,
                        v_saldo,
                        v_empresa,
                        v_plan,
                        v_medico_tratante,
                        v_personal,
                        v_obs,
                        v_exoneracion,
                        v_tipo_contrato;
        END LOOP;
        CLOSE C;

        IF v_mensaje IS NOT NULL AND V_SIN_REGISTRO = 'SI' THEN
          V_MENSAJE := V_MENSAJE||'</TABLE>';
          V_MENSAJE := V_MENSAJE||'</FONT>';
          V_MENSAJE := V_MENSAJE||'</HTML> .';

          IF V_ID_SUCURSAL = 4 THEN
            mail_id := demo_mail.begin_mail(
                            sender     => 'lacosta@lacosta.com.py',
                            recipients => 'gerencia.general@santajulia.com.py,tesoreria@santajulia.com.py,admision.programacion@santajulia.com.py,cobranzas@santajulia.com.py,gerencia.administrativa@santajulia.com.py',
                            subject    => 'PACIENTES EN UTI SIN DEPOSITOS EN GARANTIA '||' - '||V_SUCURSAL,
                            mime_type =>demo_mail.MULTIPART_MIME_TYPE);
            demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aquí se escribe si quiero enviar un texto
            demo_mail.write_text( mail_id, V_MENSAJE);

          ELSIF V_ID_SUCURSAL = 2 THEN
            mail_id := demo_mail.begin_mail(
                            sender     => 'lacosta@lacosta.com.py',
                            recipients => 'sanatorio.gciafinan@lacosta.com.py,tesoreria@lacosta.com.py,gestion.cobro@lacosta.com.py,gestion.cobro1@lacosta.com.py',
                            subject    => 'PACIENTES EN UTI SIN DEPOSITOS EN GARANTIA '||' - '||V_SUCURSAL,
                            mime_type =>demo_mail.MULTIPART_MIME_TYPE);
            demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aquí se escribe si quiero enviar un texto
            demo_mail.write_text( mail_id, V_MENSAJE);

          ELSIF V_ID_SUCURSAL = 5 THEN
            mail_id := demo_mail.begin_mail(
                            sender     => 'lacosta@lacosta.com.py',
                            recipients => 'sanatorio.gciaadm@husl.com.py,leticia.zalazar@husl.com.py,gestion.cobroS@husl.com.py',
                            subject    => 'PACIENTES EN UTI SIN DEPOSITOS EN GARANTIA '||' - '||V_SUCURSAL,
                            mime_type =>demo_mail.MULTIPART_MIME_TYPE);
            demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aquí se escribe si quiero enviar un texto
            demo_mail.write_text( mail_id, V_MENSAJE);


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
      enviar_mail_sin_comp_pago;
END;
/

