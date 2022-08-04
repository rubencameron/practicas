
SELECT   ID_ACREDITACION,
         SIMBRES,
         APELLIDOS,
         PREST_ACREDIT
FROM     ACREDITACION_MED
WHERE    PREST_ACREDIT = 'SI'   --PRESTADORES ACREDITADOS


SELECT   ID_ACREDITACION,
         SIMBRES,
         APELLIDOS,
         CREDENCIAL_ENTRE
FROM     ACREDITACION_MED
WHERE    CREDENCIAL_ENTRE = 'SI' --PRESTADORES CON PIN


SELECT  ID_ACREDITACION,
        SIMBRES,
        APELLIDOS,
        REGIS_WEB
FROM    ACREDITACION_MED
WHERE   REGIS_WEB = 'SI';        --PRESTADORES REGISTRADOS EN LA PAGINA WEB


SELECT   ID_ACREDITACION,
         SIMBRES,
         APELLIDOS,
         FIR_REGLAMEN
FROM     ACREDITACION_MED
WHERE    FIR_REGLAMEN = 'SI';    --PRESTADORES QUE FIRMARON REGLAMENTO


SELECT   ID_ACREDITACION,
         SIMBRES,
         APELLIDOS,
         CARNET_ACREDIT
FROM     ACREDITACION_MED
WHERE    CARNET_ACREDIT = 'SI'    --PRESTADORES QUE POSEEN CREDENCIAL/DISTINTIVO



SELECT   ID_ACREDITACION,
         SIMBRES,
         APELLIDOS,
         POMING_ESTACIONA
FROM     ACREDITACION_MED
WHERE    POMING_ESTACIONA = 'SI'  --PRESTADORES QUE POSEEN POMING PARA ESTACIONAMIENTO





