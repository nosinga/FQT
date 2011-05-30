set serverout on

exec  abkr_journaling.setuser('fit')

--
-- MAIN
--
-- hoofmenu toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.addmenu ( ''Fitnesse Test'' , ''MAIN'' , ''Fitnesse Test Beschrijving'' , ''70'', ''STATIC'')')
exec dbms_output.put_line(urp_utils.execute_select( 'select case when count(1) = 1 then ''SUCCES'' else ''FAILURE'' end from urp_roles where rolename = urp_menu_utils.menu2rolename ( ''Fitnesse Test'' , ''MAIN'')'))

-- hoofdmenu verwijderen
exec urp_utils.execute_call( 'urp_menu_utils.removemenu ( ''Fitnesse Test'' , ''MAIN'')')
exec dbms_output.put_line(urp_utils.execute_select( 'select case when count(1) = 0 then ''SUCCES'' else ''FAILURE'' end from urp_roles where rolename = urp_menu_utils.menu2rolename ( ''Fitnesse Test'' , ''MAIN'')'))


--
-- STATIC
--
-- hoofdmenu toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.addmenu ( ''Fitnesse Test'' , ''MAIN'' , ''Fitnesse Test Beschrijving'' , ''70'' , ''STATIC'' )')

-- menuleaf van type STATIC onder dat hoofdmenu toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.addmenuleaf ( ''Fitnesse Test Screen'' , ''STATIC'' , ''FITNESSE'' , ''Fitnesse Test'' ,''01'' , ''role_grt_admin'' )')
exec dbms_output.put_line(urp_utils.execute_select( 'select case when count(1) = 1 then ''SUCCES'' else ''FAILURE'' end from urp_permissions where value = urp_menu_utils.menuleaf2permission ( ''Fitnesse Test Screen'' , ''STATIC'')'))

--
-- URL
--
-- submenu van type URL onder hoofdmenu GUC Configuratie toevoegen 
exec urp_utils.execute_call( 'urp_menu_utils.addmenu ( ''Fitnesse Test URL'' , ''URL'' )')
-- menuleaf van type URL onder submenu toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.addmenuleaf ( ''Fitnesse Acceptance Test'' , ''URL'' , ''http://www.fitnesse.org'' , ''Fitnesse Test URL'' ,null , ''role_grt_admin'' )')

--
-- RPT
--
-- voeg rapport toe
exec urp_utils.execute_call('insert into sqm_queries (queryname, sqlstatement, short_description) values (''fitquery'',''select * from dual'',''fit'')')
-- voeg connectie toe
exec urp_utils.execute_call('urp_utils.insert_connection(''fit@ABKR'',''ata'')')
--
-- submenu van type RPT onder hoofdmenu Rapporten toevoegen 
exec urp_utils.execute_call( 'urp_menu_utils.addmenu ( ''Fitnesse Test RPT'' , ''RPT'' )')
-- menuleaf van type RPT onder submenu toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.addMenuLeafReport( ''fitquery'' , ''Fitnesse Test RPT'' , ''role_grt_admin'' , ''fit@ABKR'' )')

--
-- DOC
--
-- menuleaf van type DOC onder hoofdmenu Documenten toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.addmenuleaf ( p_menuleafname => ''FitnesseDocumenten'' , p_menuleaftype => ''DOC'' , p_rolename => ''role_grt_admin'' )')

--
-- DCA
--
-- menuleaf van type DCA aan role toevoegen
exec urp_utils.execute_call( 'urp_menu_utils.linkmenuleaf2role ( p_menuleafname => ''FitnesseDocumenten'' , p_menuleaftype => ''DCA'' , p_rolename => ''role_grt_admin'' )')

commit;

