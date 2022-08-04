PROMPT CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_2222_diario
CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail_2222_diario
--EXEC anamnesis.enviar_mail_2222_diario
IS

v_id_persona          number   (20,2);
v_persona             varchar2 (200);
v_periodo             varchar2 (200);
v_valido_para         varchar2 (200);
v_motivo              varchar2 (200);
v_mensaje             varchar2 (32767);
v_mensaje1            varchar2 (32767);
v_mensaje2            varchar2 (32767);
v_mensaje3            varchar2 (32767);
v_enter               varchar2 (10);
v_asunto              varchar2 (3000);
v_cantidad            number(18);
v_periodo             date;
v_fecha               date;
v_amb_enfer           number(18);
v_amb_enfer_int       number(18);
v_amb_obst            number(18);
v_amb_obst_int        number(18);
v_amb_ped             number(18);
v_amb_ped_int         number(18);
v_amb_trau            number(18);
v_amb_trau_int        number(18);
v_amb_cli             number(18);
v_amb_cli_int         number(18);
v_amb_ciru            number(18);
v_amb_ciru_int        number(18);
v_total_amb_enfer     number(18);
v_total_amb_enfer_int number(18);
v_total_amb_obst      number(18);
v_total_amb_obst_int  number(18);
v_total_amb_ped       number(18);
v_total_amb_ped_int   number(18);
v_total_amb_trau      number(18);
v_total_amb_trau_int  number(18);
v_total_amb_cli       number(18);
v_total_amb_cli_int   number(18);
v_total_amb_ciru      number(18);
v_total_amb_ciru_int  number(18);
v_total_prom_enfer    number(18,2);
v_total_prom_enfer_int number(18,2);
v_total_prom_obst     number(18,2);
v_total_prom_obst_int number(18,2);
v_total_prom_ped      number(18,2);
v_total_prom_ped_int  number(18,2);
v_total_prom_trau     number(18,2);
v_total_prom_trau_int number(18,2);
v_total_prom_cli      number(18,2);
v_total_prom_cli_int  number(18,2);
v_total_prom_ciru     number(18,2);
v_total_prom_ciru_int number(18,2);
v_total_dia           number(18);
v_total_dia_int       number(18);
v_total_general       number(18);
v_total_general_int   number(18);
v_acum_cant_dia       number(18);
v_acum_cant_dia_int   number(18);
v_amb_otros           number(18);
v_amb_otros_int       number(18);
v_total_amb_otros     number(18);
v_total_amb_otros_int number(18);
v_total_prom_otros    number(18,2);
v_total_prom_otros_int number(18,2);
v_color               VARCHAR2(200);
V_ID_SUCURSAL         NUMBER    (20);
V_SUCURSAL            SUCURSAL.DESCRIPCION%TYPE;
V_SIN_REGISTRO        VARCHAR2 (2);
v_mail                VARCHAR2(100);
V_FECHA_DESDE          DATE;
V_FECHA_HASTA          DATE;

MAIL_ID UTL_SMTP.CONNECTION;

CURSOR S IS
SELECT ID_SUCURSAL,
       DESCRIPCION
FROM   SUCURSAL
ORDER BY 1;

BEGIN
 v_enter := Chr(10);

v_total_amb_enfer := 0;
v_total_amb_obst  := 0;
v_total_amb_ped   := 0;
v_total_amb_trau  := 0;
v_total_amb_cli   := 0;
v_total_amb_ciru  := 0;
v_total_amb_otros := 0;

v_total_prom_enfer := 0;
v_total_prom_obst  := 0;
v_total_prom_ped   := 0;
v_total_prom_trau  := 0;
v_total_prom_cli   := 0;
v_total_prom_ciru  := 0;
v_total_prom_otros := 0;

v_acum_cant_dia   := 0;
v_acum_cant_dia_int   := 0;



IF To_Char(SYSDATE, 'dd') = 1 THEN
   V_FECHA_DESDE := Trunc(SYSDATE-1, 'MM');
   V_FECHA_HASTA := Last_Day(SYSDATE-1);
ELSE
   V_FECHA_DESDE := Trunc(SYSDATE, 'MM');
   V_FECHA_HASTA := trunc(SYSDATE, 'DD') - 1;
END IF;

 --RAISE_APPLICATION_eRROR(-20000, To_Char(V_FECHA_DESDE, 'DD/MM/RR')||' - '|| To_Char(V_FECHA_HASTA, 'DD/MM/RR')) ;

OPEN S;
FETCH S INTO V_ID_SUCURSAL, V_SUCURSAL;
BEGIN
WHILE S%FOUND
LOOP

    v_total_amb_enfer := 0;
    v_total_amb_enfer_int := 0;
    v_total_amb_obst  := 0;
    v_total_amb_obst_int  := 0;
    v_total_amb_ped   := 0;
    v_total_amb_ped_int   := 0;
    v_total_amb_trau  := 0;
    v_total_amb_trau_int  := 0;
    v_total_amb_cli   := 0;
    v_total_amb_cli_int   := 0;
    v_total_amb_ciru  := 0;
    v_total_amb_ciru_int  := 0;
    v_total_amb_otros := 0;
    v_total_amb_otros_int := 0;

    v_total_prom_enfer := 0;
    v_total_prom_enfer_int := 0;
    v_total_prom_obst  := 0;
    v_total_prom_obst_int  := 0;
    v_total_prom_ped   := 0;
    v_total_prom_ped_int   := 0;
    v_total_prom_trau  := 0;
    v_total_prom_trau_int  := 0;
    v_total_prom_cli   := 0;
    v_total_prom_cli_int   := 0;
    v_total_prom_ciru  := 0;
    v_total_prom_ciru_int  := 0;
    v_total_prom_otros := 0;
    v_total_prom_otros_int := 0;

    v_acum_cant_dia   := 0;
    v_acum_cant_dia_int   := 0;
    V_MENSAJE := NULL;
    V_MENSAJE1 := NULL;


    BEGIN
    V_SIN_REGISTRO := 'NO';
    DECLARE CURSOR C IS
      SELECT fecha,
            Sum(amb_enfer) amb_enfer,
            Sum(amb_enfer_int) amb_enfer_int,
            Sum(amb_obst) amb_obst,
            Sum(amb_obst_int) amb_obst_int,
            Sum(amb_ped) amb_ped,
            Sum(amb_ped_int) amb_ped_int,
            Sum(amb_trau) amb_trau,
            Sum(amb_trau_int) amb_trau_int,
            Sum(amb_cli) amb_cli,
            Sum(amb_cli_int) amb_cli_int,
            Sum(amb_ciru)  amb_ciru,
            Sum(amb_ciru_int)  amb_ciru_int,
            Sum(amb_otros)  amb_otros,
            Sum(amb_otros_int)  amb_otros_int

      FROM (SELECT 	To_Date(Trunc(Nvl(FECHA_ATENCION, FECHA_CONSULTA), 'dd'), 'DD-MM-RR') FECHA,
              Nvl( CASE WHEN  ES.DESCRIPCION = 'AMB. ENFERMERIA' THEN 1  END,0) amb_enfer,
              Nvl( CASE WHEN  ES.DESCRIPCION = 'AMB. ENFERMERIA' THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_enfer_int,

              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. OBSTETRICIA' THEN 1 END,0) amb_obst,
              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. OBSTETRICIA' THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_obst_int,

              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. PEDIATRIA' THEN 1 END,0) amb_ped,
              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. PEDIATRIA' THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_ped_int,

              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. TRAUMATOLOGÍA' THEN 1 END,0) amb_trau,
              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. TRAUMATOLOGÍA' THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_trau_int,

              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. CLINICA MEDICA' THEN 1 END,0) amb_cli,
              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. CLINICA MEDICA' THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_cli_int,

              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. CIRUGIA' THEN 1 END,0) amb_ciru,
              Nvl(  CASE WHEN  ES.DESCRIPCION = 'AMB. CIRUGIA' THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_ciru_int,

              Nvl(  CASE WHEN  Nvl(ES.DESCRIPCION, 'XXX') NOT IN  ('AMB. CIRUGIA','AMB. CLINICA MEDICA', 'AMB. TRAUMATOLOGÍA','AMB. PEDIATRIA','AMB. OBSTETRICIA', 'AMB. ENFERMERIA')  THEN 1 END,0) amb_otros,
              Nvl(  CASE WHEN  Nvl(ES.DESCRIPCION, 'XXX') NOT IN  ('AMB. CIRUGIA','AMB. CLINICA MEDICA', 'AMB. TRAUMATOLOGÍA','AMB. PEDIATRIA','AMB. OBSTETRICIA', 'AMB. ENFERMERIA')  THEN CASE WHEN verif_int_pac_urg(co.id_consulta) = 'SI' THEN 1 ELSE 0 END ELSE 0 END,0) amb_otros_int
        FROM 	ESPECIALIDAD ES,
              CONSULTA CO
        WHERE	CO.ESP_ID_ESPECIALIDAD = ES.ID_ESPECIALIDAD(+)
        AND   CO.ESTADO != 'CANCELADO'
        AND   CO.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
        AND   TRUNC(NVL(FECHA_ATENCION, FECHA_CONSULTA),'dd') BETWEEN V_FECHA_DESDE AND V_FECHA_HASTA
        AND   EXISTS(SELECT *
                     FROM   SRV S, NOMEN_CONSULTA N
                     WHERE  CO.ID_CONSULTA = S.CONSULTA_ID_CONSULTA
                     AND    S.NOMEN_ID_NOMENCLADOR  = N.NOMEN_ID_NOMENCLADOR
                     AND    S.ESTADO_SERVICIO = 'ACTIVO'
                     )

        ORDER BY 1)
        GROUP  BY FECHA
        ORDER BY 1;

    BEGIN
      OPEN C;
          FETCH C INTO  V_FECHA,
                        V_AMB_ENFER,
                        V_AMB_ENFER_INT,
                        V_AMB_OBST,
                        V_AMB_OBST_INT,
                        V_AMB_PED,
                        V_AMB_PED_INT,
                        V_AMB_TRAU,
                        V_AMB_TRAU_INT,
                        V_AMB_CLI,
                        V_AMB_CLI_INT,
                        V_AMB_CIRU,
                        V_AMB_CIRU_INT,
                        V_AMB_OTROS,
                        V_AMB_OTROS_INT;


            V_MENSAJE := '<HTML>';
            V_MENSAJE := V_MENSAJE||'<FONT FACE="VERDANA">';
            V_MENSAJE := V_MENSAJE||'<TABLE BORDER="1"  >';
            V_MENSAJE := V_MENSAJE||'<TR><TD colspan="25"><center><B> CONSULTAS MES DE '||MES_LETRA_FECHA(V_FECHA_DESDE)||' '||To_Char(V_FECHA_DESDE,'RRRR')||' - '||v_sucursal ||'</B></TD></TR>';
            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2>Fecha</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Dia</FONT> </TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Enfermeria</FONT> </TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT> </TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Obstetricia</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Pediatria</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Traumatología</FONT> </TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Clinica Medica</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Cirugia </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Otros </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> I</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Total Dia </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> Total I </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Enf. </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Obst. </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Ped. </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Traum. </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Cli.Med </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Ciru. </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT COLOR="black" SIZE=2> % Dia Otros </FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'</TR>';

      WHILE C%FOUND
        LOOP
          V_SIN_REGISTRO := 'SI';
          IF OBTIENE_FERIADO(V_FECHA) = 'SI'  OR  DIA_LETRA_FECHA(V_FECHA) LIKE  '%DOMINGO%' THEN
              v_color := '#F781BE' ;
          END IF;

            IF LENGTH(V_MENSAJE) > 28000 AND V_MENSAJE1 IS NULL THEN
               V_MENSAJE1 := V_MENSAJE;
               V_MENSAJE := '';
            END IF;
            IF LENGTH(V_MENSAJE) > 28000 AND V_MENSAJE1 IS NOT NULL AND V_MENSAJE2 IS NULL THEN
               V_MENSAJE2 := V_MENSAJE;
               V_MENSAJE := '';
            END IF;
            IF LENGTH(V_MENSAJE) > 28000 AND V_MENSAJE2 IS NOT NULL AND V_MENSAJE3 IS NULL THEN
               V_MENSAJE3 := V_MENSAJE;
               V_MENSAJE := '';
            END IF;

            v_total_dia :=V_AMB_ENFER+V_AMB_OBST+V_AMB_PED+V_AMB_TRAU+V_AMB_CLI+V_AMB_CIRU+V_AMB_OTROS;
            v_total_dia_int :=V_AMB_ENFER_INT + V_AMB_OBST_INT + V_AMB_PED_INT + V_AMB_TRAU_INT + V_AMB_CLI_INT + V_AMB_CIRU_INT + V_AMB_OTROS_INT;
            V_MENSAJE := V_MENSAJE||'<TR>';
            V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor='||v_color||'><FONT size=1.2>'||To_Char(V_FECHA, 'dd-mm-rr')||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor='||v_color||'><FONT size=1.2>'||dia_letra_fecha(V_FECHA)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_ENFER||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_ENFER_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_OBST||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_OBST_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_PED||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_PED_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_TRAU||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_TRAU_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_CLI||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_CLI_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_CIRU||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||V_AMB_CIRU_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center" ><FONT size=1.2>'||V_AMB_OTROS||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center" ><FONT size=1.2>'||V_AMB_OTROS_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor="#c0c0c0"><FONT size=1.2>'||V_TOTAL_DIA||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center" bgcolor="#c0c0c0"><FONT size=1.2>'||V_TOTAL_DIA_INT||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_ENFER / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_OBST / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_PED / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_TRAU / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_CLI / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_CIRU / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'<TD align="center"><FONT size=1.2>'||Round((V_AMB_OTROS / V_TOTAL_DIA)*100,2)||'</FONT></TD>'||v_enter;
            V_MENSAJE := V_MENSAJE||'</TR>';
            V_ACUM_CANT_DIA := V_ACUM_CANT_DIA +  1;
            V_ACUM_CANT_DIA_INT := V_ACUM_CANT_DIA_INT +  1;

            V_TOTAL_AMB_ENFER := V_TOTAL_AMB_ENFER +  V_AMB_ENFER;
            V_TOTAL_AMB_ENFER_INT := V_TOTAL_AMB_ENFER_INT +  V_AMB_ENFER_INT;
            V_TOTAL_AMB_OBST  := V_TOTAL_AMB_OBST  +  V_AMB_OBST;
            V_TOTAL_AMB_OBST_INT  := V_TOTAL_AMB_OBST_INT  +  V_AMB_OBST_INT;
            V_TOTAL_AMB_PED   := V_TOTAL_AMB_PED   +  V_AMB_PED;
            V_TOTAL_AMB_PED_INT   := V_TOTAL_AMB_PED_INT   +  V_AMB_PED_INT;
            V_TOTAL_AMB_TRAU  := V_TOTAL_AMB_TRAU  +  V_AMB_TRAU;
            V_TOTAL_AMB_TRAU_INT  := V_TOTAL_AMB_TRAU_INT  +  V_AMB_TRAU_INT;
            V_TOTAL_AMB_CLI   := V_TOTAL_AMB_CLI   +  V_AMB_CLI;
            V_TOTAL_AMB_CLI_INT   := V_TOTAL_AMB_CLI_INT   +  V_AMB_CLI_INT;
            V_TOTAL_AMB_CIRU  := V_TOTAL_AMB_CIRU  +  V_AMB_CIRU;
            V_TOTAL_AMB_CIRU_INT  := V_TOTAL_AMB_CIRU_INT  +  V_AMB_CIRU_INT;
            V_TOTAL_AMB_OTROS := V_TOTAL_AMB_OTROS +  V_AMB_OTROS;
            V_TOTAL_AMB_OTROS_INT := V_TOTAL_AMB_OTROS_INT +  V_AMB_OTROS_INT;




            v_color := 'white';
          FETCH C INTO  V_FECHA,
                        V_AMB_ENFER,
                        V_AMB_ENFER_INT,
                        V_AMB_OBST,
                        V_AMB_OBST_INT,
                        V_AMB_PED,
                        V_AMB_PED_INT,
                        V_AMB_TRAU,
                        V_AMB_TRAU_INT,
                        V_AMB_CLI,
                        V_AMB_CLI_INT,
                        V_AMB_CIRU,
                        V_AMB_CIRU_INT,
                        V_AMB_OTROS,
                        V_AMB_OTROS_INT;

        END LOOP;
        CLOSE C;
          v_total_general := v_total_amb_enfer+ v_total_amb_obst+v_total_amb_ped+v_total_amb_trau+v_total_amb_cli+v_total_amb_ciru +v_total_amb_otros ;
          v_total_general_int := v_total_amb_enfer_int + v_total_amb_obst_int + v_total_amb_ped_int + v_total_amb_trau_int + v_total_amb_cli_int + v_total_amb_ciru_int + v_total_amb_otros_int ;
          IF Nvl(v_total_general, 1) = 0 THEN
             v_total_general := 1;
          END IF;
          IF Nvl(v_total_general_int, 1) = 0 THEN
             v_total_general_int := 1;
          END IF;

          V_TOTAL_PROM_ENFER :=  Round((v_total_amb_enfer / v_total_general)*100,2);
          V_TOTAL_PROM_OBST  :=  Round((v_total_amb_obst / v_total_general)*100,2);
          V_TOTAL_PROM_PED   :=  Round((v_total_amb_ped / v_total_general)*100,2);
          V_TOTAL_PROM_TRAU  :=  Round((v_total_amb_trau / v_total_general)*100,2);
          V_TOTAL_PROM_CLI   :=  Round((v_total_amb_cli / v_total_general)*100,2);
          V_TOTAL_PROM_CIRU  :=  Round((v_total_amb_ciru / v_total_general)*100,2);
          V_TOTAL_PROM_OTROS :=  Round((v_total_amb_otros / v_total_general)*100,2);

          v_mensaje := v_mensaje||'<tr>'||v_enter;
          v_mensaje := v_mensaje||'<td colspan=1 bgcolor="#c0c0c0"><font size=2><b>Totales: </b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||' '||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_enfer, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_enfer_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_obst, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_obst_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_ped, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_ped_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_trau, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_trau_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_cli, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_cli_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_ciru, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_ciru_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_otros, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_amb_otros_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_general, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_general_int, '999g999g999g990'))||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_enfer, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_obst, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_ped, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_trau, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_cli, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_ciru, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||rtrim(to_char(v_total_prom_otros, '999g999g999g990'))||'%'||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'</tr>'||v_enter;

          v_mensaje := v_mensaje||'<tr>'||v_enter;
          v_mensaje := v_mensaje||'<td colspan=1 bgcolor="#c0c0c0"><font size=2><b>Prom por dia: </b></font></td>'||v_enter;
          IF Nvl(V_ACUM_CANT_DIA, 1) = 0 THEN
             V_ACUM_CANT_DIA := 1;
          END IF;
          IF Nvl(V_ACUM_CANT_DIA_INT, 1) = 0 THEN
             V_ACUM_CANT_DIA_INT := 1;
          END IF;

          v_mensaje := v_mensaje||'<td align="center" bgcolor="#c0c0c0"><font size=2><b>'||Round(V_TOTAL_GENERAL/ V_ACUM_CANT_DIA)||'</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'</tr>'||v_enter;

          v_mensaje := v_mensaje||'<tr>'||v_enter;
          v_mensaje := v_mensaje||'<td colspan=25 align="left" bgcolor="#c0c0c0"><font size=2><b>Obs.: I= Pacientes Internados</b></font></td>'||v_enter;
          v_mensaje := v_mensaje||'</tr>'||v_enter;

          v_mensaje := v_mensaje||'</font>';
          v_mensaje := v_mensaje||'</table>';
          v_mensaje := v_mensaje||'</HTML>';

/*
          mail_id := demo_mail.begin_mail(
                          sender     => 'info@lacosta.com.py',
                          recipients => v_mail,
                          subject    => v_asunto,
                          mime_type =>demo_mail.MULTIPART_MIME_TYPE);
          demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aquí se escribe si quiero enviar un texto

          demo_mail.write_text( mail_id, Nvl(V_MENSAJE_1, '')||V_MENSAJE);
          IF V_MENSAJE IS NOT NULL THEN
              demo_mail.end_mail( mail_id );
          END IF;

*/
           IF V_SIN_REGISTRO = 'SI' THEN
              V_ASUNTO := 'CONSULTAS MES DE '||MES_LETRA_FECHA(SYSDATE)||' '||To_Char(SYSDATE,'RRRR')||' - '||V_SUCURSAL;
              IF V_ID_SUCURSAL = 4 THEN
                  mail_id := demo_mail.begin_mail(
                                  sender     => 'informes@lacosta.com.py',
                                  recipients => 'gerencia.general@santajulia.com.py,direccion.medica@santajulia.com.py,jefatura.enfermeria@santajulia.com.py,raul.doria@lacosta.com.py,gerencia.administrativa@santajulia.com.py',
                                  subject    => v_asunto,
                                  mime_type =>demo_mail.MULTIPART_MIME_TYPE);
                  demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aqui se escribe si quiero enviar un texto
                  demo_mail.write_text( mail_id, V_MENSAJE1);
                  demo_mail.write_text( mail_id, V_MENSAJE2);
                  demo_mail.write_text( mail_id, V_MENSAJE3);
                  demo_mail.write_text( mail_id, V_MENSAJE);
              ELSIF V_ID_SUCURSAL = 5 THEN
                  mail_id := demo_mail.begin_mail(
                                  sender     => 'informes@lacosta.com.py',
                                  recipients => 'gerencia.general@husl.com.py,raul.doria@lacosta.com.py',
                                  subject    => v_asunto,
                                  mime_type =>demo_mail.MULTIPART_MIME_TYPE);
                  demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aqui se escribe si quiero enviar un texto
                  demo_mail.write_text( mail_id, V_MENSAJE1);
                  demo_mail.write_text( mail_id, V_MENSAJE2);
                  demo_mail.write_text( mail_id, V_MENSAJE3);
                  demo_mail.write_text( mail_id, V_MENSAJE);

              ELSE
                  mail_id := demo_mail.begin_mail(
                                  sender     => 'informes@lacosta.com.py',
                                  recipients => 'raul.doria@lacosta.com.py,mabel.benitez@lacosta.com.py,sanatorio.gciafinan@lacosta.com.py,sebastian.avila@lacosta.com.py,direccion.medica.pediatria@lacosta.com.py,sanatorio.gciafinan@lacosta.com.py,lorena.benitez@lacosta.com.py,facturacion1@lacosta.com.py,guillermina.nieto@lacosta.com.py,jefatura.enfermeria@lacosta.com.py,jorge.vazquez@lacosta.com.py,monica.martinez@lacosta.com.py,roxana.cisneros@lacosta.com.py',
                                  subject    => v_asunto,
                                  mime_type =>demo_mail.MULTIPART_MIME_TYPE);
                  demo_mail.attach_text( mail_id, ' ' , 'text/html' );--'Aqui se escribe si quiero enviar un texto
                  demo_mail.write_text( mail_id, V_MENSAJE1);
                  demo_mail.write_text( mail_id, V_MENSAJE2);
                  demo_mail.write_text( mail_id, V_MENSAJE3);
                  demo_mail.write_text( mail_id, V_MENSAJE);
              END IF;

                       --se remplaza el correo del dr Rigioni por el del Dr Avila pedido de la Lic. mabel benitez ticket 92258

              IF V_MENSAJE IS NOT NULL THEN
                  demo_mail.end_mail( mail_id );
              END IF;
           END IF;
          END;
      END;
      FETCH S INTO V_ID_SUCURSAL, V_SUCURSAL;
    END LOOP;
    CLOSE S;
   END;
END;
/

