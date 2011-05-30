PROMPT CREATE OR REPLACE PACKAGE BODY XMLP
CREATE OR REPLACE PACKAGE BODY Xmlp
IS
  g_package_name CONSTANT VARCHAR2(100) DEFAULT 'XMLP';
-- -------------------------------------------------------------------
FUNCTION ev(
     p_string IN CLOB
   , p_element_name IN VARCHAR2
   , p_occurence IN NUMBER DEFAULT 1)
RETURN VARCHAR2
IS
-- Haal uit CLOB <p_string> de waarde van tag <p_element_tag>. 
-- Gebruik het <p_occurence> e voorkomen van de tag.
  l_return                  varchar2(4000);
  l_tag                     varchar2(4000);
  l_chr                     varchar2(3);
  l_done                    boolean;
  l_pos                     integer;
  l_start_element_pos       integer;
  l_start_element_value_pos integer;
  l_end_element_pos         integer;
  l_element_value_length    integer;
  l_novalue_pos             integer;
  l_endquote_pos            integer;
BEGIN
  l_start_element_pos := instr(p_string,'<'||p_element_name, 1, p_occurence);
  l_start_element_value_pos := instr(p_string, '>', l_start_element_pos +1) +1;
  --
  if substr( p_string, l_start_element_value_pos -2, 1 ) = '/' then
    -- het is een tag zonder value  ("  <tagname/>  ")
    -- bestaat er een tag attribute "noValue"?
    l_tag := substr( p_string, l_start_element_pos, l_start_element_value_pos -l_start_element_pos );
    l_novalue_pos := instr( l_tag, 'noValue="' ); -- ga ervan uit dat er geen spaties in staan
    l_endquote_pos := instr( l_tag, '"', l_novalue_pos, 2 );
    if l_novalue_pos > 0 and l_endquote_pos > 0 then
      l_return := substr( l_tag, l_novalue_pos + 9, l_endquote_pos - l_novalue_pos -9 );
    else
      -- geen noValue attribute
      l_return := null;
    end if;
  else
    -- tag met value ("  <tagname> value </tagname>  ")
    l_end_element_pos := instr(p_string,'</'||p_element_name||'>', 1, p_occurence);
    --
    -- strip spaties en enters aan het einde
    l_pos := l_end_element_pos; -- 1e positie na <element_value>
    l_done := false;
    while not l_done and ( l_pos > l_start_element_value_pos ) loop
      l_chr := substr( p_string, l_pos -1, 1 );
      l_done := ( l_chr <> chr(10)) and (l_chr <> chr(13)) and (l_chr <> ' ');
      if not l_done then
        l_pos := l_pos -1;
      end if;
    end loop;
    -- 
    l_element_value_length := l_pos - l_start_element_value_pos;
    l_return := substr(p_string, l_start_element_value_pos, l_element_value_length);
  end if;
  --
  RETURN l_return;
END ev;
-- -------------------------------------------------------------------
function eta( p_string    in clob,
              p_tag       in varchar2,
              p_attribute in varchar2 )
return varchar2
is
-- Extract attribute <p_attribute> uit de tag <p_tag> in string <p_string>
  l_postag       integer;
  l_posattribute integer;
  l_pos1         integer;
  l_pos2         integer;
  l_value        varchar2(100);
begin
  l_postag := instr( p_string, '<' || p_tag );
  l_value := '';
  if l_postag > 0 then
    l_posattribute := instr( p_string, p_attribute, l_postag + 2 + length( p_tag ));
    if l_posattribute > 0 then
      l_pos1 := instr( p_string, '"', l_posattribute + length( p_attribute ));
      l_pos2 := instr( p_string, '"', l_pos1 +1);
      if l_pos1 > 0 and l_pos2 > 0 then
        if l_pos2 > l_pos1 +100 then
          l_pos2 := l_pos1 +100;
        end if;
        l_value := substr( p_string, l_pos1 +1, l_pos2 - l_pos1 -1 );
      end if;
    end if;
  end if;
  return l_value;
end eta;
-- -------------------------------------------------------------------
END Xmlp;
/

