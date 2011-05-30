/**
|||------------------------------------------------------------------------
|||OMSCHRIJVING:
|||  Aanmaken van de objecttypes t.b.v. pipelined functies
|||
|||PARAMETERS:
|||
|||OPMERKINGEN:
|||
|||SUBVERSION INFO : DO NOT CHANGE!!!!
|||  Date     : $Date: 2010-11-04 11:28:22 +0100 (Thu, 04 Nov 2010) $
|||  Revision : $Revision: 25877 $
|||  Author   : $Author: mcopier $
|||  URL      : $URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Types/PIPELINED_TYPES.sql $
|||  ID       : $Id: PIPELINED_TYPES.sql 25877 2010-11-04 10:28:22Z mcopier $
|||------------------------------------------------------------------------
**/
--
PROMPT OBJECT TYPE QUERY_DEPENDENCIES_OBJ
create or replace type query_dependencies_obj as object 
  ( queryname          varchar2(100)
  , called_by          clob
  , calling            clob
  , calling_missing    clob
  )
/
--
PROMPT TABLE TYPE QUERY_DEPENDENCIES_TAB
create or replace
type query_dependencies_tab as table of query_dependencies_obj
/
--