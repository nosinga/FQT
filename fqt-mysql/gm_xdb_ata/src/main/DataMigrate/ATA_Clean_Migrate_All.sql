/**
|||------------------------------------------------------------------------
|||OMSCHRIJVING:
|||  Script voor het opruimen van objecten in ATA
|||
|||PARAMETERS:
|||
|||OPMERKINGEN:
|||
|||SUBVERSION INFO : DO NOT CHANGE!!!!
|||  Date     : $Date: 2011-02-22 08:13:53 +0100 (Tue, 22 Feb 2011) $
|||  Revision : $Revision: 30189 $
|||  Author   : $Author: nosinga $
|||  URL      : $URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/DataMigrate/ATA_Clean_Migrate_All.sql $
|||  ID       : $Id: ATA_Clean_Migrate_All.sql 30189 2011-02-22 07:13:53Z nosinga $
|||------------------------------------------------------------------------
**/
--
PROMPT ===============================================================================
PROMPT Partially Cleaning schema ATA
PROMPT ===============================================================================
-- ------------------------------------------------------------------------
-- HOOFDPROCEDURE
-- ------------------------------------------------------------------------
declare
--
  -- TABELLEN
  cursor c_tab
  is
    select 'drop table '||table_name||' cascade constraints purge' as ddl_statement
    from   user_tables
    where  table_name not like '%$%'
    and    table_name not like '%JN'
    and    table_name not like '%JNA'
  ;
  -- OBJECTS
  cursor c_obj
  is
    select 'drop '||object_type||' '||object_name                  as ddl_statement
    from   user_objects
    where  object_type in ( 'VIEW'
                          , 'SEQUENCE'
                          , 'SYNONYM'
                          , 'PACKAGE'
                          , 'PROCEDURE'
                          , 'FUNCTION'
                          , 'MATERIALIZED VIEW'
                          )
  ;
  -- TYPES
  cursor c_typ
  is
    select 'drop '||object_type||' '||object_name||' FORCE'        as ddl_statement
    from   user_objects
    where  object_type = 'TYPE'    
  ; 
  -- JOBS
  cursor c_job
  is
    select job
    from   user_jobs
  ; 
  -- Database Links
  cursor c_dbl
  is
    select 'drop database link '||db_link                          as ddl_statement
    from   user_db_links
  ;
  --
  -- Constanten --
  l_user_owner       constant    varchar2(30)   := 'ATA';
  --
  -- Overige variabelen --
  l_statement                    varchar2(4000);
  l_user                         varchar2(100);
  --
  -- Exceptions --
  le_wrong_user                  exception;
--
begin
--
  -- ------------------------------------------------------------------------
  -- Controleer dat het script onder de juiste user wordt gestart
  -- ------------------------------------------------------------------------
  select username into l_user from user_users ;
  if l_user != l_user_owner
  then
    raise le_wrong_user;
  end if;
  -- ------------------------------------------------------------------------
  -- Verwijderen jobs
  -- ------------------------------------------------------------------------
  dbms_output.put_line ( 'Drop jobs' );
  for r_job in c_job
  loop
    --
    dbms_job.remove ( r_job.job );
    --
  end loop; -- c_job --  
  -- ------------------------------------------------------------------------
  -- Verwijderen database links
  -- ------------------------------------------------------------------------
  dbms_output.put_line ( 'Drop database links' );
  for r_dbl in c_dbl
  loop
    --
    execute immediate ( r_dbl.ddl_statement );
    --
  end loop; -- c_dbl --  
  -- ------------------------------------------------------------------------
  -- Verwijderen types
  -- ------------------------------------------------------------------------
  dbms_output.put_line ( 'Drop types' );
  for r_typ in c_typ
  loop
    --
    execute immediate ( r_typ.ddl_statement );
    --
  end loop; -- c_typ --  
  -- ------------------------------------------------------------------------
  -- Verwijderen objecten
  -- ------------------------------------------------------------------------
  dbms_output.put_line ( 'Drop objecten' );
  for r_obj in c_obj
  loop
    --
    execute immediate ( r_obj.ddl_statement );
    --
  end loop; -- c_obj --  
  -- ------------------------------------------------------------------------
  -- Verwijderen tabellen
  -- ------------------------------------------------------------------------
  dbms_output.put_line ( 'Drop tabellen' );
  for r_tab in c_tab
  loop
    --
    execute immediate ( r_tab.ddl_statement );
    --
  end loop; -- c_tab --  
--
exception
--
  when le_wrong_user
  then
    dbms_output.put_line('Verkeerde user, Verwachte user: '||l_user_owner||' ; Huidige user:' ||l_user);
    raise;
--
end;
/
--
--
