remark fixataconnections.sql
remark
remark Geef de juiste waarden aan de records in de tabel SQM_CONNECTIONS.
remark
remark Uitvoeren als ATA
remark 
remark 11-01-2011  H.Neervoort  Creatie
remark

execute abkr_journaling.setuser( 'fixataconnections' );

update sqm_connections 
set username    = 'abkr_rpt_user',
    servicename = 'beta-p.ioo.local:1521:gegmag',
    description = 'abkr_rpt@beta-p',
    password    = 'geheim123',
    tnsname     = 'beta-p'
where connectionname = 'abkr_rpt@ABKR';

update sqm_connections 
set username    = 'ata_user',
    servicename = 'beta-p.ioo.local:1521:gegmag',
    description = 'ata@beta-p',
    password    = 'geheim123',
    tnsname     = 'beta-p'
where connectionname = 'ata@ABKR';

update sqm_connections 
set username    = 'dvgm_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gmrdam2',
    description = 'dvgm@gmrdam2_prd',
    password    = 'geheim123',
    tnsname     = 'gmrdam2_prd'
where connectionname = 'dvgm@gegmag';

update sqm_connections 
set username    = 'gm_out_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gmrdam2',
    description = 'gm_out@gmrdam2_prd',
    password    = 'geheim123',
    tnsname     = 'gmrdam2_prd'
where connectionname = 'gm_out@gegmag';

update sqm_connections 
set username    = 'guc_filters_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gddata2',
    description = 'guc_filters@gddata2_prd',
    password    = 'geheim123',
    tnsname     = 'gddata2_prd'
where connectionname = 'guc_filters@guc';

update sqm_connections 
set username    = 'guc_queue_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gddata2',
    description = 'guc_queue@gddata2_prd',
    password    = 'geheim123',
    tnsname     = 'gddata2_prd'
where connectionname = 'guc_queue@pivqueue';

update sqm_connections 
set username    = 'guc_trace_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gddata2',
    description = 'guc_trace@gddata2_prd',
    password    = 'geheim123',
    tnsname     = 'gddata2_prd'
where connectionname = 'guc_trace@guc';

update sqm_connections 
set username    = 'guc_unique_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gddata2',
    description = 'guc_unique@gddata2_prd',
    password    = 'geheim123',
    tnsname     = 'gddata2_prd'
where connectionname = 'guc_unique@guc';

update sqm_connections 
set username    = 'mlo_out_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gmrdam2',
    description = 'mlo_out@gmrdam2_prd',
    password    = 'geheim123',
    tnsname     = 'gmrdam2_prd'
where connectionname = 'mlo_out@gegmag';

update sqm_connections 
set username    = 'stuf300_in_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gmrdam2',
    description = 'stuf300_in@gmrdam2_prd',
    password    = 'geheim123',
    tnsname     = 'gmrdam2_prd'
where connectionname = 'stuf300_in@gegmag';

update sqm_connections 
set username    = 'stuf300_out_ro',
    servicename = 'twd139.resource.twd.rotterdam.nl:1521:gmrdam2',
    description = 'stuf300_out@gmrdam2_prd',
    password    = 'geheim123',
    tnsname     = 'gmrdam2_prd'
where connectionname = 'stuf300_out@gegmag';

commit;
