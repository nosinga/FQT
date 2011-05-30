PROMPT VIEW URP_ROLE_VW
create or replace force view urp_role_vw (rolename)
as
select rle.rolename
from   urp_roles rle
where  substr(rle.rolename,1,5) = 'role_'
;
PROMPT VIEW URP_USER_ROLE_VW
create or replace force view urp_user_role_vw (username, rolename)
as
select usr.username
,      rle.rolename
from   urp_users usr
,      urp_roles rle
,      urp_user_role url
where  usr.id = url.usr_id
and    rle.id = url.rle_id
and    substr(rle.rolename,1,5) = 'role_'
;

PROMPT VIEW URP_PERMISSIONS_VW
create or replace force view urp_permissions_vw (value)
as
select pms.value
from   urp_permissions pms
;

PROMPT VIEW URP_ROLE_PERMISSION_VW
create or replace force view urp_role_permission_vw (rolename, value)
as
select rle.rolename
,      pms.value
from   urp_roles           rle
,      urp_permissions     pms
,      urp_role_permission rpm
where  rle.id = rpm.rle_id
and    pms.id = rpm.pms_id
and    substr(rle.rolename,1,5) = 'role_'
;

PROMPT VIEW URP_USER_PERMISSION_VW
create or replace force view urp_user_permission_vw (username, value)
as
select usr.username
,      pms.value
from   urp_users           usr
,      urp_permissions     pms
,      urp_role_permission rpm
,      urp_user_role       url
where  usr.id = url.usr_id
and    pms.id = rpm.pms_id
and    rpm.rle_id = url.rle_id
;
