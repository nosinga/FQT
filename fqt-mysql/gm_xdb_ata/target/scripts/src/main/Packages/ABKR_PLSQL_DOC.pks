CREATE OR REPLACE package abkr_plsql_doc
is
/**
This package contains tools to parse the declarations and
documentation comments in the packes specifications and
produces output describing the methods by means of
USAGE and INTERFACE
In addition to that it contains some basic functionality
to check and control the current version of the installed
packages
the four main functions are
1. getdocumentation
2. gettabledetails
3. getdependencies
4. getsource
In addition there are three support functions which can be
used in queries, ie it is trick to view the contents
of a plsql_table in a select statement. The thee
functions are
1. plsql_tab_attribute
2. plsql_tab_rowcount
3. plsql_tab_column_to_clob
**/
  type documentation_rec_type is record (
    owner            varchar2 (100),
    package_name     varchar2 (100),
    procedure_name   varchar2 (100),
    textline         varchar2 (256)
  );

  type documentation_tab_type is table of documentation_rec_type
    index by binary_integer;

  function getdocumentation (
    p_owner           in   varchar2,
    p_packagename     in   varchar2,
    p_procedurename   in   varchar2
  )
    return documentation_tab_type
/**
The procedure getdocumenation parses the declarations and
documentation comments in the packege specification and
return a list describing the methods by means of USAGE
, INTERFACE
If package and procedure name are filled in it return
the general package information and the documenation of
the requested procedure.
If only the package name is filled in it return the
information of the public procedures or functions
If all fields are left empty all the documentation of all
the packages are retrieved. This can take several minutes
**/
  ;

  type references_rec_type is record (
    owner          varchar2 (100),
    packagename    varchar2 (100),
    references     varchar2 (100),
    referencedby   varchar2 (100)
  );

  type references_tab_type is table of references_rec_type
    index by binary_integer;

  function getdependencies (
    p_owner                in   varchar2,
    p_references_owner     in   varchar2,
    p_referencedby_owner   in   varchar2,
    p_objectname           in   varchar2
  )
    return references_tab_type
/**
This method returns a list of all
the dependencies between the packages
tables and atomic methods (procedures and functions)
**/
  ;

  type tabledetails_rec_type is record (
    owner               varchar2 (30),
    table_name          varchar2 (30),
    table_type          varchar2 (30),
    column_name         varchar2 (100),
    column_definition   varchar2 (100),
    comments            varchar2 (4000)
  );

  type tabledetails_tab_type is table of tabledetails_rec_type
    index by binary_integer;

  function gettabledetails (p_owner in varchar2, p_table_name in varchar2)
    return tabledetails_tab_type
/**
This method returns the table definition for a table available
by owner. A table can both be a (base) table and a view.
A better name was maybe getdefineddatabaserelation
**/
  ;

  type source_rec_type is record (
    owner         varchar2 (30),
    object_name   varchar2 (30),
    object_type   varchar2 (30),
    line          number,
    text          varchar2 (4000)
  );

  type source_tab_type is table of source_rec_type
    index by binary_integer;

  function getsource (
    p_owner         in   varchar2,
    p_object_name   in   varchar2,
    p_object_type   in   varchar2
  )
    return source_tab_type
/**
This method return the source of the database objects
The current supported objects are
..PACKAGE
..PACKAGE BODY
..VIEW
..TYPE
..TRIGGER
..FUNCTION
..PROCEDURE
**/
  ;

  function plsql_tab_attribute (p_column_num in integer, p_row_num in integer)
    return varchar2
/**
    This function return one attribute from a matrix ( a plsql table)
    The attribute is defined by its position
    This function is used in the from part of a sql statement
    This fumction is always used in conjunction with the function
    plsql_tab_rowcount. The plsql_tab_rowcount function is
    used in the where clause of the above mentioned sql statement 
**/
  ;

  function plsql_tab_rowcount (
    p_function_name   in   varchar2,
    p_key1            in   varchar2 default null,
    p_value1          in   varchar2 default null,
    p_key2            in   varchar2 default null,
    p_value2          in   varchar2 default null,
    p_key3            in   varchar2 default null,
    p_value3          in   varchar2 default null,
    p_key4            in   varchar2 default null,
    p_value4          in   varchar2 default null,
    p_key5            in   varchar2 default null,
    p_value5          in   varchar2 default null,
    p_key6            in   varchar2 default null,
    p_value6          in   varchar2 default null
  )
/**
    This function is the trick of the three technical functions
    of this package. The trick is that this function
    fills the matric (plsql table) based on the input parameters
    given into this function.
    The parameter functionname has to be filled with one of
    the four above mentioned functional functionnames ie
    1. getdocumentation
    2. gettabledetails
    3. getdependencies
    4. getsource
    The other parameters have to be filled as key value pairs
    the sequence is free however the kaynames have to match
    the parameters of the the four above mentioned functions.
    This fumction is always used in conjunction with the function
    plsql_tab_attribute. The plsql_tab_attribute function is
    used in the from clause of the a sql statement in which
    the  plsql_tab_rowcount is used in the where clause
**/
  return integer;

  function plsql_tab_column_to_clob (
    p_function_name   in   varchar2,
    p_column_nums     in   integer,
    p_key1            in   varchar2 default null,
    p_value1          in   varchar2 default null,
    p_key2            in   varchar2 default null,
    p_value2          in   varchar2 default null,
    p_key3            in   varchar2 default null,
    p_value3          in   varchar2 default null,
    p_key4            in   varchar2 default null,
    p_value4          in   varchar2 default null,
    p_key5            in   varchar2 default null,
    p_value5          in   varchar2 default null,
    p_key6            in   varchar2 default null,
    p_value6          in   varchar2 default null
  )
    return clob
/**
    This function uses the same trick as plsql_tab_rowcount fuction
    of this package. The trick is that this function
    fills the matric (plsql table) based on the input parameters
    given into this function. However the next step is
    that on oere moer columns are combined to one record
    an the records are combined as a list. The list is return as a 
    clob.
    The parameter functionname has to be filled with one of
    the four above mentioned functional functionnames ie
    1. getdocumentation
    2. gettabledetails
    3. getdependencies
    4. getsource
    The other parameters have to be filled as key value pairs
    the sequence is free however the kaynames have to match
    the parameters of the the four above mentioned functions
**/
    
    ;
end abkr_plsql_doc; 
/

