declare
  l_max_urp_sequence integer;
  l_nextval          integer;
begin
  -- bepaal hoogste id van urp_users
  select nvl( max( id ), 0 ) 
  into l_max_urp_sequence
  from urp_users;
  --
  -- zorg dat de sequence tenminste 1 hoger staat
  for i in 1 .. l_max_urp_sequence loop
    select urp_sequence.nextval into l_nextval from dual;
  end loop; 
end;
/   
