remark ATA_GRANTS.sql
remark
remark Uitdelen van grants van ATA objecten aan ABKR_RPT.
remark
remark   ata.db_versie -> abkr_rpt
remark 
remark Let op! ATA kan ook anders heten (ATA_TWDPRD bijvoorbeeld). In zo'n
remark    geval gaat de grant naar de overeenkomstige naam (ABKR_RPT_TWDPRD)
remark
remark 18-03-2011  H.Neervoort  Creatie
remark

set serveroutput on

declare
  l_abkr_rpt all_users.username%type;
  l_sql      varchar2(180);
  l_null     varchar2(1);
begin
  l_abkr_rpt := replace( user, 'ATA', 'ABKR_RPT' );
  --
  select null
  into l_null
  from all_users
  where username = l_abkr_rpt;
  --
  dbms_output.put_line( user || '.DB_VERSIE granten aan ' || l_abkr_rpt );
  l_sql := 'grant select on db_versie to ' || l_abkr_rpt;
  execute immediate l_sql;
exception
  when no_data_found then
    raise_application_error( -20000, 'Kan voor ' || user || ' geen ABKR_RPT user vinden' );
end;
/

