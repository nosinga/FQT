CREATE OR REPLACE package body urp_menu_utils
is
--
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date       constant varchar (4000) := '$Date: 2011-04-22 14:16:27 +0200 (Fri, 22 Apr 2011) $';
  s_body_revision   constant varchar (4000) := '$Revision: 5985 $';
  s_body_author     constant varchar (4000) := '$Author: nanne $';
  s_body_url        constant varchar (4000) := '$URL: svn://store01/fqt-db/Packages/URP_MENU_UTILS.pkb $';
  s_body_id         constant varchar (4000) := '$Id: URP_MENU_UTILS.pkb 5985 2011-04-22 12:16:27Z nanne $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  /* ******************************************************************************* */
  /* FUNCTION ORA_INFO                                                               */
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

procedure addMenuLeafReport ( p_reportname               in varchar2
                            , p_menuname                 in varchar2
                            , p_rolename                 in varchar2
                            , p_connectionname           in varchar2
  )
is
l_menuid          number;
l_queryid         number;
l_connectionid    number;
begin
  if p_reportname is null then raise_application_error( -20001,'reportname is null'); end if;
  if urp_utils.permissionexists(p_reportname) then  raise_application_error( -20001,'permission already exists'); end if;
  if not sqm_utils.reportexists(p_reportname) then  raise_application_error( -20001,'report does not exist'); end if;
  if p_connectionname is not null
  then
     if not sqm_utils.connectionexists(p_connectionname) then  raise_application_error( -20001,'connection does not exist'); end if;
  end if;
  if p_menuname is not null
  then
    l_menuid       := urp_utils.menuname2id(p_menuname);
  end if;
  l_queryid      := sqm_utils.queryname2id(p_reportname);
  l_connectionid := sqm_utils.connectionname2id(p_connectionname);
  insert into urp_permissions ( name,         type,     menu_id,  sql_id,    con_id  )
              values          ( p_reportname, 'REPORT', l_menuid, l_queryid, l_connectionid) ;
  if p_rolename is not null
  then
     if not urp_utils.roleexists(p_rolename) then  raise_application_error( -20001,'role does not exist'); end if;
     urp_utils.link_permissionname2Role (  p_permissionname    => p_reportname
                                         , p_rolename          => p_rolename
                                        );

   end if;
end addMenuLeafReport
;
function hasmenuleafchild(p_menu_id in number, p_menuleaftype in varchar2)
return number
is
cursor csr_childmenu(b_menu_id number)
is
select id from urp_menunodes
where  parent_id = b_menu_id
;
cursor csr_menuleaf(b_menu_id number, b_menuleaftype varchar2)
is
select id from urp_menuleaf_vw
where  menu_id      = b_menu_id
and    menuleaftype = nvl(b_menuleaftype, menuleaftype)
;
l_return number default 0;
begin
  for r_menuleaf in csr_menuleaf(p_menu_id, p_menuleaftype)
  loop
    l_return := 1;
    exit;
  end loop;
  if l_return = 0
  then
    for r_childmenu in csr_childmenu(p_menu_id)
    loop
      l_return := hasmenuleafchild(r_childmenu.id, p_menuleaftype);
      if l_return = 1
      then
        exit;
      end if;
    end loop;
  end if;
  return l_return;
end hasmenuleafchild
;
function hasusermenuleafchild(p_menu_id in number, p_username in varchar2, p_menuleaftype in varchar2)
return number
is
cursor csr_childmenu(b_menu_id number)
is
select id from urp_menunodes
where  parent_id = b_menu_id
;
cursor csr_menuleaf(b_menu_id number, b_username in varchar2, b_menuleaftype varchar2)
is
select id from urp_menuleaf_vw
where  menu_id      = b_menu_id
and    menuleaftype = nvl(b_menuleaftype, menuleaftype)
and    id in (
       select id from urp_user_permission_vw
       where  username = b_username
       )
;
l_return number default 0;
begin
  for r_menuleaf in csr_menuleaf(p_menu_id, p_username, p_menuleaftype)
  loop
    l_return := 1;
    exit;
  end loop;
  if l_return = 0
  then
    for r_childmenu in csr_childmenu(p_menu_id)
    loop
      l_return := hasusermenuleafchild(r_childmenu.id, p_username, p_menuleaftype);
      if l_return = 1
      then
        exit;
      end if;
    end loop;
  end if;
  return l_return;
end hasusermenuleafchild
;
function menuname2id(p_menuname in varchar2)
return number
is
cursor csr_menuid(b_menuname varchar2)
is
select id
from   urp_menunodes
where  menuname = b_menuname
;
l_return number;
begin
  for r in csr_menuid(p_menuname)
  loop
    l_return := r.id;
    exit;
  end loop;
  return l_return;
end menuname2id
;
end urp_menu_utils;
/

