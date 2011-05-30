PROMPT CREATE OR REPLACE PACKAGE BODY ATA_HTTP
CREATE OR REPLACE package body ata_http
is
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date       constant varchar (4000) := '$Date: 2010-07-02 08:34:38 +0200 (Fri, 02 Jul 2010) $';
  s_body_revision   constant varchar (4000) := '$Revision: 20459 $';
  s_body_author     constant varchar (4000) := '$Author: nosinga $';
  s_body_url        constant varchar (4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/PackageBodies/ATA_HTTP.pkb $';
  s_body_id         constant varchar (4000) := '$Id: ATA_HTTP.pkb 20459 2010-07-02 06:34:38Z nosinga $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------

  /* ******************************************************************************* */
  /* FUNCTION ORA_INFO                                                         */
  /* ******************************************************************************* */
  function ora_info
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
           || substr (s_spec_date, 8, length (s_spec_date) - 9)
           || '</Date>'
           || chr (10)
           || '<Revision>'
           || substr (s_spec_revision, 12, length (s_spec_revision) - 13)
           || '</Revision>'
           || chr (10)
           || '<Author>'
           || substr (s_spec_author, 10, length (s_spec_author) - 11)
           || '</Author>'
           || chr (10)
           || '<URL>'
           || substr (s_spec_url, 7, length (s_spec_url) - 8)
           || '</URL>'
           || chr (10)
           || '<Id>'
           || substr (s_spec_id, 6, length (s_spec_id) - 7)
           || '</Id>'
           || chr (10)
           || '</spec>'
           || chr (10)
           || '<body>'
           || chr (10)
           || '<Date>'
           || substr (s_body_date, 8, length (s_body_date) - 9)
           || '</Date>'
           || chr (10)
           || '<Revision>'
           || substr (s_body_revision, 12, length (s_body_revision) - 13)
           || '</Revision>'
           || chr (10)
           || '<Author>'
           || substr (s_body_author, 10, length (s_body_author) - 11)
           || '</Author>'
           || chr (10)
           || '<URL>'
           || substr (s_body_url, 7, length (s_body_url) - 8)
           || '</URL>'
           || chr (10)
           || '<Id>'
           || substr (s_body_id, 6, length (s_body_id) - 7)
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

  function raw_response ( 
      p_url              in varchar2
    , p_proxy            in varchar2
    , p_no_proxy_domains in varchar2)
  return clob
  is
  l_response_pieces   utl_http.html_pieces;
  l_return clob default '';
  l_user varchar2(200);
  begin
    l_user := abkr_journaling.getUser;
    if (length(p_proxy) > 0)
    then
      utl_http.set_proxy(p_proxy,p_no_proxy_domains);
    end if;
    l_response_pieces := utl_http.request_pieces (p_url);
    for i in 1 .. nvl(l_response_pieces.count,0)
    loop
      l_return := l_return||l_response_pieces (i);
    end loop;
    return l_return;
  end raw_response;

  function response ( 
      p_url in varchar2
    , p_redirect_href_http in   varchar2
    , p_proxy              in   varchar2
    , p_no_proxy_domains   in   varchar2
)
    return clob
  is
  l_return clob;
  begin
    l_return := raw_response(p_url,p_proxy,p_no_proxy_domains);
    if p_redirect_href_http is not null
    then
      l_return := replace(l_return,'http://',p_redirect_href_http);
    end if;
    return l_return;
  end response;

end ata_http; 
/

