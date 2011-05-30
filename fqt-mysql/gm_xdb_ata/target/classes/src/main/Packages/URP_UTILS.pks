CREATE OR REPLACE package urp_utils
is
/**
This packes contains the functions which are used in
to add row_versions and flow and page labels.
**/-----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date       constant varchar (4000) := '$Date: 2010-12-01 18:09:31 +0100 (Wed, 01 Dec 2010) $';
  s_spec_revision   constant varchar (4000) := '$Revision: 27021 $';
  s_spec_author     constant varchar (4000) := '$Author: nosinga $';
  s_spec_url        constant varchar (4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Packages/URP_UTILS.pks $';
  s_spec_id         constant varchar (4000) := '$Id: URP_UTILS.pks 27021 2010-12-01 17:09:31Z nosinga $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- ------------------------------------------------------------------------------- --
  -- Functies/Procedures                                                             --
  -- ------------------------------------------------------------------------------- --
  function ora_info
    return varchar2;

  procedure addUser (
     p_username in varchar2
   , p_password in varchar2 default 'welkom123'
   , p_idm_id   in varchar2 default null
  /**
  Inserts a user in the urp_users table
  the password is default set to welkom123
  **/
  );

  function user_password_encrypt (p_char in varchar2)
    return varchar2;

  function password_encrypt (p_char in varchar2)
    return varchar2;

  function password_decrypt (p_char in varchar2)
    return varchar2;

  function check_login (p_username in varchar2, p_password in varchar2)
    return number;

  function userid2name (p_userid in number)
    return varchar2;

  function username2id (p_username in varchar2)
    return number;

  function roleid2name (p_roleid in number)
    return varchar2;

  function rolename2id (p_rolename in varchar2)
    return number;

  function permissionid2value (p_permissionid in number)
    return varchar2;

  function permissionvalue2id (p_permissionvalue in varchar2)
    return number;

  function rowmodifyallowed (p_username in varchar2)
    return varchar2;

  procedure userprofile_replace (p_userid in number, p_copyprofile in varchar2);

  procedure userprofile_add (p_userid in number, p_copyprofile in varchar2);

  procedure userprofile_change (p_userid in number, p_copyprofile in varchar2, p_action in varchar2);

  procedure link_user2role (
    p_username in varchar2,
    p_rolename in varchar2
  /**
  A user is linked to a role
  **/
  );
  procedure userprofile_add (
    p_username        in varchar2,
    p_profileusername in varchar2
  /**
  This procedure is a proxy to the procedure
  urp_utils.userprofile_change
     ( p_userid in number
     , p_copyprofile in varchar2
     , p_action in varchar2)
  The action in the above function can be add or replace
  In this particular case the action is add
  The roles from one user <p_profileusername> are copied to the other user <p_username>
  **/
  );
  procedure userprofile_add_based_on_role (
    p_rolename in varchar2,
    p_profileusername in varchar2
  /**
  This procedure is a proxy to the procedure
  urp_utils.userprofile_add_based_on_role (
    p_rolename in varchar2,
    p_copyprofile in varchar2)
  The procedure urp_utils.userprofile_add_based_on_role
  first gets all the users which are connected
  to the <p_rolename>
  an then invokes the procedure
  urp_utils.userprofile_change
     ( p_userid in number
     , p_copyprofile in varchar2
     , p_action in varchar2)
  The action in the above function can be add or replace
  In this particular case the action is add
  The users which are connected to <p_rolename> get at least the same roles
  which are connected to the <p_profileusername>
  **/
  );
  procedure user_add_role_based_on_role (
    p_base_rolename  in varchar2,
    p_new_rolename   in varchar2
  /**
  This procedure first gets all the users which are connected
  to the <p_base_rolename>
  and the adds the <p_new_rolename> to those users
  by  invoking the function link_user2role
  **/
  );
  procedure insert_permission (
    p_permissionvalue in varchar2
  /**
  This procedure inserts a permission
  **/
  );
  procedure link_permission2role (
    p_rolename          in   varchar2,
    p_permissionvalue   in   varchar2
  /**
  This procedure links a permission to a role
  **/
  );
  procedure insert_connection (
     p_connectionname   in   varchar2
    ,p_username         in   varchar2
    ,p_password         in   varchar2 default null
    ,p_hostname         in   varchar2 default 'localhost'
    ,p_port             in   varchar2 default '1521'
    ,p_servicename      in   varchar2 default 'XE'
    ,p_tnsname          in   varchar2 default 'XE'
    ,p_description      in   varchar2 default null
  /**
  This procedure inserts a connection
  **/
  );
  procedure insert_pms_and_link2role (
    p_permissionvalue   in   varchar2,
    p_rolename          in   varchar2
  /**
  This procedue inserts a permission and links it to a role
  **/
  );
  function  execute_select(p_statement in varchar2, p_showstatement varchar2 default 'n')
  return varchar2
  ;
  procedure execute_call(p_statement in varchar2, p_showstatement varchar2 default 'n')
  ;
  function  execute_call(p_statement in varchar2, p_showstatement varchar2 default 'n')
  return varchar2
  ;
end urp_utils; 
/

