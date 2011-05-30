CREATE OR REPLACE package body abkr_plsql_doc
is
---
--- begin private declarations
---
--- begin declarations for three support functions which can be
--- used in queries, ie it is trick to view the contents
--- of a plsql_table in a select statement. The thee
--- functions are
--- 1. plsql_tab_attribute
--- 2. plsql_tab_rowcount
--- 3. plsql_tab_column_to_clob
---
  type plsql_rec_type is record (
    column1   varchar2 (4000),
    column2   varchar2 (4000),
    column3   varchar2 (4000),
    column4   varchar2 (4000),
    column5   varchar2 (4000),
    column6   varchar2 (4000)
  );

  type plsql_tab_type is table of plsql_rec_type
    index by binary_integer;

  g_plsql_tab        plsql_tab_type;
  g_plsql_tab_null   plsql_tab_type;

---
--- end declarations for the three query support functions
---
---
---
  type stringpart_tab_type is table of varchar2 (255)
    index by binary_integer;

---
--- begin private functions
---

  ---
--- begin private functions for getdocumentation
---
  function packagespecification_ddl (
    p_owner          in   varchar2,
    p_package_name   in   varchar2
  )
    return clob
  is
    l_source_tab   source_tab_type;
    l_return       clob;
  begin
    l_source_tab := getsource (p_owner, p_package_name, 'PACKAGE');

    for i in 1 .. nvl (l_source_tab.last, 0)
    loop
      l_return := l_return || l_source_tab (i).text;
    end loop;

    l_return := 'CREATE OR REPLACE ' || l_return;
    return l_return;
  end packagespecification_ddl;

  function procedure_spec (
    p_packagespecification_ddl   in   clob,
    p_procedure_name             in   varchar2
  )
    return clob
  is
    l_return            clob;
    l_procedure_start   integer;
  begin
    l_procedure_start :=
      instr (upper (p_packagespecification_ddl),
             'PROCEDURE ' || upper (p_procedure_name)
            );

    if l_procedure_start = 0
    then
      l_procedure_start :=
        instr (upper (p_packagespecification_ddl),
               'FUNCTION ' || upper (p_procedure_name)
              );

      if l_procedure_start = 0
      then
        l_procedure_start :=
          instr (upper (p_packagespecification_ddl),
                 upper (p_procedure_name));
      end if;
    end if;

    l_return := substr (p_packagespecification_ddl, l_procedure_start);
    l_return := substr (l_return, 1, instr (l_return, ';') - 1);
    return l_return;
  end procedure_spec;

  function clob_part (
    p_clob           in   clob,
    p_start_needle   in   varchar2,
    p_end_needle     in   varchar2
  )
    return clob
  is
    l_return   clob;
  begin
    l_return := substr (p_clob, instr (p_clob, p_start_needle));
    l_return :=
      substr (l_return,
              1,
              instr (l_return, p_end_needle) + length (p_end_needle) - 1
             );
    return l_return;
  end clob_part;

  function cut_string (p_string in varchar2, p_separator in varchar2)
    return stringpart_tab_type
  is
    l_string             varchar2 (2000);
    l_remaining_string   varchar2 (32000);
    l_string_length      number;
    i                    integer             default 1;
    l_return             stringpart_tab_type;
  begin
    l_string_length := nvl (instr (p_string || p_separator, p_separator), 1);
    l_remaining_string := p_string || p_separator;

    loop
      exit when l_string_length = 0;
      exit when nvl (length (replace (l_remaining_string, p_separator)), 0) =
                                                                            0;
      l_string := substr (l_remaining_string, 1, l_string_length - 1);
      l_remaining_string := substr (l_remaining_string, l_string_length + 1);
      l_string_length := nvl (instr (l_remaining_string, p_separator), 0);

      if l_string is not null
      then
        l_return (i) := l_string;
        i := i + 1;
      end if;
    end loop;

    return l_return;
  end cut_string;

  function cut_clob (p_clob in clob, p_separator in varchar2)
    return stringpart_tab_type
  is
    l_string           varchar2 (255);
    l_remaining_clob   clob;
    l_clob_length      number;
    i                  integer             default 1;
    l_return           stringpart_tab_type;
  begin
    l_clob_length := nvl (instr (p_clob || p_separator, p_separator), 1);
    l_remaining_clob := p_clob || p_separator;

    loop
      exit when l_clob_length = 0;
      exit when nvl (length (replace (l_remaining_clob, p_separator)), 0) = 0;
      l_string := substr (l_remaining_clob, 1, l_clob_length - 1);
      l_string := ltrim(rtrim(l_string));
      l_remaining_clob := substr (l_remaining_clob, l_clob_length + 1);
      l_clob_length := nvl (instr (l_remaining_clob, p_separator), 0);

      if l_string is not null
      then
        l_return (i) := l_string;
        i := i + 1;
      end if;
    end loop;

    return l_return;
  end cut_clob;

---
--- end private functions
---
--- begin functional procedures
---
  function getdocumentation (
    p_owner           in   varchar2,
    p_packagename     in   varchar2,
    p_procedurename   in   varchar2
  )
    return documentation_tab_type
  is
    l_return               documentation_tab_type;

    cursor csr_procedures (
      b_owner            varchar2,
      b_package_name     varchar2,
      b_procedure_name   varchar2
    )
    is
      select distinct object_name package_name,
                      procedure_name procedure_name
                 from all_procedures
                where owner = nvl (upper (b_owner), owner)
                  and object_name = nvl (upper (b_package_name), object_name)
                  and procedure_name =
                                nvl (upper (b_procedure_name), procedure_name)
                  and (   procedure_name <> 'GETORAINFO'
                       or object_name = 'CSS_ORAPACKAGEINFO_API'
                      )
             order by 1, 2;

    l_packagespec_dll      clob;
    l_package_doc          clob;
    l_package_doc_tab      stringpart_tab_type;
    l_procedure_spec       clob;
    l_procedure_spec_tab   stringpart_tab_type;
  begin
    l_return (nvl (l_return.last, 0) + 1).owner := p_owner;
    l_return (l_return.last).package_name := p_packagename;
    l_return (l_return.last).textline := 'package ' || p_packagename;
    l_packagespec_dll := packagespecification_ddl (p_owner, p_packagename);
    l_package_doc := clob_part (l_packagespec_dll, '/**', '**/');
    l_package_doc_tab := cut_clob (l_package_doc, chr (10));

    for i in 1 .. nvl (l_package_doc_tab.last, 0)
    loop
      l_return (nvl (l_return.last, 0) + 1).textline := l_package_doc_tab (i);
    end loop;

    for r in csr_procedures (p_owner, p_packagename, p_procedurename)
    loop
      l_return (l_return.last + 1).package_name := r.package_name;
      l_return (l_return.last).procedure_name := r.procedure_name;
      l_procedure_spec :=
                         procedure_spec (l_packagespec_dll, r.procedure_name);
      l_procedure_spec_tab := cut_clob (l_procedure_spec, chr (10));

      for i in 1 .. nvl (l_procedure_spec_tab.last, 0)
      loop
        l_return (nvl (l_return.last, 0) + 1).textline :=
                                                     l_procedure_spec_tab (i);
      end loop;
    end loop;

    return l_return;
  end getdocumentation;

  function getdependencies (
    p_owner                in   varchar2,
    p_references_owner     in   varchar2,
    p_referencedby_owner   in   varchar2,
    p_objectname           in   varchar2
  )
    return references_tab_type
  is
    l_return             references_tab_type;

    cursor csr_dependencies_references (
      b_owner         varchar2,
      b_object_name   varchar2
    )
    is
      select distinct owner, name, type, referenced_name, referenced_type
                 from all_dependencies
                where owner = b_owner
                  and name = b_object_name
                  and name <> referenced_name
--and   referenced_name in (select distinct object_name from user_objects)
      order by        owner, name, referenced_type, referenced_name;

    cursor csr_dependencies_referenced_by (
      b_owner         varchar2,
      b_object_name   varchar2
    )
    is
      select distinct owner, name, type, referenced_name, referenced_type
                 from all_dependencies
                where owner = b_owner
                  and referenced_name = b_object_name
                  and name <> referenced_name
                  and name in (
                        select object_name
                          from all_objects
                         where object_type in
                                 ('PACKAGE', 'TABLE', 'VIEW', 'FUNCTION',
                                  'PROCEDURE', 'TYPE', 'TRIGGER', 'SEQUENCE'))
                  and referenced_name in (
                             select object_name
                               from all_objects
                              where object_type in
                                                 ('PACKAGE', 'TABLE', 'VIEW'))
             order by referenced_name, type, name;

    l_owner              varchar2 (35);
    l_name               varchar2 (35);
    l_references_name    varchar2 (35);
    l_type               varchar2 (35);
    j                    integer               default 0;

    type packagenames_rec_type is record (
      owner          varchar2 (35),
      package_name   varchar2 (35)
    );

    type packagenames_tab_type is table of packagenames_rec_type
      index by binary_integer;

    l_packagenames_tab   packagenames_tab_type;

    function getpackagenames (p_owner in varchar2, p_object_name in varchar2)
      return packagenames_tab_type
    is
      cursor csr_packages (b_owner varchar2, b_object_name varchar2)
      is
        select   owner, object_name package_name
            from all_objects
           where owner = nvl (upper (b_owner), owner)
             and object_name = nvl (upper (b_object_name), object_name)
             and object_type = 'PACKAGE'
        union
        select distinct owner, name package_name
                   from all_dependencies
                  where owner = nvl (upper (b_owner), owner)
                    and referenced_name =
                                  nvl (upper (b_object_name), referenced_name)
                    and name <> referenced_name
                    and name in (select distinct object_name
                                            from user_objects)
                    and type in ('PACKAGE', 'PACKAGE BODY')
        union
        select   owner, referenced_name package_name
            from all_dependencies
           where owner = nvl (upper (b_owner), owner)
             and name = nvl (upper (b_object_name), name)
             and name <> referenced_name
--and    referenced_name in (select object_name from all_objects where object_type in ('PACKAGE'))
        order by 1;

      cursor csr_all_packages (b_owner varchar2)
      is
        select owner, object_name package_name
          from all_objects
         where owner = nvl (upper (b_owner), owner)
               and object_type = 'PACKAGE';

      l_packagenames_tab   packagenames_tab_type;
    begin
      if p_object_name is null
      then
        for r in csr_all_packages (p_owner)
        loop
          l_packagenames_tab (nvl (l_packagenames_tab.last, 0) + 1).owner :=
                                                                      r.owner;
          l_packagenames_tab (l_packagenames_tab.last).package_name :=
                                                               r.package_name;
        end loop;
      else
        for r in csr_packages (p_owner, p_object_name)
        loop
          l_packagenames_tab (nvl (l_packagenames_tab.last, 0) + 1).owner :=
                                                                      r.owner;
          l_packagenames_tab (l_packagenames_tab.last).package_name :=
                                                               r.package_name;
        end loop;
      end if;

      return l_packagenames_tab;
    end getpackagenames;
  begin
    l_packagenames_tab := getpackagenames (p_owner, p_objectname);

    for i in 1 .. nvl (l_packagenames_tab.last, 0)
    loop
      for r2 in
        csr_dependencies_references (p_owner,
                                     l_packagenames_tab (i).package_name
                                    )
      loop
        j := j + 1;

        if csr_dependencies_references%rowcount = 1
        then
          l_owner := l_packagenames_tab (i).owner;
          l_name := l_packagenames_tab (i).package_name;
          l_references_name := l_packagenames_tab (i).package_name;
        else
          l_owner := null;
          l_name := null;
        end if;

        l_type := replace (r2.referenced_type, 'PACKAGE BODY', 'PACKAGE');
        l_return (j).owner := l_owner;
        l_return (j).packagename := l_name;
        l_return (j).references := lower (l_type) || ' ' || r2.referenced_name;
        l_return (j).referencedby := '';
      end loop;

      for r2 in
        csr_dependencies_referenced_by (p_owner,
                                        l_packagenames_tab (i).package_name
                                       )
      loop
        j := j + 1;

        if     csr_dependencies_referenced_by%rowcount = 1
           and l_packagenames_tab (i).package_name <> l_references_name
        then
          l_owner := l_packagenames_tab (i).owner;
          l_name := l_packagenames_tab (i).package_name;
        else
          l_owner := null;
          l_name := null;
        end if;

        l_type := replace (r2.type, 'PACKAGE BODY', 'PACKAGE');
        l_return (j).packagename := l_name;
        l_return (j).references := '';
        l_return (j).referencedby := lower (l_type) || ' ' || r2.name;
      end loop;
    end loop;

    return l_return;
  end getdependencies;

  function gettabledetails (p_owner in varchar2, p_table_name in varchar2)
    return tabledetails_tab_type
  is
    i                     integer               default 0;
    l_return              tabledetails_tab_type;
    l_column_definition   varchar2 (100);

    cursor csr_tables (b_owner varchar2, b_table_name varchar2)
    is
      select owner, table_name, table_type, comments
        from all_tab_comments
       where owner = b_owner
         and table_name = nvl (upper (b_table_name), table_name);

    cursor csr_columns (b_owner varchar2, b_table_name varchar2)
    is
      select   atcl.owner, atcl.table_name, atcl.column_name, atcl.data_type,
               atcl.data_length, atcl.data_precision, atcl.data_scale,
               atcl.nullable, atcl.data_default, acct.comments
          from all_tab_columns atcl, all_col_comments acct
         where atcl.owner = b_owner
           and atcl.table_name = nvl (upper (b_table_name), atcl.table_name)
           and atcl.table_name = acct.table_name
           and atcl.column_name = acct.column_name
      order by atcl.column_id;
  begin
    for r_tab in csr_tables (p_owner, p_table_name)
    loop
      i := i + 1;
      l_return (i).owner := r_tab.owner;
      l_return (i).table_name := r_tab.table_name;
      l_return (i).table_type := r_tab.table_type;
      l_return (i).comments := r_tab.comments;

      for r in csr_columns (p_owner, r_tab.table_name)
      loop
        i := i + 1;
        l_column_definition := r.data_type;

        if (r.data_type = 'NUMBER')
        then
          if (r.data_precision is not null)
          then
            l_column_definition :=
                               l_column_definition || '(' || r.data_precision;

            if (r.data_scale is not null)
            then
              l_column_definition :=
                                   l_column_definition || ',' || r.data_scale;
            end if;

            l_column_definition := l_column_definition || ')';
          end if;
        elsif (r.data_type like '%CHAR%')
        then
          l_column_definition :=
                           l_column_definition || '(' || r.data_length || ')';
        end if;

        l_return (i).column_name := r.column_name;
        l_return (i).column_definition := l_column_definition;
        l_return (i).comments := r.comments;
      end loop;
    end loop;

    return l_return;
  end gettabledetails;

  function getsource (
    p_owner         in   varchar2,
    p_object_name   in   varchar2,
    p_object_type   in   varchar2
  )
    return source_tab_type
  is
    l_return                 source_tab_type;

    cursor csr_all_source_objects (
      b_owner         varchar2,
      b_object_name   varchar2,
      b_object_type   varchar2
    )
    is
      select distinct name object_name, type object_type
                 from all_source
                where owner = b_owner
                  and name = nvl (b_object_name, name)
                  and type = nvl (b_object_type, type)
             order by (decode (type,
                               'PACKAGE', 1,
                               'PACKAGE BODY', 2,
                               'FUNCTION', 3,
                               'PROCEDURE', 4,
                               'TRIGGER', 5,
                               'TYPE', 6,
                               'TYPE BODY', 7
                              )
                      ),
                      name;

    cursor csr_all_source (
      b_owner         varchar2,
      b_object_name   varchar2,
      b_object_type   varchar2
    )
    is
      select   line, text
          from all_source
         where owner = b_owner and name = b_object_name
               and type = b_object_type
      order by line;

    i                        integer         default 0;
    l_prev_row_object_name   varchar2 (35)   default ' ';
    l_prev_row_object_type   varchar2 (35)   default ' ';
    l_object_name            varchar2 (35)   default ' ';
    l_object_type            varchar2 (35)   default ' ';
  begin
    for r1 in csr_all_source_objects (p_owner, p_object_name, p_object_type)
    loop
      for r2 in csr_all_source (p_owner, r1.object_name, r1.object_type)
      loop
        if l_prev_row_object_name <> r1.object_name
        then
          l_object_name := r1.object_name;
          l_object_type := r1.object_type;
        else
          l_object_name := null;
          l_object_type := null;
        end if;

        if l_prev_row_object_type <> r1.object_type
        then
          l_object_type := r1.object_type;
        end if;

        i := i + 1;
        l_return (i).object_name := l_object_name;
        l_return (i).object_type := l_object_type;
        l_return (i).line := r2.line;
        l_return (i).text := r2.text;
        l_prev_row_object_name := r1.object_name;
        l_prev_row_object_type := r1.object_type;
      end loop;
    end loop;

    return l_return;
  end getsource;

---
--- end functional procedures
---
---
--- begin technical procedures
---
  function plsql_tab_attribute (p_column_num in integer, p_row_num in integer)
    return varchar2
  is
    l_return   varchar2 (4000);
  begin
    case p_column_num
      when 1
      then
        l_return := g_plsql_tab (p_row_num).column1;
      when 2
      then
        l_return := g_plsql_tab (p_row_num).column2;
      when 3
      then
        l_return := g_plsql_tab (p_row_num).column3;
      when 4
      then
        l_return := g_plsql_tab (p_row_num).column4;
      when 5
      then
        l_return := g_plsql_tab (p_row_num).column5;
      when 6
      then
        l_return := g_plsql_tab (p_row_num).column6;
      else
        null;
    end case;

    return l_return;
  end plsql_tab_attribute;

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
    return integer
  is
    type key_value_rec_type is record (
      p_key     varchar2 (4000),
      p_value   varchar2 (4000)
    );

    type key_value_tab_type is table of key_value_rec_type
      index by binary_integer;

    l_owner                    varchar2 (100);
--
    l_packagename              varchar2 (100);
    l_procedurename            varchar2 (100);
    l_documentation_tab        documentation_tab_type;
--
    l_objectname               varchar2 (100);
    l_references_tab           references_tab_type;
--
    l_table_name               varchar2 (100);
    l_tabledetails_tab         tabledetails_tab_type;
--
    l_object_name              varchar2 (100);
    l_object_type              varchar2 (100);
    l_source_tab               source_tab_type;
--
    l_key_value_tab            key_value_tab_type;
--
    l_transactionid            varchar2 (100);
    l_document_retrieve_date   varchar2 (100);
    l_ora_user                 varchar2 (100);
    l_sid                      varchar2 (100);
    l_result_id                varchar2 (100);
    l_result_message           varchar2 (100);
  begin
    g_plsql_tab := g_plsql_tab_null;
    l_key_value_tab (1).p_key := p_key1;
    l_key_value_tab (1).p_value := p_value1;
    l_key_value_tab (2).p_key := p_key2;
    l_key_value_tab (2).p_value := p_value2;
    l_key_value_tab (3).p_key := p_key3;
    l_key_value_tab (3).p_value := p_value3;
    l_key_value_tab (4).p_key := p_key4;
    l_key_value_tab (4).p_value := p_value4;
    l_key_value_tab (5).p_key := p_key5;
    l_key_value_tab (5).p_value := p_value5;
    l_key_value_tab (6).p_key := p_key6;
    l_key_value_tab (6).p_value := p_value6;

    for i in 1 .. nvl (l_key_value_tab.last, 0)
    loop
      case l_key_value_tab (i).p_key
        when 'owner'
        then
          l_owner := l_key_value_tab (i).p_value;
        else
          null;
      end case;
    end loop;

    case p_function_name
      when 'getdocumentation'
      then
        for i in 1 .. nvl (l_key_value_tab.last, 0)
        loop
          case l_key_value_tab (i).p_key
            when 'packagename'
            then
              l_packagename := l_key_value_tab (i).p_value;
            when 'procedurename'
            then
              l_procedurename := l_key_value_tab (i).p_value;
            else
              null;
          end case;
        end loop;

        l_documentation_tab :=
                    getdocumentation (l_owner, l_packagename, l_procedurename);

        for i in 1 .. nvl (l_documentation_tab.last, 0)
        loop
          g_plsql_tab (i).column1 := l_documentation_tab (i).owner;
          g_plsql_tab (i).column2 := l_documentation_tab (i).package_name;
          g_plsql_tab (i).column3 := l_documentation_tab (i).procedure_name;
          g_plsql_tab (i).column4 := l_documentation_tab (i).textline;
        end loop;
      when 'getdependencies'
      then
        for i in 1 .. nvl (l_key_value_tab.last, 0)
        loop
          case l_key_value_tab (i).p_key
            when 'objectname'
            then
              l_objectname := l_key_value_tab (i).p_value;
            else
              null;
          end case;
        end loop;

        l_references_tab :=
                     getdependencies (l_owner, l_owner, l_owner, l_objectname);

        for i in 1 .. nvl (l_references_tab.last, 0)
        loop
          g_plsql_tab (i).column1 := l_references_tab (i).owner;
          g_plsql_tab (i).column2 := l_references_tab (i).packagename;
          g_plsql_tab (i).column3 := l_references_tab (i).references;
          g_plsql_tab (i).column4 := l_references_tab (i).referencedby;
        end loop;
      when 'gettabledetails'
      then
        for i in 1 .. nvl (l_key_value_tab.last, 0)
        loop
          case l_key_value_tab (i).p_key
            when 'table_name'
            then
              l_table_name := l_key_value_tab (i).p_value;
            else
              null;
          end case;
        end loop;

        l_tabledetails_tab := gettabledetails (l_owner, l_table_name);

        for i in 1 .. nvl (l_tabledetails_tab.last, 0)
        loop
          g_plsql_tab (i).column1 := l_tabledetails_tab (i).owner;
          g_plsql_tab (i).column2 := l_tabledetails_tab (i).table_name;
          g_plsql_tab (i).column3 := l_tabledetails_tab (i).table_type;
          g_plsql_tab (i).column4 := l_tabledetails_tab (i).column_name;
          g_plsql_tab (i).column5 := l_tabledetails_tab (i).column_definition;
          g_plsql_tab (i).column6 := l_tabledetails_tab (i).comments;
        end loop;
      when 'getsource'
      then
        for i in 1 .. nvl (l_key_value_tab.last, 0)
        loop
          case l_key_value_tab (i).p_key
            when 'object_name'
            then
              l_object_name := l_key_value_tab (i).p_value;
            when 'object_type'
            then
              l_object_type := l_key_value_tab (i).p_value;
            else
              null;
          end case;
        end loop;

        l_source_tab := getsource (l_owner, l_object_name, l_object_type);

        for i in 1 .. nvl (l_source_tab.last, 0)
        loop
          g_plsql_tab (i).column1 := l_source_tab (i).owner;
          g_plsql_tab (i).column2 := l_source_tab (i).object_name;
          g_plsql_tab (i).column3 := l_source_tab (i).object_type;
          g_plsql_tab (i).column4 := l_source_tab (i).line;
          g_plsql_tab (i).column5 := l_source_tab (i).text;
        end loop;
    end case;

    return nvl (g_plsql_tab.last, 0);
  end plsql_tab_rowcount;

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
  is
    l_i           integer;
    l_return      clob;
    l_plsql_tab   plsql_tab_type;

    function column_from_record (
      p_plsql_rec    in   plsql_rec_type,
      p_column_num   in   integer
    )
      return varchar2
    is
      l_return   varchar2 (4000);
    begin
      case p_column_num
        when 1
        then
          l_return := p_plsql_rec.column1;
        when 2
        then
          l_return := p_plsql_rec.column2;
        when 3
        then
          l_return := p_plsql_rec.column3;
        when 4
        then
          l_return := p_plsql_rec.column4;
        when 5
        then
          l_return := p_plsql_rec.column5;
        when 6
        then
          l_return := p_plsql_rec.column6;
        else
          null;
      end case;

      return l_return;
    end column_from_record;

    function columns_from_record (
      p_plsql_rec     in   plsql_rec_type,
      p_column_nums   in   integer,
      p_separator     in   varchar2 default ' '
    )
      return varchar2
    is
      l_return   varchar2 (4000);
    begin
      for i in 1 .. length (p_column_nums)
      loop
        l_return :=
             l_return
          || p_separator
          || column_from_record (p_plsql_rec, substr (p_column_nums, i, 1));
      end loop;

      return l_return;
    end columns_from_record;
  begin
    l_i :=
      plsql_tab_rowcount (p_function_name,
                          p_key1,
                          p_value1,
                          p_key2,
                          p_value2,
                          p_key3,
                          p_value3,
                          p_key4,
                          p_value4,
                          p_key5,
                          p_value5,
                          p_key6,
                          p_value6
                         );
    l_plsql_tab := g_plsql_tab;

    for i in 1 .. nvl (l_plsql_tab.last, 0)
    loop
      l_return :=
             l_return || columns_from_record (l_plsql_tab (i), p_column_nums);
    end loop;

    return l_return;
  end plsql_tab_column_to_clob;
end abkr_plsql_doc; 
/

