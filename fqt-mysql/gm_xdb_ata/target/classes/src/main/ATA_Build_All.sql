-- $Date: 2011-03-23 10:40:23 +0100 (Wed, 23 Mar 2011) $
-- $Revision: 31507 $
-- $Author: mcopier $
-- $URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/ATA_Build_All.sql $
-- $ID: $

spool ata_build_all.log
set define off
--
set feedback off
--
PROMPT ===============================================================================
PROMPT Schoonmaken zonder alle data te verwijderen               
PROMPT ===============================================================================
@@DataMigrate/ATA_Clean_Migrate_All.sql
--
PROMPT ===============================================================================
PROMPT Aanmaken van de DB-VERSIE tabel               
PROMPT ===============================================================================
@@Tables/DB_VERSIE.tab
--
PROMPT
PROMPT ===============================================================================
PROMPT Vullen DB-versie tabel
PROMPT ===============================================================================
@@Data/DB_VERSIE.dat
--
commit;
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Tabellen
PROMPT ===============================================================================
@@Tables/ATA_tables.sql
@@Tables/URP_tables.sql
@@Tables/SQM_tables.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Migreren Tabel Data
PROMPT ===============================================================================
@@DataMigrate/URP_tables_Migrate.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Sequences
PROMPT ===============================================================================
@@Sequences/URP_sequence.sql
@@Sequences/SQM_sequence.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Ophogen Sequence
PROMPT ===============================================================================
@@DataMigrate/URP_sequence_Migrate.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Constraints
PROMPT ===============================================================================
@@Constraints/URP_constraints.sql
@@Constraints/SQM_constraints.sql
--
PROMPT ===============================================================================
PROMPT Aanmaken types
PROMPT ===============================================================================
@@Types/PIPELINED_TYPES.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken package specificaties
PROMPT ===============================================================================
@@Packages/URP_UTILS.pks
@@Packages/URP_MENU_UTILS.pks
@@Packages/ATA_UTILS.pks
@@Packages/ATA_HTTP.pks
@@../../../gm_xdb_commons/src/main/Packages/ABKR_UTILS_GEN_DDL.pks
@@../../../gm_xdb_commons/src/main/Packages/ABKR_JOURNALING.pks
@@../../../gm_xdb_commons/src/main/Packages/ABKR_JOURNALING_MAINTENANCE.pks
@@Packages/SQM_UTILS.pks
@@Packages/ATA_REPORTS.pks
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Table Triggers
PROMPT ===============================================================================
@@Triggers/URP_triggers.sql
@@Triggers/SQM_triggers.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Views
PROMPT ===============================================================================
@@Views/URP_views.sql
@@Views/URP_MENU_views.sql
@@Views/URP_user_menu_view.sql
@@Views/URP_user_reports_view.sql
@@Views/URP_user_urls_view.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken View Triggers
PROMPT ===============================================================================
@@Triggers/URP_VIEW_triggers.sql
PROMPT
--
PROMPT ===============================================================================
PROMPT Aanmaken package bodies
PROMPT ===============================================================================
@@PackageBodies/URP_UTILS.pkb
@@PackageBodies/URP_MENU_UTILS.pkb
@@PackageBodies/ATA_UTILS.pkb
@@PackageBodies/ATA_HTTP.pkb
@@../../../gm_xdb_commons/src/main/PackageBodies/ABKR_UTILS_GEN_DDL.pkb
@@../../../gm_xdb_commons/src/main/PackageBodies/ABKR_JOURNALING.pkb
@@../../../gm_xdb_commons/src/main/PackageBodies/ABKR_JOURNALING_MAINTENANCE.pkb
@@PackageBodies/SQM_UTILS.pkb
@@PackageBodies/ATA_REPORTS.pkb
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken package specificaties
PROMPT ===============================================================================
prompt package ABKR_PLSQL_DOC
@@Packages/ABKR_PLSQL_DOC.pks
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken package bodies
PROMPT ===============================================================================
prompt package body ABKR_PLSQL_DOC
@@PackageBodies/ABKR_PLSQL_DOC.pkb
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken tijdelijke Data packages
PROMPT ===============================================================================
--@@Data/ATA_INSTALL_DML.pks
--@@Data/ATA_INSTALL_DML.pkb
--
PROMPT ===============================================================================
PROMPT Toevoegen ATA Users
PROMPT ===============================================================================
@@Data/URP_Users.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen ATA Roles
PROMPT ===============================================================================
@@Data/URP_Roles.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Koppelen ATA Roles aan ATA Meta Users
PROMPT ===============================================================================
@@Data/URP_Roles2MetaUsers.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Kopieeren ATA User profielen naar ATA Users
PROMPT ===============================================================================
@@Data/URP_Users2MetaUsers.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen ATA Permissions
PROMPT ===============================================================================
-- alleen nodig voor php applicatie
@@Data/URP_Permissions.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen database connecties tbv functionele Queries
PROMPT ===============================================================================
@@Data/SQM_Connections.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen functionele Queries
PROMPT ===============================================================================
@@Data/rpt_ata_gm.dat
@@Data/rpt_gbaprsbasis.dat
@@Data/rpt_daily_checks.dat
@@Data/rpt_bronhouder.dat
@@Data/rpt_stelselcatalogus.dat
@@Data/rpt_referentie.dat
@@Data/rpt_lk_inkomend.dat
@@Data/rpt_lk_inkomend_bag.dat
@@Data/rpt_lk_uitgaand.dat
@@Data/rpt_la_uitgaand.dat
@@Data/rpt_guc.dat
@@Data/rpt_filters.dat
@@Data/rpt_bagdata.dat
@@Data/rpt_GBALandelijketabel.dat
--
PROMPT ===============================================================================
PROMPT Toevoegen ATA Menus
PROMPT ===============================================================================
@@Data/URP_Menus_Insert.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen ATA Menus Leafs
PROMPT ===============================================================================
@@Data/URP_MenuLeafs_Insert.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Linken ATA Menus Leafs aan rollen
PROMPT ===============================================================================
@@Data/URP_MenuLeafs_Link2Role.dat
--
PROMPT                                                                                  
PROMPT ===============================================================================  
PROMPT Toevoegen ATA Menus Leafs voor Rapporten
PROMPT ===============================================================================  
@@Data/URP_MenuLeafs4Reports.dat                                                         
--
PROMPT
PROMPT ===============================================================================
PROMPT Draaien journaling
PROMPT ===============================================================================
prompt begin abkr_journaling_maintenance.create_objects('URP%',true); end;
begin abkr_journaling_maintenance.create_objects('URP%',true); end;
/
prompt begin abkr_journaling_maintenance.create_objects('SQM%',true); end;
begin abkr_journaling_maintenance.create_objects('SQM%',true); end;
/
--
--
PROMPT
PROMPT ===============================================================================
PROMPT ATA tabellen granten
PROMPT ===============================================================================
@@Grants/ATA_GRANTS.sql
--
--
PROMPT
PROMPT ===============================================================================
PROMPT Drop tijdelijke packages
PROMPT ===============================================================================
--------prompt drop package Ata_Install_DML
--------drop package Ata_Install_DML
--------/
prompt drop package abkr_journaling_maintenance
--drop package abkr_journaling_maintenance
--/
PROMPT
PROMPT ===============================================================================
PROMPT Update DB-versie tabel (status)
PROMPT ===============================================================================
@@Data/DB_VERSIE.upd
--
commit;
--
set feedback on
--
spool off

