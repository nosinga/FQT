/**
|||-----------------------------------------------------------------------
|||OMSCHRIJVING:
|||  
|||
|||PARAMETERS:
|||
|||OPMERKINGEN:
|||
|||SUBVERSION INFO : DO NOT CHANGE!!!!
|||  $Date: 2011-04-29 10:01:47 +0200 (Fri, 29 Apr 2011) $                       
|||  $Revision: 5998 $                   
|||  $Author: nanne $                     
|||  $URL: svn://store01/fqt-db/Tables/URP_tables.sql $                        
|||  $ID: $                         
|||-----------------------------------------------------------------------
**/
PROMPT CREATE TABLE URP_USERS_TAB
CREATE TABLE URP_USERS_TAB
(
  ID        NUMBER,
  RV        NUMBER             NOT NULL,
  USERNAME  VARCHAR2(100 BYTE) NOT NULL,
  PASSWORD  VARCHAR2(200 BYTE) ,
  IDM_ID    VARCHAR2(100 BYTE)
)
;

PROMPT CREATE TABLE URP_ROLES
CREATE TABLE URP_ROLES
(
  ID          NUMBER,
  RV          NUMBER             NOT NULL,
  ROLENAME    VARCHAR2(100 BYTE) NOT NULL,
  DESCRIPTION VARCHAR2(200)              
)
;

PROMPT CREATE TABLE URP_PERMISSIONS
CREATE TABLE URP_PERMISSIONS
(
  ID      NUMBER,
  RV      NUMBER             NOT NULL,
  NAME    VARCHAR2(100)      NOT NULL,
  TYPE    VARCHAR2(10)               ,
  VALUE   VARCHAR2(200 BYTE)         ,
  MENU_ID NUMBER,
  ORDERBY VARCHAR2(100),
  SQL_ID  NUMBER,
  CON_ID  NUMBER
)
;

PROMPT CREATE TABLE URP_USER_ROLE
CREATE TABLE URP_USER_ROLE
(
  ID      NUMBER,
  RV      NUMBER  NOT NULL,
  USR_ID  NUMBER  NOT NULL,
  RLE_ID  NUMBER  NOT NULL
)
;

PROMPT CREATE TABLE URP_ROLE_PERMISSION
CREATE TABLE URP_ROLE_PERMISSION
(
  ID      NUMBER,
  RV      NUMBER NOT NULL,
  RLE_ID  NUMBER NOT NULL,
  PMS_ID  NUMBER NOT NULL
)
;
CREATE TABLE URP_MENUNODES
(
  ID               NUMBER,
  RV               NUMBER               NOT NULL,
  MENUNAME         VARCHAR2(400 BYTE)   NOT NULL,
  PARENT_ID        NUMBER,
  MENUDESCRIPTION  VARCHAR2(400 BYTE),
  ORDERBY          VARCHAR2(100 BYTE)
)
;

