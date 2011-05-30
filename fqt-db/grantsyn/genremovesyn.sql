remark gensyn.sql
remark
remark
remark

set heading off
set pagesize 0
set linesize 132
set feedback off
set termout off

spool grantsyn/removesyn.sql

prompt set termout off

prompt spool grantsyn/removesyn.lis

select 'drop public synonym ' || synonym_name || ';'  
from dba_synonyms                                                                           
where table_owner    in ('FQT','ATA')
and   owner       = 'PUBLIC'                                                                      
order by table_owner, synonym_name                                                                              
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
