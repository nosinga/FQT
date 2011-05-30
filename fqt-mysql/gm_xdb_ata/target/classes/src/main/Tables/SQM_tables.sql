/**
|||------------------------------------------------------------------------
|||OMSCHRIJVING:
|||  Aanmaken tabeldefinities SQM
|||
|||PARAMETERS:
|||
|||OPMERKINGEN:
|||
|||SUBVERSION INFO : DO NOT CHANGE!!!!
|||  Date     : $Date: 2010-09-29 10:32:05 +0200 (Wed, 29 Sep 2010) $
|||  Revision : $Revision: 23881 $
|||  Author   : $Author: mcopier $
|||  URL      : $URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Tables/SQM_tables.sql $
|||  ID       : $Id: SQM_tables.sql 23881 2010-09-29 08:32:05Z mcopier $
|||------------------------------------------------------------------------
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
, SQLSTATEMENT       VARCHAR2(4000 BYTE)
, SHORT_DESCRIPTION  VARCHAR2(80 BYTE)                     NOT NULL
, DESCRIPTION        VARCHAR2(4000 BYTE)
, LOGUSAGE           VARCHAR2(1)              DEFAULT 'y'
, REPORT_FORMAT      VARCHAR2(4000 BYTE)
)
;

