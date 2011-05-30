PROMPT CREATE OR REPLACE PACKAGE ATA_REPORTS
create or replace package ata_reports
IS
--
  /**
  |||------------------------------------------------------------------------
  |||NAAM:
  |||  ATA_REPORTS
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
  s_spec_date         constant     varchar(4000) := '$Date: 2010-11-04 11:28:22 +0100 (Thu, 04 Nov 2010) $';
  s_spec_revision     constant     varchar(4000) := '$Revision: 25877 $';
  s_spec_author       constant     varchar(4000) := '$Author: mcopier $';
  s_spec_url          constant     varchar(4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Packages/ATA_REPORTS.pks $';
  s_spec_id           constant     varchar(4000) := '$Id: ATA_REPORTS.pks 25877 2010-11-04 10:28:22Z mcopier $';
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- ------------------------------------------------------------------------
  -- Constanten
  -- ------------------------------------------------------------------------
  g_package_naam                constant       varchar2(30)          := 'ATA_REPORTS';
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
--
end ata_reports;
/