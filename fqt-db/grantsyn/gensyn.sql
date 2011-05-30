remark gensyn.sql
remark
remark

set heading off
set pagesize 0
set linesize 132
set feedback off
set termout off

spool grantsyn/syn.sql

prompt set termout off

prompt spool grantsyn/syn.lis

select 'create public synonym ' || obj.object_name || ' for  ' || obj.owner || '.' ||  obj.object_name ||';'  
from dba_objects obj                                                                           
where obj.owner    = 'FQT'                                                                      
and   obj.object_type in ( 'TABLE', 'VIEW', 'PACKAGE' )
and   obj.object_name not like 'BIN%'                                         
order by obj.owner                                                                              
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
