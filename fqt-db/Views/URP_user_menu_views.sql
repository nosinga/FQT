PROMPT VIEW URP_USER_MENUTREE_VW
create or replace force view urp_user_menutree_vw
as
  select usr.username
  ,      tree.itemname
  ,      tree.menulevel
  ,      tree.iscycle
  ,      tree.id
  ,      tree.parent_id
  ,      tree.menutype
  ,      tree.menusubtype
  ,      tree.menuresourcelocation
  ,      tree.queryname
  ,      tree.connectionname
  ,      tree.hasmenuleafchild
  from   urp_menutree_vw tree
  ,      urp_users usr
  where (tree.menutype = 'node'
         and urp_menu_utils.hasusermenuleafchild (tree.id, usr.username) = 1
         )
         or 
        (tree.menutype = 'leaf' 
         and tree.id  in (select id
                          from   urp_user_permission_vw
                          where  username = usr.username
                         )
         )
;

PROMPT VIEW URP_USER_MENUTREEREPORT_VW
create or replace force view urp_user_menutreereport_vw
as
  select usr.username
  ,      tree.itemname
  ,      tree.menulevel
  ,      tree.iscycle
  ,      tree.id
  ,      tree.parent_id
  ,      tree.menutype
  ,      tree.menusubtype
  ,      tree.menuresourcelocation
  ,      tree.queryname
  ,      tree.connectionname
  ,      tree.hasmenuleafchild
  from   urp_menutree_vw tree
  ,      urp_users usr
  where  (tree.menutype = 'node'
          and urp_menu_utils.hasusermenuleafchild (tree.id, usr.username, 'REPORT') = 1
         )
         or 
         (
              tree.menutype = 'leaf' 
          and tree.menusubtype = 'REPORT'
          and tree.id  in (select id
                           from   urp_user_permission_vw
                           where  username = usr.username
                          )
         );
