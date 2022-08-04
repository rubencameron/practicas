PROMPT CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail
CREATE OR REPLACE PROCEDURE anamnesis.enviar_mail
(ENVIA IN VARCHAR2 ,
RECIBE IN VARCHAR2 ,
CON_COPIA IN VARCHAR2 ,
ASUNTO IN VARCHAR2 ,
MENSAJE IN VARCHAR2,
HOST IN VARCHAR2)
IS
MAILHOST VARCHAR2(30) := LTRIM(RTRIM(HOST));
MAIL_CONN UTL_SMTP.CONNECTION;

SALIR BOOLEAN;

CRLF VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
MESG VARCHAR2( 32000 );
V_CON_COPIA VARCHAR2(4000);
V_MEN_NO_ENVIADO VARCHAR2(4000);
V_REMITENTE VARCHAR2(200);
BEGIN


MAILHOST := obt_ip_servidor_correo;

IF Nvl(Upper(obtener_parametro_letra(372)), 'SI') = 'SI' THEN
MAIL_CONN := UTL_SMTP.OPEN_CONNECTION(MAILHOST, 25);

    SELECT Nvl(REMITENTE_CORREO, 'info@sis-sanroque.com.py')
    INTO   V_REMITENTE
    FROM   SUCURSAL
    WHERE ID_SUCURSAL = OBTENER_SUC_USUARIO(USER);



  /*
mesg := 'Date: ' ||
        TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss') || crlf ||
           'From: <'|| pSender ||'>' || crlf ||
           'Subject: '|| pSubject || crlf ||
           'To: '||pRecipient || crlf || '' || crlf || pMessage;
*/
IF ASUNTO = '.' THEN
    --MESG:= 'Fecha: ' || TO_CHAR( SYSDATE, 'dd/mm/yyyy hh24:mi:ss' ) || CRLF ||
    --MESG:= 'Date: ' || TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' ) || CRLF ||
    MESG:= 'Fecha: ' || TO_CHAR( SYSDATE, 'dd/mm/yyyy hh24:mi:ss' ) || CRLF ||
    'FROM: <'||V_REMITENTE||'>' || CRLF ||
    'SUBJECT: '||ASUNTO || CRLF ||
    'TO: '||RECIBE || CRLF ||
    'CC: '||CON_COPIA || CRLF ||
    '' || CRLF || MENSAJE;
ELSIF ASUNTO != 'CONSULTAS MEDICAS' THEN
    --MESG:= 'Fecha: ' || TO_CHAR( SYSDATE, 'dd/mm/yyyy hh24:mi:ss' ) || CRLF ||
    --MESG:= 'Date: ' || TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' ) || CRLF ||
    MESG:= 'Fecha: ' || TO_CHAR( SYSDATE, 'dd/mm/yyyy hh24:mi:ss' ) || CRLF ||
    'FROM: <'||V_REMITENTE||'>' || CRLF ||
    'SUBJECT: '||ASUNTO || CRLF ||
    'TO: '||RECIBE || CRLF ||
    'CC: '||CON_COPIA || CRLF ||
    '' || CRLF || MENSAJE;
ELSE
    MESG:= 'Fecha: ' || TO_CHAR( SYSDATE, 'dd/mm/yyyy hh24:mi:ss' ) || CRLF ||
    'FROM: <'||V_REMITENTE||'>' || CRLF ||
    'SUBJECT: '||ASUNTO || CRLF ||
    'TO: '||RECIBE || CRLF ||
    'CC: '||CON_COPIA || CRLF ||
    '' || CRLF || MENSAJE;
END IF;

UTL_SMTP.HELO(MAIL_CONN, MAILHOST);
UTL_SMTP.MAIL(MAIL_CONN, V_REMITENTE);--ENVIA
UTL_SMTP.RCPT(MAIL_CONN, RECIBE);

V_CON_COPIA := CON_COPIA;

IF V_CON_COPIA IS NOT NULL THEN
  LOOP
    IF INSTR(V_CON_COPIA, ',') = 0 THEN
      SALIR := TRUE;
      UTL_SMTP.RCPT(MAIL_CONN, SubStr(V_CON_COPIA, 1, Length(V_CON_COPIA)));
    ELSE
      UTL_SMTP.RCPT(MAIL_CONN, SubStr(V_CON_COPIA, 1, InStr(V_CON_COPIA, ',') - 1));
    END IF;

    V_CON_COPIA := SubStr(V_CON_COPIA, InStr(V_CON_COPIA, ',') + 1, Length(V_CON_COPIA));

    EXIT WHEN V_CON_COPIA IS NULL OR SALIR;
  END LOOP;
END IF;

UTL_SMTP.DATA(MAIL_CONN, MESG);
UTL_SMTP.QUIT(MAIL_CONN);
INSERT INTO MENSAJE_CORREO_CELULAR
VALUES(SYSDATE,
       SubStr(RECIBE, 1, 4000),
       SubStr(CON_COPIA, 1, 4000),
       SubStr(ASUNTO, 1, 4000),
       SubStr(MENSAJE, 1, 4000));

END IF;

EXCEPTION
WHEN OTHERS THEN

     --UTL_SMTP.CLOSE_CONNECTION(MAIL_CONN);
     NULL;
     V_MEN_NO_ENVIADO := 'NO ENVIADO. MOTIVO :'||SQLERRM;
     IF V_MEN_NO_ENVIADO IS NULL THEN
        V_MEN_NO_ENVIADO := 'NO ENVIADO';
     END IF;
     INSERT INTO MENSAJE_CORREO_CELULAR
     VALUES(SYSDATE,
            SubStr(RECIBE, 1, 4000),
            SubStr(CON_COPIA, 1, 4000),
            SubStr(ASUNTO, 1, 4000),
            V_MEN_NO_ENVIADO);


END;
/

GRANT EXECUTE ON anamnesis.enviar_mail TO comun;
GRANT EXECUTE ON anamnesis.enviar_mail TO r_comun;
