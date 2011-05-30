declare
  l_null varchar2(1);
  l_sql  varchar2(2000);
begin
  -- Als de tabel URP_USERS_JN bestaat..
  select null
  into l_null
  from user_tables 
  where table_name = 'URP_USERS_JN';
  --
  -- .. neem dan de users uit de journalling tabel over.
  l_sql := '
  insert into urp_users ( id, rv, username, password, idm_id )
  select id, rv, username, password, null
  from urp_users_jn u1
  where ( id, rv ) = ( select id, max( rv )
                       from urp_users_jn
                       where id = u1.id
                       and id not in ( select id
                                       from urp_users_jn
                                       where jn_action = ''DEL'' )
                       group by id )';
  -- 
  execute immediate l_sql;
  --
exception 
  when no_data_found then
    -- .. en anders niet
    null;
end;
/
