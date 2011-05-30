PROMPT CREATE OR REPLACE PACKAGE ATA_UTILS
CREATE OR REPLACE package ata_utils
is
/**
**/-----------------------------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------------------------------------
--SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date       constant varchar (4000) := '$Date: 2010-02-04 09:38:13 +0100 (Thu, 04 Feb 2010) $';
  s_spec_revision   constant varchar (4000) := '$Revision: 14250 $';
  s_spec_author     constant varchar (4000) := '$Author: mcopier $';
  s_spec_url        constant varchar (4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Packages/ATA_UTILS.pks $';
  s_spec_id         constant varchar (4000) := '$Id: ATA_UTILS.pks 14250 2010-02-04 08:38:13Z mcopier $';

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----
  function ora_info
    return varchar2;

  function clob_pieces (p_i in integer)
/**
   The functions clob_pieces and clob_pieces_count
   are constructed to support constructions in php
   where a clob can not be returned (in a rowset)
--
   A typical example is the page urlredirect_vrs.php
--
    // File: urlredirect_vrs.php
    // this page processes a vrs (A varchar row set)
    // normally you would process a clob (urlredirect_vrs.php)
    // however not every php installation is willing to return a clob
    //
    // php oci8 on redhat refuses to return a clob
    //
--
    In the above mentioned file the following sql statement is used :
         select rownum, ata_utils.clob_pieces(rownum) response
         from all_users,all_users,all_users,all_users,all_users,all_users,all_users
         where rownum <= ata_utils.clob_pieces_count('#clob#1234567890abcdefghijklmnopqrstuvwxyz#clob#')
         order by rownum
**/
  return varchar2;

  function clob_pieces_count (p_clob in clob)
    return integer;

--
  function select_to_clob (
    p_return_clob_column   in   varchar2,
    p_table_name           in   varchar2,
    p_key_name             in   varchar2,
    p_key_value            in   varchar2
  )
    return clob;

--
  function ora_info (
    p_spec_date       in   varchar2,
    p_spec_revision   in   varchar2,
    p_spec_author     in   varchar2,
    p_spec_url        in   varchar2,
    p_spec_id         in   varchar2,
    p_body_date       in   varchar2,
    p_body_revision   in   varchar2,
    p_body_author     in   varchar2,
    p_body_url        in   varchar2,
    p_body_id         in   varchar2
  )
    return varchar2;
--
end ata_utils; 
/

