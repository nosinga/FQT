declare
cursor csr_table_exists(b_table_name varchar2)
is
select 1
from   user_tables
where  table_name = b_table_name
;
l_table_not_exists boolean;
begin
  l_table_not_exists := true;
  for r in csr_table_exists('ATA_LOGINS_JNA')
  loop
    l_table_not_exists := false;
  end loop;
  if l_table_not_exists
  then
    execute immediate('CREATE TABLE ATA_LOGINS_JNA (      '||
                      '  TIMESTAMP DATE          NOT NULL '||
                      ', USERNAME  VARCHAR2(100) NOT NULL '||
                      ', PASSWORD  VARCHAR2(200) NOT NULL '||
                      ', RESULT    VARCHAR2(1 BYTE))'
                      );
  end if;
  l_table_not_exists := true;
  for r in csr_table_exists('ATA_ACTIONS_JNA')
  loop
    l_table_not_exists := false;
  end loop;
  if l_table_not_exists
  then
    execute immediate('CREATE TABLE ATA_ACTIONS_JNA(       '||
                      '  TIMESTAMP DATE           NOT NULL '||
                      ', USERNAME  VARCHAR2(100)  NOT NULL '||
                      ', ACTION    VARCHAR2(4000) NOT NULL)'
                      );
  end if;
end;
/


