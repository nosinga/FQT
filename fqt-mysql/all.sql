drop table urp_users;
CREATE TABLE URP_USERS
(
  ID        INT             NOT NULL auto_increment primary key,
  RV        INT             NOT NULL default 1,
  USERNAME  VARCHAR(100) NOT NULL,
  PASSWORD  VARCHAR(200) NOT NULL,
  IDM_ID    VARCHAR(100)
)
;

drop table urp_roles;
CREATE TABLE URP_ROLES
(
  ID        INT             NOT NULL auto_increment primary key,
  RV        INT             NOT NULL default 1,
  ROLENAME  VARCHAR(100) NOT NULL
)
;

drop table urp_permissions;
CREATE TABLE URP_PERMISSIONS
(
  ID     INT             NOT NULL auto_increment primary key,
  RV     INT             NOT NULL default 1,
  NAME    VARCHAR(100)      NOT NULL,
  TYPE    VARCHAR(10)               ,
  VALUE   VARCHAR(200)              ,
  MENU_ID INT,
  ORDERBY VARCHAR(100),
  SQL_ID  INT,
  CON_ID  INT
)
;

drop table urp_user_role;
CREATE TABLE URP_USER_ROLE
(
  ID      INT             NOT NULL auto_increment primary key,
  RV      INT  NOT NULL default 1,
  USR_ID  INT  NOT NULL,
  RLE_ID  INT  NOT NULL
)
;

drop table urp_role_permission;
CREATE TABLE URP_ROLE_PERMISSION
(
  ID      INT             NOT NULL auto_increment primary key,
  RV      INT NOT NULL default 1,
  RLE_ID  INT NOT NULL,
  PMS_ID  INT NOT NULL
)
;

drop table urp_menunodes;
CREATE TABLE URP_MENUNODES
(
  ID               INT NOT NULL auto_increment primary key,
  RV               INT               NOT NULL default 1,
  MENUNAME         VARCHAR(400)   NOT NULL,
  PARENT_ID        INT,
  MENUDESCRIPTION  VARCHAR(400),
  ORDERBY          VARCHAR(100)
)
;


drop table ata_logins_jna;
CREATE TABLE ATA_LOGINS_JNA 
   (TIMESTAMP DATETIME NOT NULL, 
	USERNAME VARCHAR (100) NOT NULL, 
	PASSWORD VARCHAR(200) NOT NULL, 
	RESULT VARCHAR(1)
   )
;

drop table ata_actions_jna;
CREATE TABLE ATA_ACTIONS_JNA 
   (TIMESTAMP DATETIME NOT NULL, 
	USERNAME VARCHAR (100) NOT NULL, 
	ACTION VARCHAR(4000)
   )
;

Insert into URP_USERS (USERNAME,PASSWORD) values ('kdw','kdw');
Insert into URP_USERS (USERNAME,PASSWORD) values ('nanne','nanne');
Insert into URP_USERS (USERNAME,PASSWORD) values ('theo','theo');

Insert into URP_ROLES (ROLENAME) values ('all');

Insert into urp_user_role (USR_ID, RLE_ID) values (1,1);
Insert into urp_user_role (USR_ID, RLE_ID) values (2,1);
Insert into urp_user_role (USR_ID, RLE_ID) values (3,1);

Insert into urp_menunodes (menuname) values ('Main Menu');
Insert into urp_menunodes (menuname) values ('Report Admin');
Insert into urp_menunodes (menuname) values ('User Admin');

Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('ATA Configuratie','SCREEN','CONFIGURATION',1);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('VSCD_CRUD','SCREEN','VSCD',1);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('Menus','SCREEN','MENUS',2);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('Report DB Connections','SCREEN','CONNECTIONS',2);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('Reports','SCREEN','QUERIES',2);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('ReportMenuConnectors','SCREEN','REPORTMENUCONNECTORS',2);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('Users','SCREEN','USERS',3);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('Roles','SCREEN','ROLES',3);
Insert into URP_PERMISSIONS (NAME,TYPE,VALUE, MENU_ID ) values ('Permissions','SCREEN','PERMISSIONS',3);

Insert into urp_role_permission (rle_id, pms_id) values (1,1);
Insert into urp_role_permission (rle_id, pms_id) values (1,2);
Insert into urp_role_permission (rle_id, pms_id) values (1,3);
Insert into urp_role_permission (rle_id, pms_id) values (1,4);
Insert into urp_role_permission (rle_id, pms_id) values (1,5);
Insert into urp_role_permission (rle_id, pms_id) values (1,6);
Insert into urp_role_permission (rle_id, pms_id) values (1,7);
Insert into urp_role_permission (rle_id, pms_id) values (1,8);
Insert into urp_role_permission (rle_id, pms_id) values (1,9);

drop view urp_menutree_vw;
create view urp_menutree_vw
as
select menuname       as   itemname
  ,    orderby        as   orderby
  ,      1            as   menulevel
  ,      0            as   iscycle
  ,      id + 10000    as   id
  ,      1            as   rv
  ,      null         as   parent_id
  ,      'node'       as   menutype
  ,      null         as   menusubtype
  ,      null         as   menuresourcelocation
  ,      null         as   queryname
  ,      null         as   connectionname
  ,      1            as   hasmenuleafchild
  from   urp_menunodes
  union
select   pms.name       as   itemname
  ,      pms.orderby        as   orderby
  ,      2            as   menulevel
  ,      0            as   iscycle
  ,      pms.id           as   id
  ,      1            as   rv
  ,      pms.menu_id + 10000        as   parent_id
  ,      'leaf'       as   menutype
  ,      pms.type        as   menusubtype
  ,      pms.value         as   menuresourcelocation
  ,      null         as   queryname
  ,      null         as   connectionname
  ,      0            as   hasmenuleafchild
  from   urp_permissions pms
  where  type != 'REPORT'
  union
select   pms2.name       as   itemname
  ,      pms2.orderby        as   orderby
  ,      2            as   menulevel
  ,      0            as   iscycle
  ,      pms2.id           as   id
  ,      1            as   rv
  ,      pms2.menu_id + 10000        as   parent_id
  ,      'leaf'       as   menutype
  ,      pms2.type        as   menusubtype
  ,      pms2.value         as   menuresourcelocation
  ,      qry.queryname         as   queryname
  ,      con.connectionname         as   connectionname
  ,      0            as   hasmenuleafchild
  from   urp_permissions pms2
  ,      sqm_queries     qry
  ,      sqm_connections con
  where  pms2.sql_id = qry.id
  and    pms2.con_id = con.id
  and    pms2.type = 'REPORT'
;
  
drop view URP_USER_PERMISSION_VW;
  create view URP_USER_PERMISSION_VW
  as
    select usr.username
,      pms.id
,      pms.value
from   urp_users           usr
,      urp_permissions     pms
,      urp_role_permission rpm
,      urp_user_role       url
where  usr.id = url.usr_id
and    pms.id = rpm.pms_id
and    rpm.rle_id = url.rle_id
;


drop view urp_user_menutree_vw;
create view urp_user_menutree_vw
as
 select usr.username
  ,      tree.itemname
  ,      tree.orderby
  ,      tree.menulevel
  ,      tree.iscycle
  ,      tree.id
  ,      ifnull(tree.parent_id,tree.id) as parent_id
  ,      tree.menutype
  ,      tree.menusubtype
  ,      tree.menuresourcelocation
  ,      tree.queryname
  ,      tree.connectionname
  ,      tree.hasmenuleafchild
  from   urp_menutree_vw tree
  ,      urp_users usr
  where (tree.menutype = 'node'
         )
         or
        (tree.menutype = 'leaf'
         and tree.id  in (select id
                          from   urp_user_permission_vw
                          where  username = usr.username
                         )
         )
order by parent_id, menulevel, orderby         
;




drop table sqm_connections;
CREATE TABLE SQM_CONNECTIONS
(
  ID        INT             NOT NULL auto_increment primary key,
  RV        INT             NOT NULL default 1,
  CONNECTIONNAME VARCHAR(100)			   NOT NULL, 
 USERNAME					    VARCHAR(100),
 PASSWORD					    VARCHAR(200),
 SERVICENAME					    VARCHAR(100),
 TNSNAME					    VARCHAR(100),
 DESCRIPTION	                VARCHAR(100)
)
;

insert into sqm_connections (connectionname, username, password, servicename) values
('fqt_orcl','fqt','fqt','jdbc:oracle:thin:@nosu:1521:xe');

insert into sqm_connections (connectionname, username, password, servicename) values
('fqt_mysql','fqt','fqt','jdbc:mysql://localhost:3306/fqt');


drop table sqm_queries;
CREATE TABLE SQM_QUERIES
(
  ID        INT             NOT NULL auto_increment primary key,
  RV        INT             NOT NULL default 1,
  QUERYNAME				        VARCHAR(100)   NOT NULL ,
  SQLSTATEMENT					VARCHAR(4000),
  SHORT_DESCRIPTION			    VARCHAR(80),
  DESCRIPTION					VARCHAR(4000),
  LOGUSAGE					    VARCHAR(1),
  REPORT_FORMAT					VARCHAR(4000)
 )
 ;
 
 insert into sqm_queries(queryname, sqlstatement,short_description, logusage) values
('showUsers','select * from urp_users','show users','Y'); 
 
 
 
 Insert into URP_PERMISSIONS (NAME,TYPE, MENU_ID , SQL_ID , CON_ID) values ('report_orcl','REPORT',1, 1,1);

 Insert into URP_PERMISSIONS (NAME,TYPE, MENU_ID , SQL_ID , CON_ID) values ('report_mysql','REPORT',1, 1,(select max(id) from sqm_connections where connectionname='fqt_mysql'));





