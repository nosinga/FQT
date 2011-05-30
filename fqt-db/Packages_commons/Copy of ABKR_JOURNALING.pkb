PROMPT CREATE OR REPLACE PACKAGE BODY ABKR_JOURNALING
create or replace package body ABKR_JOURNALING
is
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date     constant varchar(4000) := '$Date: 2011-04-22 14:16:27 +0200 (Fri, 22 Apr 2011) $';
  s_body_revision constant varchar(4000) := '$Revision: 5985 $';
  s_body_author   constant varchar(4000) := '$Author: nanne $';
  s_body_url      constant varchar(4000) := '$URL: svn://store01/fqt-db/Packages_commons/Copy%20of%20ABKR_JOURNALING.pkb $';
  s_body_id       constant varchar(4000) := '$Id: Copy of ABKR_JOURNALING.pkb 5985 2011-04-22 12:16:27Z nanne $';
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  /* ******************************************************************************* */
  /* FUNCTION ORA_INFO                                                               */
  /* ******************************************************************************* */
  function ora_info
    return varchar2
  is
  begin
    return 's_spec_id  : '||s_spec_id  ||chr(10)||
           's_spec_url : '||s_spec_url ||chr(10)||
           's_body_id  : '||s_body_id  ||chr(10)||
           's_spec_url : '||s_body_url
           ;
  end ora_info;
--
  /* ******************************************************************************* */
  /* FUNCTION GETUSER                                                                */
  /* ******************************************************************************* */
  function getuser
  return varchar2
  is
  begin
  --
    if ( g_user is not null )
    then
      return( g_user );
    else
      raise_application_error( -20000, 'Identify yourself first!' );
    end if;
  --
  END getUser;
--
  /* ******************************************************************************* */
  /* FUNCTION SETUSER                                                                */
  /* ******************************************************************************* */
  function setuser                     ( p_username             in     varchar2 )
  return varchar2
  is
  begin
  --
    g_user := p_username;
    return( g_user );
  --
  end setuser;
--
  /* ******************************************************************************* */
  /* PROCEDURE SETUSER                                                               */
  /* ******************************************************************************* */
  procedure setuser                    ( p_username             in     varchar2 )
  is
  begin
  --
    g_user := setuser( p_username => p_username );
  --
  end setuser;
--
end abkr_journaling;
/

