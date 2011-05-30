Om ata te installeren op acc of prd
moeten er nog enkele handmatige stappen 
gedaan worden.

1. de connectie tabel in ATA moet aangepast worden aan de omgeving
    draai hiervoor het script
    <workspaces>\abkr\gm_xdb_ata\src\main\targets\<omgeving>\update_connections.sql

2. maak database links aan vanuit de abkr_rpt omgeving
    draai hiervoor het script
    <workspaces>\abkr\gm_xdb_abkr_rpt\src\main\targets\<omgeving>\recreate_dblinks.sql
