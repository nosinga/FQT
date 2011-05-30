remark gengrant.sql
remark
remark 
remark Genereer alleen de missende grants.
remark Genereer geen grants op de tabellen en views die bestaan tbv materialized
remark views.
remark
remark Uitvoeren als SYSTEM (iemand met dba rechten)
remark
remark 17-02-2011  N.Osinga  Creatie
remark

set heading off
set pagesize 0
set linesize 132
set feedback off
set termout off

spool grant.sql

prompt set termout off

prompt spool grant.lis

remark remark
remark 
remark select 'grant all on ' || obj.owner || '.' || obj.object_name || ' to ' || usr.username || ';'
remark from dba_objects obj,
remark      dba_users   usr
remark where usr.username in ('FSCH','ADC')
remark and   obj.owner    =   'FQT'
remark and   obj.object_type in ( 'TABLE', 'VIEW', 'PACKAGE' )
remark order by usr.username, 
remark          obj.owner
remark /

select 'grant all on ' || obj.owner || '.' || obj.object_name || ' to ' || usr.username || ';'  
from dba_objects obj,                                                                           
     dba_users   usr                                                                            
where usr.username in ('FSCH','ADC')
and   obj.owner    =   'FQT'
and   obj.object_type in ( 'TABLE', 'VIEW', 'PACKAGE' )                                         
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
