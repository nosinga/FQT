CREATE OR REPLACE package body fqt_reports
IS
--
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_body_date         constant     varchar(4000) := '$Date: 2011-05-11 13:27:16 +0200 (Wed, 11 May 2011) $';
  s_body_revision     constant     varchar(4000) := '$Revision: 6012 $';
  s_body_author       constant     varchar(4000) := '$Author: nanne $';
  s_body_url          constant     varchar(4000) := '$URL: svn://store01/fqt-db/Packages/FQT_REPORTS.pkb $';
  s_body_id           constant     varchar(4000) := '$Id: FQT_REPORTS.pkb 6012 2011-05-11 11:27:16Z nanne $';
  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  /* ******************************************************************************* */
  /* FUNCTION ORA_INFO                                                               */
  /* ******************************************************************************* */
  function ora_info
  return varchar2 is
  begin
    return  '<ora_info>'||chr(10)
          ||'<ora_user>'||sys_context('USERENV', 'SESSION_USER')||'</ora_user>'||chr(10)
          ||'<ora_sid>'||sys_context('USERENV', 'DB_NAME')||'</ora_sid>'||chr(10)
          ||'<ora_host>'||sys_context('USERENV', 'SERVER_HOST')||'</ora_host>'||chr(10)
          ||'<ora_terminal>'||sys_context('USERENV', 'TERMINAL')||'</ora_terminal>'||chr(10)
          ||'<svn_info>'||chr(10)
          ||'<spec>'||chr(10)
          ||'<Date>'||SUBSTR(s_spec_date,8,LENGTH(s_spec_date)-9)||'</Date>'||chr(10)
          ||'<Revision>'||SUBSTR(s_spec_revision,12,LENGTH(s_spec_revision)-13)||'</Revision>'||chr(10)
          ||'<Author>'||SUBSTR(s_spec_author,10,LENGTH(s_spec_author)-11)||'</Author>'||chr(10)
          ||'<URL>'||SUBSTR(s_spec_url,7,LENGTH(s_spec_url)-8)||'</URL>'||chr(10)
          ||'<Id>'||SUBSTR(s_spec_id,6,LENGTH(s_spec_id)-7)||'</Id>'||chr(10)
          ||'</spec>'||chr(10)
          ||'<body>'||chr(10)
          ||'<Date>'||SUBSTR(s_body_date,8,LENGTH(s_body_date)-9)||'</Date>'||chr(10)
          ||'<Revision>'||SUBSTR(s_body_revision,12,LENGTH(s_body_revision)-13)||'</Revision>'||chr(10)
          ||'<Author>'||SUBSTR(s_body_author,10,LENGTH(s_body_author)-11)||'</Author>'||chr(10)
          ||'<URL>'||SUBSTR(s_body_url,7,LENGTH(s_body_url)-8)||'</URL>'||chr(10)
          ||'<Id>'||SUBSTR(s_body_id,6,LENGTH(s_body_id)-7)||'</Id>'||chr(10)
          ||'</body>'||chr(10)
          ||'</svn_info>'||chr(10)
          ||'</ora_info>'||chr(10)
          ;
  --
  end ora_info;
--
  /* ******************************************************************************* */
  /* FUNCTION ADD_STRING                                                             */
  /* ******************************************************************************* */
  function add_string                  ( p_string               in     clob
                                       , p_if_null              in     varchar2
                                       , p_if_notnull           in     varchar2
                                       , p_toevoeging           in     varchar2
                                       )
  return clob
  is
    -- Declaratie variabelen --
    l_return           clob;
  --
  begin
  --
    if p_string is null
    then
      -- De opgegeven string is leeg
      -- Plak de tussenvoegsel en de aanvulling aan elkaar vast
      l_return := p_if_null || p_toevoeging ;
    else
      -- De opgegevens string is niet leeg
      -- Plak achter deze string de tussenvoegsel en aanvulling
      l_return := p_string || p_if_notnull || p_toevoeging ;
      --
    end if;
    --
    return (l_return);
    --
  end add_string;
--
  /* ******************************************************************************* */
  /* FUNCTION MISSING_QUERIES                                                        */
  /* ******************************************************************************* */
  function missing_queries             ( p_queryname            in     varchar2
                                       , p_sqlstatement         in     varchar2
                                       )
  return clob
  is
  --
    -- Declaratie variabelen
    l_start              number;
    l_einde              number;
    l_stmnt              varchar2(4000);
    l_queryname          varchar2(4000);
    l_found              varchar2(1);
    l_true               boolean                    := true;
    l_return             clob;
  --
  begin
  --
    l_stmnt  := p_sqlstatement;
    --
    -- Bepaal of het statement #queryname= voorkomt in de query
    -- Dit statement verwijst namelijk naar een andere query (drill-down functie)
    while instr ( l_stmnt , '#queryname=' ) != 0
    loop
      --
      l_start := instr ( l_stmnt , '#queryname=' );
      --
      -- Drill-down statement komt voor
      -- Vervang allereerst de amp tekens voor #
      -- Het statement betreft namelijk : queryname=<queryname>&<parameternaam>=<parameterwaarde>#<verderedetails>#
      -- Hierbij geldt dat niet alle queries parameters hoeven te hebben dus de amp hoeft niet perse voor te komen
      l_stmnt := substr( l_stmnt , l_start );
      l_stmnt := replace( l_stmnt, '&' , '#' );
      --
      -- Bepaal vervolgens de eerstvolgende #, zodat daar de queryname uitgefilterd kan worden
      l_einde := instr ( l_stmnt , '#' , 1, 2 );
      --
      -- Bepaal tenslotte de queryname
      l_queryname := substr( l_stmnt , 12, l_einde - 12 );
      --
      -- Indien de qevonden queryname gelijk is aan '||queryname||' dan houdt dit in dat
      -- de query zichzelf aanroept. Dit betreft dus geen missing query
      if l_queryname != chr(39)|| '||queryname||' ||chr(39)
      then
        begin
          -- Bestaat de gevonden query
          select 'J'
          into   l_found
          from   sqm_queries
          where  queryname = l_queryname;
        exception
          when no_data_found
          then
            l_found := 'N';
        end;
      else
        l_found := 'J';
      end if;
      --
      if l_found = 'N'
      then
        -- De aangeroepen query is niet gevonden : print deze queryname als missing
        l_return := add_string ( l_return , null , chr(10) , l_queryname );
        --
      end if;
      --
        -- Pas het door te zoeken statement aan
      l_stmnt := substr(l_stmnt,l_einde );
      --
    end loop; -- instr --
  --
  return (l_return);
  --
  end missing_queries;
--
  /* ******************************************************************************* */
  /* FUNCTION QUERY_DEPENDENCIES                                                     */
  /* ******************************************************************************* */
  function query_dependencies
  return query_dependencies_tab pipelined
  is
    /*
    || Ophalen van de queries
    */
    cursor c_qry
    is
      select queryname
      ,      sqlstatement
      from   sqm_queries
    ;
    /* Cursor voor het bepalen van de queries die aangeroepen worden door de opgegeven query */
    cursor c_calling ( b_queryname        sqm_queries.queryname%type )
    is
      select sqm1.queryname
      ,      sqm2.queryname    roept_aan
      from   sqm_queries   sqm1
      ,      sqm_queries   sqm2
      where  sqm1.sqlstatement like '%'||'queryname='||sqm2.queryname||'%'
      and    sqm2.queryname      != sqm1.queryname
      and sqm1.queryname          = b_queryname
    ;
    /* Cursor voor het bepalen van de queries die de huidige query aanroepen */
    cursor c_called_by ( b_queryname        sqm_queries.queryname%type )
    is
      select sqm1.queryname
      ,      sqm2.queryname     aangeroepen_door
      from   sqm_queries   sqm1
      ,      sqm_queries   sqm2
      where  sqm1.queryname       = b_queryname
      and    sqm2.sqlstatement like '%'||'queryname='||sqm1.queryname||'%'
      and    sqm2.queryname      != sqm1.queryname
    ;
    --
    -- Declaratie variabelen
    out_rec                  query_dependencies_obj := query_dependencies_obj(null,null,null,null);
    l_called_by              clob;
    l_calling                clob;
    l_calling_missing        clob;
  --
  begin
  --
    /* Loop door alle aanwezige queries */
    for r_qry in c_qry
    loop
    --
      l_calling         := null;
      l_called_by       := null;
      l_calling_missing := null;
      --
      /* Vaststellen van de rapporten die de query zelf aanroept */
        for r_calling in c_calling ( r_qry.queryname )
      loop
        --
        l_calling := add_string ( l_calling , null , chr(10) , r_calling.roept_aan );
        --
      end loop;
      --
      /* Vaststellen van de rapporten die aangeroepen worden door de query */
      for r_called_by in c_called_by ( r_qry.queryname )
      loop
        --
        l_called_by := add_string ( l_called_by , null , chr(10) , r_called_by.aangeroepen_door );
        --
      end loop;
      --
      /* Vaststellen missing queries */
      l_calling_missing := missing_queries ( r_qry.queryname , r_qry.sqlstatement );
      --
      /* Stel out-rec samen */
      out_rec.queryname       := r_qry.queryname;
      out_rec.called_by       := l_called_by;
      out_rec.calling         := l_calling;
      out_rec.calling_missing := l_calling_missing;
      --
      pipe row(out_rec);
      --
    end loop; -- r_qry --
    --
    return;
    --
  end query_dependencies;
  --
  procedure changeReportConnection
            (p_action in varchar2
            ,p_pms_id  in number
            ,p_sql_id  in number
            ,p_con_id  in number
            ,p_menu_id in number
            ,p_role_id in number
            ,p_orderby in varchar2
            )
  is
  l_queryname      varchar2(100);
  l_connectionname varchar2(100);
  l_pms_id         number;
  begin
     if p_action not in ('Insert','Update') then raise_application_error(-20001,'no Insert or Update'); end if;
     select queryname      into l_queryname      from sqm_queries     where id = p_sql_id;
     select connectionname into l_connectionname from sqm_connections where id = p_con_id;
     if    p_action = 'Insert'
     then
       insert into urp_permissions
         (name
        ,type
        ,menu_id
        ,sql_id
        ,con_id
        ,orderby
        )
       values
        (l_queryname||'#'||l_connectionname
        ,'REPORT'
        ,p_menu_id
        ,p_sql_id
        ,p_con_id
        ,p_orderby
        )
        ;
        select urp_sequence.currval into l_pms_id from dual; 
     elsif p_action = 'Update'
     then
       update urp_permissions
       set    name    = l_queryname||'#'||l_connectionname
       ,      type    = 'REPORT'
       ,      menu_id = p_menu_id
       ,      sql_id  = p_sql_id
       ,      con_id  = p_con_id
       ,      orderby = p_orderby
       where  id = p_pms_id
       ;
       l_pms_id := p_pms_id;
     end if;
     if p_role_id is not null
     then
       begin
         insert into urp_role_permission
          (rle_id
          ,pms_id)
         values
          (p_role_id
          ,l_pms_id)
         ;
       exception when dup_val_on_index then null;
       end; 
     end if;
  end changeReportConnection
  ;          
  
  procedure insertReportConnection
            (p_sql_id  in number
            ,p_con_id  in number
            ,p_menu_id in number
            ,p_role_id in number
            ,p_orderby in varchar2
            )
  is
  begin
     changeReportConnection
            (p_action  => 'Insert'
            ,p_pms_id  => null
            ,p_sql_id  => p_sql_id
            ,p_con_id  => p_con_id
            ,p_menu_id => p_menu_id
            ,p_role_id => p_role_id
            ,p_orderby => p_orderby
            );  
  end insertReportConnection            
  ;
  procedure updateReportConnection
            (p_pms_id  in number
            ,p_sql_id  in number
            ,p_con_id  in number
            ,p_menu_id in number
            ,p_role_id in number
            ,p_orderby in varchar2
            )
  is
  begin
     changeReportConnection
            (p_action  => 'Update'
            ,p_pms_id  => p_pms_id
            ,p_sql_id  => p_sql_id
            ,p_con_id  => p_con_id
            ,p_menu_id => p_menu_id
            ,p_role_id => p_role_id
            ,p_orderby => p_orderby
            );  
  end updateReportConnection            
   ;
  function search(p_search in varchar2, p_table_name in varchar2, p_id_name in varchar2)
  return     varchar2
  is
  TYPE RefCurType IS REF CURSOR;
  l_refcur RefCurType;
  l_id_string     varchar2(32000);
  l_id            varchar2(100);
  l_return        varchar2(32000);
  l_sql_statement varchar2(32000);
  l_search        varchar2(4000);
  cursor csr_col_names(b_table_name varchar2)
  is
  select column_name
  from   user_tab_columns
  where  table_name = upper(b_table_name)
  ; 
  l_return varchar2(4000);
  begin
    l_search := '%'||lower(p_search)||'%';
    l_sql_statement := 'select '||p_id_name||' from '||p_table_name||chr(10)||
                       'where lower(';
    for r in csr_col_names(p_table_name)
    loop
      l_sql_statement := l_sql_statement||'||chr(0)||'||r.column_name;
    end loop;
    l_sql_statement   := replace(l_sql_statement,'where lower(||', 'where lower(');
    l_sql_statement   := l_sql_statement||') like '''||l_search||'''';   
    
    open l_refcur for l_sql_statement;
    LOOP
      FETCH l_refcur INTO l_id;
      EXIT WHEN l_refcur%NOTFOUND;
      l_id_string := l_id_string||'#'||l_id;
    END LOOP;
   CLOSE l_refcur;
   l_id_string := l_id_string||'#';
   return l_id_string;
  end search  
  ;
end fqt_reports; 
/

