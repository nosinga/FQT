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
|||  $Date: 2011-04-22 14:16:27 +0200 (Fri, 22 Apr 2011) $                       
|||  $Revision: 5985 $                   
|||  $Author: nanne $                     
|||  $URL: svn://store01/fqt-db/Constraints/SQM_constraints.sql $                        
|||  $ID: $                         
|||-----------------------------------------------------------------------
**/
ALTER TABLE SQM_CONNECTIONS ADD (
  CONSTRAINT SQM_CON_PK PRIMARY KEY (ID));

ALTER TABLE SQM_CONNECTIONS ADD (
  CONSTRAINT SQM_CON_UK UNIQUE (CONNECTIONNAME));


ALTER TABLE SQM_QUERIES ADD (
  CONSTRAINT SQM_SQL_PK PRIMARY KEY (ID));

ALTER TABLE SQM_QUERIES ADD (
  CONSTRAINT SQM_SQL_UK UNIQUE (QUERYNAME));

