CREATE OR REPLACE package body urp_utils
is
--
  g_initial_user    constant varchar2 (100)
                                           default 'nosinga@ioo.rotterdam.nl';
  g_userdomain      constant varchar2 (100) default 'rotterdam.nl';
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date       constant varchar (4000) := '$Date: 2011-03-07 12:05:00 +0100 (Mon, 07 Mar 2011) $';
  s_body_revision   constant varchar (4000) := '$Revision: 30785 $';
  s_body_author     constant varchar (4000) := '$Author: nosinga $';
  s_body_url        constant varchar (4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/PackageBodies/URP_UTILS.pkb $';
  s_body_id         constant varchar (4000) := '$Id: URP_UTILS.pkb 30785 2011-03-07 11:05:00Z nosinga $';

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
  function decimal2hex (p_decimal in integer)
    return varchar2
  is
    l_result      varchar2 (12);
    l_hex_digit   varchar2 (1);
    l_quotient    integer;
    l_remainder   integer;
  begin
    if (p_decimal < 10)
    then
      l_result := to_char (p_decimal);
    elsif (p_decimal < 16)
    then
      l_result := chr (65 + (p_decimal - 10));                -- or 55 + idec
    else
      l_remainder := mod (p_decimal, 16);
      l_quotient := round ((p_decimal - l_remainder) / 16);
      l_result := decimal2hex (l_quotient) || decimal2hex (l_remainder);
    end if;

    return l_result;
  end decimal2hex;

  function hex2decimal (p_hex in varchar2)
    return integer
  is
    l_result    integer;
    l_hex2dec   integer;
  begin
    for i in 1 .. length (p_hex)
    loop
      if (ascii (substr (p_hex, i, 1)) > 47
          and ascii (substr (p_hex, i, 1)) < 58
         )
      then
        l_hex2dec := ascii (substr (p_hex, i, 1)) - 48;
      elsif (    ascii (substr (p_hex, i, 1)) > 64
             and ascii (substr (p_hex, i, 1)) < 72
            )
      then
        l_hex2dec := ascii (substr (p_hex, i, 1)) - 55;
      end if;

      if i = 1
      then
        l_result := l_hex2dec;
      elsif i = 2
      then
        l_result := l_result * 16 + l_hex2dec;
      end if;
    end loop;

    return (l_result);
  end hex2decimal;

  function dec2hex (p_decimal in integer)
    return varchar2
  is
    l_result   varchar2 (12);
  begin
    l_result := decimal2hex (p_decimal => p_decimal);

    if length (l_result) = 1
    then
      l_result := '0' || l_result;
    end if;

    return l_result;
  end dec2hex;

  function hex2dec (p_hex in varchar2)
    return integer
  is
  begin
    return (hex2decimal (p_hex));
  end hex2dec;

  function hex2char (p_hex in varchar2)
    return varchar2
  is
    l_result   varchar2 (10);
  begin
    for i in 1 .. length (p_hex)
    loop
      if (ascii (substr (p_hex, i, 1)) > 47
          and ascii (substr (p_hex, i, 1)) < 58
         )
      then
        l_result := l_result || chr (ascii (substr (p_hex, i, 1)) - 48 + 97);
      elsif (    ascii (substr (p_hex, i, 1)) > 64
             and ascii (substr (p_hex, i, 1)) < 72
            )
      then
        l_result :=
                 l_result || chr (ascii (substr (p_hex, i, 1)) - 65 + 10 + 97);
      end if;
    end loop;

    return l_result;
  end hex2char;

  function char2hex (p_char in varchar2)
    return varchar2
  is
    l_result   varchar2 (10);
  begin
    for i in 1 .. length (p_char)
    loop
      if (    ascii (substr (p_char, i, 1)) > 96
          and ascii (substr (p_char, i, 1)) < 107
         )
      then
        l_result := l_result || chr (ascii (substr (p_char, i, 1)) - 97 + 48);
      elsif (    ascii (substr (p_char, i, 1)) > 106
             and ascii (substr (p_char, i, 1)) < 113
            )
      then
        l_result := l_result || chr (ascii (substr (p_char, i, 1)) - 107 + 65);
      end if;
    end loop;

    return l_result;
  end char2hex;

--
  function ascii_encrypt (p_char in varchar2)
    return varchar2
  is
  begin
    return hex2char (dec2hex (ascii (p_char)));
  end ascii_encrypt;

  function ascii_decrypt (p_char in varchar2)
    return varchar2
  is
  begin
    return chr (hex2dec (char2hex (p_char)));
  end ascii_decrypt;

  function md5_fill_string (
    p_char          in   varchar2,
    p_fill_length   in   number,
    p_loop_start    in   integer default 1
  )
    return varchar2
  is
    l_return   varchar2 (1000) default p_char || 'x';
  begin
    for i in p_loop_start .. (p_loop_start + 5)
    loop
      l_return :=
          l_return || dbms_obfuscation_toolkit.md5 (input_string     => l_return);
    end loop;

    return (substr (l_return, 1, p_fill_length));
  end md5_fill_string;

--
-- end private functions
--
  procedure addUser (
     p_username in varchar2
   , p_password in varchar2
   , p_idm_id   in varchar2
   )
  is
  begin
    insert into urp_users
                (username, password, idm_id
                )
         values (p_username, urp_utils.password_encrypt (p_password), p_idm_id
                );
  exception
    when dup_val_on_index
    then
      null;
  end addUser
  ;
  function user_password_encrypt (p_char in varchar2)
    return varchar2
  is
  l_return varchar2(200);
  begin
    if (    length(p_char) > 0
        and length(p_char) < 31)
    then
      l_return := password_encrypt (p_char => p_char);
    else
      l_return := p_char;
    end if;
    return l_return;
  end user_password_encrypt
  ;
  function password_encrypt (p_char in varchar2)
    return varchar2
  is
    l_password_length        integer;
    l_password               varchar2 (100);
    l_prefix                 varchar2 (100);
    l_result                 varchar2 (1000);
    l_suffix                 varchar2 (100);
    l_password_length_char   varchar2 (100);
  begin
    if p_char is null
    then
      l_result := null;
    else
      l_password_length := length (p_char);
      l_password := substr (p_char, 1, 20);

      if l_password_length > 20
      then
        l_password_length := 20;
      end if;

      l_prefix := md5_fill_string (p_char, l_password_length);

      if mod (l_password_length, 2) = 0
      then
        l_prefix := lower (l_prefix);
      end if;

      for i in 1 .. nvl (l_password_length, 0)
      loop
        l_result := ascii_encrypt (substr (l_password, i, 1)) || l_result;
      end loop;

      for i in 1 .. length (l_prefix)
      loop
        l_result := ascii_encrypt (substr (l_prefix, i, 1)) || l_result;
      end loop;

      l_suffix :=
               md5_fill_string (p_char, 47 - (l_password_length * (1 + 1)), 4);

      if mod (l_password_length, 2) = 0
      then
        l_suffix := lower (l_suffix);
      end if;

      for i in 1 .. length (l_suffix)
      loop
        l_result := l_result || ascii_encrypt (substr (l_suffix, i, 1));
      end loop;

      l_password_length_char := to_char (300 + l_password_length);

      for i in 1 .. 3
      loop
        l_result :=
              l_result || ascii_encrypt (substr (l_password_length_char, i, 1));
      end loop;
    end if;
    return l_result;
  end password_encrypt;

  function password_decrypt (p_char in varchar2)
    return varchar2
  is
    l_in_string              varchar2 (1000);
    l_password_length_part   varchar2 (100);
    l_password_length_char   varchar2 (100);
    l_password_length        integer;
    l_result                 varchar2 (1000);
  begin
    begin
      l_password_length_part := substr (p_char, -6);

      for i in 1 .. 6
      loop
        if mod ((i - 1), 2) = 0
        then
          l_password_length_char :=
               l_password_length_char
            || ascii_decrypt (substr (l_password_length_part, i, 2));
        end if;
      end loop;

      l_password_length := to_number (l_password_length_char) - 300;
      l_in_string :=
             substr (p_char, 1 + l_password_length * 2, l_password_length * 2);

      for i in 1 .. length (l_in_string)
      loop
        if mod ((i - 1), 2) = 0
        then
          l_result := ascii_decrypt (substr (l_in_string, i, 2)) || l_result;
        end if;
      end loop;
    exception
      when others
      then
        l_result := 'password';
    end;

    return l_result;
  end password_decrypt;

  function check_login (p_username in varchar2, p_password in varchar2)
    return number
  is
    pragma autonomous_transaction;
                               -- allows insert when used in select-statement

    cursor c (b_username in varchar2, b_password in varchar2)
    is
      select id
        from urp_users
       where username = b_username
         and password = b_password
         and username like '%' || g_userdomain;

    r   c%rowtype;
  begin
    open c (b_username     => p_username,
            b_password     => password_encrypt (p_password)
           );

    fetch c
     into r;

    close c;

    insert into ata_logins_jna
                (timestamp, username, password,
                 result
                )
         values (sysdate, p_username, password_encrypt (p_password),
                 decode (r.id, null, 0, 1)
                );

--  owner_css.css_bre_journalling.setUser@user_iss#nsst1( p_username ); -- before commit!!!
    commit;
    return (r.id);
  end check_login;

  procedure check_login (
    p_username   in       varchar2,
    p_password   in       varchar2,
    x_result     out      number
  )
  is
  begin
    x_result :=
             check_login (p_username     => p_username,
                          p_password     => p_password);
  end check_login;

  function userid2name (p_userid in number)
    return varchar2
  is
    cursor csr_username (b_userid number)
    is
      select username
        from urp_users
       where id = b_userid;

    l_return   varchar2 (200);
  begin
    for r in csr_username (p_userid)
    loop
      l_return := r.username;
      exit;
    end loop;

    return l_return;
  end userid2name;

  function username2id (p_username in varchar2)
    return number
  is
    cursor csr_userid (b_username varchar2)
    is
      select id
        from urp_users
       where username = b_username;

    l_return   number;
  begin
    for r in csr_userid (p_username)
    loop
      l_return := r.id;
      exit;
    end loop;

    return l_return;
  end username2id;

  function roleid2name (p_roleid in number)
    return varchar2
  is
    cursor csr_rolename (b_roleid number)
    is
      select rolename
        from urp_roles
       where id = b_roleid;

    l_return   varchar2 (200);
  begin
    for r in csr_rolename (p_roleid)
    loop
      l_return := r.rolename;
      exit;
    end loop;

    return l_return;
  end roleid2name;

  function rolename2id (p_rolename in varchar2)
    return number
  is
    cursor csr_roleid (b_rolename varchar2)
    is
      select id
        from urp_roles
       where rolename = b_rolename;

    l_return   number;
  begin
    for r in csr_roleid (p_rolename)
    loop
      l_return := r.id;
      exit;
    end loop;

    return l_return;
  end rolename2id;

  function permissionid2value (p_permissionid in number)
    return varchar2
  is
    cursor csr_permissionid (b_permissionid number)
    is
      select value
        from urp_permissions
       where id = b_permissionid;

    l_return   varchar2 (200);
  begin
    for r in csr_permissionid (p_permissionid)
    loop
      l_return := r.value;
      exit;
    end loop;

    return l_return;
  end permissionid2value;

  function permissionvalue2id (p_permissionvalue in varchar2)
    return number
  is
    cursor csr_permissionid (b_permissionvalue varchar2)
    is
      select id
        from urp_permissions
       where value = b_permissionvalue;

    l_return   number;
  begin
    for r in csr_permissionid (p_permissionvalue)
    loop
      l_return := r.id;
      exit;
    end loop;

    return l_return;
  end permissionvalue2id;

  function rowmodifyallowed (p_username in varchar2)
    return varchar2
  is
    cursor csr_rowpermissions (b_username varchar2)
    is
      select distinct substr (pms.value, 7) rowpermission
                 from urp_users usr,
                      urp_user_role url,
                      urp_role_permission rpm,
                      urp_permissions pms
                where usr.id = url.usr_id
                  and url.rle_id = rpm.rle_id
                  and rpm.pms_id = pms.id
                  and substr (pms.value, 1, 6) = 'rowml#'
                  and usr.username = b_username
             order by rowpermission asc;

    l_return   varchar (32000);
  begin
    l_return := ',';

    for r in csr_rowpermissions (p_username)
    loop
      l_return := l_return || r.rowpermission || ',';
    end loop;

    return l_return;
  end rowmodifyallowed;

  procedure userprofile_change (
    p_userid        in   number,
    p_copyprofile   in   varchar2,
    p_action        in   varchar2
  )
  is
    cursor csr_username1_minus_username2 (
      b_username1   varchar2,
      b_username2   varchar2
    )
    is
      select url.rle_id as roleid
        from urp_user_role url, urp_users usr
       where url.usr_id = usr.id and usr.username = b_username1
      minus
      select url.rle_id as roleid
        from urp_user_role url, urp_users usr
       where url.usr_id = usr.id and usr.username = b_username2;

    l_username   varchar2 (200);
  begin
    l_username := userid2name (p_userid);

    if p_action = 'add' or p_action = 'replace'
    then
      for r in csr_username1_minus_username2 (p_copyprofile, l_username)
      loop
        insert into urp_user_role
                    (usr_id, rle_id
                    )
             values (p_userid, r.roleid
                    );
      end loop;

      if p_action = 'replace'
      then
        for r in csr_username1_minus_username2 (l_username, p_copyprofile)
        loop
          delete      urp_user_role
                where usr_id = p_userid and rle_id = r.roleid;
        end loop;
      end if;
    end if;
  end userprofile_change;

  procedure userprofile_replace (p_userid in number, p_copyprofile in varchar2)
  is
  begin
    userprofile_change (p_userid, p_copyprofile, 'replace');
  end userprofile_replace;

  procedure userprofile_add (p_userid in number, p_copyprofile in varchar2)
  is
  begin
    userprofile_change (p_userid, p_copyprofile, 'add');
  end userprofile_add;

  procedure userprofile_add_based_on_role (p_rolename in varchar2, p_profileusername in varchar2)
  is
  cursor csr_role_users(b_rolename varchar2)
  is
  select url.usr_id     userid
  from   urp_user_role  url
  ,      urp_roles      rle
  where  rle.id       = url.rle_id
  and    rle.rolename = b_rolename
  ;
  begin
    for r in csr_role_users(p_rolename)
    loop
      userprofile_change (r.userid, p_profileusername, 'add');
    end loop;
  end userprofile_add_based_on_role
  ;
  procedure metauserrole_add
  is
  begin
    null;
  end metauserrole_add;
--
  procedure insert_permission (
    p_permissionvalue in varchar2
  )
  is
  begin
    insert into urp_permissions
                (value
                )
         values (p_permissionvalue
                );
  exception
    when dup_val_on_index
    then
      null;
  end insert_permission
  ;
  procedure link_user2role (
    p_username in varchar2,
    p_rolename in varchar2
  )
  is
  begin
    if urp_utils.rolename2id (p_rolename) is null
    then
      dbms_output.put_line (p_rolename);
    end if;
    insert into urp_user_role
                (usr_id,
                 rle_id
                )
         values (urp_utils.username2id (p_username),
                 urp_utils.rolename2id (p_rolename)
                );
  exception
    when dup_val_on_index
    then
      null;
  end link_user2role
  ;
  procedure link_permission2role (
    p_rolename          in   varchar2,
    p_permissionvalue   in   varchar2
  )
  is
  begin
    insert into urp_role_permission
                (rle_id,
                 pms_id
                )
         values (urp_utils.rolename2id (p_rolename),
                 urp_utils.permissionvalue2id (p_permissionvalue)
                );
  exception
    when dup_val_on_index
    then
      null;
  end link_permission2role
  ;
  procedure insert_pms_and_link2role (
    p_permissionvalue   in   varchar2,
    p_rolename          in   varchar2
  )
  is
  begin
    insert_permission (p_permissionvalue);
    link_permission2role (p_rolename, p_permissionvalue);
  end insert_pms_and_link2role
  ;
  procedure insert_connection (
     p_connectionname   in   varchar2
    ,p_username         in   varchar2
    ,p_password         in   varchar2
    ,p_hostname         in   varchar2
    ,p_port             in   varchar2
    ,p_servicename      in   varchar2
    ,p_tnsname          in   varchar2
    ,p_description      in   varchar2
  )
  is
  begin
    insert into sqm_connections
                ( connectionname
                , username
                , password
                , servicename
                , tnsname
                , description
                )
         values ( p_connectionname
                , p_username
                , nvl(p_password,p_username)
                , p_hostname||':'||p_port||':'||p_servicename
                , p_tnsname
                , nvl (p_description, p_username || '@' || p_tnsname)
                );
  exception
    when dup_val_on_index
    then
      null;
  end insert_connection
  ;
  procedure userprofile_add (
    p_username        in varchar2,
    p_profileusername in varchar2
  )
  is
  begin
    urp_utils.userprofile_change
       ( urp_utils.username2id (p_username)
       , p_profileusername
       , 'add'
       );
  end userprofile_add
  ;
/**
  procedure userprofile_add_based_on_role (
    p_rolename in varchar2,
    p_profileusername in varchar2
  )
  is
  begin
    urp_utils.userprofile_add_based_on_role( p_rolename
                                           , p_profileusername);
  end userprofile_add_based_on_role
  ;

**/
  procedure user_add_role_based_on_role (
    p_base_rolename  in varchar2,
    p_new_rolename   in varchar2
  )
  is
  cursor csr_user_based_on_role(b_rolename varchar2)
  is
  select usr.username   username
  from   urp_users      usr
  ,      urp_user_role  url
  ,      urp_roles      rle
  where  usr.id       = url.usr_id
  and    rle.id       = url.rle_id
  and    rle.rolename = b_rolename
  ;
  begin
    for r in csr_user_based_on_role(p_base_rolename)
    loop
      link_user2role(r.username, p_new_rolename);
    end loop;
  end user_add_role_based_on_role
  ;
  function execute_select(p_statement in varchar2, p_showstatement varchar2)
  return varchar2
  is
  l_return varchar2(4000);
  begin
    execute immediate(p_statement) into l_return;
    if p_showstatement = 'y'
    then
      dbms_output.put_line(p_statement);
    end if;
    return l_return;
  end execute_select
  ;
  procedure execute_call(p_statement in varchar2, p_showstatement varchar2)
  is
  l_statement varchar2(4000) default p_statement;
  begin
    if substr(rtrim(l_statement),-1) != ';'
    then
      l_statement := l_statement||';';
    end if;
    l_statement := 'begin '||l_statement||' end;';
    execute immediate (l_statement);
    if p_showstatement = 'y'
    then
      dbms_output.put_line(l_statement);
    end if;
  end execute_call
  ;
  function execute_call(p_statement in varchar2, p_showstatement varchar2)
  return varchar2
  is
  l_statement varchar2(4000) default p_statement;
  l_return varchar2(4000);
  begin
    if substr(rtrim(l_statement),-1) != ';'
    then
      l_statement := l_statement||';';
    end if;
    l_statement := 'begin '||l_statement||' end;';
    execute immediate(l_statement) returning into l_return;
    if p_showstatement = 'y'
    then
      dbms_output.put_line(l_statement);
    end if;
    return l_return;
  end execute_call
  ;
end urp_utils; 
/

