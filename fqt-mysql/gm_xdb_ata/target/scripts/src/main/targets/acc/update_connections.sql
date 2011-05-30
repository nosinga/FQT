--
-- De database instelleingen zijn omgeving
-- specifiek. Onderstaande script
-- stelt de connecties in op welke
-- database de rapporten worden uitgevoerd 
--
-- Om het script uit te kunnen voeren
-- moet je een user zetten (voor de journaling)
--
exec abkr_journaling.setuser(user)
--
set verify off
--
accept password_abkr_rpt      prompt 'geef password abkr_rpt@ABKR : '
accept password_ata           prompt 'geef password ata@ABKR : '
accept password_guc_queue     prompt 'geef password guc_queue@pivqueue : '
accept password_guc_trace     prompt 'geef password guc_trace@guc : '
accept password_guc_filters   prompt 'geef password guc_filters@guc : '
accept password_stuf300_in    prompt 'geef password stuf300_in@gegmag : '
accept password_dvgm          prompt 'geef password dvgm@gegmag : '
accept password_mlo_out       prompt 'geef password mlo_out@gegmag : '
accept password_gm_out       prompt 'geef password gm_out@gegmag : '
--
prompt update sqm_connections abkr_rpt@ABKR
update sqm_connections
set    password       = '&&password_abkr_rpt'
,      servicename    = 'beta-a:1521/gegmag.ioo.local'
,      tnsname        = 'beta-a'
,      description    = username||'@beta-a'
where  connectionname = 'abkr_rpt@ABKR' 
;

prompt update sqm_connections ata@ABKR
update sqm_connections
set    password       = '&&password_ata'
,      servicename    = 'beta-a:1521/gegmag.ioo.local'
,      tnsname        = 'beta-a'
,      description    = username||'@beta-a'
where  connectionname = 'ata@ABKR' 
;

prompt update sqm_connections guc_queue@pivqueue
update sqm_connections
set    username       = 'guc_queue_ro'
,      password       = '&&password_guc_queue'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gddata'
,      tnsname        = 'gddata_acc'
,      description    = username||'@gddata_acc'
where  connectionname = 'guc_queue@pivqueue' 
;

prompt update sqm_connections guc_trace@guc
update sqm_connections
set    username       = 'guc_trace_ro'
,      password       = '&&password_guc_trace'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gddata'
,      tnsname        = 'gddata_acc'
,      description    = username||'@gddata_acc'
where  connectionname = 'guc_trace@guc' 
;

prompt update sqm_connections guc_filters@guc
update sqm_connections
set    username       = 'guc_filters_ro'
,      password       = '&&password_guc_filters'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gddata'
,      tnsname        = 'gddata_acc'
,      description    = username||'@gddata_acc'
where  connectionname = 'guc_filters@guc' 
;

prompt update sqm_connections stuf300_in@gegmag
update sqm_connections
set    username       = 'stuf300_in_ro'
,      password       = '&&password_stuf300_in'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gmrdam'
,      tnsname        = 'gmrdam_acc'
,      description    = username||'@gmrdam_acc'
where  connectionname = 'stuf300_in@gegmag' 
;

prompt update sqm_connections dvgm@gegmag
update sqm_connections
set    username       = 'dvgm_ro'
,      password       = '&&password_dvgm'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gmrdam'
,      tnsname        = 'gmrdam_acc'
,      description    = username||'@gmrdam_acc'
where  connectionname = 'dvgm@gegmag' 
;

prompt update sqm_connections mlo_out@gegmag
update sqm_connections
set    username       = 'mlo_out_ro'
,      password       = '&&password_mlo_out'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gmrdam'
,      tnsname        = 'gmrdam_acc'
,      description    = username||'@gmrdam_acc'
where  connectionname = 'mlo_out@gegmag' 
;

prompt update sqm_connections gm_out@gegmag
update sqm_connections
set    username       = 'gm_out_ro'
,      password       = '&&password_mlo_out'
,      servicename    = 'twd068.resource.ta-twd.rotterdam.nl:1521/gmrdam'
,      tnsname        = 'gmrdam_acc'
,      description    = username||'@gmrdam_acc'
where  connectionname = 'gm_out@gegmag' 
;
