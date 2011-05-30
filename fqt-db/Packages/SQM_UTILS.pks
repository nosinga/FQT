CREATE OR REPLACE PACKAGE Sqm_Utils IS
/**
**/
-- User defined type OraVersion
--
TYPE OraVersion_rec_type IS RECORD (
	 ORACLE_VERSION  VARCHAR2(100)
);
TYPE OraVersion_ref_csr_type IS REF CURSOR RETURN OraVersion_rec_type;

g_user VARCHAR2(100);

type bindvariable_rec_type is record (
    bindvariable     varchar2 (200)
);

type bindvariable_tab_type is table of bindvariable_rec_type
    index by binary_integer;

function getbindvariables (
    p_query           in   varchar2
)
return bindvariable_tab_type
/**
This function returns in a pl/sql table
the bind variables found in a string
A bindvariable is characterized with ":"
The function ignores reserved words
like HH24, MI and SS
The functions returns a list of unique
bindvariables ie double names are
removed
**/
;
function getbindvariable (
    p_query           in   varchar2
   ,p_index           in   integer default 1
)
return varchar2
/**
This function returns a member of
the result of the getbindvariables
The member is identified by it's
index. The index starts at 1
**/
;
function getbindvariabledefaultvalue (
    p_bindvariable    in   varchar2
)
return varchar2
/**
This function returns a default
value for a bind variable.
especially for date bind variables
the date "19700101" is returned
in all order cases the name
of the bind variable is used
for the value of that specific
bind variable
**/
;
function getbindvariablefitnessestring (
    p_bindvariable    in   varchar2
)
return varchar2
/**
This is a helper function
that generates a fitnesse table
string which can be used in fitnesse
tests. This function is used
a "gencontents.sql" script
which can be found in
abkr/gm_fit_dev/src/main/fitnesse/root/AbkrTestSuite/AtaSuite/AtaVraagTest
**/
;
PROCEDURE update_urp_permissions
( p_cud_action IN VARCHAR2
, p_new_queryname IN VARCHAR2
, p_old_queryname IN VARCHAR2 DEFAULT NULL
);
--
  function connectionname2id (p_connectionname in varchar2)
    return number;
--
  function queryname2id (p_queryname in varchar2)
    return number;
--
function reportexists(p_reportname in varchar2)
return boolean
;
function connectionexists(p_connectionname in varchar2)
return boolean
;

PROCEDURE GetOraInfo (
/**
This method is available in each package and is used
to return to status and version of the individual
package and to  return the schema and database info
of the databse in which the package resides
**/
    p_user IN VARCHAR2
  , px_transactionId IN OUT VARCHAR2
  , x_PACKAGE_NAME OUT VARCHAR2
  , x_PACKAGE_VSS_HEADER OUT VARCHAR2
  , x_PACKAGE_VSS_REVISION OUT VARCHAR2
  , x_ORA_USER OUT VARCHAR2
  , x_SID OUT VARCHAR2
  , x_ORA_VERSION_LIST OUT OraVersion_ref_csr_type
);
--
END Sqm_Utils;
/

