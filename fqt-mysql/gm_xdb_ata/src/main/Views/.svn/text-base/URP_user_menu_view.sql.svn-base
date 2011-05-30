PROMPT VIEW URP_USER_MENU_VW
create or replace force view urp_user_menu_vw 
as
select usr.username  
 ,     usr.id usr_id
 , substr( rleparentmenu.rolename
 , instr(rleparentmenu.rolename,chr(35),1,2)+1
 , instr(rleparentmenu.rolename,chr(35),1,3)
 - instr(rleparentmenu.rolename,chr(35),1,2) - 1 ) parentname
, substr(rleparentmenu.rolename,instr(rleparentmenu.rolename,chr(35),1,3)+1) parentdescription
, substr( pms.value
 , instr(pms.value,chr(35),1,2)+1
 , instr(pms.value,chr(35),1,3) - instr(pms.value,chr(35),1,2) - 1 ) name
, substr( pms.value
 , instr(pms.value,chr(35),1,2)+1
 , instr(pms.value,chr(35),1,3) - instr(pms.value,chr(35),1,2) - 1 ) description
, substr(pms.value, instr(pms.value,chr(35),1,3)+1) location
, 'Static' menutype
, pms.value value
, rleparentmenu.rolename orderby1
, pms.value orderby2
from urp_roles rleparentmenu
, urp_role_permission rpmparentmenu
, urp_permissions pms
, urp_role_permission rpm
, urp_user_role url
, urp_users     usr
where rleparentmenu.id = rpmparentmenu.rle_id
and pms.id = rpmparentmenu.pms_id
and substr(rleparentmenu.rolename,1,8) = 'mainmenu'
and substr(pms.value,1,7) = 'submenu'
and substr(pms.value, instr(pms.value,chr(35),1,3)+1) is not null
and substr(pms.value,1,23) != 'submenu'||chr(35)||'permission2role'
and rpm.pms_id = pms.id
and rpm.rle_id = url.rle_id
and url.usr_id = usr.id
union
select usr.username
 ,     usr.id usr_id 
 , substr( rleparentmenu.rolename
 , instr(rleparentmenu.rolename,chr(35),1,2)+1
 , instr(rleparentmenu.rolename,chr(35),1,3) - instr(rleparentmenu.rolename,chr(35),1,2) - 1 ) parentname
, substr(rleparentmenu.rolename,instr(rleparentmenu.rolename,chr(35),1,3)+1) parentdescription
, substr( rlesubmenu.rolename,8) name
, substr( rlesubmenu.rolename,8) description
, rlesubmenu.rolename location
, 'Dynamic' menutype
, pms.value value
, rleparentmenu.rolename orderby1
, rlesubmenu.rolename orderby2
from urp_roles rleparentmenu
, urp_role_permission rpm
, urp_permissions pms
, urp_roles rlesubmenu
, urp_users usr
where rleparentmenu.id = rpm.rle_id
and pms.id = rpm.pms_id
and substr(rleparentmenu.rolename,1,8) = 'mainmenu'
and ( substr(pms.value,1,31) = 'submenu'||chr(35)||'permission2role'||chr(35)||'rptmenu'
   or substr(pms.value,1,31) = 'submenu'||chr(35)||'permission2role'||chr(35)||'urlmenu'
   or substr(pms.value,1,31) = 'submenu'||chr(35)||'permission2role'||chr(35)||'docmenu'
   or substr(pms.value,1,31) = 'submenu'||chr(35)||'permission2role'||chr(35)||'dcamenu'
    )
and substr(rlesubmenu.rolename,1,7) = substr( pms.value
 , instr(pms.value,chr(35),1,2)+1
 , instr(pms.value,chr(35),1,3) - instr(pms.value,chr(35),1,2) - 1 ) 
and    rlesubmenu.id in (select rpm_report.rle_id                                                                                     
                         from   urp_role_permission rpm_report                                                                        
                         ,      urp_role_permission rpm_user_role                                                                     
                         ,      urp_user_role       url                                                                               
                         ,      urp_users           inner_usr                                                                         
                         where  rpm_report.pms_id    = rpm_user_role.pms_id                                                           
                         and    rpm_user_role.rle_id = url.rle_id                                                                     
                         and    inner_usr.id         = url.usr_id
                         and    inner_usr.id         = usr.id                                                                   
                        )    
;

