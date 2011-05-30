PROMPT CREATE OR REPLACE PACKAGE BODY ATA_UTILS
CREATE OR REPLACE package body ata_utils
is
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
--SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date       constant varchar (4000)       := '$Date: 2010-07-02 08:34:38 +0200 (Fri, 02 Jul 2010) $';
  s_body_revision   constant varchar (4000)       := '$Revision: 20459 $';
  s_body_author     constant varchar (4000)       := '$Author: nosinga $';
  s_body_url        constant varchar (4000)       := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/PackageBodies/ATA_UTILS.pkb $';
  s_body_id         constant varchar (4000)       := '$Id: ATA_UTILS.pkb 20459 2010-07-02 06:34:38Z nosinga $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  type clob_pieces_tab_type is table of varchar2 (3000)
    index by binary_integer;

  g_clob_pieces_tab          clob_pieces_tab_type;

/* ******************************************************************************* */
/* FUNCTION ORA_INFO                                                               */
/* ******************************************************************************* */
  function ora_info
    return varchar2
  is
  begin
    return ata_utils.ora_info (s_spec_date,
                               s_spec_revision,
                               s_spec_author,
                               s_spec_url,
                               s_spec_id,
                               s_body_date,
                               s_body_revision,
                               s_body_author,
                               s_body_url,
                               s_body_id
                              );
  end;

--
-- start private functions
--
  function clob_to_pieces_tab (p_clob in clob)
    return clob_pieces_tab_type
  is
    l_clob_length       integer;
    l_piece_size        integer              default 1995;
    l_pieces_count      integer;
    l_clob_pieces_tab   clob_pieces_tab_type;
  begin
    l_clob_length := length (p_clob);
    l_pieces_count := ceil (l_clob_length / l_piece_size);

    for i in 1 .. nvl (l_pieces_count, 0)
    loop
      l_clob_pieces_tab (i) :=
                     substr (p_clob, 1 + (i - 1) * l_piece_size,
                             l_piece_size);
    end loop;

    return (l_clob_pieces_tab);
  end clob_to_pieces_tab;

  function pieces_tab_to_clob (p_clob_pieces_tab in clob_pieces_tab_type)
    return clob
  is
    l_return   clob;
  begin
    for i in 1 .. nvl (p_clob_pieces_tab.count, 0)
    loop
      l_return := l_return || p_clob_pieces_tab (i);
    end loop;

    return l_return;
  end pieces_tab_to_clob;

--
-- stop private functions
--
  function clob_pieces (p_i in integer)
    return varchar2
  is
    l_return   varchar2 (3000);
  begin
    return g_clob_pieces_tab (p_i);
  end clob_pieces;

  function clob_pieces_count (p_clob in clob)
    return integer
  is
  begin
    g_clob_pieces_tab := clob_to_pieces_tab (p_clob);
    return nvl (g_clob_pieces_tab.count, 0);
  end clob_pieces_count;

----
  function select_to_clob (
    p_return_clob_column   in   varchar2,
    p_table_name           in   varchar2,
    p_key_name             in   varchar2,
    p_key_value            in   varchar2
  )
    return clob
  is
    l_return   clob;
  begin
    execute immediate    'select '
                      || p_return_clob_column
                      || ' from '
                      || p_table_name
                      || ' where '
                      || p_key_name
                      || ' = :key_value '
                 into l_return
                using p_key_value;

    return l_return;
  end select_to_clob;

----
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
    return varchar2
  is
  begin
    return    '<ora_info>'
           || chr (10)
           || '<ora_user>'
           || sys_context ('USERENV', 'SESSION_USER')
           || '</ora_user>'
           || chr (10)
           || '<ora_sid>'
           || sys_context ('USERENV', 'DB_NAME')
           || '</ora_sid>'
           || chr (10)
           || '<ora_host>'
           || sys_context ('USERENV', 'SERVER_HOST')
           || '</ora_host>'
           || chr (10)
           || '<ora_terminal>'
           || sys_context ('USERENV', 'TERMINAL')
           || '</ora_terminal>'
           || chr (10)
           || '<svn_info>'
           || chr (10)
           || '<spec>'
           || chr (10)
           || '<Date>'
           || substr (p_spec_date, 8, length (p_spec_date) - 9)
           || '</Date>'
           || chr (10)
           || '<Revision>'
           || substr (p_spec_revision, 12, length (p_spec_revision) - 13)
           || '</Revision>'
           || chr (10)
           || '<Author>'
           || substr (p_spec_author, 10, length (p_spec_author) - 11)
           || '</Author>'
           || chr (10)
           || '<URL>'
           || substr (p_spec_url, 7, length (p_spec_url) - 8)
           || '</URL>'
           || chr (10)
           || '<Id>'
           || substr (p_spec_id, 6, length (p_spec_id) - 7)
           || '</Id>'
           || chr (10)
           || '</spec>'
           || chr (10)
           || '<body>'
           || chr (10)
           || '<Date>'
           || substr (p_body_date, 8, length (p_body_date) - 9)
           || '</Date>'
           || chr (10)
           || '<Revision>'
           || substr (p_body_revision, 12, length (p_body_revision) - 13)
           || '</Revision>'
           || chr (10)
           || '<Author>'
           || substr (p_body_author, 10, length (p_body_author) - 11)
           || '</Author>'
           || chr (10)
           || '<URL>'
           || substr (p_body_url, 7, length (p_body_url) - 8)
           || '</URL>'
           || chr (10)
           || '<Id>'
           || substr (p_body_id, 6, length (p_body_id) - 7)
           || '</Id>'
           || chr (10)
           || '</body>'
           || chr (10)
           || '</svn_info>'
           || chr (10)
           || '</ora_info>'
           || chr (10);
  --
  end ora_info;
---
end ata_utils; 
/

