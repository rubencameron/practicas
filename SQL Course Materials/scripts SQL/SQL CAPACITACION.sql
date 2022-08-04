DOS TIPOS OPERACIONES

LAS OPERACIONES DDL

DATA DEFINITION LANGUAGE

LAS OPERACIONES DML
DATA MANIPULATION LANGUAGE

CONSULTA SELECT
ALTA CREACION INSERT
BAJA BORRADO DELETE
ACTUALIZACION UPDATE

PL/SQL
CONSULTA SELECT
ALTA CREACION INSERT
BAJA BORRADO DELETE
ACTUALIZACION UPDATE

MAS
IF
LOOP
FOR

PROCESOS

SELECT ID_GRUPO,
       SECUENCIA,
       NOMBRES||' '||APELLIDOS BENEFICIARIO,
       RPAD(NOMBRES, 20, '*'),
       LPAD(NOMBRES, 20, '*'),
       Lower(NOMBRES),
       UPPER(NOMBRES),
       INITCAP(NOMBRES),
       Length(NOMBRES),
       InStr(Lower(NOMBRES), 'u'),
       REPLACE(nombres, 'A', '*'),
       SubStr(nombres, 1, 4),
       InStr(SubStr(NOMBRES, InStr(NOMBRES, 'U') + 1, Length(NOMBRES)), 'U') + InStr(NOMBRES, 'U'),
       CI,
       PRIMA,
       ESTADO_ASEGURADO,
       FECHA_NACIMIENTO
FROM GRU_ASG;

SELECT ID_GRUPO,
       SECUENCIA,
       NOMBRES||' '||APELLIDOS BENEFICIARIO,
       To_Char(PRIMA, '999G999G999D00'),
       To_Char(PRIMA, '000G000G000D99'),
       PRIMA,
       PRIMA + Round(PRIMA * 15 / 100),
       Round(PRIMA * 15 / 100, 2) "PRIMA_15%",
       Round(PRIMA * 15 / 100) "PRIMA_15%",
       TRUNC(PRIMA * 15 / 100) "PRIMA_15%",

       Trunc(157.27, 1) = 157.2
       ROUND(157.27, 1) = 157.3

       ESTADO_ASEGURADO,
       FECHA_NACIMIENTO
FROM GRU_ASG;

SELECT ID_GRUPO,
       SECUENCIA,
       fecha_nacimiento,
       Add_Months(fecha_nacimiento, 1),
       Add_Months(fecha_nacimiento, 3),
       Add_Months(fecha_nacimiento, -3),
       Trunc(SYSDATE, 'mi'),
       Trunc(SYSDATE, 'hh24'),
       Trunc(SYSDATE, 'dd'),
       Trunc(SYSDATE, 'mm'),
       Trunc(SYSDATE, 'rr'),
       Last_Day(SYSDATE),
       SYSDATE,
       To_Char(SYSDATE, 'hh24'),
       To_Char(SYSDATE, 'mi'),
       To_Char(SYSDATE, 'dd/mm/yyyy hh24:mi'),
       SYSDATE + (1 / 1440) sumar_minuto,
       SYSDATE + ((1 / 1440) * 60 * 5)sumar_minuto,
       Trunc(SYSDATE - fecha_nacimiento) dias,
       Trunc(Months_Between(SYSDATE, fecha_nacimiento)) meses,
       Trunc(Months_Between(SYSDATE, fecha_nacimiento) / 12) años,
       Lower(To_Char(FECHA_NACIMIENTO, 'DAY dd ')||' DE '||To_Char(FECHA_NACIMIENTO, 'MONTH')||' DE '||To_Char(FECHA_NACIMIENTO, 'YYYY')),
       To_Char(FECHA_NACIMIENTO, 'RR'),
       To_Char(FECHA_NACIMIENTO, 'YYYY'),
       To_Char(FECHA_NACIMIENTO, 'DAY'),
       To_Char(FECHA_NACIMIENTO, 'DD'),
       To_Char(FECHA_NACIMIENTO, 'D'),
       To_Char(FECHA_NACIMIENTO, 'MONTH'),
       To_Char(FECHA_NACIMIENTO, 'MM'),
       To_Char(FECHA_NACIMIENTO, 'MON'),
       FECHA_NACIMIENTO,
       SYSDATE,
       To_Char(SYSDATE, 'D'),
       USER
FROM GRU_ASG
WHERE id_grupo = 38350
AND   secuencia = 1;

SELECT DISTINCT SEXO
FROM GRU_ASG;

SELECT *
FROM gru_asg;




SELECT G.ID_GRUPO,
       G.SECUENCIA,
       G.NOMBRES||' '||G.APELLIDOS BENEFICIARIO,
       TRUNC(MONTHS_BETWEEN(SYSDATE, FECHA_NACIMIENTO) / 12) AÑOS,
       G.ESTADO_ASEGURADO,
       Decode(G.SEXO,
              'FEMENINO', 'F',
              'MASCULINO', 'M') SEXO,
       C.ID_CATEGORIA,
       C.DESCRIPCION CATEGORIA,
       PL.ID_PLAN,
       PL.DESCRIPCION PLAN,
       M.ID_MOTIVO,
       M.DESCRIPCION MOTIVO_EGRESO
FROM GRU_ASG G, CTG C, PLAN PL, MTV_EGR M
WHERE G.TRF_CTG_ID_CATEGORIA = C.ID_CATEGORIA
AND   G.TRF_PLAN_ID_PLAN = PL.ID_PLAN
AND   G.MTVEGR_ID_MOTIVO = M.ID_MOTIVO

AND  (
      (PL.ID_PLAN = 1
AND    G.ESTADO_ASEGURADO = 'ACTIVO')
OR    G.ESTADO_ASEGURADO = 'INACTIVO'
      )
ORDER BY 9, G.ID_GRUPO, 7;









SELECT ID_GRUPO, SECUENCIA, MTVEGR_ID_MOTIVO, TRF_PLAN_ID_PLAN, ESTADO_ASEGURADO
FROM GRU_ASG
WHERE trf_plan_id_plan = 1
OR   estado_asegurado = 'ACTIVO';