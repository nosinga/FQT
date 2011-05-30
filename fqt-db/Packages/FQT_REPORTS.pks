CREATE OR REPLACE package fqt_reports
IS
--
  /**
  |||------------------------------------------------------------------------
  |||NAAM:
  |||  FQT_REPORTS
  |||
  |||OMSCHRIJVING:
  |||  Hoofdpackage met alle procedures/functies t.b.v. uitvoeren van queries
  |||
  |||OPMERKINGEN:
  |||------------------------------------------------------------------------
  **/
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date         constant     varchar(4000) := '$Date: 2011-04-22 14:16:27 +0200 (Fri, 22 Apr 2011) $';
  s_spec_revision     constant     varchar(4000) := '$Revision: 5985 $';
  s_spec_author       constant     varchar(4000) := '$Author: nanne $';
  s_spec_url          constant     varchar(4000) := '$URL: svn://store01/fqt-db/Packages/FQT_REPORTS.pks $';
  s_spec_id           constant     varchar(4000) := '$Id: FQT_REPORTS.pks 5985 2011-04-22 12:16:27Z nanne $';
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- ------------------------------------------------------------------------
  -- Constanten
  -- ------------------------------------------------------------------------
  g_package_naam                constant       varchar2(30)          := 'FQT_REPORTS';
--
  -- ------------------------------------------------------------------------
  -- Functies/Procedures
  -- ------------------------------------------------------------------------
  function  ora_info                     return varchar2
  ;
  function query_dependencies
  return query_dependencies_tab pipelined
    /**
    |||------------------------------------------------------------------------
    |||OMSCHRIJVING:
    |||  Pipelined functie om de afhankelijkheden van queries te bepalen
    |||
    |||PARAMETERS:
    |||  Retourneert de onderstaande attributen
    |||  - queryname          varchar2(100)
    |||  - called_by          clob
    |||  - calling            clob
    |||  - calling_missing    clob
    |||
    |||OPMERKINGEN:
    |||  - queryname          Naam van de query
    |||  - called_by          Alle querynamen die de query aanroepen
    |||  - calling            Alle querynamen die de query zelf aanroept
    |||  - calling_missing    Alle querynamen die de query zelf aanroept, maar die niet (meer) zodanig als query aanwezig zijn
    |||------------------------------------------------------------------------
    **/
  ;
procedure insertReportConnection
            (p_sql_id  in number
            ,p_con_id  in number
            ,p_menu_id in number
            ,p_role_id in number
            ,p_orderby in varchar2
            );

procedure updateReportConnection
            (p_pms_id  in number
            ,p_sql_id  in number
            ,p_con_id  in number
            ,p_menu_id in number
            ,p_role_id in number
            ,p_orderby in varchar2
            );
function search(p_search in varchar2, p_table_name in varchar2, p_id_name in varchar2 default 'id')
return   varchar2
;
--
end fqt_reports; 
/

