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
|||  $URL: svn://store01/fqt-db/Constraints/FQT_constraints.sql $                        
|||  $ID: $                         
|||-----------------------------------------------------------------------
**/
ALTER TABLE ATA_PARAMETERS ADD (
  CONSTRAINT ATA_PAR_PK PRIMARY KEY (ID));

ALTER TABLE ATA_PARAMETERS ADD (
  CONSTRAINT ATA_PAR_UK UNIQUE (PARAMETERNAME));

