CREATE OR REPLACE package body abkr_utils_gen_ddl
is
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date       constant varchar (4000) := '$Date: 2011-05-11 14:08:44 +0200 (Wed, 11 May 2011) $';
  s_body_revision   constant varchar (4000) := '$Revision: 6014 $';
  s_body_author     constant varchar (4000) := '$Author: nanne $';
  s_body_url        constant varchar (4000) := '$URL: svn://store01/fqt-db/Packages_commons/ABKR_UTILS_GEN_DDL.pkb $';
  s_body_id         constant varchar (4000) := '$Id: ABKR_UTILS_GEN_DDL.pkb 6014 2011-05-11 12:08:44Z nanne $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------

  /* ******************************************************************************* */
  /* FUNCTION ORA_INFO                                                               */
  /* ******************************************************************************* */
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

    -- -----------------------------------------------------------------------------
    -- Procedure : add line to statement
    -- -----------------------------------------------------------------------------
    procedure add_line                  ( px_statement           in out varchar2
                                        , p_line                 in     varchar2
                                        , p_nl                   in     boolean
                                        )
    is
    begin
    --
      if ( p_nl )
       then
        px_statement := px_statement||chr(10)||p_line;
      else
        px_statement := px_statement||p_line;
      end if;
    --
    end add_line;
    --
    -- -----------------------------------------------------------------------------
    -- Procedure : EXECUTE_STMNT
    -- -----------------------------------------------------------------------------
    procedure execute_stmnt             ( p_statement            in     varchar2
                                        , p_create_script        in     boolean
                                        , p_stop_on_error        in     boolean )
    is
    --
      l_statement varchar2(10000) := p_statement;
    --
    begin
    --
      if ( p_create_script )
      then
      --
        while ( instr( l_statement, chr(10) ) > 0 )
        loop
          --
          dbms_output.put_line( substr( l_statement, 1, instr( l_statement, chr(10) ) - 1 ) );
          l_statement := substr( l_statement, instr( l_statement, chr(10) )  + 1 );
          --
        end loop;
        --
        dbms_output.put_line( l_statement||chr(10)||'/' );
      --
      else
      --
        begin
          execute immediate( l_statement );
        exception
        --
          when others
          then
            dbms_output.put_line( substr( 'Fout in'||chr(10)||p_statement, 1, 255 ) );
            dbms_output.put_line( substr( SQLERRM, 1, 255 ) );
            if ( p_stop_on_error )
            then
              raise;
            end if;
        end;
      end if;
      --
    end execute_stmnt;
    -- -----------------------------------------------------------------------------
    -- Functie : TABLE2ALIAS
    -- -----------------------------------------------------------------------------
    function table2alias             ( p_table_name             in     varchar2 )
    return varchar2
    is
    --
      cursor c_cons(b_table_name varchar2)
      is
        select constraint_name
        from   user_constraints
        where  table_name      = upper( b_table_name )
        and    constraint_type = 'P'
      ;
      -- Declaratie variabelen
      l_return                          varchar2(100) default p_table_name ;
      l_constraint                      varchar2(30);
    --
    begin
    --
      open  c_cons( p_table_name );
      fetch c_cons into l_constraint;
      close c_cons;
      --
      if ( l_constraint is not null )
      then
        l_return :=  substr(rtrim( l_constraint, '_PK' ),1,23);
      end if;
      --
      return( l_return );
      --
    end table2alias;
    --

  --
end abkr_utils_gen_ddl;
/

