remark gensyn.sql
remark
remark Zorg dat alle ontvangers van de %_READ_ONLY rol en de %_USER_ROL rol
remark private synonyms hebben voor de objecten die ze via die rol gegrant
remark krijgen.
remark
remark Zorg dat diezelfde ontvangers alleen synoniemen hebben die verwijzen
remark naar bestaande tabellen (niet noodzakelijkerwijs gegrant via de rollen),
remark delete "dode" synoniemen.
remark
remark DB_VERSIE
remark
remark De tabel DB_VERSIE komt in meerdere schema's voor. Voor deze tabel wordt
remark alleen een synonym gemaakt als grant-ontvanger lijkt op eigenaar, dus er
remark bestaat een DVGM_USER.DB_VERSIE synonym dat wijst naar DVGM.DB_VERSIE,
remark maar er is geen DVGM_USER synonym dat verwijst naar STUF300_IN.DB_VERSIE.
remark
remark Genereer create statements voor de missende synoniemen, genereer drop
remark statements voor synonyms die naar niet bestaande objecten verwijzen.
remark (alleen voor ontvangers van _READ_ONLY en _USER_ROL rollen)
remark
remark Uitvoeren als SYSTEM (iemand met dba rechten)
remark
remark 08-01-2010  H.Neervoort  Creatie
remark 20-04-2010  H.Neervoort  Genereer ook synoniemen voor _USER_ROL rollen
remark 22-10-2010  H.Neervoort  Verwijder "dode" synoniemen
remark 15-11-2010  H.Neervoort  Negeer BIN$ objecten (recyclebin)
remark

set heading off
set pagesize 0
set linesize 132
set feedback off
set termout off

spool syn.sql

prompt set termout off

prompt spool syn.lis

select 'create public synonym ' || obj.object_name || ' for  ' || obj.owner || '.' ||  obj.object_name ||';'  
from dba_objects obj                                                                           
where obj.owner    = 'FQT'                                                                      
and   obj.object_type in ( 'TABLE', 'VIEW', 'PACKAGE' )                                         
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
