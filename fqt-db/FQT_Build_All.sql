/**
|||-----------------------------------------------------------------------
|||OMSCHRIJVING:
|||  
|||
|||PARAMETERS:
|||
|||OPMERKINGEN:
|||
|||SUBVERSION INFO : DO NOT CHANGE!!!!
|||  $Date: 2011-05-11 17:20:19 +0200 (Wed, 11 May 2011) $                       
|||  $Revision: 6016 $                   
|||  $Author: nanne $                     
|||  $URL: svn://store01/fqt-db/FQT_Build_All.sql $                        
|||  $ID: $                         
|||-----------------------------------------------------------------------
**/

spool fqt_build_all.log
set define off
--
set feedback off
--
PROMPT ===============================================================================
PROMPT Schoonmaken Aalle data wordt verwijderd               
PROMPT ===============================================================================
--@@DataMigrate/FQT_Clean_Migrate_All.sql
@@FQT_Clean_All.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Tabellen
PROMPT ===============================================================================
@@Tables/FQT_tables.sql
@@Tables/URP_tables.sql
@@Tables/SQM_tables.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Migreren Tabel Data
PROMPT ===============================================================================
--@@DataMigrate/URP_tables_Migrate.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Sequences
PROMPT ===============================================================================
@@Sequences/FQT_sequence.sql
@@Sequences/URP_sequence.sql
@@Sequences/SQM_sequence.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Ophogen Sequence
PROMPT ===============================================================================
--@@DataMigrate/URP_sequence_Migrate.sql
--

--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Constraints
PROMPT ===============================================================================
@@Constraints/FQT_constraints.sql
@@Constraints/SQM_constraints.sql
@@Constraints/URP_constraints.sql

PROMPT ===============================================================================
PROMPT Aanmaken types
PROMPT ===============================================================================
@@Types/PIPELINED_TYPES.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken package specificaties
PROMPT ===============================================================================
@@Packages/FQT_UTILS.pks
@@Packages/FQT_REPORTS.pks
@@Packages/URP_UTILS.pks
@@Packages/URP_USER_UTILS.pks
@@Packages/URP_MENU_UTILS.pks
@@Packages/SQM_UTILS.pks
--
@@Packages_commons/ABKR_UTILS_GEN_DDL.pks
@@Packages_commons/ABKR_JOURNALING.pks
@@Packages_commons/ABKR_JOURNALING_MAINTENANCE.pks

PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Table Triggers
PROMPT ===============================================================================
@@Triggers/FQT_triggers.sql
@@Triggers/URP_triggers.sql
@@Triggers/SQM_triggers.sql

PROMPT
PROMPT ===============================================================================
PROMPT Oracle Users aan URP_USERS plakken
PROMPT ===============================================================================
@@Views/URP_users_view.sql
@@Synonyms/URP_synonyms.sql
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Views
PROMPT ===============================================================================
@@Views/URP_views.sql
@@Views/URP_menu_views.sql
@@Views/URP_user_menu_views.sql
@@Views/URP_user_reports_view.sql
@@Views/URP_user_urls_view.sql
--
--
PROMPT
PROMPT ===============================================================================
PROMPT Aanmaken Synonyms
PROMPT ===============================================================================
--  @@Views/URP_synonyms.sql
--
--
PROMPT ===============================================================================
PROMPT Aanmaken package bodies
PROMPT ===============================================================================
@@Packages/FQT_UTILS.pkb
@@Packages/FQT_REPORTS.pkb
@@Packages/URP_UTILS.pkb
@@Packages/URP_USER_UTILS.pkb
@@Packages/URP_MENU_UTILS.pkb
@@Packages/SQM_UTILS.pkb
@@Packages_commons/ABKR_UTILS_GEN_DDL.pkb
@@Packages_commons/ABKR_JOURNALING.pkb
@@Packages_commons/ABKR_JOURNALING_MAINTENANCE.pkb

PROMPT ===============================================================================
PROMPT Toevoegen ATA Parameters
PROMPT ===============================================================================
@@Data/ATA_Parameters.dat

PROMPT ===============================================================================
PROMPT Toevoegen FQT Users
PROMPT ===============================================================================
@@Data/URP_Users.dat

PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen FQT Roles
PROMPT ===============================================================================
@@Data/URP_Roles.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Koppelen FQT Roles aan FQT Meta Users
PROMPT ===============================================================================
@@Data/URP_Roles2MetaUsers.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Kopieeren FQT User profielen naar FQT Users
PROMPT ===============================================================================
@@Data/URP_Users2MetaUsers.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen FQT Permissions
PROMPT ===============================================================================
@@Data/URP_Permissions.dat

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
@@Data/rpt_referentie.dat
--
PROMPT ===============================================================================
PROMPT Toevoegen FQT Menus
PROMPT ===============================================================================
@@Data/URP_Menus_Insert.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Toevoegen FQT Menus Leafs
PROMPT ===============================================================================
@@Data/URP_MenuLeafs_Insert.dat
--
PROMPT
PROMPT ===============================================================================
PROMPT Linken FQT Menus Leafs aan rollen
PROMPT ===============================================================================
@@Data/URP_MenuLeafs_Link2Role.dat
--
PROMPT                                                                                  
PROMPT ===============================================================================  
PROMPT Toevoegen FQT Menus Leafs voor Rapporten
PROMPT ===============================================================================  
@@Data/URP_MenuLeafs4Reports.dat                                                         
--
PROMPT
PROMPT ===============================================================================
PROMPT Draaien journaling
PROMPT ===============================================================================
prompt begin abkr_journaling_maintenance.create_objects('FQT%',true); end;
begin abkr_journaling_maintenance.create_objects('FQT%',true); end;
/
prompt begin abkr_journaling_maintenance.create_objects('URP%',true); end;
begin abkr_journaling_maintenance.create_objects('URP%',true); end;
/
prompt begin abkr_journaling_maintenance.create_objects('SQM%',true); end;
begin abkr_journaling_maintenance.create_objects('SQM%',true); end;
/
prompt begin abkr_journaling_maintenance.create_objects('ATA_PARAMETERS',true); end;
begin abkr_journaling_maintenance.create_objects('SQM%',true); end;
/
--
--
PROMPT
PROMPT ===============================================================================
PROMPT Drop tijdelijke packages
PROMPT ===============================================================================
prompt drop package abkr_journaling_maintenance
--drop package abkr_journaling_maintenance
--/
--
commit;
--
@grantsyn/grantsyn.sql
set feedback on
--
spool off

