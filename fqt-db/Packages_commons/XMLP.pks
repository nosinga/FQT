PROMPT CREATE OR REPLACE PACKAGE XMLP
CREATE OR REPLACE PACKAGE Xmlp
IS
--
FUNCTION ev(
     p_string IN CLOB
   , p_element_name IN VARCHAR2
   , p_occurence IN NUMBER DEFAULT 1)
RETURN VARCHAR2;
-- Haal uit CLOB <p_string> de waarde van tag <p_element_tag>.
-- Gebruik het <p_occurence> e voorkomen van de tag.
--
function eta( p_string    in clob,
              p_tag       in varchar2,
              p_attribute in varchar2 )
return varchar2;
-- Extract attribute <p_attribute> uit de tag <p_tag> in string <p_string>
--
END Xmlp;
/

