@@FQT_Clean_all.sql
@@FQT_Build_all.sql

update ata_parameters set value = 'PDCD2' where parametername = 'TNS_SID_NAME'
;

update sqm_connections set servicename = replace(servicename, 'localhost:1521:XE','vrdbms2:1621:pdcd2')
;



commit
/

