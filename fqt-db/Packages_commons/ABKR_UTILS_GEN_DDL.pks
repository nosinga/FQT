CREATE OR REPLACE package abkr_utils_gen_ddl
is
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date       constant varchar (4000) := '$Date: 2011-05-11 14:08:44 +0200 (Wed, 11 May 2011) $';
  s_spec_revision   constant varchar (4000) := '$Revision: 6014 $';
  s_spec_author     constant varchar (4000) := '$Author: nanne $';
  s_spec_url        constant varchar (4000) := '$URL: svn://store01/fqt-db/Packages_commons/ABKR_UTILS_GEN_DDL.pks $';
  s_spec_id         constant varchar (4000) := '$Id: ABKR_UTILS_GEN_DDL.pks 6014 2011-05-11 12:08:44Z nanne $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------

    /* ******************************************************************************* */
    /* FUNCTION ORA_INFO                                                               */
    /* ******************************************************************************* */
    function ora_info
    return varchar2
    ;
    -- -----------------------------------------------------------------------------
    -- Procedure : add line to statement
    -- -----------------------------------------------------------------------------
    procedure add_line                  ( px_statement           in out varchar2
                                        , p_line                 in     varchar2
                                        , p_nl                   in     boolean  default true
                                        )
    ;
    --
    -- -----------------------------------------------------------------------------
    -- Procedure : EXECUTE_STMNT
    -- -----------------------------------------------------------------------------
    procedure execute_stmnt             ( p_statement            in     varchar2
                                        , p_create_script        in     boolean  default false
                                        , p_stop_on_error        in     boolean  default false )
    ;
    -- -----------------------------------------------------------------------------
    -- Functie : TABLE2ALIAS
    -- -----------------------------------------------------------------------------
    function table2alias             ( p_table_name             in     varchar2 )
    return varchar2
    ;
end abkr_utils_gen_ddl;
/

