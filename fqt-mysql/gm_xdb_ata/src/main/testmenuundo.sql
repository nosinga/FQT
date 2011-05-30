--
--Om ook met de ATA tool het resultaat te zien, draai dan onderstaande deze file niet
--

set serverout on

exec  abkr_journaling.setuser('fit')

-- 
-- Afonden van test
-- Alles weer terugbrengen in oorspronkelijke staat
-- MAIN en STATIC
exec urp_utils.execute_call( 'urp_menu_utils.removemenu ( ''Fitnesse Test'' , ''MAIN'', ''yes'')')
exec dbms_output.put_line(urp_utils.execute_select( 'select case when count(1) = 0 then ''SUCCES'' else ''FAILURE'' end from urp_roles where rolename = urp_menu_utils.menu2rolename ( ''Fitnesse Test'' , ''MAIN'')'))

-- URL
-- submenu verwijderen van type URL onder hoofdmenu GUC Configuratie 
exec urp_utils.execute_call( 'urp_menu_utils.removemenu ( ''Fitnesse Test URL'' , ''URL'', ''yes'')')

-- RPT
-- verwijder rapport
exec urp_utils.execute_call('delete sqm_queries where queryname = ''fitquery'' ')
-- verwijder connectie
exec urp_utils.execute_call('delete sqm_connections where connectionname = ''fit@ABKR'' ')
-- submenu verwijderen van type RPT onder hoofdmenu Rapporten
exec urp_utils.execute_call( 'urp_menu_utils.removemenu ( ''Fitnesse Test RPT'' , ''RPT'' , ''yes'')')

-- DOC
-- submenu verwijderen van type URL onder hoofdmenu GUC Configuratie 
exec urp_utils.execute_call( 'urp_menu_utils.removemenu ( ''FitnesseDocumenten'' , ''DOC'', ''yes'')')

-- DCA
-- submenu verwijderen van type URL onder hoofdmenu GUC Configuratie 
exec urp_utils.execute_call( 'urp_menu_utils.removemenu ( ''FitnesseDocumenten'' , ''DCA'', ''yes'')')



commit;
