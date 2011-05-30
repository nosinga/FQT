CREATE OR REPLACE package ABKR_JOURNALING
is
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date         constant     varchar(4000) := '$Date: 2011-05-11 14:08:44 +0200 (Wed, 11 May 2011) $';
  s_spec_revision     constant     varchar(4000) := '$Revision: 6014 $';
  s_spec_author       constant     varchar(4000) := '$Author: nanne $';
  s_spec_url          constant     varchar(4000) := '$URL: svn://store01/fqt-db/Packages_commons/ABKR_JOURNALING.pks $';
  s_spec_id           constant     varchar(4000) := '$Id: ABKR_JOURNALING.pks 6014 2011-05-11 12:08:44Z nanne $';
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- --------------------------------------------------------------------------------
  -- Constanten
  -- -------------------------------------------------------------------------------
  g_package_name                   constant       varchar2(35) default 'ABKR_JOURNALING';
--
  -- -------------------------------------------------------------------------------
  -- Types
  -- -------------------------------------------------------------------------------
  type oraversion_rec_type         is record ( oracle_version  varchar2(100) );
  --
  type oraversion_ref_csr_type     is ref cursor return oraversion_rec_type;
--
  -- -------------------------------------------------------------------------------
  -- Globals
  -- -------------------------------------------------------------------------------
  g_user                           varchar2(100);
--
  -- ------------------------------------------------------------------------------- --
  -- Functies/Procedures                                                             --
  -- ------------------------------------------------------------------------------- --
  function  ora_info                     return varchar2;
  function  getUser                      return varchar2;
  function  setuser                    ( p_username             in     varchar2 )
                                         return varchar2;
  --
  procedure setuser                    ( p_username             in     varchar2 );
--
end abkr_journaling;
/

