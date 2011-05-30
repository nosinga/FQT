remark gengrant.sql
remark
remark 1. Zorg dat alle <<xyz>>_READ_ONLY rollen select grants ontvangen van
remark    alle tables en views van het <<xyz>> schema.
remark 2. Zorg dat alle <<xyz>>_USER_ROL rollen select, insert, update, delete
remark    en execute grants ontvangen van alle tabellen, views, packages,
remark    functions, procedures en sequences (waar zinvol) van het <<xyz>>
remark    schema.
remark 3. Zorg dat grants die direct aan een <<xyz>> schema zijn toegekend 
remark    waarvoor ook een <<xyz>>_USER_ROL bestaat, ook worden gegrant aan die
remark    <<xyz>>_USER_ROL.
remark 
remark Genereer alleen de missende grants.
remark Genereer geen grants op de tabellen en views die bestaan tbv materialized
remark views.
remark
remark Uitvoeren als SYSTEM (iemand met dba rechten)
remark
remark 08-01-2010  H.Neervoort  Creatie
remark 20-04-2010  H.Neervoort  Genereer ook grants voor _USER_ROL rollen
remark 15-06-2010  H.Neervoort  Grants ordenen op object_naam (netter)
remark 12-07-2010  H.Neervoort  Negeer BIN$ objecten (recyclebin)
remark

set heading off
set pagesize 0
set linesize 132
set feedback off
set termout off

spool grantsyn/grant.sql

prompt set termout off

prompt spool grantsyn/grant.lis

remark remark Genereer directe grants als er geen _READ_ONLY rol is
remark remark
remark 
remark select 'grant all on ' || obj.owner || '.' || obj.object_name || ' to ' || usr.username || ';'
remark from dba_objects obj,
remark      dba_users   usr
remark where usr.username = 'FSCH'
remark and   obj.owner    = 'FQT'
remark and   obj.object_type in ( 'TABLE', 'VIEW', 'PACKAGE' )
remark order by usr.username, 
remark          obj.owner
remark /

select 'grant all on ' || obj.owner || '.' || obj.object_name || ' to ' || usr.username || ';'  
from dba_objects obj,                                                                           
     dba_users   usr                                                                            
where usr.username = 'FSCH'                                                                     
and   obj.owner    = 'FQT'                                                                      
and   obj.object_type in ( 'TABLE', 'VIEW', 'PACKAGE' )
and   obj.object_name not like 'BIN$%'                                         
order by usr.username,                                                                          
         obj.owner                                                                              
/                                                                                               











set trimspool on
prompt spool off

prompt set termout on

spool off

set termout on
set feedback on
set linesize 80
set pagesize 40
set heading on
