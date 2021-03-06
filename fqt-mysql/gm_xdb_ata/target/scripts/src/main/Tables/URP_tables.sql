PROMPT CREATE TABLE URP_USERS
CREATE TABLE URP_USERS
(
  ID        NUMBER,
  RV        NUMBER             NOT NULL,
  USERNAME  VARCHAR2(100 BYTE) NOT NULL,
  PASSWORD  VARCHAR2(200 BYTE) NOT NULL,
  IDM_ID    VARCHAR2(100 BYTE)
)
;

PROMPT CREATE TABLE URP_ROLES
CREATE TABLE URP_ROLES
(
  ID        NUMBER,
  RV        NUMBER             NOT NULL,
  ROLENAME  VARCHAR2(100 BYTE) NOT NULL
)
;

PROMPT CREATE TABLE URP_PERMISSIONS
CREATE TABLE URP_PERMISSIONS
(
  ID     NUMBER,
  RV     NUMBER             NOT NULL,
  VALUE  VARCHAR2(200 BYTE) NOT NULL
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

