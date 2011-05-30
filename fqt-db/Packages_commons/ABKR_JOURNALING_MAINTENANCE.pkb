CREATE OR REPLACE package body ABKR_journaling_maintenance
is
  -- SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date     constant varchar(4000) := '$Date: 2011-05-11 14:08:44 +0200 (Wed, 11 May 2011) $';
  s_body_revision constant varchar(4000) := '$Revision: 6014 $';
  s_body_author   constant varchar(4000) := '$Author: nanne $';
  s_body_url      constant varchar(4000) := '$URL: svn://store01/fqt-db/Packages_commons/ABKR_JOURNALING_MAINTENANCE.pkb $';
  s_body_id       constant varchar(4000) := '$Id: ABKR_JOURNALING_MAINTENANCE.pkb 6014 2011-05-11 12:08:44Z nanne $';
  -- SUBVERSION INFO
-- -------------------------------------------------------------------
  procedure wl (  px_statement           in out varchar2
                , p_line                 in     varchar2
                , p_nl                   in     boolean  default true
                )
  is
  begin
    abkr_utils_gen_ddl.add_line
               ( px_statement => px_statement
               , p_line       => p_line
               , p_nl         => p_nl
               );
  end wl;
-- -------------------------------------------------------------------
  function tableExists( p_table_name in varchar2 )
  return boolean
  is
  -- Find out if table <p_table_name> exists
    l_null varchar2(1);
  begin
    select null
    into l_null
    from user_tables
    where table_name = p_table_name;
    --
    return true;
  exception
    when no_data_found then
      return false;
  end tableExists;
-- -------------------------------------------------------------------
  function triggerExists( p_trigger_name in varchar2, p_table_name in varchar2 )
  return boolean
  is
  -- Find out if trigger <p_trigger_name> exists on another table
    l_null varchar2(1);
  begin
    select null
    into l_null
    from user_triggers
    where trigger_name  = p_trigger_name
    and   table_name   != p_table_name;
    --
    return true;
  exception
    when no_data_found then
      return false;
  end triggerExists;
-- -------------------------------------------------------------------
  function ora_info
    return varchar2
  is
  begin
    return 's_spec_id  : '||s_spec_id  ||chr(10)||
           's_spec_url : '||s_spec_url ||chr(10)||
           's_body_id  : '||s_body_id  ||chr(10)||
           's_spec_url : '||s_body_url
           ;
  end ora_info;
-- -------------------------------------------------------------------
  procedure create_objects             ( p_table_name           in     varchar2
                                       , p_replace              in     boolean  := false
                                       , p_with_archive         in     boolean  := true
                                       )
  is
  -- For all tables like <p_table_name> create a journal-table and an after-row trigger.
  -- <p_replace> - true  - drop any existing journal-table ("<p_tablename>_JN")
  --              false - fail if journal-table already exists
  -- <p_with_archive> - true - if journal-table exists and <p_replace>, copy its contents
  --                           into an archive table ("ZZ_<p_table_name>_J01", "_J02", etc)
  --                  - false - don't copy contents before dropping
  --
    cursor c_col ( b_table_name    in varchar2 )
    is
      select   col.column_name
      ,        col.data_type
      ,        col.data_length
      ,        col.data_precision
      ,        col.data_scale
      ,        col.nullable
      ,        col.data_default
      from     user_tab_columns col
      where    col.table_name = b_table_name
      order by col.column_id
    ;
    l_statement    varchar2(32000);
    l_trigger_name user_triggers.trigger_name%type;
  -- -----------------------------------------------------------------------------
    function lf_archivename (p_table_name in varchar2)
      return varchar2
    is
    -- Create the name for an 'archive' table for <p_table_name>.
    -- An archive name defaults to 'ZZ_<p_tablename>_J01'.
    -- If '.._J01' already exists, return '.._J02', etc.
    -- If the archive tablename is longer than 30 characters, trim
    -- the <p_table_name> part.
    --
      l_default user_tables.table_name%type;
      l_next    user_tables.table_name%type;
    begin
      -- If no archive tables exists, this is the default name
      -- 30 (max tablename length) - 3 ('ZZ_') - 4 ('_Jxx') = 23
      l_default := 'ZZ_' || substr(p_table_name,1,23) || '_J01';
      --
      -- Select the highest existing archive table and increase the sequence
      -- part of its name
      select max( substr(table_name, 1, length(table_name) -2 ) ||
                  ltrim( to_char( to_number( substr( table_name, -2 )) + 1, 'B09' )))
      into l_next
      from user_tables
      where table_name like substr( l_default, 1, length(l_default) -2 ) || '__';
      --
      return nvl( l_next, l_default );
    end lf_archivename;
  -- -----------------------------------------------------------------------------
  begin
    for r_tab in ( select table_name
                   from   user_tables
                   where  table_name     like upper( p_table_name )
                   and    table_name not like '%JN'
                   and    table_name not like '%JNA'
                   and    table_name not like '%J__'
                   and    table_name not in ( 'DB_VERSIE' )
                   order by 1 ) loop
      -- -----------------------------------------------------------------------------
      -- Deal with existing journaling table
      -- -----------------------------------------------------------------------------
      if tableExists( r_tab.table_name || '_JN' ) then
        -- An existing journaling table exists
        if p_replace then
          -- We're going to drop and recreate it
          if p_with_archive then
            -- After the contents have been copied into a archiving table
            l_statement := 'create table '
                           || lf_archivename (r_tab.table_name)
                           || ' as select * from '
                           || r_tab.table_name
                           || '_jn';
            abkr_utils_gen_ddl.execute_stmnt( l_statement, p_stop_on_error => true );
          end if;
          l_statement := 'drop table '||r_tab.table_name||'_jn';
          abkr_utils_gen_ddl.execute_stmnt( l_statement, p_stop_on_error => true );
        else
          raise_application_error( -20001, 'A journaling table already exists for ' || r_tab.table_name );
        end if;
      end if;
      -- -----------------------------------------------------------------------------
      -- Deal with existing journaling trigger
      -- -----------------------------------------------------------------------------
      l_trigger_name := 'ABKR_' ||
                        abkr_utils_gen_ddl.table2alias( p_table_name => r_tab.table_name ) ||
                        '_JN_TRG';
      if triggerExists( l_trigger_name , r_tab.table_name) then
        raise_application_error( -20002, 'A journaling trigger ' || l_trigger_name || ' already exists' );
      end if;
      -- -----------------------------------------------------------------------------
      -- Create journaling table
      -- -----------------------------------------------------------------------------
      l_statement := null;
      wl ( l_statement,  'create table '||r_tab.table_name||'_jn' );
      wl ( l_statement,  '( JN_TIMESTAMP date         default sysdate not null' );
      wl ( l_statement,  ', JN_USER      varchar2(30) default user    not null' );
      wl ( l_statement,  ', JN_ACTION    varchar2(3)                  not null' );
      wl ( l_statement,  ', JN_LABEL     varchar2(30)' );
      --
      -- Looping columns : add kolom aan create statement journaling table
      for r_col in c_col ( r_tab.table_name ) loop
        wl ( l_statement, ', '||r_col.column_name||' '||r_col.data_type );
        if ( r_col.data_type = 'NUMBER' ) then
          if ( r_col.data_precision is not null ) then
            wl ( l_statement,  '('||r_col.data_precision, false );
            if ( r_col.data_scale is not null ) then
              wl ( l_statement,  ','||r_col.data_scale, false );
            end if;
            wl ( l_statement,  ')', false );
          end if;
        elsif ( r_col.data_type LIKE '%CHAR%'  ) then
          wl ( l_statement,  '('||r_col.data_length||')', false );
        end if;
        --
        -- DO NOT CONSTRAIN THE JOURNAL-TABLE
        --    if ( r_col.data_default is not null ) then
        --      v_statement := v_statement || ' default ' || r_col.data_default;
        --    end if;
        --    if ( r_col.nullable = 'Y' ) then
        --      v_statement := v_statement || ' not null ';
        --    end if;
      --
      end loop; -- r_col --
      wl ( l_statement,  ')' );
      abkr_utils_gen_ddl.execute_stmnt ( l_statement, p_stop_on_error => true );
      -- -----------------------------------------------------------------------------
      -- Initial filling of journaling table
      -- -----------------------------------------------------------------------------
      l_statement := null;
      wl ( l_statement,  'insert into '||r_tab.table_name||'_jn' );
      wl ( l_statement,  'select sysdate' );
      wl ( l_statement,  ',      user' );
      wl ( l_statement,  ',      ''INS''' );
      wl ( l_statement,  ',      ''INITIAL''' );
      --
      -- Looping columns : add kolom aan insert statement
      for r_col in c_col ( r_tab.table_name )
      loop
        wl ( l_statement,  ',      '||r_col.column_name );
      end loop; -- r_col --
      --
      wl ( l_statement, 'from   '||r_tab.table_name );
      abkr_utils_gen_ddl.execute_stmnt( l_statement );
      -- -----------------------------------------------------------------------------
      -- Create statement journaling trigger
      -- -----------------------------------------------------------------------------
      l_statement := null;
      wl ( l_statement,  'create or replace trigger ' || l_trigger_name );
      wl ( l_statement,  'AFTER INSERT or UPDATE or DELETE' );
      wl ( l_statement,  'ON '||r_tab.table_name||' REFERENCING NEW AS NEW OLD AS OLD' );
      wl ( l_statement,  'for EACH ROW' );
      wl ( l_statement,  'DECLARE' );
      wl ( l_statement,  '  r_row         '||r_tab.table_name||'_JN%rowtype;' );
      wl ( l_statement,  'begin' );
      wl ( l_statement,  '  r_row.JN_TIMESTAMP := sysdate;' );
      wl ( l_statement,  '  r_row.JN_USER      := abkr_journaling.getuser;' );
      wl ( l_statement,  '  if ( inserting )' );
      wl ( l_statement,  '  then' );
      wl ( l_statement,  '    r_row.JN_ACTION := ''INS'';' );
      --
      -- Looping columns : add kolom aan if-INS statement trigger
      for r_col in c_col( r_tab.table_name )
      loop
        wl ( l_statement, '    r_row.'||r_col.column_name||' := :new.'||r_col.column_name||';' );
      end loop;
      --
      wl ( l_statement,  '  elsif ( updating )' );
      wl ( l_statement,  '  then' );
      wl ( l_statement,  '    r_row.JN_ACTION := ''UPD'';' );
      --
      -- Looping columns : add kolom aan if-UPD statement trigger
      for r_col in c_col ( r_tab.table_name )
      loop
        wl ( l_statement, '    r_row.'||r_col.column_name||' := :new.'||r_col.column_name||';' );
      end loop;
      --
      wl ( l_statement,  '  elsif ( deleting )' );
      wl ( l_statement,  '  then' );
      wl ( l_statement,  '    r_row.JN_ACTION := ''DEL'';' );
      --
      -- Looping columns : add kolom aan if-DEL statement trigger
      for r_col in c_col ( r_tab.table_name )
      loop
        wl ( l_statement, '    r_row.'||r_col.column_name||' := :old.'||r_col.column_name||';' );
      end loop;
      --
      wl ( l_statement,  '  end if;' );
      wl ( l_statement,  '  insert into '||r_tab.table_name||'_JN' );
      wl ( l_statement,  '  ( JN_TIMESTAMP' );
      wl ( l_statement,  '  , JN_USER' );
      wl ( l_statement,  '  , JN_ACTION' );
      --
      -- Looping columns : add kolom aan INSERT kolom statement trigger
      for r_col IN c_col ( r_tab.table_name )
      loop
        wl ( l_statement, '  , '||r_col.column_name );
      end loop;
      --
      wl ( l_statement,  '  )' );
      wl ( l_statement,  '  values' );
      wl ( l_statement,  '  ( r_row.JN_TIMESTAMP' );
      wl ( l_statement,  '  , r_row.JN_USER' );
      wl ( l_statement,  '  , r_row.JN_ACTION' );
      --
      -- Looping columns : add kolom aan INSERT values statement trigger
      for r_col in c_col( r_tab.table_name )
      loop
        wl ( l_statement, '  , r_row.'||r_col.column_name );
      end loop;
      --
      wl ( l_statement,  '  );' );
      wl ( l_statement,  'end;' );
      abkr_utils_gen_ddl.execute_stmnt (l_statement);
      --
    end loop;
  end create_objects;
-- -------------------------------------------------------------------
  procedure drop_archive  ( p_table_name            in     varchar2
                          , p_purge                 in     boolean  := true
                          )
  is
    l_statement varchar2(100);
  begin
    for r_tab in ( select table_name
                   from   user_tables
                   where  table_name     like upper( p_table_name )
                   order by 1 )
    loop
      for r_archive_tab in (select table_name
                            from   user_tables
                            where  table_name like 'ZZ_'||substr(r_tab.table_name,1,23)||'_J__'
                            order by 1)
      loop
        l_statement := 'drop table ' || r_archive_tab.table_name;
        if p_purge
        then
          l_statement := l_statement || ' purge';
        end if;
        abkr_utils_gen_ddl.execute_stmnt (l_statement);
      end loop;
    end loop;
  end drop_archive
  ;
end abkr_journaling_maintenance;
/

