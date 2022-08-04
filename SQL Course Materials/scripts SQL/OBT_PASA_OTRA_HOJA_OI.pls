PROMPT CREATE OR REPLACE FUNCTION anamnesis.obt_pasa_otra_hoja_oi
CREATE OR REPLACE FUNCTION anamnesis.obt_pasa_otra_hoja_oi(P_ID_ORDEN NUMBER, P_TIPO_HOJA VARCHAR2)
RETURN VARCHAR2 IS
V_VALOR CHAR(2);
V_CANT_CARACTER NUMBER(20);
BEGIN

    IF P_TIPO_HOJA = 'A4' THEN
       V_CANT_CARACTER := 225;  --corresponde a la cantidad de caracteres que caben en el cuadro de A4 de los items de tratamineto o dieta_nutricional o estudios_solicitados o interconsulta o medicacion
    ELSE
       V_CANT_CARACTER := 130;  --corresponde a la cantidad de caracteres que caben en el cuadro de A5 de los items de tratamineto o dieta_nutricional o estudios_solicitados o interconsulta o medicacion
    END IF;

    SELECT CASE WHEN (LENGTH(REPLACE(S.TRATAMIENTO,'
',RPad(' ', V_CANT_CARACTER,' '))) >= V_CANT_CARACTER OR
                                       LENGTH(REPLACE(S.DIETA_NUTRICIONAL,'
',RPad(' ', V_CANT_CARACTER,' '))) >= V_CANT_CARACTER OR
                                      LENGTH(REPLACE(S.ESTUDIOS_SOLICITADOS,'
',RPad(' ', V_CANT_CARACTER,' '))) >= V_CANT_CARACTER OR
                                      LENGTH(REPLACE(S.INTERCONSULTA,'
',RPad(' ', V_CANT_CARACTER,' '))) >= V_CANT_CARACTER OR
                                      LENGTH(REPLACE(S.MEDICACION,'
',RPad(' ', V_CANT_CARACTER,' '))) >= V_CANT_CARACTER) THEN 'SI' ELSE 'NO' END PASA_A_OTRA_HOJA
   INTO    V_VALOR
   FROM    SOL_ORDEN_INT S
   WHERE   S.ID_ORDEN = P_ID_ORDEN;

   RETURN(Nvl(V_VALOR, 'NO'));
END;
/

GRANT EXECUTE ON anamnesis.obt_pasa_otra_hoja_oi TO comun;
GRANT EXECUTE ON anamnesis.obt_pasa_otra_hoja_oi TO r_comun;
