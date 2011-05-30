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
