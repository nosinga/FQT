create user fqt
identified by fqt
default tablespace users
temporary tablespace temp;

grant connect, resource to fqt;
remark Packages in ATA maken tabellen en triggers aan. Deze privileges moeten
remark direct gegrant zijn.
grant create view to fqt;
grant create table to fqt;
grant create synonym to fqt;
grant create trigger to fqt;
grant create database link to fqt;
grant alter user to fqt;
-- TODO grant execute on utl_http to fqt;