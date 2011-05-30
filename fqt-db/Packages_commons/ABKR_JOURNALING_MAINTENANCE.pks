CREATE OR REPLACE package ABKR_journaling_maintenance
is
  -- -------------------------------------------------------------------
  -- SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date         constant     varchar(4000) := '$Date: 2011-05-11 14:08:44 +0200 (Wed, 11 May 2011) $';
  s_spec_revision     constant     varchar(4000) := '$Revision: 6014 $';
  s_spec_author       constant     varchar(4000) := '$Author: nanne $';
  s_spec_url          constant     varchar(4000) := '$URL: svn://store01/fqt-db/Packages_commons/ABKR_JOURNALING_MAINTENANCE.pks $';
  s_spec_id           constant     varchar(4000) := '$Id: ABKR_JOURNALING_MAINTENANCE.pks 6014 2011-05-11 12:08:44Z nanne $';
  -- SUBVERSION INFO
  -- -------------------------------------------------------------------
  --
  g_package_name                   constant       varchar2(35) default 'ABKR_JOURNALING_MAINTENANCE';
  type oraversion_rec_type         is record ( oracle_version  varchar2(100) );
  type oraversion_ref_csr_type     is ref cursor return oraversion_rec_type;
  --
  function  ora_info       return varchar2;
  --
  procedure create_objects ( p_table_name           in     varchar2 := null
                           , p_replace              in     boolean  := false
                           , p_with_archive         in     boolean  := true
                           );
  -- For all tables like <p_table_name> create a journal-table and an after-row trigger.
  -- <p_replace> - true  - drop any existing journal-table ("<p_tablename>_JN")
  --              false - fail if journal-table already exists
  -- <p_with_archive> - true - if journal-table exists and <p_replace>, copy its contents
  --                           into an archive table ("ZZ_<p_table_name>_J01", "_J02", etc)
  --                  - false - don't copy contents before dropping
  --
  procedure drop_archive  ( p_table_name            in     varchar2
                          , p_purge                 in     boolean  := true
                          );
  -- For all tables like <p_table_name>, remove any existing archive-table
  -- <p_purge> - purge dropped table from recyclebin
  --
end abkr_journaling_maintenance;
/

