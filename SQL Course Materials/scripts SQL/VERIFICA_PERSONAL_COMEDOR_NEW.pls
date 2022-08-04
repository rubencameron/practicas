PROMPT CREATE OR REPLACE PROCEDURE anamnesis.verifica_personal_comedor_new
CREATE OR REPLACE PROCEDURE anamnesis.verifica_personal_comedor_new
  (p_empresa IN VARCHAR2,
   p_persona IN NUMBER,
   p_derecho IN VARCHAR2,
   p_vale IN VARCHAR2,
   p_mensaje OUT VARCHAR2,
   p_id_factura_comedor OUT NUMBER,
   p_tipo_refrigerio IN varchar2)
  IS
  dummy CHAR(1);
  v_dia_hoy VARCHAR2(20);
  v_salida_menu salida_menu.id_salida_menu%TYPE;
  v_nro_comanda salida_menu.nro_comanda%TYPE;
  v_monto_menu menu.precio_interno_1%TYPE;
  v_tipo_derecho VARCHAR2(20);
  v_tipo_derecho_real  VARCHAR2(20);

  V_EXENTO_NORMAL NUMBER(20);
  V_EXENTO_INTERNO  NUMBER(20);
  V_GRAVADO_NORMAL  NUMBER(20);
  V_GRAVADO_INTERNO  NUMBER(20);

  --v_id_factura_comedor fact_comed.id_factura_comedor%TYPE;
  v_id_paciente pac.id_paciente%TYPE;
  v_tipo_paciente pac.tip_pac_id_tipo_paciente%TYPE;
  v_cliente pac.nombres%TYPE;
  v_ruc_nuevo pac.ruc_nuevo%TYPE;

  vale_utilizado  EXCEPTION;
  beneficio_lleno EXCEPTION;
  hora_no_corresponde EXCEPTION;
  sin_beneficio EXCEPTION;
  SIN_LIMITE    EXCEPTION;
  v_utilizado vale_comedor.utilizado%TYPE;
  v_derecho_vale vale_comedor.derecho%TYPE;
  v_id_menu menu.id_menu%TYPE;
  v_id_menu_parcial menu.id_menu%TYPE;
  v_derecho VARCHAR2(200);
  V_DIA_DERECHO VARCHAR2(20);
  V_CANTIDAD_HABILITADA NUMBER(20);
  V_CANTIDAD_DISPONIBLE NUMBER(20);
  V_CANT_PARCIAL NUMBER(10);
  v_fecha DATE;
  v_fecha_desde DATE;
  v_fecha_hasta DATE;
  v_id_sucursal sucursal.id_sucursal%TYPE;
  V_ITEM                NUMBER(20);
  V_COMENTARIO          VARCHAR2(200);
  V_LIMITE              FACT_COMED.MONTO_EXENTO%TYPE;
  V_SALDO               FACT_COMED.MONTO_EXENTO%TYPE;
  V_SALDO_INICIAL       FACT_COMED.MONTO_EXENTO%TYPE;
  V_ID_COMEDOR          NUMBER(20);
  V_ID_MESA             NUMBER(20);
  V_ID_OPERADOR         NUMBER(20);
  V_ID_MESERO           NUMBER(20);
  V_ID_PERSONA_VALE     NUMBER(20);

BEGIN

  v_id_sucursal := obtener_suc_usuario(USER);

  IF p_vale IS NOT NULL THEN

    BEGIN
      SELECT Nvl(utilizado, 'NO'), derecho, fecha, fecha_desde, fecha_hasta
      INTO v_utilizado, v_derecho_vale, v_fecha, v_fecha_desde, v_fecha_hasta
      FROM vale_comedor
      WHERE codigo_generado = p_vale
      AND   Nvl(estado, 'ACTIVO') IN ('ACTIVO','APROBADO');

      IF v_utilizado = 'SI' THEN

         IF v_fecha_desde IS NOT NULL THEN
            IF Trunc(SYSDATE, 'dd') NOT BETWEEN Trunc(v_fecha_desde, 'dd') AND Trunc(v_fecha_hasta, 'dd') THEN
               Raise_Application_Error(-20000, 'VALE corresponde a la fecha desde '||To_Char(v_fecha_desde, 'dd-mm-rr')||' hasta '||To_Char(v_fecha_hasta, 'dd-mm-rr'));
            END IF;
         ELSE
            p_mensaje := 'VALE ya utilizado';
         END IF;
      ELSE
         IF v_fecha_desde IS NULL THEN
            IF Trunc(v_fecha, 'dd') != Trunc(SYSDATE, 'dd') THEN
               Raise_Application_Error(-20000, 'VALE corresponde a la fecha '||To_Char(v_fecha, 'dd-mm-rr'));
            END IF;
         ELSE
            IF Trunc(SYSDATE, 'dd') NOT BETWEEN Trunc(v_fecha_desde, 'dd') AND Trunc(v_fecha_hasta, 'dd') THEN
               Raise_Application_Error(-20000, 'VALE corresponde a la fecha desde '||To_Char(v_fecha_desde, 'dd-mm-rr')||' hasta '||To_Char(v_fecha_hasta, 'dd-mm-rr'));
            END IF;
         END IF;
      END IF;
    EXCEPTION
      WHEN No_Data_Found THEN
        --p_mensaje := 'VALE no existe';
        Raise_Application_Error(-20000, 'VALE no existe');
        --RAISE vale_utilizado;
    END;
  END IF;

  SELECT Decode(p_derecho,
                'ALMUERZO_LIGHT', 'ALMUERZO',
                'RN', 'REFRIGERIO',
                'RM', 'REFRIGERIO',
                'RT', 'REFRIGERIO',
                p_derecho)
  INTO v_tipo_derecho
  FROM dual;

  IF p_vale IS NOT NULL THEN

    IF v_derecho_vale != v_tipo_derecho THEN
      p_mensaje := 'El VALE ingreso corresponde a '||v_derecho_vale;
      Raise_Application_Error(-20000, 'El VALE ingreso corresponde a '||v_derecho_vale);
      --RAISE vale_utilizado;
    END IF;

    UPDATE vale_comedor
    SET utilizado = 'SI'
    WHERE codigo_generado = p_vale
    AND   Nvl(utilizado, 'NO') = 'NO';
  END IF;

  BEGIN
      BEGIN
        SELECT '1'
        INTO   DUMMY
        FROM   FERIADOS_RRHH
        WHERE  TO_CHAR(FECHA, 'DD') = To_Char(SYSDATE, 'DD')
        AND    TO_CHAR(FECHA, 'MM') = To_Char(SYSDATE, 'MM');

        V_DIA_DERECHO := 'FERIADO';

      EXCEPTION
          WHEN No_Data_Found THEN

              IF To_Char(SYSDATE, 'DAY') LIKE '%SABADO%' OR
                To_Char(SYSDATE, 'DAY') LIKE '%SÁBADO%' OR
                To_Char(SYSDATE, 'DAY') LIKE '%SATURDAY%' THEN

                V_DIA_DERECHO := 'SABADO';

              ELSIF To_Char(SYSDATE, 'DAY') LIKE '%SUNDAY%' OR
                    To_Char(SYSDATE, 'DAY') LIKE '%DOMINGO%' THEN

                V_DIA_DERECHO := 'DOMINGO';

              ELSE
                V_DIA_DERECHO := 'L_a_V';
              END IF;
      END;
    BEGIN

      IF OBT_DATO_PER_RRHH_SUC(P_PERSONA,V_ID_SUCURSAL,'CAT_SAL_ID_CATEGORIA', NULL, NULL, NULL, NULL) NOT IN (72, 78, 80) OR OBT_DATO_PER_RRHH_SUC(P_PERSONA,V_ID_SUCURSAL,'CARGO_ID_CARGO', NULL, NULL, NULL, NULL) NOT IN (54) THEN --para los medicos no se debe tene en cuenta. Ticket 52272
      v_dia_hoy := Trim(DIA_LETRA_FECHA(SYSDATE));

              SELECT Decode(Upper(v_dia_hoy),
                            'MONDAY', 'LUNES',
                            'LUNES', 'LUNES',
                            'TUESDAY', 'MARTES',
                            'MARTES', 'MARTES',
                            'MIERCOLES', 'MIERCOLES',
                            'MIÉRCOLES', 'MIERCOLES',
                            'WEDNESDAY', 'MIERCOLES',
                            'JUEVES', 'JUEVES',
                            'THURSDAY', 'JUEVES',
                            'FRIDAY', 'VIERNES',
                            'VIERNES', 'VIERNES',
                            'SATURDAY', 'SABADO',
                            'SABADO', 'SABADO',
                            'SÁBADO', 'SABADO',
                            'SUNDAY', 'DOMINGO',
                            'DOMINGO', 'DOMINGO',
                                        v_dia_hoy)
              INTO v_dia_hoy
              FROM DUAL;

              BEGIN

                SELECT  '1'
                INTO   DUMMY
                FROM   HORARIO_PERSONA D
                WHERE  D.HPT_PER_ID_PERSONA = P_PERSONA
                AND    D.DIA = V_DIA_HOY
                AND    D.COMEDOR = V_TIPO_DERECHO
                AND    D.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
                AND    D.HPT_FECHA_VIGENCIA_DESDE = (SELECT Max(DD.HPT_FECHA_VIGENCIA_DESDE)
                                                      FROM   HORARIO_PERSONA DD
                                                      WHERE  DD.HPT_PER_ID_PERSONA = P_PERSONA
                                                      AND    DD.DIA = V_DIA_HOY
                                                      AND    DD.COMEDOR = V_TIPO_DERECHO
                                                      AND    DD.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
                                                    )
                AND    ROWNUM < 2;
              EXCEPTION
                WHEN No_Data_Found THEN
                    p_mensaje := 'No tiene asignado derecho de '||v_tipo_derecho||', favor ver con RRHH. '||'
  Legajo Id. '||P_PERSONA;
                    RAISE sin_beneficio;
              END;

     END IF;


      --XQ mas arriba esta variable tiene valor REFRIGERIO PARA RM, MN y RT, por lo que vuelve asumir el valor de parametro original
      if v_tipo_derecho = 'REFRIGERIO' then
         v_tipo_derecho_real := p_derecho;
      else
         v_tipo_derecho_real := v_tipo_derecho;
      end if;

      SELECT Decode(V_TIPO_DERECHO_REAL,
                    'ALMUERZO', ALMUERZO,
                    'CENA'    , CENA,
                    'RM'      , RM,
                    'RT'      , RT,
                    'RN'      , RN)
      INTO V_CANTIDAD_HABILITADA
      FROM PLANILLA_DIETA
      WHERE ((DEPARTAMEN_ID_DEPARTAMENTO, DEPARTAMEN_ID_SECCION) IN (SELECT PS.D_SUC_DEP_DEPARTAMEN_ID_DEPART,
                                                                            PS.D_SUC_DEP_DEPARTAMEN_ID_SECCIO
                                                                     FROM   PERSONA_RRHH P, PER_RRHH_SUC PS
                                                                     WHERE  P.ID_PERSONA = PS.PER_ID_PERSONA
                                                                     AND    PS.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
                                                                     AND    P.ID_PERSONA = P_PERSONA
                                                                     AND    ESTADO = 'ACTIVO')
      OR    ((DEPARTAMEN_ID_DEPARTAMENTO, 0) IN (SELECT PS.D_SUC_DEP_DEPARTAMEN_ID_DEPART,
                                                          0
                                                   FROM   PERSONA_RRHH P, PER_RRHH_SUC PS
                                                   WHERE  P.ID_PERSONA = PS.PER_ID_PERSONA
                                                   AND    PS.SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL
                                                   AND    P.ID_PERSONA = P_PERSONA
                                                   AND    ESTADO ='ACTIVO')
      AND   DEPARTAMEN_ID_DEPARTAMENTO IN (44444, 1010101010))) --se saca a pedido de Nelson (fijo para 4 y 10, seccion cero)...
      AND   DIA = V_DIA_DERECHO;
    EXCEPTION
      WHEN No_Data_Found THEN
        V_CANTIDAD_HABILITADA := 0;
      WHEN Too_Many_Rows THEN
        Raise_Application_Error(-20000, 'El departamento del personal tiene mas de un derecho en el dia, se debe consultar con RR.HH., formulario 1019');
    END;

    IF V_TIPO_DERECHO = 'RN' THEN
      IF To_Char(SYSDATE, 'HH24') NOT BETWEEN 19 AND 21 THEN
        P_MENSAJE :='El REFRIGERIO TURNO NOCHE esta disponible de 19 a 22 Hs.';
        RAISE HORA_NO_CORRESPONDE;
      END IF;
    END IF;

    BEGIN
      SELECT DISTINCT '1'
      INTO DUMMY
      FROM FACT_COMED F, PERSONA_RRHH PR
      WHERE F.ESTADO_FACT_COMEDOR = 'ACTIVO'
      AND   F.EMPRESA_RESP = V_TIPO_DERECHO
      AND   F.TIPO_FACTURA = 'DIETA'
      AND   F.PAC_ID_PACIENTE = PR.PAC_ID_PACIENTE
      AND   PR.ID_PERSONA = P_PERSONA
      AND   Trunc(F.FECHA, 'DD') = Trunc(SYSDATE, 'DD');

      P_MENSAJE := '('||V_TIPO_DERECHO||') Usted ya registra el beneficio para el dia de hoy!';
      RAISE BENEFICIO_LLENO;

    EXCEPTION
      WHEN No_Data_Found THEN NULL;
    END;
 /*
    SELECT Nvl(V_CANTIDAD_HABILITADA, 0) - Count(*)
    INTO V_CANTIDAD_DISPONIBLE
    FROM FACT_COMED F, PERSONA_RRHH PR
    WHERE F.ESTADO_FACT_COMEDOR = 'ACTIVO'
    AND   F.EMPRESA_RESP = V_TIPO_DERECHO
    AND   F.TIPO_FACTURA = 'DIETA'
    AND   F.PAC_ID_PACIENTE = PR.PAC_ID_PACIENTE
    AND   (PR.D_SUC_DEP_DEPARTAMEN_ID_DEPA_1, PR.D_SUC_DEP_DEPARTAMEN_ID_SECC_1) = (SELECT PR1.D_SUC_DEP_DEPARTAMEN_ID_DEPA_1,
                                                                                           PR1.D_SUC_DEP_DEPARTAMEN_ID_SECC_1
                                                                                    FROM PERSONA_RRHH PR1
                                                                                    WHERE PR1.ID_PERSONA = P_PERSONA)
    AND   Trunc(F.FECHA, 'DD') = Trunc(SYSDATE, 'DD');
  */

      SELECT Nvl(V_CANTIDAD_HABILITADA, 0) - Count(*)
      INTO V_CANTIDAD_DISPONIBLE
      FROM FACT_COMED F, PERSONA_RRHH PR, PER_RRHH_SUC PS
      WHERE F.ESTADO_FACT_COMEDOR = 'ACTIVO'
      AND   F.EMPRESA_RESP = V_TIPO_DERECHO
      AND   PR.ESTADO = 'ACTIVO'
      AND   F.TIPO_FACTURA = 'DIETA'
      AND   F.PAC_ID_PACIENTE = PR.PAC_ID_PACIENTE
      AND   PR.ID_PERSONA = PS.PER_ID_PERSONA
      AND   PS.SUCURSAL_ID_SUCURSAL = 1
      AND   (PS.D_SUC_DEP_DEPARTAMEN_ID_DEPART, PS.D_SUC_DEP_DEPARTAMEN_ID_SECCIO) = (SELECT PS1.D_SUC_DEP_DEPARTAMEN_ID_DEPART,
                                                                                             PS1.D_SUC_DEP_DEPARTAMEN_ID_SECCIO
                                                                                      FROM   PERSONA_RRHH PR1, PER_RRHH_SUC PS1
                                                                                      WHERE  PR1.ID_PERSONA = PS1.PER_ID_PERSONA
                                                                                      AND    PS1.SUCURSAL_ID_SUCURSAL = 1
                                                                                      AND    PR1.ID_PERSONA = P_PERSONA
                                                                                      )
      AND   Trunc(F.FECHA, 'DD') = Trunc(SYSDATE, 'DD')
      AND    F.NRO_VALE IS NULL;   --PARA QUE NO INCLUYA LOS VALES

    IF OBT_DATO_PER_RRHH_SUC(P_PERSONA,V_ID_SUCURSAL,'CAT_SAL_ID_CATEGORIA', NULL, NULL, NULL, NULL) NOT IN (72, 78, 80) OR OBT_DATO_PER_RRHH_SUC(P_PERSONA,V_ID_SUCURSAL,'CARGO_ID_CARGO', NULL, NULL, NULL, NULL) NOT IN (54) THEN --para los medicos no se debe tene en cuenta. Ticket 52272
      IF Nvl(V_CANTIDAD_HABILITADA, 0) > 0 THEN
        IF Nvl(V_CANTIDAD_DISPONIBLE, 0) < 1 THEN
          P_MENSAJE := '('||V_TIPO_DERECHO||') El beneficio para su departamento ya fue totalmente utilizado el dia de hoy

Favor consulte con RR.HH., gracias!';
          RAISE BENEFICIO_LLENO;
        END IF;
      ELSE
        IF Nvl(V_CANTIDAD_DISPONIBLE, 0) < 1 THEN
          P_MENSAJE := '('||V_TIPO_DERECHO||') No disponible el beneficio para su departamento.

Favor consulte con RR.HH., gracias!';
          RAISE BENEFICIO_LLENO;
        END IF;
      END IF;
    END IF;

    IF v_tipo_derecho IN ('ALMUERZO', 'CENA', 'RN') THEN
      p_mensaje := 'COMANDA GENERADA !';

      CGUI$CG_CODE_CONTROLS('SEQ_SALIDA_MENU', v_salida_menu);

      SELECT NVL(MAX(NRO_COMANDA), 0) + 1
	    INTO v_nro_comanda
	    FROM SALIDA_MENU
	    WHERE FECHA_VENTA > TO_DATE('20-11-07 15:00', 'DD-MM-RR hh24:mi');

      --precio_interno,
      SELECT  obtener_precio_menu(id_menu, v_id_sucursal, 'PRECIO_INTERNO'),
              Decode(p_derecho,
                    'ALMUERZO_LIGHT', 249,
                    'RN'            , 270,
                                      51),
              Decode(p_derecho,
                    'ALMUERZO_LIGHT', 'ALMUERZO',
                    'RN', 'REFRIGERIO',
                    'RM', 'REFRIGERIO',
                    'RT', 'REFRIGERIO',
                    p_derecho)
      INTO    v_monto_menu, v_id_menu, v_derecho
      FROM    menu
      WHERE   id_menu = Decode(p_derecho,
                              'ALMUERZO_LIGHT', 249,
                              'RN'            , 270,
                                                51);

      INSERT INTO salida_menu VALUES (
      v_salida_menu, --ID_SALIDA_MENU
      1, --DET_MENU_COMEDOR_ID_COMEDOR
      1, --DET_MENU_ITEM
      v_id_menu, --DET_MENU_MENU_ID_MENU
      SYSDATE, --FECHA_VENTA
      'NO', --PROCESADO
      v_monto_menu, --MONTO_MENU
      NULL, --SRV_ID_SERVICIO
      26, --MESA_ID_MESA
      'COMEDOR PERSONAL', --OBS
      NULL, --DESCUENTO
      10, --D_COM_PERS_OPERADOR
      10, --D_COM_PERS_MESERO
      'CONTADO', --ESTADO_CONTABLE
      'ACTIVO', --ESTADO_SAL_MENU
      1, --CANTIDAD
      v_monto_menu, --MONTO_INTERNO
      NULL, --FACT_COMED_ID_FACTURA_COMEDOR
      'NO', --IMPRESO
      v_nro_comanda, --NRO_COMANDA
      NULL, --FECHA_ENTREGA
      'COMEDOR PERSONAL', --TIPO_COMANDA
      NULL, --SEPARAR
      NULL, --DEP_ID_DEPOSITO
      v_derecho,--TIPO
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL);

      OBTENER_IMPORTE_MESA(
                26,
                1,
                V_EXENTO_NORMAL,
                V_EXENTO_INTERNO,
                V_GRAVADO_NORMAL,
                  V_GRAVADO_INTERNO);

      CGUI$CG_CODE_CONTROLS('SEQ_FACTURA_COMEDOR', p_id_factura_comedor);

      begin
        select p.pac_id_paciente, pp.tip_pac_id_tipo_paciente, p.apellidos||', '||p.nombres, pp.ruc_nuevo
        into v_id_paciente, v_tipo_paciente, v_cliente, v_ruc_nuevo
        from persona_rrhh p, pac pp
        where p.id_persona = p_persona
        AND   p.pac_id_paciente = pp.id_paciente;
      EXCEPTION
        WHEN No_Data_Found THEN
          Raise_Application_Error(-20000, 'No tiene habilitado el servicio, consulte con RRHH');
      END;

      INSERT INTO FACT_COMED VALUES (
      p_id_factura_comedor, --ID_FACTURA_COMEDOR
      OBTENER_PARAMETRO_NRO_USER('CR'), --NRO_FACTURA_COMEDOR
      'ACTIVO', --ESTADO_FACT_COMEDOR
      --'INTERNO', --TIPO_FACTURA
      'DIETA', --TIPO_FACTURA
      v_id_paciente, --PAC_ID_PACIENTE
      v_gravado_interno, --MONTO_GRAVADO
      v_exento_interno, --MONTO_EXENTO
      'NO', --PROCESADO
      'GENERADO AUTOMATICAMENTE', --OBS
      SYSDATE, --FECHA
      NULL, --D_SUC_ID_SECCION
      NULL, --D_SUC_ID_SUCURSAL
      NULL, --D_SUC_ID_DEPARTAMENTO
      1, --COMEDOR_ID_COMEDOR
      26, --MESA_ID_MESA
      1, --MND_ID_MONEDA
      1, --COMPRA
      1, --VENTA
      'NO', --IMPRESO
      'NO', --ASENTADO
      v_nro_comanda, --NRO_COMANDA
      v_cliente, --RAZON_SOCIAL
      v_ruc_nuevo, --RUC
      p_vale, --NRO_VALE
      NULL, --NRO_HABITACION
      v_tipo_paciente,--TIP_PAC_ID_TIPO_PACIENTE
      NULL, --COMENSAL
      v_tipo_derecho, --EMPRESA_RESP
      NULL, --FUERA_HORARIO
      NULL, --LIMITE_CREDITO
      NULL, --RES_CIRUG_ID_RESERVA
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL);


      ACTUALIZAR_PARAM_NRO_INC_USER ('CR');
      COMMIT;

    ELSIF p_derecho IN ('RM', 'RT')  AND p_tipo_refrigerio = 'PROCESAR' THEN

      p_mensaje := 'COMANDA GENERADA !';

      SELECT NVL(MAX(NRO_COMANDA), 0) + 1
	    INTO v_nro_comanda
	    FROM SALIDA_MENU
	    WHERE FECHA_VENTA > TO_DATE('20-11-07 15:00', 'DD-MM-RR hh24:mi');

      DECLARE
        CURSOR ITEM_MENU IS
        SELECT ID_MENU, Decode(ID_MENU,
                               1, 1, --Para las empanadas, 2 en cantidad
                                     --desde el 12-09-12 modidicado, tiene que ser 1 pxq es empanada al horno (antes era chico y frita y ahora es al grande y al horno)
                                  1)
        FROM TMP_MENU_PERSONAL
        ORDER BY 1;
      BEGIN
        OPEN ITEM_MENU;
        FETCH ITEM_MENU INTO V_ID_MENU_PARCIAL, V_CANT_PARCIAL;
        IF ITEM_MENU%NOTFOUND THEN
          --Raise_Application_Error(-20000, 'Nada que CONFIRMAR');
          P_MENSAJE := 'Nada que Confirmar';
          RAISE BENEFICIO_LLENO;
        END IF;
        WHILE ITEM_MENU%FOUND
        LOOP
          --precio_interno
          SELECT obtener_precio_menu(id_menu, v_id_sucursal, 'PRECIO_INTERNO')
          INTO   v_monto_menu
          FROM   menu
          WHERE  id_menu = v_id_menu_parcial;

          CGUI$CG_CODE_CONTROLS('SEQ_SALIDA_MENU', v_salida_menu);

          INSERT INTO salida_menu VALUES (
              v_salida_menu, --ID_SALIDA_MENU
              1, --DET_MENU_COMEDOR_ID_COMEDOR
              1, --DET_MENU_ITEM
              V_ID_MENU_PARCIAL, --DET_MENU_MENU_ID_MENU
              SYSDATE, --FECHA_VENTA
              'NO', --PROCESADO
              v_monto_menu, --MONTO_MENU
              NULL, --SRV_ID_SERVICIO
              26, --MESA_ID_MESA
              'COMEDOR PERSONAL', --OBS
              NULL, --DESCUENTO
              10, --D_COM_PERS_OPERADOR
              10, --D_COM_PERS_MESERO
              'CONTADO', --ESTADO_CONTABLE
              'ACTIVO', --ESTADO_SAL_MENU
              V_CANT_PARCIAL, --CANTIDAD
              v_monto_menu, --MONTO_INTERNO
              NULL, --FACT_COMED_ID_FACTURA_COMEDOR
              'NO', --IMPRESO
              v_nro_comanda, --NRO_COMANDA
              NULL, --FECHA_ENTREGA
              'COMEDOR PERSONAL', --TIPO_COMANDA
              NULL, --SEPARAR
              NULL, --DEP_ID_DEPOSITO
              v_tipo_derecho,--TIPO
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL);
          FETCH ITEM_MENU INTO V_ID_MENU_PARCIAL, V_CANT_PARCIAL;
        END LOOP;
        CLOSE ITEM_MENU;
      END;

      OBTENER_IMPORTE_MESA(
                26,
                1,
                V_EXENTO_NORMAL,
                V_EXENTO_INTERNO,
                V_GRAVADO_NORMAL,
                V_GRAVADO_INTERNO);

      CGUI$CG_CODE_CONTROLS('SEQ_FACTURA_COMEDOR', p_id_factura_comedor);

      begin
        select p.pac_id_paciente, pp.tip_pac_id_tipo_paciente, p.apellidos||', '||p.nombres, pp.ruc_nuevo
        into v_id_paciente, v_tipo_paciente, v_cliente, v_ruc_nuevo
        from persona_rrhh p, pac pp
        where p.id_persona = p_persona
        AND   p.pac_id_paciente = pp.id_paciente;
      EXCEPTION
        WHEN No_Data_Found THEN
          Raise_Application_Error(-20000, 'No tiene habilitado el servicio, consulte con RRHH');
      END;

      INSERT INTO FACT_COMED VALUES (
      p_id_factura_comedor, --ID_FACTURA_COMEDOR
      OBTENER_PARAMETRO_NRO_USER('CR'), --NRO_FACTURA_COMEDOR
      'ACTIVO', --ESTADO_FACT_COMEDOR
      --'INTERNO', --TIPO_FACTURA
      'DIETA', --TIPO_FACTURA
      v_id_paciente, --PAC_ID_PACIENTE
      v_gravado_interno, --MONTO_GRAVADO
      v_exento_interno, --MONTO_EXENTO
      'NO', --PROCESADO
      'GENERADO AUTOMATICAMENTE', --OBS
      SYSDATE, --FECHA
      NULL, --D_SUC_ID_SECCION
      NULL, --D_SUC_ID_SUCURSAL
      NULL, --D_SUC_ID_DEPARTAMENTO
      1, --COMEDOR_ID_COMEDOR
      26, --MESA_ID_MESA
      1, --MND_ID_MONEDA
      1, --COMPRA
      1, --VENTA
      'NO', --IMPRESO
      'NO', --ASENTADO
      v_nro_comanda, --NRO_COMANDA
      v_cliente, --RAZON_SOCIAL
      v_ruc_nuevo, --RUC
      p_vale, --NRO_VALE
      NULL, --NRO_HABITACION
      v_tipo_paciente,--TIP_PAC_ID_TIPO_PACIENTE
      NULL, --COMENSAL
      v_tipo_derecho, --EMPRESA_RESP
      NULL, --FUERA_HORARIO
      NULL, --LIMITE_CREDITO
      NULL,--RES_CIRUG_ID_RESERVA
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL);


      ACTUALIZAR_PARAM_NRO_INC_USER ('CR');
--      COMMIT;
    ELSIF V_TIPO_DERECHO IN ('CANTINA') AND P_TIPO_REFRIGERIO = 'PROCESAR' THEN

      P_MENSAJE := 'COMANDA GENERADA !';

      SELECT NVL(MAX(NRO_COMANDA), 0) + 1
	    INTO   V_NRO_COMANDA
	    FROM   SALIDA_MENU
	    WHERE  FECHA_VENTA > TO_DATE('20-11-07 15:00', 'DD-MM-RR HH24:MI');

      DECLARE
        CURSOR ITEM_MENU IS
        SELECT   ID_MENU,
                 1                --cantidad
        FROM     TMP_MENU_CREDITO
        ORDER BY 1;
      BEGIN
        OPEN ITEM_MENU;
        FETCH ITEM_MENU INTO V_ID_MENU_PARCIAL, V_CANT_PARCIAL;
        IF ITEM_MENU%NOTFOUND THEN
          --Raise_Application_Error(-20000, 'Nada que CONFIRMAR');
          P_MENSAJE := 'Nada que CONFIRMAR';
          RAISE BENEFICIO_LLENO;
        END IF;
        WHILE ITEM_MENU%FOUND
        LOOP
          --PRECIO_INTERNO
          SELECT OBTENER_PRECIO_MENU(ID_MENU, V_ID_SUCURSAL, 'PRECIO_INTERNO')
          INTO   V_MONTO_MENU
          FROM   MENU
          WHERE  ID_MENU = V_ID_MENU_PARCIAL;

/*          IF V_ID_MENU_PARCIAL IN(445) AND V_ID_SUCURSAL = 4 THEN --PEDIDO DEL SR. SILVIO TICKET 22529
            --PRECIO_INTERNO
            SELECT OBTENER_PRECIO_MENU(ID_MENU, V_ID_SUCURSAL, 'PRECIO_INTERNO')
            INTO   V_MONTO_MENU
            FROM   MENU
            WHERE  ID_MENU = 72; ---SIEMPRE DEBE ESTIRAR EL MENU NORMAL YA NO HAY LIGTH
          END IF;

          IF V_ID_MENU_PARCIAL = 72 THEN
            V_ITEM := 2;
          ELSE
            V_ITEM := 1;
          END IF;
*/
          DECLARE
            DUMMY CHAR(1);
          BEGIN
            SELECT '1'
            INTO   DUMMY
            FROM   DET_MENU
            WHERE  ITEM = V_ITEM
            AND    MENU_ID_MENU = V_ID_MENU_PARCIAL
            AND    COMEDOR_ID_COMEDOR = V_ID_COMEDOR; --2;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              IF V_ITEM = 1 THEN
                V_ITEM := 2;
              ELSE
                V_ITEM := 1;
              END IF;
          END;


          CGUI$CG_CODE_CONTROLS('SEQ_SALIDA_MENU', V_SALIDA_MENU);

          INSERT INTO SALIDA_MENU VALUES (
              V_SALIDA_MENU,          --ID_SALIDA_MENU
              1,           --2, --DET_MENU_COMEDOR_ID_COMEDOR
              1,                 --DET_MENU_ITEM
              V_ID_MENU_PARCIAL,      --DET_MENU_MENU_ID_MENU
              SYSDATE,                --FECHA_VENTA
              'NO',                   --PROCESADO
              V_MONTO_MENU,           --MONTO_MENU
              NULL,                   --SRV_ID_SERVICIO
              26,              --27,--MESA_ID_MESA
              'COMEDOR PERSONAL',     --OBS
              NULL,                   --DESCUENTO
              10,          --47, --D_COM_PERS_OPERADOR
              10,            --47, --D_COM_PERS_MESERO
              'CONTADO',              --ESTADO_CONTABLE
              'ACTIVO',               --ESTADO_SAL_MENU
              V_CANT_PARCIAL,         --CANTIDAD
              V_MONTO_MENU,           --MONTO_INTERNO
              NULL,                   --FACT_COMED_ID_FACTURA_COMEDOR
              'NO',                   --IMPRESO
              V_NRO_COMANDA,          --NRO_COMANDA
              NULL,                   --FECHA_ENTREGA
              'COMEDOR PERSONAL',     --TIPO_COMANDA
              NULL,                   --SEPARAR
              NULL,                   --DEP_ID_DEPOSITO
              V_TIPO_DERECHO,         --TIPO
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL);
          FETCH ITEM_MENU INTO V_ID_MENU_PARCIAL, V_CANT_PARCIAL;
        END LOOP;
        CLOSE ITEM_MENU;
      END;

      OBTENER_IMPORTE_MESA(v_id_mesa,       --27,
                           v_id_comedor,    --2,
                           V_EXENTO_NORMAL,
                           V_EXENTO_INTERNO,
                           V_GRAVADO_NORMAL,
                           V_GRAVADO_INTERNO);

      CGUI$CG_CODE_CONTROLS('SEQ_FACTURA_COMEDOR', p_id_factura_comedor);

      /*
      begin
        select pp.id_paciente, pp.tip_pac_id_tipo_paciente, p.apellidos||', '||p.nombres, pp.ruc_nuevo
        into v_id_paciente, v_tipo_paciente, v_cliente, v_ruc_nuevo
        from persona_rrhh p, pac pp
        where p.id_persona = p_persona
        AND   p.pac_id_paciente = pp.id_paciente;
      EXCEPTION
        WHEN No_Data_Found THEN
          Raise_Application_Error(-20000, 'No tiene habilitado el servicio, consulte con RRHH');
      END;
      */
      BEGIN
        SELECT PP.ID_PACIENTE,
               PP.TIP_PAC_ID_TIPO_PACIENTE,
               P.PERSONA,
               PP.RUC_NUEVO
        INTO   V_ID_PACIENTE,
               V_TIPO_PACIENTE,
               V_CLIENTE,
               V_RUC_NUEVO
	      FROM   V_PERSONA_RRHH_SSRLC_CMLC P, PAC PP
	      WHERE  P.ID_PERSONA = P_PERSONA
        AND    P.ESTADO = 'ACTIVO'
        AND    P.EMPRESA = P_EMPRESA
        AND    P.CODIGO_COMEDOR = PP.ID_PACIENTE;
      EXCEPTION
        WHEN No_Data_Found THEN
          Raise_Application_Error(-20000, 'No tiene habilitado el servicio, consulte con RRHH de '||P_EMPRESA);
      END;

      IF v_tipo_derecho IS NULL THEN
        Raise_Application_Error(-20000, 'Consulte con Informática');
      END IF;

      V_SALDO_INICIAL := DEV_MONTO_CONSUMO_CR_PER(SYSDATE, v_id_paciente, 'SALDO');
      V_LIMITE        := DEV_MONTO_CONSUMO_CR_PER(SYSDATE, v_id_paciente, 'LIMITE');

      IF V_LIMITE <= 0 THEN
        ROLLBACK;

        P_MENSAJE := 'No tiene asignado límite de crédito. Consulte con RR.HH.';
        RAISE SIN_LIMITE;
      END IF;

      INSERT INTO FACT_COMED VALUES (
      p_id_factura_comedor,                   --ID_FACTURA_COMEDOR
      OBTENER_PARAMETRO_NRO_USER('CR'),       --NRO_FACTURA_COMEDOR
      'ACTIVO',                               --ESTADO_FACT_COMEDOR
      --'INTERNO',                            --TIPO_FACTURA
      'INTERNO',                              --TIPO_FACTURA
      v_id_paciente,                          --PAC_ID_PACIENTE
      v_gravado_interno,                      --MONTO_GRAVADO
      v_exento_interno,                       --MONTO_EXENTO
      'NO',                                   --PROCESADO
      'GENERADO AUTOMATICAMENTE - CREDITO',   --OBS
      SYSDATE,                                --FECHA
      NULL,                                   --D_SUC_ID_SECCION
      NULL,                                   --D_SUC_ID_SUCURSAL
      NULL,                                   --D_SUC_ID_DEPARTAMENTO
      1,                                      --, 1, --COMEDOR_ID_COMEDOR
      26,                                     --27, --MESA_ID_MESA
      1,                                      --MND_ID_MONEDA
      1,                                      --COMPRA
      1,                                      --VENTA
      'NO',                                   --IMPRESO
      'NO',                                   --ASENTADO
      v_nro_comanda,                          --NRO_COMANDA
      v_cliente,                              --RAZON_SOCIAL
      v_ruc_nuevo,                            --RUC
      p_vale,                                 --NRO_VALE
      NULL,                                   --NRO_HABITACION
      v_tipo_paciente,                        --TIP_PAC_ID_TIPO_PACIENTE
      NULL,                                   --COMENSAL
      v_tipo_derecho,                         --EMPRESA_RESP
      NULL,                                   --FUERA_HORARIO
      NULL,                                   --LIMITE_CREDITO
      NULL,                                   --RES_CIRUG_ID_RESERVA
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL);

      V_LIMITE := DEV_MONTO_CONSUMO_CR_PER(SYSDATE, v_id_paciente, 'LIMITE');
      V_SALDO  := DEV_MONTO_CONSUMO_CR_PER(SYSDATE, v_id_paciente, 'SALDO');

      IF V_SALDO > V_LIMITE THEN
        ROLLBACK;

        P_MENSAJE := 'Con ésta compra excede su límite de crédito. Límite:'||v_limite||'. Saldo:'||V_SALDO_INICIAL||'. Esta compra es:'||(V_SALDO - V_SALDO_INICIAL);
        RAISE SIN_LIMITE;
      END IF;

      ACTUALIZAR_PARAM_NRO_INC_USER ('CR');
      --COMMIT;
    END IF;
  END;
    --ELSE
    -- Raise_Application_Error(-20000, 'PRUEBA DE SISTEMAS');
  --END IF;
   COMMIT;


EXCEPTION
  WHEN VALE_UTILIZADO  THEN NULL;
  WHEN BENEFICIO_LLENO THEN NULL;
  WHEN SIN_BENEFICIO THEN NULL;
  WHEN HORA_NO_CORRESPONDE THEN NULL;

END;
/

