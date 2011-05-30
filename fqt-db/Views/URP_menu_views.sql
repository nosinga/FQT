create or replace force view urp_menuleaf_vw 
as
  select menuleaf.id                              id
  ,      menuleaf.rv                              rv
  ,      menuleaf.name                            menuleafname
  ,      menuleaf.type                            menuleaftype
  ,      menuleaf.menu_id                         menu_id
  ,      menuleaf.value                           menuresourcelocation
  ,      menuleaf.orderby                         orderby
  ,      qry.queryname                            queryname
  ,      con.connectionname                       connectionname
  from   urp_permissions menuleaf
  ,      sqm_queries     qry
  ,      sqm_connections con
  where  menuleaf.sql_id = qry.id(+)
  and    menuleaf.con_id = con.id(+)
  and    menuleaf.type in ('SCREEN','REPORT','URL')
  and    menuleaf.menu_id is not null
   ;

create or replace force view urp_menutree_debug_vw
as
  select     itemname                             itemname            
  ,          level                                menulevel           
  ,          connect_by_iscycle                   iscycle             
  ,          id                                   id                  
  ,          rv                                   rv
  ,          parent_id                            parent_id           
  ,          menutype                             menutype            
  ,          menusubtype                          menusubtype         
  ,          menuresourcelocation                 menuresourcelocation
  ,          queryname                            queryname           
  ,          connectionname                       connectionname      
  ,          urp_menu_utils.hasmenuleafchild (id) hasmenuleafchild     
  from (select id          id
       ,       rv          rv
       ,       menuname    itemname
       ,       orderby     orderby
       ,       parent_id   parent_id
       ,       'node'      menutype
       ,       ''          menusubtype
       ,       ''          menuresourcelocation
       ,       ''          queryname
       ,       ''          connectionname
       from    urp_menunodes
       union
       select  id
       ,       rv
       ,       menuleafname
       ,       orderby
       ,       menu_id
       ,       'leaf'
       ,       menuleaftype
       ,       menuresourcelocation
       ,       queryname
       ,       connectionname
       from    urp_menuleaf_vw
       )
       where   itemname is not null
       start   with parent_id is null
       connect by nocycle prior id = parent_id and level <= 10
       order siblings by orderby
       ;


create or replace force view urp_menutree_vw 
as
  select itemname                          itemname
  ,      menulevel                         menulevel
  ,      iscycle                           iscycle
  ,      id                                id
  ,      rv                                rv
  ,      parent_id                         parent_id
  ,      menutype                          menutype
  ,      menusubtype                       menusubtype
  ,      menuresourcelocation              menuresourcelocation
  ,      queryname                         queryname
  ,      connectionname                    connectionname
  ,      hasmenuleafchild                  hasmenuleafchild
  from   urp_menutree_debug_vw
  where  (menutype = 'node' and hasmenuleafchild = 1) or menutype = 'leaf'
  ;


