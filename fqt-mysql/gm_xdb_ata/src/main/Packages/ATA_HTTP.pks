PROMPT CREATE OR REPLACE PACKAGE ATA_HTTP
CREATE OR REPLACE package ata_http
is
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date         constant     varchar(4000) := '$Date: 2010-07-02 08:34:38 +0200 (Fri, 02 Jul 2010) $';
  s_spec_revision     constant     varchar(4000) := '$Revision: 20459 $';
  s_spec_author       constant     varchar(4000) := '$Author: nosinga $';
  s_spec_url          constant     varchar(4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Packages/ATA_HTTP.pks $';
  s_spec_id           constant     varchar(4000) := '$Id: ATA_HTTP.pks 20459 2010-07-02 06:34:38Z nosinga $';
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- ------------------------------------------------------------------------------- --
  -- Functies/Procedures                                                             --
  -- ------------------------------------------------------------------------------- --
 function  ora_info                     return varchar2;
    function response (
     p_url                in   varchar2 default 'http://www.google.com'
,    p_redirect_href_http in   varchar2 default null
,    p_proxy              in   varchar2 default null
,    p_no_proxy_domains   in   varchar2 default null
  )
    return clob;
end ata_http; 
/

