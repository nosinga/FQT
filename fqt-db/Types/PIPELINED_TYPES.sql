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
|||  Date     : $Date: 2011-04-22 14:16:27 +0200 (Fri, 22 Apr 2011) $
|||  Revision : $Revision: 5985 $
|||  Author   : $Author: nanne $
|||  URL      : $URL: svn://store01/fqt-db/Types/PIPELINED_TYPES.sql $
|||  ID       : $Id: PIPELINED_TYPES.sql 5985 2011-04-22 12:16:27Z nanne $
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