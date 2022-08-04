PROMPT CREATE OR REPLACE PROCEDURE anamnesis.carga_det_eva_desempeno
CREATE OR REPLACE PROCEDURE anamnesis.carga_det_eva_desempeno (P_ID_EVALUACION IN NUMBER,
                                                               P_TIPO          VARCHAR2,
                                                               P_ID_SUCURSAL   IN NUMBER
                                                              )
IS
V_DUMMY        CHAR(1);
V_ID_CATEGORIA NUMBER(20);
V_ID_CARGO     NUMBER(20);
BEGIN
     SELECT CAT_SAL_ID_CATEGORIA,
            CARGO_ID_CARGO
     INTO   V_ID_CATEGORIA,
            V_ID_CARGO
     FROM   EVALUACION_DESEMPENO
     WHERE  ID_EVALUACION = P_ID_EVALUACION
     AND    SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL;

     IF V_ID_CARGO IS NULL THEN
        Raise_Application_Error(-20000, 'Favor de completar el campo de Cargo el cual corresponde al personal..Gracias!!');
     END IF;

     IF V_ID_CATEGORIA IS NULL THEN
        --Raise_Application_Error(-20000, 'Favor de completar el campo de Categoria el cual corresponde al personal..Gracias!!');
         NULL;-- puse mas abajo la restrección
     END IF;

     BEGIN
          SELECT '1'
          INTO   V_DUMMY
          FROM   DET_EVALUACION_DESEMPENO
          WHERE  EVALUACION_ID_EVALUACION = P_ID_EVALUACION
          AND    ROWNUM <2;

          IF  P_TIPO = 'PRODUCCION' THEN
              -- actualiza el detalle de Produccion

              DELETE FROM DET_EVALUACION_DESEMPENO
              WHERE  EVALUACION_ID_EVALUACION = P_ID_EVALUACION
              AND    GRUPO = 'PRODUCCION';

              BEGIN

                SELECT '1'
                INTO   V_DUMMY
                FROM   ITEM_EVA_DES I,
                       EVALUACION_DESEMPENO E
                WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                AND    E.ID_EVALUACION = P_ID_EVALUACION
                AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                AND    ROWNUM < 2;
                --Dbms_Output.PUT_LINE('ERROR '||P_ID_EVALUACION);
                BEGIN
                    SELECT '1'
                    INTO   V_DUMMY
                    FROM   ITEM_EVA_DES I, EVALUACION_DESEMPENO E
                    WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                    AND    E.CAT_SAL_ID_CATEGORIA = I.CAT_SAL_ID_CATEGORIA
                    AND    E.ID_EVALUACION = P_ID_EVALUACION
                    AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                    AND    ROWNUM < 2;

                    INSERT INTO DET_EVALUACION_DESEMPENO
                    SELECT P_ID_EVALUACION,
                           I.GRUPO,
                           I.ITEM,
                           0,
                           I.ID_ITEM
                    FROM   ITEM_EVA_DES I,
                           EVALUACION_DESEMPENO E
                    WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                    AND    E.CAT_SAL_ID_CATEGORIA = I.CAT_SAL_ID_CATEGORIA
                    AND    E.ID_EVALUACION = P_ID_EVALUACION
                    AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                    AND    TRUNC(I.PERIODO, 'MM') = (SELECT MAX(II.PERIODO)
                                                     FROM   ITEM_EVA_DES II
                                                     WHERE  I.CARGO_ID_CARGO = II.CARGO_ID_CARGO
                                                     AND    I.CAT_SAL_ID_CATEGORIA = II.CAT_SAL_ID_CATEGORIA
                                                     AND    II.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                                                     AND    Trunc(II.PERIODO, 'MM') <= Trunc(E.FECHA_EVALUACION, 'MM')
                                                     )
                    ORDER BY ID_ITEM;

                EXCEPTION
                    WHEN No_Data_Found THEN
                         INSERT INTO DET_EVALUACION_DESEMPENO
                         SELECT P_ID_EVALUACION,
                                I.GRUPO,
                                I.ITEM,
                                0,
                                I.ID_ITEM
                         FROM   ITEM_EVA_DES I,
                                EVALUACION_DESEMPENO E
                         WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                         AND    I.CAT_SAL_ID_CATEGORIA IS NULL
                         AND    E.ID_EVALUACION = P_ID_EVALUACION
                         AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                         AND    TRUNC(I.PERIODO, 'MM') = (SELECT MAX(II.PERIODO)
                                                          FROM   ITEM_EVA_DES II
                                                          WHERE  I.CARGO_ID_CARGO = II.CARGO_ID_CARGO
                                                          AND    II.CAT_SAL_ID_CATEGORIA IS NULL
                                                          AND    II.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                                                          AND    Trunc(II.PERIODO, 'MM') <= Trunc(E.FECHA_EVALUACION, 'MM')
                                                         )
                         ORDER BY ID_ITEM;
                END;

              EXCEPTION
                WHEN No_Data_Found THEN
                 IF v_id_categoria IS NULL THEN
                    Raise_Application_Error(-20000,' Para el cargo '||v_id_cargo||' no esta definido los items de producción favor ver con el Desarrollo Organizacional');
                 ELSE
                    Raise_Application_Error(-20000,' Para el cargo '||v_id_cargo||' y departamento '||v_id_categoria||' no esta definido los items de producción en el formulario 724 favor ver con Desarrollo Organizacional');
                 END IF;
              END;

          END IF;

     EXCEPTION
          WHEN No_Data_Found THEN
              --END;
-- Inserta en el detalle de Produccion
              BEGIN
                SELECT '1'
                INTO   V_DUMMY
                FROM   ITEM_EVA_DES I, EVALUACION_DESEMPENO E
                WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                AND    E.ID_EVALUACION = P_ID_EVALUACION
                AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                AND    ROWNUM < 2;

                BEGIN
                    SELECT '1'
                    INTO   V_DUMMY
                    FROM   ITEM_EVA_DES I, EVALUACION_DESEMPENO E
                    WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                    --AND    E.CAT_SAL_ID_CATEGORIA = I.CAT_SAL_ID_CATEGORIA
                    AND    E.ID_EVALUACION = P_ID_EVALUACION
                    AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                    AND    ROWNUM < 2;

                    INSERT INTO DET_EVALUACION_DESEMPENO
                    SELECT P_ID_EVALUACION,
                           I.GRUPO,
                           I.ITEM,
                           0,
                           I.ID_ITEM
                    FROM   ITEM_EVA_DES I,
                           EVALUACION_DESEMPENO E
                    WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                    --AND    E.CAT_SAL_ID_CATEGORIA = I.CAT_SAL_ID_CATEGORIA
                    AND    E.ID_EVALUACION = P_ID_EVALUACION
                    AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                    AND    TRUNC(I.PERIODO, 'MM') = (SELECT MAX(II.PERIODO)
                                                     FROM   ITEM_EVA_DES II
                                                     WHERE  I.CARGO_ID_CARGO = II.CARGO_ID_CARGO
                                                     --AND    I.CAT_SAL_ID_CATEGORIA = II.CAT_SAL_ID_CATEGORIA
                                                     AND    II.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                                                     AND    Trunc(II.PERIODO, 'MM') <= Trunc(E.FECHA_EVALUACION, 'MM')
                                                     )
                    ORDER BY ID_ITEM;

                EXCEPTION
                    WHEN No_Data_Found THEN
                         INSERT INTO DET_EVALUACION_DESEMPENO
                         SELECT P_ID_EVALUACION,
                                I.GRUPO,
                                I.ITEM,
                                0,
                                I.ID_ITEM
                         FROM   ITEM_EVA_DES I,
                                EVALUACION_DESEMPENO E
                         WHERE  E.CARGO_ID_CARGO = I.CARGO_ID_CARGO
                         AND    I.CAT_SAL_ID_CATEGORIA IS NULL
                         AND    E.ID_EVALUACION = P_ID_EVALUACION
                         AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                         AND    TRUNC(I.PERIODO, 'MM') = (SELECT MAX(II.PERIODO)
                                                          FROM   ITEM_EVA_DES II
                                                          WHERE  I.CARGO_ID_CARGO = II.CARGO_ID_CARGO
                                                          AND    II.CAT_SAL_ID_CATEGORIA IS NULL
                                                          AND    II.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                                                          AND    Trunc(II.PERIODO, 'MM') <= Trunc(E.FECHA_EVALUACION, 'MM')
                                                         )
                         ORDER BY ID_ITEM;
                END;
              EXCEPTION
                WHEN No_Data_Found THEN
                 IF v_id_categoria IS NULL THEN
                    Raise_Application_Error(-20000,' Para el cargo '||v_id_cargo||' no esta definido los items de producción favor ver con el Desarrollo Organizacional');
                 ELSE
                    Raise_Application_Error(-20000,' Para el cargo '||v_id_cargo||' y departamento '||v_id_categoria||' no esta definido los items de producción en el formulario 724 favor ver con Desarrollo Organizacional');
                 END IF;
              END;

     END;
     BEGIN
        SELECT '1'
        INTO    V_DUMMY
        FROM    DET_EVALUACION_DESEMPENO
        WHERE   EVALUACION_ID_EVALUACION = P_ID_EVALUACION
        --AND     GRUPO = 'PRODUCCION'
        AND     ROWNUM < 2;
     EXCEPTION
        WHEN No_Data_Found THEN
              IF V_ID_CATEGORIA IS NULL THEN
                BEGIN
                    SELECT '1'
                    INTO   V_DUMMY
                    FROM   ITEM_EVA_DES I
                    WHERE  I.CARGO_ID_CARGO = V_ID_CARGO
                    AND    I.CAT_SAL_ID_CATEGORIA IS NULL
                    AND    I.SUCURSAL_ID_SUCURSAL = P_ID_SUCURSAL
                    AND    ROWNUM < 2;
                EXCEPTION
                    WHEN No_Data_Found THEN
                        Raise_Application_Error(-20000, 'Favor verificar el formulario 724, para el cargo '||V_ID_CARGO||' y categoria NULO no hay items para producción cargados.Comuniquese con el departamento de RR.HH');
                END;
              ELSE
                Raise_Application_Error(-20000, 'Favor verificar el formulario 724, para el cargo '||V_ID_CARGO||' y categoria '||V_ID_CATEGORIA||' no hay items para producción cargados.Comuniquese con el departamento de RR.HH');
              END IF;
     END;

     COMMIT;
END;
/

GRANT EXECUTE ON anamnesis.carga_det_eva_desempeno TO r_gerente;
GRANT EXECUTE ON anamnesis.carga_det_eva_desempeno TO r_gerente_adm;
