create or replace view urp_users_vw
as
select ID              ID
,      RV              RV
,      USERNAME        USERNAME
,      PASSWORD        PASSWORD
,      IDM_ID          IDM_ID
,     'CUSTOM'         USER_ORIGIN
from   urp_users_tab
union
select USER_ID         ID
,      1               RV
,      lower(USERNAME) USERNAME
,      null            PASSWORD
,      null            IDM_ID
,     'ORACLE'         USER_ORIGIN
from   all_users
where  urp_user_utils.ora_user_in_ata_parameters(username) = 1 
order by USER_ORIGIN desc, USERNAME 
;


