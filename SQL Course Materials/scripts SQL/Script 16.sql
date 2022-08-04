 declare
  job_num                number;
  nlsvar                 varchar2(4000);
  envvar                 raw(32);
  v_dueño_bd             VARCHAR2(1000);
  v_nombre_procedimiento VARCHAR2(1000);
  v_primera_ejecucion    DATE;
  v_intervalo            VARCHAR2(1000);
begin
  select nls_env,misc_env into nlsvar,envvar from dba_jobs where rownum<2 and nls_env is not null and misc_env is not null ;
  select max(job)+1 into job_num from dba_jobs;

  v_dueño_bd := 'ANAMNESIS';
  v_nombre_procedimiento := 'anamnesis.enviar_mail_cons_est';

  v_primera_ejecucion := To_Date('15-12-17 13:00','DD-MM-RRRR :HH24 MI');
  v_intervalo         := 'Trunc(SYSDATE, ''HH24'' ) + (1 /1440 * 240)'; --debe ser en varchar

  sys.dbms_ijob.submit(job=>job_num,
                       luser=>v_dueño_bd,
                       puser=>v_dueño_bd,
                       cuser=>v_dueño_bd,
                       what=>v_nombre_procedimiento||';', --nombre procedimiento
                       next_date=>v_primera_ejecucion, --esta es la fecha de la primera ejecucion
                       interval=>v_intervalo,
                       broken=>FALSE,
                       nlsenv=>nlsvar,
                       env=>envvar);
  dbms_output.put_line(job_num);

  COMMIT;
end;
