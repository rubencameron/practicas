
SELECT DISTINCT r.grantee,
                p.usuario,
                p.nombres,
                p.apellidos,
                p.ci,
                u.account_status
FROM    DBA_ROLE_PRIVS r,
        DBA_USERS u,
        persona p
WHERE   r.grantee = p.usuario,
AND
AND     granted_role IN ('R_TESORERIA','R_CONTABLE','R_CONSULTA_GERENTE','R_AUDITOR','R_GERENTE','R_GIRADURIA','R_GERENTE_ADM','R_GERENTE_ADM'),
AND     account_status= 'OPEN';


SELECT *
FROM dba_users;