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
|||  $Date: 2011-05-11 12:26:05 +0200 (Wed, 11 May 2011) $                       
|||  $Revision: 6011 $                   
|||  $Author: nanne $                     
|||  $URL: svn://store01/fqt-db/Tables/SQM_tables.sql $                        
|||  $ID: $                         
|||-----------------------------------------------------------------------
**/
--
PROMPT CREATE TABLE SQM_CONNECTIONS
CREATE TABLE SQM_CONNECTIONS
(
  ID                 NUMBER
, RV                 NUMBER                   DEFAULT 1   NOT NULL
, CONNECTIONNAME     VARCHAR2(100 BYTE)                   NOT NULL
, USERNAME           VARCHAR2(100 BYTE)
, PASSWORD           VARCHAR2(200 BYTE)
, SERVICENAME        VARCHAR2(100 BYTE)
, TNSNAME            VARCHAR2(100 BYTE)
, DESCRIPTION        VARCHAR2(4000 BYTE)
)
;

PROMPT CREATE TABLE SQM_QUERIES
CREATE TABLE SQM_QUERIES
(
  ID                 NUMBER 
, RV                 NUMBER                   DEFAULT 1    NOT NULL
, QUERYNAME          VARCHAR2(100  BYTE)                   NOT NULL
, SQLSTATEMENT       CLOB
, SHORT_DESCRIPTION  VARCHAR2(80 BYTE)                     NOT NULL
, DESCRIPTION        VARCHAR2(4000 BYTE)
, LOGUSAGE           VARCHAR2(1)              DEFAULT 'y'
, REPORT_FORMAT      VARCHAR2(4000 BYTE)
)
;

