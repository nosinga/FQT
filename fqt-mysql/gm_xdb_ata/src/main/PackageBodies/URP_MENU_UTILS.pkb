CREATE OR REPLACE package body urp_menu_utils
is
--
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date       constant varchar (4000) := '$Date: 2010-11-22 10:10:46 +0100 (Mon, 22 Nov 2010) $';
  s_body_revision   constant varchar (4000) := '$Revision: 26484 $';
  s_body_author     constant varchar (4000) := '$Author: nosinga $';
  s_body_url        constant varchar (4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/PackageBodies/URP_MENU_UTILS.pkb $';
  s_body_id         constant varchar (4000) := '$Id: URP_MENU_UTILS.pkb 26484 2010-11-22 09:10:46Z nosinga $';

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

--
-- start private functions
--
/*
function menuexists(p_id in integer, p_rv in integer)
return boolean
is
l_return boolean default false;
l_menu   varchar2(100) default null;
begin
  l_menu := menu2rolename(p_id, p_rv);
  if l_menu is not null
  then
    l_return := true;
  end if;
  return l_return;
end menuexists
;
*/
function menuexists(p_menuname in varchar2)
return boolean
is
l_return boolean default false;
l_menu   varchar2(100) default null;
begin
  l_menu := menu2rolename(p_menuname);
  if l_menu is not null
  then
    l_return := true;
  end if;
  return l_return;
end menuexists
;
function menuleafexists(p_id in integer, p_rv in integer)
return boolean
is
l_return boolean default false;
l_permission varchar2(100) default null;
begin
  l_permission := menuleaf2permission( p_id , p_rv);
  if l_permission is not null
  then
    l_return := true;
  end if;
  return l_return;
end menuleafexists
;
function menuleafexists(p_menuitemname in varchar2, p_menuitemtype in varchar2)
return boolean
is
l_return boolean default false;
l_permission varchar2(100) default null;
begin
  l_permission := menuleaf2permission( p_menuitemname , p_menuitemtype);
  if l_permission is not null
  then
    l_return := true;
  end if;
  return l_return;
end menuleafexists
;
function roleexists(p_rolename in varchar2)
return boolean
is
cursor csr_roleexists(b_rolename varchar2)
is
select 1
from   urp_roles
where  substr(rolename,1,5) = 'role_' --check of het role is
and    rolename = b_rolename
;
l_return boolean default false;
begin
  for r in csr_roleexists(p_rolename)
  loop
    l_return := true;
  end loop;
  return l_return;
end roleexists
;
function permissionvalue4DynMenuType(p_menutype in varchar2)
return varchar2
is
l_menuidentifier        varchar2(100);
l_url_and_parametername varchar2(100);
begin
  if p_menutype is null or p_menutype not in ('DOC','DCA','RPT','URL')
     then raise_application_error( -20001, 'menutype not DOC,DCA,RPT,URL'); end if;
       --
       -- Dit zijn de dynamische menu's
       -- deze zijn op een dynamiche wijze gekoppeld aan de onderliggende shermen via de submenus
       -- eigenlijk wordt er voor rapporten urls en document directories steeds naar 1 type
       -- scherm gegaan met een parameter naanm (de naam van het submenu)
       -- er is 1 scherm voor rapporten een scherm voor urls en en een scherm voor document directories
       --
       -- Hieronder gebeurt de echte koppeling
       --
  case when p_menutype in ('DOC','DCA')
       then
            l_url_and_parametername := '../appdocs/documentatie.php?map';
       when p_menutype = 'RPT'
       then
            l_url_and_parametername := '../sqm/runReport.php?rolename';
       when p_menutype = 'URL'
       then
            l_url_and_parametername := '../apputils/showURLs.php?urlmenuname';
   end case;
   l_menuidentifier := lower(p_menutype)||'menu';
   return 'submenu#permission2role#'||l_menuidentifier||'#'||l_url_and_parametername||'='||l_menuidentifier||'[ROLENAME]" target="serviceFrame">[ROLENAME]' ;
end permissionvalue4DynMenuType
;
function permissionvalue2DynMenuType(p_permissionvalue in varchar2)
return varchar2
is
begin
  return upper(substr(p_permissionvalue,25,3));
end permissionvalue2DynMenuType
;
function mainmenuorder(p_menu_id in integer)
return varchar2
is
cursor csr_menuorder (b_menu_id integer)
is
select menuorder
from   urp_menu_vw
where  menutype = 'MAIN'
and    id = b_menu_id
;
l_return varchar2(10) default '00';
begin
  for r in csr_menuorder (p_menu_id)
  loop
    l_return := r.menuorder;
  end loop;
  return l_return;
end mainmenuorder
;
procedure linkDynamicMenuType2MainMenu ( p_mainmenuname    in varchar2
                                       , p_permissionvalue in varchar2
--
-- menutype = ['RPT','DOC','DCA','URL']
-- linkDynamicMenuType2MainMenu ( 'Rapporten', 'RPT');
--
-- deze menutypes zijn op een dynamiche wijze gekoppeld aan de onderliggende shermen via de submenus
-- eigenlijk wordt er voor rapporten urls en document directories steeds naar 1 type
-- scherm gegaan met een parameter naanm (de naam van het submenu)
-- er is 1 scherm voor rapporten een scherm voor urls en en een scherm voor document directories
--
)
is
l_rolename              varchar2(100);
l_menutype              varchar2(100);
begin
  -- check input parameters
  if not menuexists(p_mainmenuname) then  raise_application_error( -20001,'mainmenu does not exist'); end if;
 l_menutype := permissionvalue2dynmenutype(p_permissionvalue);
 if l_menutype is null or l_menutype not in ('DOC','DCA','RPT','URL')
    then raise_application_error( -20001, 'menutype not DOC,DCA,RPT,URL'); end if;
  -- connect dynamic menutype to menu
  ---- get rolename
  l_rolename := menu2rolename(p_mainmenuname);
  -- insert permissionvalue4DynamicMenu and link to main menu
  -- nu wordt de nieuwe verbinding aangemaakt
  begin
     urp_utils.insert_pms_and_link2role (
        p_permissionvalue => p_permissionvalue
      , p_rolename        => l_rolename);
  end;
end linkDynamicMenuType2MainMenu
;
function reportexists(p_reportname in varchar2)
return boolean
is
cursor csr_reportexists(b_reportname varchar2)
is
select 1
from   sqm_queries
where  queryname = b_reportname
;
l_return boolean default false;
begin
  for r in csr_reportexists(p_reportname)
  loop
    l_return := true;
  end loop;
  return l_return;
end reportexists
;
function connectionexists(p_connectionname in varchar2)
return boolean
is
cursor csr_connectionexists(b_connectionname varchar2)
is
select 1
from   sqm_connections
where  connectionname = b_connectionname
;
l_return boolean default false;
begin
  for r in csr_connectionexists(p_connectionname)
  loop
    l_return := true;
  end loop;
  return l_return;
end connectionexists
;
--
-- TODO
--
procedure addReportLink ( p_reportname     in varchar2
                        , p_connectionnane in varchar2
                        , p_menuname       in varchar2 default null
                        , p_rolename       in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een reportlink aanmaken
--
-- Parameters
--   reportname         = naam van het Raport (max 30)
--   connectioname      = naam vende connectie
--     bovenstaande twee parameters zijn veprlicht en met
--     name deze twee worden aan elkaar gekoppeld
--     dat vormt de report link
--
--   menuname         = naam van het Menu (max 30) waar de
--                      de report link aan gekoppeld kan worden
--                      het menu waar aan gekoppeld wordt moet
--                      wel bestaan en is altijd van het type RPT
--                      Een report link kan maximaal aan 1 menu gekoppeld
--                      worden maar dat hoeft niet ! Een rapport kan namelijk
--                      ook aan een ander rapport gekoppeld zijn ipv van
--                      een menu
--   rolename         = naam van de role waar een rapport aan gekoppeld is
--                      er zal altijd 1 rol moeten zijn waar een reportLink aan
--                      gekoppeld is om het rapport te kunnen uitvoeren
--
)
is
begin
  null;
end addReportLink
;
procedure modifyReportLink ( p_reportname        in varchar2
                           , p_connectionnane    in varchar2
                           , p_newreportname     in varchar2 default null
                           , p_newconnectionname in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een reportlink aanmaken
--
-- Parameters
--   reportname         = naam van het Raport (max 30)
--   connectioname      = naam van de connectie
--     bovenstaande twee parameters zijn verplicht en met
--     name deze twee worden aan elkaar gekoppeld
--     dat vormt de report link
--
--   newreportname      = de aangepaste naam van het rapport
--   newconnectionname  = de aangepatse naam van de connectie
--
)
is
begin
  null;
end modifyReportLink
;
--
-- end private functions
--
function submenutype2mainmenuid(p_menutype in varchar2)
return integer
is
cursor csr_mainmenu(b_menutype varchar2)
is
select id
from   urp_menu_vw
where  submenutype = b_menutype
;
l_return integer default 0;
begin
  if p_menutype is null or p_menutype not in ('RPT','URL','DOC')
     then raise_application_error( -20001, 'menutype not RPT,URL,DOC'); end if;
  for r in csr_mainmenu(p_menutype)
  loop
    l_return := r.id;
  exit when csr_mainmenu%rowcount = 1;
  end loop;
  return l_return;
end submenutype2mainmenuid
;
function addMenu(   p_menuname         in varchar2
                  , p_menutype         in varchar2
                  , p_menudescription  in varchar2 default null
                  , p_parentmenu_id    in integer  default null
                  , p_order            in varchar2 default null
                  , p_submenutype      in varchar2 default null
                  )
return integer
is
l_rolename              varchar2(100);
l_permissionvalue       varchar2(200);
l_return                integer;
function mainmenu_with_subtype_exists(p_permissionvalue varchar2)
return boolean
is
cursor  csr_mainmenu_with_subtype(b_permissionvalue varchar2)
is
select  1
from    urp_permissions      pms
,       urp_role_permission  rpm
where   pms.id    = rpm.pms_id
and     pms.value = b_permissionvalue
;
l_return boolean default false;
begin
  for r in csr_mainmenu_with_subtype(p_permissionvalue)
  loop
    l_return := true;
  end loop;
  return l_return;
end mainmenu_with_subtype_exists
;
begin
  -- check input parameters
  if p_menuname is null then raise_application_error( -20001,'menuname is null'); end if;
  if p_menutype is null or p_menutype not in ('MAIN','RPT','URL')
     then raise_application_error( -20001, 'menutype not MAIN,RPT,URL'); end if;
  if menuexists(p_menuname) then  raise_application_error( -20001,'menu already exists'); end if;
  if p_parentmenu_id is not null and p_menutype not in ('RPT','URL')
     then  raise_application_error( -20001,p_parentmenu_id||'only menutype RPT,URL can have a parent menu'); end if;
  case when p_menutype = 'MAIN'
       then
            l_rolename := 'mainmenu#'||p_order||'#'||p_menuname||'#'||p_menudescription ;
       --
       -- Dit zijn de dynamische menu's
       -- deze zijn op een dynamiche wijze gekoppeld aan de onderliggende shermen via de submenus
       -- eigenlijk wordt er voor rapporten urls en document directories steeds naar 1 type
       -- scherm gegaan met een parameter naanm (de naam van het submenu)
       -- er is 1 scherm voor rapporten een scherm voor urls en en een scherm voor document directories
       --
       when p_menutype in ('RPT','URL')
       then
         -- check of er al een mainmenu bestaat voor dit subtype
         if (mainmenu_with_subtype_exists(permissionvalue4DynMenuType(p_menutype)) = false)
            then raise_application_error(-20001,'Main menu with this submenutype does not exists'); end if;
         -- parentmenu_id is verplicht relevantie
         if (p_parentmenu_id is null)
            then  raise_application_error(-20001,'parentmenu_id is mandatory for RPT, URL submenu'); end if;
         -- parentmenu_id check de relevantie
         if (submenutype2mainmenuid(p_menutype) != p_parentmenu_id)
            then  raise_application_error(-20001,'Main menu with this submenutype has another id'); end if;
        --
        -- enkele additionele checks
         if p_menudescription is not null
            then  raise_application_error(-20001,'menudescription is not supported for submenu'); end if;
         if p_order is not null
            then  raise_application_error(-20001,'order is not supported for submenu'); end if;
         if p_submenutype is not null
            then  raise_application_error(-20001,'submenutype is not supported for submenu'); end if;
         --
         -- zet nu de niewue rol waarde
         --
         l_rolename        := lower(p_menutype)||'menu'||p_menuname ;
  end case;
  begin
    insert into urp_roles
              (rolename
              )
            values
              (l_rolename
              );
     select urp_sequence.currval into l_return from dual ;
  exception
    when dup_val_on_index then raise_application_error( -20001, 'menuname already exists');
  end;
  if p_submenutype is not null
  then
    if p_submenutype != 'STATIC'
    then
      -- bepaal de permissionvalue waarde voor een dynamische menu koppeling
      l_permissionvalue := permissionvalue4DynMenuType(p_submenutype);
      -- check of er al een main menu bestaat met dit submenu
      if mainmenu_with_subtype_exists(l_permissionvalue)
        then raise_application_error(-20001,'Main menu with this submenutype already exists'); end if;
      -- link uiteindelijk dit main menu aan het submenutype
      linkDynamicMenuType2MainMenu ( p_mainmenuname        => p_menuname
                                   , p_permissionvalue => l_permissionvalue
                                   );
    end if;
  end if;
  return l_return;
end addMenu
;

procedure addMenu(  p_menuname         in varchar2
                  , p_menutype         in varchar2
                  , p_menudescription  in varchar2
                  , p_order            in varchar2
                  , p_submenutype      in varchar2
                  )
is
l_return                integer;
l_parentmenu_id         integer default null;
begin
  if p_menutype in ('RPT','URL')
  then
    l_parentmenu_id := submenutype2mainmenuid(p_menutype);
  end if;
  l_return := addMenu(
                 p_menuname        => p_menuname
               , p_menutype        => p_menutype
               , p_menudescription => p_menudescription
               , p_parentmenu_id   => l_parentmenu_id
               , p_order           => p_order
               , p_submenutype     => p_submenutype )
               ;
end addMenu
;
function menuname2id(p_menuname in varchar2)
return integer
is
cursor csr_menuid(b_menuname in varchar2)
is
select id
from   urp_menu_vw
where  menuname = b_menuname
;
l_return integer default null;
begin
  for r in csr_menuid (p_menuname)
  loop
    l_return := r.id;
  exit when csr_menuid%rowcount = 1;
  end loop;
  return l_return;
end menuname2id
;
function menu2rolename(p_menuname in varchar2)
return varchar2
is
begin
  return urp_utils.roleid2name(menuname2id(p_menuname));
end menu2rolename
;
function modifyMenu(  p_id               in integer
                    , p_rv               in integer
                    , p_menuname         in varchar2
                    , p_menudescription  in varchar2 default null
                    , p_order            in varchar2 default null
)
return integer
is
begin
  return 1;
end modifyMenu
;
procedure modifyMenu( p_menuname         in varchar2
                    , p_menutype         in varchar2
                    , p_newmenuname      in varchar2
                    , p_menudescription  in varchar2
                    , p_order            in varchar2
)
is
cursor csr_menu_ids(b_menuname varchar2, b_menutype varchar2)
is
select id
,      rv
from   urp_menu_vw
where  menuname = b_menuname
and    menutype = b_menutype
;
l_return integer default 0;
begin
  for r in csr_menu_ids(p_menuname, p_menutype)
  loop
    l_return := modifyMenu(
                      r.id
                    , r.rv
                    , p_newmenuname
                    , p_menudescription
                    , p_order
                    );
    exit when csr_menu_ids%rowcount = 1;
  end loop;
end modifyMenu
;
function addMenuLeaf (   p_menuleafname             in varchar2
                       , p_menuleaftype             in varchar2
                       , p_menu_id                  in integer
                       , p_menuleafresourcelocation in varchar2
                       , p_order                    in varchar2
                       , p_connectionname           in varchar2
) return integer
is
l_return integer default 0;
l_parentorder     varchar2(10) default '00';
l_order           varchar2(10) default nvl(p_order,'01');
l_permissionvalue varchar2(100);
begin
  -- check input parameters
  if p_menuleafname is null then raise_application_error( -20001,'menuleafname is null'); end if;
  if menuleafexists(p_menuleafname,p_menuleaftype) then  raise_application_error( -20001,'menuleaf already exists'); end if;
  if p_menuleaftype is null or p_menuleaftype not in ('STATIC','URL','DOC','RPT')
     then raise_application_error( -20001, 'menuleaftype not STATIC,URL,DOC,RPT'); end if;
  --
  l_parentorder := mainmenuorder ( p_menu_id);
  if length(l_order) <= 3
  then
    l_order := l_parentorder||l_order;
  end if;
  case when p_menuleaftype = 'STATIC'
       then
         l_permissionvalue := 'submenu#'||l_order||'#'||p_menuleafname||'#'||p_menuleafresourcelocation;
       when p_menuleaftype = 'URL'
       then
         l_permissionvalue := 'url#URLREDIRECT;'||p_menuleafresourcelocation||'#'||p_menuleafname;
       when p_menuleaftype = 'DOC'
       then
         l_permissionvalue := 'docdirectory'||p_menuleafname;
       when p_menuleaftype = 'RPT'
       then
         if not reportexists(p_menuleafname) then  raise_application_error( -20001,'report does not exist'); end if;
         l_permissionvalue := 'sqm#'||p_menuleafname;
         if p_connectionname is not null
         then
           if not connectionexists(p_connectionname) then  raise_application_error( -20001,'connection does not exist'); end if;
           l_permissionvalue := l_permissionvalue||'#'||p_connectionname;
         end if;
  end case;
  insert into urp_permissions ( value ) values ( l_permissionvalue) ;
  select urp_sequence.currval into l_return from dual;
  -- maak meteen even een administratie menuleaf aan voor documenten
  -- dit menuleaf kan aan een andere rol gehangen worden
  if p_menuleaftype = 'DOC'
  then
    insert into urp_roles (rolename) values ( 'docmenu'||p_menuleafname );
    urp_utils.link_permission2role (
      p_rolename => 'docmenu'||p_menuleafname
     ,p_permissionvalue => l_permissionvalue
      );
    -- maak meteen koppeling aan een administratie menuleaf voor documenten
    -- dit menuleaf wordt meteen aan het administratie submenu gehangen
    insert into urp_roles (rolename) values ( 'dcamenu'||p_menuleafname );
    insert into urp_permissions ( value ) values ( 'dcadirectory'||p_menuleafname );
       urp_utils.link_permission2role (
          p_rolename => 'dcamenu'||p_menuleafname
         ,p_permissionvalue => 'dcadirectory'||p_menuleafname
       );
  end if;
  --
  if p_menu_id is not null
  then
    -- creeer nu de koppeling van menuleaf naar het menu
    urp_utils.link_permission2role (
      p_rolename =>  urp_utils.roleid2name(p_menu_id)
     ,p_permissionvalue => l_permissionvalue
      );
  end if
  ;
  return l_return;
end addMenuLeaf
;
procedure addMenuLeaf (  p_menuleafname             in varchar2
                       , p_menuleaftype             in varchar2
                       , p_menuleafresourcelocation in varchar2
                       , p_menuname                 in varchar2
                       , p_order                    in varchar2
                       , p_rolename                 in varchar2
                       , p_connectionname           in varchar2
)
is
l_return integer;
begin
  l_return := addMenuLeaf (
                           p_menuleafname             => p_menuleafname
                         , p_menuleaftype             => p_menuleaftype
                         , p_menu_id                  => menuname2id(p_menuname)
                         , p_menuleafresourcelocation => p_menuleafresourcelocation
                         , p_order                    => p_order
                         , p_connectionname           => p_connectionname
                         );
  if p_rolename is not null
  then
     if not roleexists(p_rolename) then  raise_application_error( -20001,'role does not exist'); end if;
     linkMenuLeaf2Role (  p_menuleafname
                        , p_menuleaftype
                        , p_rolename
                        , p_connectionname
                       );

   end if;
end addMenuLeaf
;
function menuleaf2permission (p_id in integer
                            , p_rv in integer
                            )
return varchar2
is
cursor csr_menuleaf2permission(b_id integer, b_rv integer)
is
select value permission
,      substr(value,instr(value,'#',1,2) + 1,instr(value,'#',1,3)-instr(value,'#',1,2) - 1) menuleafname
,      'STATIC'                                                                             menuleaftype
,      null                                                                                 connectionname
from   urp_permissions
where  substr(value,1,8) = 'submenu#' --check of het een submenu is (STATIC)
and    substr(value,instr(value,'#',1,1) + 1,instr(value,'#',1,2)-instr(value,'#',1,1) - 1) != 'permission2role'
and    id = b_id
and    rv = b_rv
union
select value
,      substr(value,instr(value,'#',1,2) + 1)
,      upper(substr(value,1,3))
,      null
from   urp_permissions
where  substr(value,1,4) = 'url#' --check of het een url is (URL)
and    id = b_id
and    rv = b_rv
union
select value
,      substr(value,instr(value,'directory',1) + 9)
,      upper(substr(value,1,3))
,      null
from   urp_permissions
where  substr(value,1,3) in ('doc','dca') --check of het een docdcadirectory is (DOC.DCA)
and    substr(value,4,9) = 'directory'
and    id = b_id
and    rv = b_rv
union
select value
,      substr(value,instr(value,'#',1) + 1,instr(value,'#',1,2)-instr(value,'#',1) - 1)
,      'RPT'
,      substr(value,instr(value,'#',1,2) + 1)
from   urp_permissions
where  substr(value,1,4) = 'sqm#' --check of het een report is (RPT)
and    id = b_id
and    rv = b_rv
;
l_return varchar2(100) default null;
begin
  for r in csr_menuleaf2permission(p_id, p_rv)
  loop
    l_return := r.permission;
  end loop;
  return l_return;
end menuleaf2permission
;
function menuleaf2permission (p_menuleafname in varchar2, p_menuleaftype in varchar2, p_connectionname in varchar2)
return varchar2
is
cursor csr_menuleaf2permission(b_menuleafname varchar2, b_menuleaftype varchar2, b_connectionname varchar2)
is
select value permission
,      substr(value,instr(value,'#',1,2) + 1,instr(value,'#',1,3)-instr(value,'#',1,2) - 1) menuleafname
,      'STATIC'                                                                             menuleaftype
,      null                                                                                 connectionname
from   urp_permissions
where  substr(value,1,8) = 'submenu#' --check of het een submenu is (STATIC)
and    substr(value,instr(value,'#',1,1) + 1,instr(value,'#',1,2)-instr(value,'#',1,1) - 1) != 'permission2role'
and    substr(value,instr(value,'#',1,2) + 1,instr(value,'#',1,3)-instr(value,'#',1,2) - 1)  = b_menuleafname
and   'STATIC' = b_menuleaftype
union
select value
,      substr(value,instr(value,'#',1,2) + 1)
,      upper(substr(value,1,3))
,      null
from   urp_permissions
where  substr(value,1,4) = 'url#' --check of het een url is (URL)
and    substr(value,instr(value,'#',1,2) + 1) = b_menuleafname
and    upper(substr(value,1,3)) = b_menuleaftype
union
select value
,      substr(value,instr(value,'directory',1) + 9)
,      upper(substr(value,1,3))
,      null
from   urp_permissions
where  substr(value,1,3) in ('doc','dca') --check of het een docdcadirectory is (DOC.DCA)
and    substr(value,4,9) = 'directory'
and    substr(value,instr(value,'directory',1) + 9) = b_menuleafname
and    upper(substr(value,1,3)) = b_menuleaftype
union
select value
,      substr(value,instr(value,'#',1) + 1,instr(value,'#',1,2)-instr(value,'#',1) - 1)
,      'RPT'
,      substr(value,instr(value,'#',1,2) + 1)
from   urp_permissions
where  substr(value,1,4) = 'sqm#' --check of het een report is (RPT)
and    substr(value,instr(value,'#',1) + 1,instr(value,'#',1,2)-instr(value,'#',1) - 1) = b_menuleafname
and    'RPT' = b_menuleaftype
and    substr(value,instr(value,'#',1,2) + 1) = nvl(b_connectionname,substr(value,instr(value,'#',1,2) + 1))
;
l_return varchar2(100) default null;
begin
  for r in csr_menuleaf2permission(p_menuleafname, p_menuleaftype, p_connectionname)
  loop
    l_return := r.permission;
  end loop;
  return l_return;
end menuleaf2permission
;
function modifyMenuLeaf (   p_id                       in integer
                          , p_rv                       in integer
                          , p_menuleafname             in varchar2
                          , p_menuleafresourcelocation in varchar2 default null
                          , p_menuname                 in varchar2 default null
                          , p_order                    in varchar2 default null
                         )
return integer
is
l_return integer default 0;
begin
  return l_return;
end modifyMenuLeaf
;
procedure modifyMenuLeaf (  p_menuleafname             in varchar2
                          , p_menuleaftype             in varchar2
                          , p_newmenuleafname          in varchar2
                          , p_menuleafresourcelocation in varchar2
                          , p_menuname                 in varchar2
                          , p_order                    in varchar2
)
is
cursor csr_menuleaf_ids(b_menuleafname varchar2, b_menuleaftype varchar2)
is
select id
,      rv
from   urp_menuleaf_vw
where  menuleafname = b_menuleafname
and    menuleaftype = b_menuleaftype
;
l_return integer default 0;
begin
  for r in csr_menuleaf_ids(p_menuleafname, p_menuleaftype)
  loop
    l_return := modifyMenuLeaf(
                      r.id
                    , r.rv
                    , p_newmenuleafname
                    , p_menuleafresourcelocation
                    , p_menuname
                    , p_order
                    );
    exit when csr_menuleaf_ids%rowcount = 1;
  end loop;
end modifyMenuLeaf
;
procedure linkMenuLeaf2Menu (  p_menuleafname       in varchar2
                             , p_menuleaftype       in varchar2
                             , p_menuname           in varchar2
)
is
begin
  null;
end linkMenuLeaf2Menu
;
procedure linkMenuLeaf2Role (  p_menuleafname             in varchar2
                             , p_menuleaftype             in varchar2
                             , p_rolename                 in varchar2
                             , p_connectionname           in varchar2
)
is
l_permissionvalue varchar2(100);
begin
  l_permissionvalue := menuleaf2permission(
                          p_menuleafname
                         ,p_menuleaftype
                         ,p_connectionname);
  if l_permissionvalue is null
  then  raise_application_error( -20001,'menuleaf does not exists'); end if;
  begin
    urp_utils.link_permission2role (
      p_rolename          => p_rolename
     ,p_permissionvalue   => l_permissionvalue
     );
  end;
end linkMenuLeaf2Role
;
procedure unlinkMenuLeaf4Role (  p_menuleafname       in varchar2
                               , p_menuleaftype       in varchar2
                               , p_rolename           in varchar2
                               , p_connectionname     in varchar2 default null
)
is
begin
  null;
end unlinkMenuLeaf4Role
;
procedure addMenuLeafReport ( p_reportname               in varchar2
                            , p_menuname                 in varchar2
                            , p_rolename                 in varchar2
                            , p_connectionname           in varchar2
  )
is
begin
    addMenuLeaf (  p_menuleafname             => p_reportname
                 , p_menuleaftype             => 'RPT'
                 , p_menuname                 => p_menuname
                 , p_rolename                 => p_rolename
                 , p_connectionname           => p_connectionname
                );
end addMenuLeafReport
;
function removeMenu(   p_id       in integer
                     , p_rv       in integer
                     , p_cascade  in varchar2 default 'no'
                   )
return integer
is
cursor csr_role_permissions(b_roleid integer)
is
select pms_id
from   urp_role_permission
where  rle_id = b_roleid
;
cursor csr_role_permissions2(b_roleid integer)
is
select pms_id
from   urp_role_permission
where  rle_id = b_roleid
;
cursor csr_permission(b_pms_id integer)
is
select value permission
from   urp_permissions
where  id = b_pms_id
;
cursor csr_role(b_submenutype varchar2)
is
select id roleid
from   urp_roles
where  substr(rolename,1,7) = b_submenutype
;
l_submenutype varchar2(100);
l_return integer default 0;
--
begin
-- TODO
--  if not menuexists(p_id, p_rv)
--  then  raise_application_error( -20001,'menu does not exists'); end if;
  for r1 in csr_role_permissions(p_id)
  loop
    if p_cascade = 'yes'
    then
      for r2 in csr_permission(r1.pms_id)
      loop
        if r2.permission like 'submenu#permission2role#%'
        then
          case when instr(r2.permission,'rptmenu') > 0 then l_submenutype := 'rptmenu';
               when instr(r2.permission,'urlmenu') > 0 then l_submenutype := 'urlmenu';
               when instr(r2.permission,'docmenu') > 0 then l_submenutype := 'docmenu';
               when instr(r2.permission,'dcamenu') > 0 then l_submenutype := 'dcamenu';
          end case;
          for r3 in csr_role(l_submenutype)
          loop
            for r4 in csr_role_permissions2(r3.roleid)
            loop
              delete urp_role_permission
              where  pms_id = r4.pms_id
--              and    rle_id = r3.roleid
              ;
              delete urp_permissions
              where id = r4.pms_id
              ;
            end loop;
            delete urp_roles
            where  id = r3.roleid
            ;
          end loop;
        end if;
      end loop;
      delete urp_role_permission
      where  pms_id = r1.pms_id
--      and    rle_id = l_roleid
      ;
      delete urp_permissions
      where id = r1.pms_id
      ;
    else
      raise_application_error( -20001,'menu has submenus or leafs');
    end if;
  end loop;
  delete urp_roles
  where  id = p_id
  and    rv = p_rv
  ;
  l_return := sql%rowcount;
  return l_return;
end removeMenu
;

procedure removeMenu(  p_menuname in varchar2
                     , p_menutype in varchar2
                     , p_cascade  in varchar2
                     )
is
l_roleid      integer;
l_rv          integer;
l_rolename    varchar2(100);
l_return      integer;
begin
if not menuexists(p_menuname)
 then  raise_application_error( -20001,'menu does not exists'); end if;
  l_rolename := menu2rolename(p_menuname);
  l_roleid   := urp_utils.ROLENAME2ID(l_rolename);
  select rv into l_rv from urp_roles where id = l_roleid
  ;
  l_return := removeMenu(
                       l_roleid
                     , l_rv
                     , p_cascade
                   );
end removeMenu
;
function removeMenuLeaf(  p_id       in integer
                        , p_rv       in integer)
return integer
is
l_return integer default 0;
begin
  if not menuleafexists( p_id, p_rv)
  then raise_application_error( -20001,'menuleaf does not exists'); end if;
  begin
    delete urp_role_permission
    where  pms_id = p_id
    ;
    delete urp_permissions
    where  id     = p_id
    and    rv     = p_rv
    ;
  end;
  return l_return;
end removeMenuLeaf
;
procedure removeMenuLeaf(  p_menuleafname       in varchar2
                         , p_menuleaftype       in varchar2
                         , p_connectionname     in varchar2
)
is
l_permissionvalue varchar2(100);
l_permissionid    integer;
l_rv              integer;
l_return          integer;
begin
  if not menuleafexists( p_menuleafname, p_menuleaftype)
  then raise_application_error( -20001,'menuleaf does not exists'); end if;
  begin
    l_permissionvalue := menuleaf2permission( p_menuleafname,p_menuleaftype,p_connectionname);
    l_permissionid    := urp_utils.PERMISSIONVALUE2ID(l_permissionvalue);
    select rv into l_rv from urp_permissions where id = l_permissionid;
    l_return := removeMenuLeaf(l_permissionid, l_rv);
  end;
end removeMenuLeaf
;
end urp_menu_utils; 
/

