-- create or replace force view urp_menumenueaf_vw (parentname,
--                                           parentdescription,
--                                           name,
--                                           description,
--                                           location,
--                                           menutype,
--                                           value,
--                                           orderby1,
--                                           orderby2
--                                          )
-- as
--   select substr (rleparentmenu.rolename,
--                  instr (rleparentmenu.rolename, chr (35), 1, 2) + 1,
--                    instr (rleparentmenu.rolename, chr (35), 1, 3)
--                  - instr (rleparentmenu.rolename, chr (35), 1, 2)
--                  - 1
--                 ) parentname,
--          substr (rleparentmenu.rolename,
--                  instr (rleparentmenu.rolename, chr (35), 1, 3) + 1
--                 ) parentdescription,
--          substr (pms.value,
--                  instr (pms.value, chr (35), 1, 2) + 1,
--                  instr (pms.value, chr (35), 1, 3) - instr (pms.value, chr (35), 1, 2) - 1
--                 ) name,
--          substr (pms.value,
--                  instr (pms.value, chr (35), 1, 2) + 1,
--                  instr (pms.value, chr (35), 1, 3) - instr (pms.value, chr (35), 1, 2) - 1
--                 ) description,
--          substr (pms.value, instr (pms.value, chr (35), 1, 3) + 1) location, 'Static' menutype,
--          pms.value value, rleparentmenu.rolename orderby1, pms.value orderby2
--     from urp_roles rleparentmenu,
--          urp_role_permission rpmparentmenu,
--          urp_permissions pms,
--          urp_role_permission rpm
--    where rleparentmenu.id = rpmparentmenu.rle_id
--      and pms.id = rpmparentmenu.pms_id
--      and substr (rleparentmenu.rolename, 1, 8) = 'mainmenu'
--      and substr (pms.value, 1, 7) = 'submenu'
--      and substr (pms.value, instr (pms.value, chr (35), 1, 3) + 1) is not null
--      and substr (pms.value, 1, 23) != 'submenu' || chr (35) || 'permission2role'
--      and rpm.pms_id = pms.id
--   union
--   select substr (rleparentmenu.rolename,
--                  instr (rleparentmenu.rolename, chr (35), 1, 2) + 1,
--                    instr (rleparentmenu.rolename, chr (35), 1, 3)
--                  - instr (rleparentmenu.rolename, chr (35), 1, 2)
--                  - 1
--                 ) parentname,
--          substr (rleparentmenu.rolename,
--                  instr (rleparentmenu.rolename, chr (35), 1, 3) + 1
--                 ) parentdescription,
--          substr (rlesubmenu.rolename, 8) name, substr (rlesubmenu.rolename, 8) description,
--          rlesubmenu.rolename location, 'Dynamic' menutype, pms.value value,
--          rleparentmenu.rolename orderby1, rlesubmenu.rolename orderby2
--     from urp_roles rleparentmenu,
--          urp_role_permission rpm,
--          urp_permissions pms,
--          urp_roles rlesubmenu
--    where rleparentmenu.id = rpm.rle_id
--      and pms.id = rpm.pms_id
--      and substr (rleparentmenu.rolename, 1, 8) = 'mainmenu'
--      and (   substr (pms.value, 1, 31) =
--                                  'submenu' || chr (35) || 'permission2role' || chr (35)
--                                  || 'rptmenu'
--           or substr (pms.value, 1, 31) =
--                                  'submenu' || chr (35) || 'permission2role' || chr (35)
--                                  || 'urlmenu'
--           or substr (pms.value, 1, 31) =
--                                  'submenu' || chr (35) || 'permission2role' || chr (35)
--                                  || 'docmenu'
--           or substr (pms.value, 1, 31) =
--                                  'submenu' || chr (35) || 'permission2role' || chr (35)
--                                  || 'dcamenu'
--          )
--      and substr (rlesubmenu.rolename, 1, 7) =
--            substr (pms.value,
--                    instr (pms.value, chr (35), 1, 2) + 1,
--                    instr (pms.value, chr (35), 1, 3) - instr (pms.value, chr (35), 1, 2) - 1
--                   )
-- ;
-- 
create or replace view urp_menu_vw
as
select  rle.id                                              id
,       rle.rv                                              rv
,       substr (rle.rolename,
                 instr (rle.rolename, chr (35), 1, 2) + 1,
                   instr (rle.rolename, chr (35), 1, 3)
                 - instr (rle.rolename, chr (35), 1, 2)
                 - 1
                )                                           menuname
,      'MAIN'                                               menutype
,       null                                                parent_id
,       substr (rle.rolename,
                 instr (rle.rolename, chr (35), 1, 3) + 1
                )                                           menudescription
,       substr (rle.rolename,
                 instr (rle.rolename, chr (35), 1, 1) + 1,
                   instr (rle.rolename, chr (35), 1, 2)
                 - instr (rle.rolename, chr (35), 1, 1)     
                 - 1
                )                                           menuorder
,       upper(substr(pms.value,25,3))                       submenutype
from   urp_roles           rle
,      urp_role_permission rpm
,      urp_permissions     pms
where  rle.id = rpm.rle_id
and    pms.id = rpm.pms_id
and    substr(rle.rolename,1,8) = 'mainmenu'
and    substr (pms.value, 1, 23) = 'submenu' || chr (35) || 'permission2role'
union
select  rle.id                                              id
,       rle.rv                                              rv
,       substr (rle.rolename,
                 instr (rle.rolename, chr (35), 1, 2) + 1,
                   instr (rle.rolename, chr (35), 1, 3)
                 - instr (rle.rolename, chr (35), 1, 2)
                 - 1
                )                                           
,      'MAIN'                                               
,       null
,       substr (rle.rolename,
                 instr (rle.rolename, chr (35), 1, 3) + 1
                )                                           
,       substr (rle.rolename,
                 instr (rle.rolename, chr (35), 1, 1) + 1,
                   instr (rle.rolename, chr (35), 1, 2)
                 - instr (rle.rolename, chr (35), 1, 1)     
                 - 1
                )                                           
,      'STATIC'                                             
from   urp_roles           rle
where  substr(rle.rolename,1,8) = 'mainmenu'
and    rle.id not in ( select rlei.id
                       from   urp_roles           rlei
                       ,      urp_role_permission rpmi
                       ,      urp_permissions     pmsi
                       where  rlei.id = rpmi.rle_id
                       and    pmsi.id = rpmi.pms_id
                       and    substr(rlei.rolename,1,8) = 'mainmenu'
                       and    substr (pmsi.value, 1, 23) = 'submenu' || chr (35) || 'permission2role')
union
select  menu.id                                              id
,       menu.rv                                              rv
,       substr (menu.rolename,8)                   
,       upper(substr (menu.rolename,1,3))          
,       parent_menu.rle_id
,       null                                      
,       null                                      
,       null                                      
from    urp_roles            menu
,       urp_role_permission  parent_menu
,       urp_permissions      menu2menu
where   substr(menu.rolename,4,4) = 'menu'
and     upper(substr(menu.rolename,1,3)) in ('RPT','URL')
and     parent_menu.pms_id = menu2menu.id
and     substr(menu2menu.value, 1, 23) = 'submenu' || chr (35) || 'permission2role'
and substr (menu.rolename, 1, 7) =
            substr (menu2menu.value,
                    instr (menu2menu.value, chr (35), 1, 2) + 1,
                    instr (menu2menu.value, chr (35), 1, 3) - instr (menu2menu.value, chr (35), 1, 2) - 1
                   )
;

create or replace view urp_menuleaf_vw
as      
-- 
-- Dit zijn de rapporten die wel aan een menu zijn gelinkt
-- 
select  menuleaf.id                                    id
,       menuleaf.rv                                    rv
,       substr (menuleaf.value,                               
         instr (menuleaf.value, chr (35), 1, 1) + 1,  
           instr (menuleaf.value, chr (35), 1, 2)     
         - instr (menuleaf.value, chr (35), 1, 1)     
         - 1                                        
        )                                           
                                                       menuleafname
,      'RPT'                                           menuleaftype
,      menu.id                                         menu_id
,      null                                            menuresourcelocation
,      null                                            menuleaforder
,      substr (menuleaf.value,                               
       instr (menuleaf.value, chr (35), 1, 2) + 1  )
                connectionname
from   urp_permissions              menuleaf
,      urp_role_permission          menu2menuleaf
,      urp_roles                    menu
where  substr(menuleaf.value,1,4) = 'sqm#'
and    menuleaf.id = menu2menuleaf.pms_id
and    menu.id     = menu2menuleaf.rle_id
and    upper(substr (menu.rolename,1,3)) = 'RPT'
-- 
-- Dit zijn de rapporten die niet aan een menu zijn gelinkt
-- 
union
select  menuleaf.id                                    id
,       menuleaf.rv                                    rv
,       substr (menuleaf.value,                               
         instr (menuleaf.value, chr (35), 1, 1) + 1,  
           instr (menuleaf.value, chr (35), 1, 2)     
         - instr (menuleaf.value, chr (35), 1, 1)     
         - 1                                        
        )                                           
,      'RPT'    menuleaftype
,      null     menu_id
,      null     menuresourcelocation
,      null     menuleaforder
,      substr (menuleaf.value,                               
       instr (menuleaf.value, chr (35), 1, 2) + 1  )
                connectionname
from   urp_permissions              menuleaf
where  substr(menuleaf.value,1,4) = 'sqm#'
and    menuleaf.id not in 
       (select  imenuleaf.id
        from    urp_permissions            imenuleaf
        ,       urp_role_permission        imenu2menuleaf
        ,       urp_roles                  imenu
        where  substr(imenuleaf.value,1,4) = 'sqm#'
        and    imenuleaf.id = imenu2menuleaf.pms_id
        and    imenu.id     = imenu2menuleaf.rle_id
        and    upper(substr (imenu.rolename,1,3)) = 'RPT')
union
-- 
-- Dit zijn de urls die aan een menu zijn gelinkt
-- 
select menuleaf.id                                              id
,      menuleaf.rv                                              rv
,       substr (menuleaf.value,                               
         instr (menuleaf.value, chr (35), 1, 2) + 1)
,      'URL'
,      menu.id
,      replace(
        substr (menuleaf.value,                               
         instr (menuleaf.value, chr (35), 1, 1) + 1,  
           instr (menuleaf.value, chr (35), 1, 2)     
         - instr (menuleaf.value, chr (35), 1, 1)     
         - 1                                        
        ),'URLREDIRECT;')     menuresourcelocation
,      null     menuleaforder
,      null     connectionname
from   urp_permissions              menuleaf
,      urp_role_permission          menu2menuleaf
,      urp_roles                    menu
where  substr(menuleaf.value,1,4) = 'url#'
and    menuleaf.id = menu2menuleaf.pms_id
and    menu.id     = menu2menuleaf.rle_id
and    upper(substr (menu.rolename,1,3)) = 'URL'
union
-- 
-- DOC
-- Dit zijn de docs die aan een menu zijn gelinkt
-- tbv raadplegen (downloaden)
-- 
-- DCA
-- Dit zijn de docs die aan een menu zijn gelinkt
-- tbv administratie (DCA staat voor document administratie)
-- administratie betekent hier uploaden of verwijderen 
--
select menuleaf.id                                              id
,      menuleaf.rv                                              rv
,      substr(menuleaf.value,13)
,      upper(substr (menu.rolename,1,3))
,      parent_menu.rle_id
,      null     menuresourcelocation
,      null     menuleaforder
,      null     connectionname
from   urp_permissions              menuleaf
,      urp_role_permission          menu2menuleaf
,      urp_roles                    menu
,      urp_role_permission          parent_menu
,      urp_permissions              menu2menu
where  substr(menuleaf.value,4,9) = 'directory'
and    menuleaf.id = menu2menuleaf.pms_id
and    menu.id     = menu2menuleaf.rle_id
and    upper(substr (menu.rolename,1,3)) in ('DOC','DCA')
and     substr(menu.rolename,4,4) = 'menu'
and     parent_menu.pms_id = menu2menu.id
and     substr(menu2menu.value, 1, 23) = 'submenu' || chr (35) || 'permission2role'
and substr (menu.rolename, 1, 7) =
            substr (menu2menu.value,
                    instr (menu2menu.value, chr (35), 1, 2) + 1,
                    instr (menu2menu.value, chr (35), 1, 3) - instr (menu2menu.value, chr (35), 1, 2) - 1
                   )
-- 
-- Dit zijn de schermen die aan een menu zijn gelinkt
-- tbv onderhoud van ATA en FILTER database tabellen 
--
union
select menuleaf.id                                              id
,      menuleaf.rv                                              rv
,       substr (menuleaf.value,                               
         instr (menuleaf.value, chr (35), 1, 2) + 1,  
           instr (menuleaf.value, chr (35), 1, 3)     
         - instr (menuleaf.value, chr (35), 1, 2)     
         - 1                                        
        )       
,      'STATIC'
,      menu.id
,      substr (menuleaf.value,                               
       instr (menuleaf.value, chr (35), 1, 3) + 1  )
                menuresourcelocation
,      substr (menuleaf.value,                               
         instr (menuleaf.value, chr (35), 1, 1) + 1,  
           instr (menuleaf.value, chr (35), 1, 2)     
         - instr (menuleaf.value, chr (35), 1, 1)     
         - 1                                        
        )       menuleaforder
,      null     connectionname
from   urp_permissions                menuleaf
,      urp_role_permission            menu2menuleaf
,      urp_roles                      menu
where  substr(menuleaf.value,1,8)   = 'submenu#'
and    substr(menuleaf.value,1,24) != 'submenu#permission2role#'
and    menuleaf.id = menu2menuleaf.pms_id
and    menu.id     = menu2menuleaf.rle_id
and    substr(menu.rolename,1,9)   = 'mainmenu#'
;

create or replace view urp_menumenuleaf_vw
as
select  menu.menuname
,       menu.menutype
,       menuleaf.menuleafname
,       menuleaf.menuleaftype
,       menu.menuorder
,       menuleaf.menuleaforder
from    urp_menu_vw       menu
,       urp_menuleaf_vw   menuleaf
where   menu.id = menuleaf.menu_id(+)
;