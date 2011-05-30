/**
|||------------------------------------------------------------------------
|||OMSCHRIJVING:
|||  Connecties DEVELOPMENT OMGEVING
|||
|||PARAMETERS:
|||
|||OPMERKINGEN:
|||  De database instellingen zijn omgeving specifiek. 
|||  Onderstaande script stelt de connecties in op welke database de rapporten worden uitgevoerd 
|||
|||  Om het script uit te kunnen voeren moet je een user zetten (voor de journaling)
|||
|||SUBVERSION INFO : DO NOT CHANGE!!!!
|||  Date     : $Date: 2011-03-07 12:09:06 +0100 (Mon, 07 Mar 2011) $
|||  Revision : $Revision: 30786 $
|||  Author   : $Author: mcopier $
|||  URL      : $URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/targets/dev/update_connections.sql $
|||  ID       : $Id: update_connections.sql 30786 2011-03-07 11:09:06Z mcopier $
|||------------------------------------------------------------------------
**/
--
exec abkr_journaling.setuser(user)
--
set verify off
--
set define on
--
accept pwd_abkr_user   prompt 'password voor abkr_user omgeving (users) : '
accept pwd_ata_user    prompt 'password voor ata_user omgeving (users)  : '
accept pwd_db128_user  prompt 'password voor db128 omgeving (users)     : ' 
--
PROMPT UPDATE SQM_CONNECTIONS ATA
update sqm_connections
set    password       = '&&pwd_ata_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'ata@ABKR' 
;
PROMPT UPDATE SQM_CONNECTIONS ABKR_RPT
update sqm_connections
set    password       = '&&pwd_abkr_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'abkr_rpt@ABKR' 
;
--
PROMPT UPDATE SQM_CONNECTIONS STUF300_IN
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'stuf300_in@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS STUF301_IN
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'stuf301_in@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS DVGM
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'dvgm@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS GM_OUT
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'gm_out@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS MLO_OUT
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'mlo_out@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS STUF300_OUT
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'stuf300_out@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS STUF301_OUT
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GMRDAM'
,      tnsname        = 'GMRDAM-O'
,      description    =  username||'@GMRDAM'
where  connectionname = 'stuf301_out@gegmag' 
;
--
PROMPT UPDATE SQM_CONNECTIONS GUC_FILTERS
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GDDATA'
,      tnsname        = 'GDDATA-O'
,      description    =  username||'@GDDATA'
where  connectionname = 'guc_filters@guc' 
;
--
PROMPT UPDATE SQM_CONNECTIONS GUC_QUEUE
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GDDATA'
,      tnsname        = 'GDDATA-O'
,      description    =  username||'@GDDATA'
where  connectionname = 'guc_queue@pivqueue' 
;
--
PROMPT UPDATE SQM_CONNECTIONS GUC_TRACE
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GDDATA'
,      tnsname        = 'GDDATA-O'
,      description    =  username||'@GDDATA'
where  connectionname = 'guc_trace@guc' 
;
--
PROMPT UPDATE SQM_CONNECTIONS GUC_UNIQUE
update sqm_connections
set    password       = '&&pwd_db128_user'
,      servicename    = 'beta-o.ioo.local:1521:GDDATA'
,      tnsname        = 'GDDATA-O'
,      description    =  username||'@GDDATA'
where  connectionname = 'guc_unique@guc' 
;
--
commit;

