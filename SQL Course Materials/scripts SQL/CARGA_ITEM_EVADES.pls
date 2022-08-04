PROMPT CREATE OR REPLACE PROCEDURE anamnesis.carga_item_evades
CREATE OR REPLACE PROCEDURE anamnesis.carga_item_evades
IS
V_DUMMY        CHAR(1);
P_ID_CATEGORIA NUMBER(20);
P_ID_CARGO     NUMBER(20);
V_ID_SUCURSAL     NUMBER(20);
V_ID_ITEM      NUMBER(20);
CURSOR S IS
  SELECT  ID_SUCURSAL
  FROM SUCURSAL
  ORDER BY 1;

V_NUMBERO NUMBER(20);
V_CARGO_ANT NUMBER(20);
BEGIN
 OPEN S;
 FETCH S INTO V_ID_SUCURSAL;
 WHILE S%FOUND
 LOOP
  DECLARE
    CURSOR  VERIFICA IS
    SELECT    ID_CARGO,NULL
    FROM      CARGO
    GROUP BY  ID_CARGO,NULL
    ORDER BY 1,2;
    BEGIN
      OPEN VERIFICA;
      FETCH VERIFICA INTO P_ID_CARGO,
                          P_ID_CATEGORIA;

      WHILE VERIFICA%FOUND
      LOOP

	      CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Sus actos coinciden con las promesas que hace y con las responsabilidades que le corresponden.'
        ,TRUNC(SYSDATE,'MM'),'CONFIANZA',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL, 1);

        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Su conducta personal y laboral es un reflejo de los valores que definen a la organización.'
        ,TRUNC(SYSDATE,'MM'),'CONFIANZA',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,2);

        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES',V_ID_ITEM );
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Comunica con claridad sus actos, brindando datos conforme a las directivas que recibe.'
        ,TRUNC(SYSDATE,'MM'),'CONFIANZA',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL, 3);


       CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Su trabajo y/o tareas no presentan errores y es de alta calidad.',
        TRUNC(SYSDATE,'MM'),'EXCELENCIA',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL, 1);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Supera o busca superar sus estándares de desempeño.',
        TRUNC(SYSDATE,'MM'),'EXCELENCIA',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL, 2);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Identifica mejoras en los procesos a su cargo, y plantea sugerencias para su implementacion.',
        TRUNC(SYSDATE,'MM'),'EXCELENCIA',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL, 3);




        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Brinda  un trato cordial  en todo momento.',
        TRUNC(SYSDATE,'MM'),'RESPETO',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,1);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Demuestra apertura a las opiniones, ideas y propuestas de los demas aun siendo diferente  a las suyas.',
        TRUNC(SYSDATE,'MM'),'RESPETO',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,2);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Escucha y se comunica con respeto con sus superiores y compañeros.',
        TRUNC(SYSDATE,'MM'),'RESPETO',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,3);


        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Sugiere ideas nuevas  que pueden causar un impacto positivo en los servicios y clientes.',
        TRUNC(SYSDATE,'MM'),'INNOVACION',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,1);
         CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Presenta flexibilidad y apertura para salir de los esquemas pre establecidos.',
        TRUNC(SYSDATE,'MM'),'INNOVACION',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,2);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Busca alternativas diferentes de solución a problemas que se presenten.',
        TRUNC(SYSDATE,'MM'),'INNOVACION',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,3);


        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Presenta el problema junto con alternativas de solución.',
        TRUNC(SYSDATE,'MM'),'PROACTIVIDAD',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,1);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Se anticipa a los requerimientos de su trabajo y se ofrece para tareas adicionales, si  su trabajo actual ya ha sido completado.',
        TRUNC(SYSDATE,'MM'),'PROACTIVIDAD',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,2);
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Muestra determinación ante situaciones que puedan ocasionar inconvenientes en su trabajo.',
        TRUNC(SYSDATE,'MM'),'PROACTIVIDAD',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,3);

          /*
        CGUI$CG_CODE_CONTROLS('SEQ_ITEM_EVA_DES', V_ID_ITEM);
        INSERT INTO  ITEM_EVA_DES
        VALUES(V_ID_ITEM,
        'Grado en que la capacitación anual ha influido en el mejoramiento de su desempeño laboral.',
        To_Date('01-01-05','DD-MM-RR'),'CAPACITACION',P_ID_CARGO,P_ID_CATEGORIA,V_ID_SUCURSAL,4);
            */
      FETCH VERIFICA INTO P_ID_CARGO,
                          P_ID_CATEGORIA;

      END LOOP;
      CLOSE VERIFICA;
     END;
     FETCH S INTO V_ID_SUCURSAL;
 END LOOP;
 CLOSE S;
     --COMMIT;
END;
/

GRANT EXECUTE ON anamnesis.carga_item_evades TO r_gerente;
GRANT EXECUTE ON anamnesis.carga_item_evades TO r_gerente_adm;
