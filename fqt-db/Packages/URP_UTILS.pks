CREATE OR REPLACE package urp_utils
is
/**
This packes contains the functions which are used in
to add row_versions and flow and page labels.
**/-----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date       constant varchar (4000) := '$Date: 2011-04-29 10:01:47 +0200 (Fri, 29 Apr 2011) $';
  s_spec_revision   constant varchar (4000) := '$Revision: 5998 $';
  s_spec_author     constant varchar (4000) := '$Author: nanne $';
  s_spec_url        constant varchar (4000) := '$URL: svn://store01/fqt-db/Packages/URP_UTILS.pks $';
  s_spec_id         constant varchar (4000) := '$Id: URP_UTILS.pks 5998 2011-04-29 08:01:47Z nanne $';

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

  procedure change_password(p_username in varchar2, p_password in varchar2)
  ;

  function check_login (p_username in varchar2, p_password in varchar2)
    return number;

  function userid2name (p_userid in number)
    return varchar2;

  function username2id (p_username in varchar2)
    return number;

  function roleexists(p_rolename in varchar2)
    return boolean;

  function roleid2name (p_roleid in number)
    return varchar2;

  function rolename2id (p_rolename in varchar2)
    return number;

  function permissionexists(p_name in varchar2)
    return boolean;

  function permissionid2value (p_permissionid in number)
    return varchar2;

  function permissionname2value (p_name in varchar2)
    return varchar2;

  function permissionvalue2id (p_permissionvalue in varchar2)
    return number;

  function permissionname2id (p_permissionname in varchar2)
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
  procedure link_userid2roleids (
    p_userid in varchar2,
    p_roleids in varchar2
  /**
  A user is linked to a set of roles
  userid is the id of the user
  rolids is a comma separated list of role ids
  **/
  );
  procedure link_roleid2userids (
    p_roleid in varchar2
   ,p_userids in varchar2
   ,x_sqlcode out varchar2
  /**
  A role is linked to a set of users
  roleid is the id of the role
  userids is a comma separated list of user ids
  **/
  );
  procedure link_roleid2userids (
    p_roleid in varchar2
   ,p_userids in varchar2
  /**
  A role is linked to a set of users
  roleid is the id of the role
  userids is a comma separated list of user ids
  **/
  );
  procedure link_permissionid2roleids (
    p_permissionid in varchar2,
    p_roleids in varchar2
  /**
  A user is linked to a set of roles
  userid is the id of the user
  rolids is a comma separated list of role ids
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
     p_name            in varchar2 default null
    ,p_type            in varchar2 default null
    ,p_permissionvalue in varchar2
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
  procedure link_permissionname2role (
    p_rolename          in   varchar2,
    p_permissionname    in   varchar2
  /**
  This procedure links a permission to a role
  **/
  );
  procedure link_roleid2permissionids (
    p_roleid in varchar2,
    p_permissionids in varchar2
  /**
  A role is linked to a set of permissions
  roleid is the id of the role
  permissionids is a comma separated list of permission ids
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
    p_name              in   varchar2 default null,
    p_type              in   varchar2 default null,
    p_permissionvalue   in   varchar2,
    p_rolename          in   varchar2
  /**
  This procedue inserts a permission and links it to a role
  **/
  );
  function menuname2id(p_menuname in varchar2)
  return integer
  -- hulp functie om inserts via scripts makkelijker te maken
  --
  ;
  function  execute_select(p_statement in varchar2, p_showstatement varchar2 default 'n')
  return varchar2
  ;
  procedure execute_call(p_statement in varchar2, p_showstatement varchar2 default 'n')
  ;
  function  execute_call(p_statement in varchar2, p_showstatement varchar2 default 'n')
  return varchar2
  ;
--
-- lokale test procedures
--
procedure test_comma_to_table(p_string in varchar2 default '1,2,3,4,5')
;
procedure test2_comma_to_table
;
end urp_utils;
/

