CREATE OR REPLACE package urp_menu_utils
is
/**
This packes contains the functions which are used in
to add row_versions and flow and page labels.
**/-----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date       constant varchar (4000) := '$Date: 2011-04-22 14:16:27 +0200 (Fri, 22 Apr 2011) $';
  s_spec_revision   constant varchar (4000) := '$Revision: 5985 $';
  s_spec_author     constant varchar (4000) := '$Author: nanne $';
  s_spec_url        constant varchar (4000) := '$URL: svn://store01/fqt-db/Packages/URP_MENU_UTILS.pks $';
  s_spec_id         constant varchar (4000) := '$Id: URP_MENU_UTILS.pks 5985 2011-04-22 12:16:27Z nanne $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- ------------------------------------------------------------------------------- --
  -- Functies/Procedures                                                             --
  -- ------------------------------------------------------------------------------- --
  function ora_info
    return varchar2
    ;
procedure addMenuLeafReport ( p_reportname               in varchar2
                            , p_menuname                 in varchar2
                            , p_rolename                 in varchar2
                            , p_connectionname           in varchar2
);
function hasmenuleafchild(p_menu_id in number, p_menuleaftype in varchar2 default null)
return number
;
function hasusermenuleafchild(p_menu_id in number, p_username in varchar2, p_menuleaftype in varchar2 default null)
return number
;
function menuname2id(p_menuname in varchar2)
return number
;
end urp_menu_utils;
/

