
--para ver los jobs
SELECT *
FROM dba_jobs
WHERE Upper(what) LIKE '%PRUEBA_JOB%';

--si desea modificar debe primero borrar el job y luego crear

--para crear JOBS
declare
  job_num                number;
  nlsvar                 varchar2(4000);
  envvar                 raw(32);
  v_due�o_bd             VARCHAR2(1000);
  v_nombre_procedimiento VARCHAR2(1000);
  v_primera_ejecucion    DATE;
  v_intervalo            VARCHAR2(1000);
begin
  select nls_env,misc_env into nlsvar,envvar from dba_jobs where rownum<2 and nls_env is not null and misc_env is not null ;
  select max(job)+1 into job_num from dba_jobs;

  v_due�o_bd := 'ANAMNESIS';
  v_nombre_procedimiento := 'FACTURA_PROV_ENTREGA_PAGO';

  v_primera_ejecucion := TO_DATE('13-06-18 08:00','dd-mm-rr hh24:MI');
  v_intervalo         := 'TRUNC(SYSDATE,''HH24'')+1'; --debe ser en varchar

  sys.dbms_ijob.submit(job=>job_num,
                       luser=>v_due�o_bd,
                       puser=>v_due�o_bd,
                       cuser=>v_due�o_bd,
                       what=>v_nombre_procedimiento ,
                       next_date=>v_primera_ejecucion,
                       interval=>v_intervalo,
                       broken=>FALSE,
                       nlsenv=>nlsvar,
                       env=>envvar);
  dbms_output.put_line(job_num);

  COMMIT;
end;

--PARA BORRAR job o modificar
SELECT *
FROM dba_jobs
WHERE Upper(what) LIKE '%FACTURA_PROV_ENTREGA_PAGO%';

--luego borrar cargando el dato del campo JOB
BEGIN
  sys.dbms_ijob.remove(4036);
  COMMIT;
END;





