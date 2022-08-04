PROMPT CREATE OR REPLACE TRIGGER anamnesis.t_persona_rrhh_iud_a
CREATE OR REPLACE TRIGGER anamnesis.t_persona_rrhh_iud_a AFTER INSERT OR DELETE OR UPDATE ON anamnesis.persona_rrhh REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
V_VALOR          VARCHAR2(100);
DUMMY            CHAR(1);
V_MENSAJE        VARCHAR2(20000);
V_IMPORTE_NORMAL CARGO.IMPORTE_NORMAL%TYPE;
V_IMPORTE_FRANQUERA CARGO.IMPORTE_FRANQUERA%TYPE;
V_ID_CONCEPTO CONCEPTO_SALARIO.ID_CONCEPTO_SALARIO%TYPE;
V_ID_MOV_FIJO MOV_FIJO_SALARIO.ID_MOV_FIJO_SALARIO%TYPE;
V_ID_PRESTADOR    PRESTADOR.ID_PRESTADOR%TYPE;
V_ID_PRESTADOR_FP PRESTADOR.ID_PRESTADOR%TYPE;
V_MENSAJE_SALDO  VARCHAR2(4000);
V_MENSAJE_DESVIN VARCHAR2(4000);
V_CARGO          VARCHAR2(100);
V_ID_PERSONA     NUMBER(30);
V_CORREO         VARCHAR2(4000);
V_ASUNTO         VARCHAR2(2000);
V_PARA           VARCHAR2(2000);
V_EMPRESA        VARCHAR2(50);
V_MENSAJE_ACTIVACION VARCHAR2(2000);
V_MENSAJE_INGRESO_IPS  VARCHAR2(2000);
V_MENSAJE_MEDICO       VARCHAR2(2000);
V_USUARIO  VARCHAR2(20);
V_SQL  VARCHAR2(100);

BEGIN

IF obtener_suc_usuario(USER) = 4 THEN
    V_EMPRESA := 'SSRSJ';  --SJ
ELSE
    V_EMPRESA := 'SSRLC';  --LC
END IF;


IF UPDATING THEN
   IF IF_UPDATE(:NEW.CI, :OLD.CI) THEN
       BEGIN
          SELECT '1'
          INTO    DUMMY
          FROM    PERSONA
          WHERE   CI = :OLD.CI;

          UPDATE PERSONA
          SET    CI = :NEW.CI
          WHERE  CI = :OLD.CI;
       EXCEPTION
          WHEN No_Data_Found THEN
               NULL;
          WHEN Too_Many_Rows THEN
               NULL;
       END;
   END IF;

   IF IF_UPDATE(:NEW.PROV_ID_PROVEEDOR, :OLD.PROV_ID_PROVEEDOR) THEN
      BEGIN
          SELECT '1'
          INTO   DUMMY
          FROM   PLANILLA_PAGO_MEDICO_ELECTRO
          WHERE  PROV_ID_PROVEEDOR = :OLD.PROV_ID_PROVEEDOR
          AND    PERIODO = (SELECT Max(PERIODO)
                            FROM   PLANILLA_PAGO_MEDICO_ELECTRO
                           );
          Raise_Application_Error(-20000, 'No se puede mofificar la realación, ya existe planilla generada');
      EXCEPTION
          WHEN No_Data_Found THEN
               NULL;
      END;
   END IF;

END IF;
 IF INSERTING OR UPDATING THEN
    NULL;
 END IF;

 IF INSERTING THEN

    V_MENSAJE := 'Se ha creado el personal '||:NEW.NOMBRES||' '||:NEW.APELLIDOS||' con cédula de identidad '||:NEW.CI||' con fecha de ingreso '||To_Char(:NEW.FECHA_INGRESO, 'DD-MM-RR')||' que corresponde a La Costa '||chr(10);
    IF V_MENSAJE IS NOT NULL THEN
        ENVIAR_MAIL('anamnesis@lacosta.com.py',
                    'lucia.doria@sanroque.com.py',
                    null,
                    'Personal creado en La Costa',
                    V_MENSAJE,
                    '192.168.3.5');
    END IF;

 END IF;

 IF UPDATING THEN
    NULL;
 END IF;

  IF INSERTING THEN
   -------
     BEGIN
       SELECT'1'
       INTO  DUMMY
       FROM  PERSONA
       WHERE (USUARIO      = :NEW.USUARIO
       OR     CI        = :NEW.CI
       OR    (NOMBRES   = :NEW.NOMBRES AND APELLIDOS = :NEW.APELLIDOS)
             );
     EXCEPTION
       WHEN No_Data_Found THEN
           V_CARGO := NULL;

            CGUI$CG_CODE_CONTROLS('SEQ_PERSONA', V_ID_PERSONA);
            INSERT INTO PERSONA VALUES (V_ID_PERSONA,
                                       :NEW.NOMBRES,    --NOMBRES
                                       :NEW.APELLIDOS,  --APELLIDOS
                                       :NEW.CI,         --CI
                                       :NEW.USUARIO,    --USUARIO
                                       V_CARGO,         --CARGO
                                       NULL,            --CORREO
                                       NULL,            --CELULAR
                                       NULL,            --ENFERMERIA_ID_ENFERMERIA
                                       NULL,            --PAC_ID_PACIENTE
                                       NULL,            --PIN
                                       'ACTIVO',        --ESTADO
                                       NULL,            --EST_CIV_ID_ESTADO_CIVIL
                                       NULL,            --CARGO_ID_CARGO
                                       NULL,            --BARRIO_ID_BARRIO
                                       NULL,            --PAIS_ID_PAIS
                                       NULL,            --CIU_ID_CIUDAD
                                       NULL,            --DIRECCION_PARTICULAR
                                       NULL,            --FECHA_NACIMIENTO
                                       NULL,            --TEL
                                       NULL,            --RUC
                                       NULL,            --SEXO
                                       NULL,            --CAT_PER_ID_CATEGORIA_PERSONA
                                       NULL,            --NRO_CTA_CTE
                                       NULL,            --SALARIO_BASICO
                                       NULL,            --FECHA_INGRESO
                                       NULL,            --FECHA_EGRESO
                                       NULL,            --NRO_ASEGURADO_IPS
                                       NULL,            --ID_PERSONA_ANTERIOR
                                       NULL,            --CAT_SAL_ID_CATEGORIA
                                       NULL,            --LEGAJO
                                       NULL,            --GRUPO_SANGUINEO
                                       NULL,            --PROF_ID_PROFESION
                                       NULL,            --GIN_ID_GRADO
                                       NULL,            --FECHA_PREAVISO
                                       NULL,            --LOCALIDAD
                                       NULL,            --D_SUC_DEP_DEPARTAMEN_ID_SECCIO
                                       NULL,            --D_SUC_DEP_SUCURSAL_ID_SUCURSAL
                                       NULL,            --D_SUC_DEP_DEPARTAMEN_ID_DEPART
                                       NULL,            --MARCA
                                       NULL,            --AGUINALDO
                                       NULL,            --VACACIONES
                                       NULL,            --HORAS_EXTRAS
                                       NULL,            --CONS_NRO_ID_CONSULTORIO
                                       NULL,            --PEN_TIPO_CR
                                       NULL,            --PEN_PUNTO_CR
                                       NULL,            --PEN_NUMERO_CR
                                       NULL,            --PEN_TIPO_FC
                                       NULL,            --PEN_PUNTO_FC
                                       NULL,            --PEN_NUMERO_FC
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       null
                                       );
     END;
  END IF;
   --------

   IF UPDATING THEN
      IF IF_UPDATE(:NEW.ESTADO,:OLD.ESTADO) AND  NVL(:NEW.ESTADO,'X') = 'INACTIVO' AND Nvl(:NEW.MEO_ID_MOTIVO, 0) != 6 THEN

         UPDATE  persona
         SET estado = 'INACTIVO'
         WHERE CI = :NEW.CI;

         UPDATE  PRESTADOR
         SET     ESTADO_PRESTADOR = 'INACTIVO'
         WHERE   PREST_ID_PRESTADOR = :NEW.PREST_ID_PRESTADOR;


      END IF;
      IF IF_UPDATE(:NEW.ESTADO,:OLD.ESTADO) AND  NVL(:NEW.ESTADO,'X') = 'ACTIVO' AND Nvl(:NEW.MEO_ID_MOTIVO, 0) != 6 THEN
         V_MENSAJE_ACTIVACION := 'Personal '||:NEW.ID_PERSONA||' '||:NEW.NOMBRES||' '||:NEW.APELLIDOS||' ha sido activado en '||OBTENER_DESC_SUC_USUARIO(USER)||' por el usuario '||USER||chr(10)||' favor verificar.';
            IF OBTENER_SUC_USUARIO(USER) = 2 THEN
              ENVIAR_MAIL('lacosta@lacosta.com.py',
                                'gustavo.britos@lacosta.com.py',
                                'laura.galeano@lacosta.com.py,rrhh.lc@lacosta.com.py',
                                'Reingreso de Personal en Sucursal',
                                V_MENSAJE_ACTIVACION,
                                '192.168.3.5');
            ELSE
              ENVIAR_MAIL('lacosta@lacosta.com.py',
                                'christian.wolscham@santajulia.com.py',
                                 NULL,--'auxiliar.rrhh@santajulia.com.py',
                                'Reingreso de Personal en Sucursal',
                                V_MENSAJE_ACTIVACION,
                                '192.168.3.5');
            END IF;


      END IF;
      IF IF_UPDATE(:NEW.ESTADO,:OLD.ESTADO) AND  NVL(:NEW.ESTADO,'X') = 'INACTIVO' AND Nvl(:NEW.MEO_ID_MOTIVO, 0) != 6 THEN
        V_MENSAJE_ACTIVACION := 'Personal '||:NEW.ID_PERSONA||' '||:NEW.NOMBRES||' '||:NEW.APELLIDOS||' ha sido Inactivado en '||OBTENER_DESC_SUC_USUARIO(USER)||' por el usuario '||USER||chr(10)||' favor verificar.';
            IF OBTENER_SUC_USUARIO(USER) = 2 THEN
              ENVIAR_MAIL('lacosta@lacosta.com.py',
                                'gustavo.britos@lacosta.com.py',
                                'laura.galeano@lacosta.com.py,rrhh.lc@lacosta.com.py',
                                'Reingreso de Personal en Sucursal',
                                V_MENSAJE_ACTIVACION,
                                '192.168.3.5');
            ELSE
              ENVIAR_MAIL('lacosta@lacosta.com.py',
                                'christian.wolscham@santajulia.com.py',
                                NULL,--'auxiliar.rrhh@santajulia.com.py',
                                'Reingreso de Personal en Sucursal',
                                V_MENSAJE_ACTIVACION,
                                '192.168.3.5');
            END IF;




      END IF;

      IF IF_UPDATE(:NEW.FECHA_INGRESO_IPS,:OLD.FECHA_INGRESO_IPS) AND  :NEW.FECHA_INGRESO_IPS IS NOT NULL THEN
         V_MENSAJE_INGRESO_IPS := 'Personal '||:NEW.ID_PERSONA||' '||:NEW.NOMBRES||' '||:NEW.APELLIDOS||' Ingresado en IPS en '||OBTENER_DESC_SUC_USUARIO(USER)||' por el usuario '||USER||chr(10)||' favor verificar.';
             ENVIAR_MAIL('lacosta@lacosta.com.py',
                                'gustavo.britos@lacosta.com.py',
                                'rrhh.lc@lacosta.com.py',
                                'Ingreso de Personal en IPS',
                                V_MENSAJE_INGRESO_IPS,
                                '192.168.3.5');



      END IF;



     IF :NEW.MEO_ID_MOTIVO != 6 THEN
        IF IF_UPDATE(:NEW.ESTADO,:OLD.ESTADO) AND  NVL(:NEW.ESTADO,'X') = 'INACTIVO' AND :NEW.FECHA_INGRESO_IPS IS NOT null THEN

             -------------------------------------------- separado por sucursal a pedido del Lic. Silvio ticket 13164 carlos
             V_CORREO:= 'vanessa.alegre@asismed.com.py,gestion.cobranzas@sanroque.com.py,boutique@lacosta.com.py,ana.monzon@asismed.com.py,gestioncobro@lacosta.com.py,analia.fretes@asismed.com.py,cinthia.paredes@asismed.com.py,lorena.cardozo@asismed.com.py,auxiliar2.cmlc@lacosta.com.py, seguridad@lacosta.com.py, mabel.benitez@lacosta.com.py,sanatorio.gciaadm@lacosta.com.py,sanatorio.gciaadm@sanroque.com.py,tesoreria.cmlc@lacosta.com.py';
             V_PARA:= 'rrhh.lc@lacosta.com.py';
          IF VERIFICA_PER_SUC_SJ (:NEW.ID_PERSONA) = 'SI' THEN
             ---CAMBIADOS LOS DESTINATARIOS A PEDIDO DE CRISTHIAN WOLSCHAM TICKET Nº 18104 - PABLO
             V_PARA:= 'jefatura.rrhh@santajulia.com.py';
             V_CORREO:= 'auxiliar.rrhh@santajulia.com.py, vanessa.alegre@asismed.com.py, gestion.cobranzas@sanroque.com.py, boutique@lacosta.com.py, ana.monzon@asismed.com.py, gestioncobro@lacosta.com.py, analia.fretes@asismed.com.py, cinthia.paredes@asismed.com.py, lorena.cardozo@asismed.com.py, control.interno@lacosta.com.py, mabel.benitez@lacosta.com.py, gerencia.general@santajulia.com.py, cobranzas@santajulia.com.py, silvio.aguilar@santajulia.com.py,auxiliar2.cmlc@lacosta.com.py,teresa.benitez@lacosta.com.py,jazmin.lopez@husl.com.py,leticia.zalazar@husl.com.py';
             V_ASUNTO := 'Desvinculacion Personal SANATORIO LA COSTA - Suc. Santa Julia';
          ELSIF obtener_suc_per_rrhh(:NEW.ID_PERSONA) = 2 THEN
             V_ASUNTO := 'Desvinculacion Personal SANATORIO LA COSTA';
          ELSIF obtener_suc_per_rrhh(:NEW.ID_PERSONA) = 5 THEN
             V_ASUNTO := 'Desvinculacion Personal SANATORIO LA COSTA - Suc. San Lorenzo';
          END IF;

                V_MENSAJE_SALDO := 'Informamos la desvinculación de '||:NEW.NOMBRES||' '||:NEW.APELLIDOS ||' C.I. No :'||:NEW.CI||'
    Favor inactivar cuenta y enviar saldo si hubiere.- '||chr(10)
    ||'FAVOR CONTESTAR A LA BREVEDAD POSIBLE, YA QUE DE ESTO DEPENDE EL CIERRE DE LAS LIQUIDACIONES'||CHR(10);
                IF V_MENSAJE_SALDO IS NOT NULL THEN

                    ENVIAR_MAIL('lacosta@lacosta.com.py',
                                V_PARA,
                                V_CORREO,
                                V_ASUNTO,
                                V_MENSAJE_SALDO,
                                '192.168.3.5');
                END IF;


        END IF;

        IF IF_UPDATE(:NEW.ESTADO,:OLD.ESTADO) AND  NVL(:NEW.ESTADO,'X') = 'INACTIVO' AND OBT_DATO_PER_RRHH_SUC(:NEW.ID_PERSONA,OBTENER_SUC_USUARIO(USER),'CARGO_ID_CARGO',NULL,NULL,NULL,NULL) = 54 AND OBTENER_SUC_USUARIO(USER) = 2 THEN  --PARA MEDICOS DE GUARDIA
                V_MENSAJE_MEDICO := 'Nombre y Apellido:'||:NEW.NOMBRES||' '||:NEW.APELLIDOS||Chr(10)||
                       'Cedula:'||:NEW.CI||Chr(10)||
                       'Codigo Prestador:'||:NEW.PREST_ID_PRESTADOR;

                 ENVIAR_MAIL('lacosta@lacosta.com.py',
                                'graciela.alegre@lacosta.com.py',
                                'gustavo.britos@lacosta.com.py',
                                'Inactivacion de Medico de Guardia',
                                V_MENSAJE_MEDICO,
                                '192.168.3.5');
        END IF;



     END IF;

     IF  :NEW.estado != :OLD.estado then
         IF nvl(:NEW.ESTADO, 'ACTIVO') = 'ACTIVO'  AND Nvl(OBT_DATO_PER_RRHH_SUC(:NEW.ID_PERSONA, OBTENER_SUC_USUARIO(USER), 'DRUGSTORE', NULL, NULL, NULL, NULL), 'XXX') = 'SI' AND :NEW.MEO_ID_MOTIVO != 6 THEN --AND :NEW.FECHA_INGRESO_IPS IS NOT NULL THEN
         anamnesis.actualiza_credito_drugstore(
           :NEW.CI,
           :NEW.ESTADO,
           :NEW.NOMBRES,
           :NEW.APELLIDOS,
           CASE WHEN :NEW.PREFIJO_CEL IS NOT NULL AND :NEW.CELULAR IS NOT NULL AND LENGTH(0||''||:NEW.PREFIJO_CEL||''||:NEW.CELULAR) = 10 THEN
              0||''||:NEW.PREFIJO_CEL||''||:NEW.CELULAR
           ELSE
              NULL
           END,
           :NEW.TEL,
           :NEW.DIRECCION_PARTICULAR,
           :NEW.CORREO,
           NULL,
           V_EMPRESA);
         ELSIF NVL(:NEW.ESTADO,'ACTIVO') = 'INACTIVO' THEN
            IF :NEW.MEO_ID_MOTIVO != 6 THEN  ---- SE AGREGO POR EL CASO TICKET NRO 15024 NO DEBE ENVIAR CORREO CUANDO EL DESPIDO ES POR PROFORMA
                anamnesis.actualiza_credito_drugstore(
                :NEW.CI,
                :NEW.ESTADO,
                :NEW.NOMBRES,
                :NEW.APELLIDOS,
                CASE WHEN :NEW.PREFIJO_CEL IS NOT NULL AND :NEW.CELULAR IS NOT NULL AND LENGTH(0||''||:NEW.PREFIJO_CEL||''||:NEW.CELULAR) = 10 THEN
                  0||''||:NEW.PREFIJO_CEL||''||:NEW.CELULAR
                ELSE
                  NULL
                END,
                :NEW.TEL,
                :NEW.DIRECCION_PARTICULAR,
                :NEW.CORREO,
                NULL,
                V_EMPRESA);
            END IF;
          /*BEGIN
            SELECT USUARIO
            INTO   V_USUARIO
            FROM   PERSONA
            WHERE  CI =:NEW.CI;

            V_SQL := 'ALTER USER '||V_USUARIO||' ACCOUNT LOCK';
            EXECUTE IMMEDIATE (V_SQL);
          EXCEPTION
             WHEN No_Data_Found THEN
              NULL;
          END;*/
        END IF;
     END IF;
   END IF;
--------------------------------------------------------------------------------
  IF INSERTING THEN
   /* DECLARE
     V_ID_SUCURSAL NUMBER(2) ;
     V_ID_CNT_FIR  NUMBER(10);
     BEGIN
     V_ID_SUCURSAL := OBTENER_SUC_USUARIO(USER);
        SELECT '1'
        INTO   DUMMY
        FROM   CONTRATO_FIRMA_PER
        WHERE  PER_ID_PERSONA = :NEW.ID_PERSONA
        AND    SUCURSAL_ID_SUCURSAL = V_ID_SUCURSAL ;
     EXCEPTION
        WHEN No_Data_Found THEN
           CGUI$CG_CODE_CONTROLS('SEQ_CNT_FIRMA', V_ID_CNT_FIR);
           INSERT INTO CONTRATO_FIRMA_PER VALUES(V_ID_CNT_FIR,       --ID_CNT_FIR
                                                 'NO',               --CONTRATO_FIRMADO
                                                 NULL,               --FECHA_FIRMA
                                                 :NEW.ID_PERSONA,    --PER_ID_PERSONA
                                                 V_ID_SUCURSAL       --SUCURSAL_ID_SUCURSAL
                                                        );
     END;
          */
          NULL;
  END IF;

  IF INSERTING THEN
    IF :new.ci = 3519520 THEN
      enviar_mail('lacosta@lacosta.com.py',
                          'amir.perez@asismed.com.py',
                          null,
                          'SAN LC/SJ Ingresando CI 3.519.520',
                          'SAN LC/SJ Ingresando CI 3.519.520',
                          '192.168.3.5');
      Raise_Application_Error(-20000, 'No puede ingresar a un personal con éste número de C.I.');
    END IF;
  END IF;

  IF UPDATING THEN
    IF :new.ci = 3519520 OR :old.ci = 3519520 THEN
      enviar_mail('lacosta@lacosta.com.py',
                          'amir.perez@asismed.com.py',
                          null,
                          'SAN LC/SJ Actualizando CI 3.519.520',
                          'SAN LC/SJ Actualizando CI 3.519.520',
                          '192.168.3.5');
      Raise_Application_Error(-20000, 'No puede ingresar a un personal con éste número de C.I.');
    END IF;
  END IF;
END;
/

