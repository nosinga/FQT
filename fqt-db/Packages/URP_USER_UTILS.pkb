CREATE OR REPLACE package body urp_user_utils
is

function tns_sid_name
return varchar2
is
l_return varchar2(1000);
begin
  select value  into l_return
  from ata_parameters where parametername = 'TNS_SID_NAME';
  return l_return;
end tns_sid_name
;
--
--
procedure pl(p_string in varchar2)
is
begin
  dbms_output.put_line(p_string);
end pl
;
--
function authenticate_on_orcl (p_username in varchar2, p_password in varchar2)
return number
is
l_return number default null;
l_sql_statement varchar2(1000);
l_tns_sid_name varchar2(100);
begin
--
  l_tns_sid_name := tns_sid_name;
--
  begin
    commit;
    l_sql_statement := 'ALTER SESSION CLOSE DATABASE LINK ORCL_AUTH_'||upper(p_username)||'#'||upper(l_tns_sid_name);
    execute immediate l_sql_statement;
  exception when others then
    if sqlcode = -2081 -- database link is not open
    then
      null;
    else
      raise;
    end if;
  end;
  begin
    l_sql_statement := 'drop database link ORCL_AUTH_'||upper(p_username)||'#'||upper(l_tns_sid_name);
    execute immediate l_sql_statement;
  exception when others then
    if sqlcode = -2024 -- database link does not exist
    then
      null;
    else
      raise;
    end if;
  end;
--
  l_sql_statement := 'create database link '||chr(10)||
                     'orcl_auth_'||p_username||'#'||l_tns_sid_name||chr(10)||
                     'connect to '||p_username||chr(10)||
                     'identified by '||p_password||chr(10)||
                     'using '''||l_tns_sid_name||'''';
    execute immediate l_sql_statement;
--
  l_sql_statement := 'select user_id from user_users@'||
                      'orcl_auth_'||p_username||'#'||l_tns_sid_name;
  begin
    execute immediate l_sql_statement into l_return;
  exception when others then
    if sqlcode = -1017 -- invalid username/password
    then
      l_return := null;
    else
      raise;
    end if;
  end;
--
  begin
    commit;
    l_sql_statement := 'ALTER SESSION CLOSE DATABASE LINK ORCL_AUTH_'||upper(p_username)||'#'||upper(l_tns_sid_name);
    execute immediate l_sql_statement;
  exception when others then
    if sqlcode = -2081 -- database link is not open
    then
      null;
    else
      raise;
    end if;
  end;
  begin
    l_sql_statement := 'drop database link ORCL_AUTH_'||upper(p_username)||'#'||upper(l_tns_sid_name);
    execute immediate l_sql_statement;
  exception when others then
    if sqlcode = -2024 -- database link does not exist
    then
      null;
    else
      raise;
    end if;
  end;
--
  return l_return;
end authenticate_on_orcl
;
function check_login_on_orcl(p_username in varchar2, p_password in varchar2)
return number
is
l_return number;
PRAGMA AUTONOMOUS_TRANSACTION;
begin
  l_return := authenticate_on_orcl(p_username , p_password );
  commit;
  return l_return;
end check_login_on_orcl
;
function ora_user_in_ata_parameters(p_username in varchar2)
return number
is
l_user_list varchar2(32000);
l_return number default 0;
begin
  select upper(value) into l_user_list from ATA_PARAMETERS where parametername = 'ALLOWED_ORA_USERS';
  l_user_list := ','||l_user_list;
  if (instr(l_user_list, ','||upper(p_username)||',') > 0)
  then
    l_return := 1;
  end if;  
  return l_return ;
end ora_user_in_ata_parameters 
;

end urp_user_utils
; 
/

