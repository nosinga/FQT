PROMPT CREATE OR REPLACE TRIGGER URP_USR_TRG_BRIU
CREATE OR REPLACE TRIGGER URP_USR_TRG_BRIU
BEFORE INSERT OR UPDATE OR DELETE
ON urp_users
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    if inserting then
      :new.rv := 1;
      :new.username := lower(:new.username);
	  if :new.id is null
	  then
        SELECT URP_sequence.NextVal into :new.id from dual;
	  end if;	
    elsif updating
    then
      :new.rv := :old.rv + 1;
    end if;
END
;
/

PROMPT CREATE OR REPLACE TRIGGER URP_RLE_TRG_BRIU
CREATE OR REPLACE TRIGGER URP_RLE_TRG_BRIU
BEFORE INSERT OR UPDATE OR DELETE
ON urp_roles
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    if inserting then
      :new.rv := 1;
	  if :new.id is null
	  then
        SELECT URP_sequence.NextVal into :new.id from dual;
	  end if;	
    elsif updating
    then
      :new.rv := :old.rv + 1;
    end if;
END
;
/

PROMPT CREATE OR REPLACE TRIGGER URP_PMS_TRG_BRIU
CREATE OR REPLACE TRIGGER URP_PMS_TRG_BRIU
BEFORE INSERT OR UPDATE OR DELETE
ON urp_permissions
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    if inserting then
      :new.rv := 1;
	  if :new.id is null
	  then
        SELECT URP_sequence.NextVal into :new.id from dual;
	  end if;	
    elsif updating
    then
      :new.rv := :old.rv + 1;
    end if;
END
;
/

PROMPT CREATE OR REPLACE TRIGGER URP_URL_TRG_BRIU
CREATE OR REPLACE TRIGGER URP_URL_TRG_BRIU
BEFORE INSERT OR UPDATE OR DELETE
ON urp_user_role
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    if inserting then
      :new.rv := 1;
	  if :new.id is null
	  then
        SELECT URP_sequence.NextVal into :new.id from dual;
	  end if;	
    elsif updating
    then
      :new.rv := :old.rv + 1;
    end if;
END
;
/

PROMPT CREATE OR REPLACE TRIGGER URP_RPM_TRG_BRIUD
CREATE OR REPLACE TRIGGER URP_RPM_TRG_BRIUD
BEFORE INSERT OR UPDATE OR DELETE
ON urp_role_permission
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    if inserting then
      :new.rv := 1;
	  if :new.id is null
	  then
        SELECT URP_sequence.NextVal into :new.id from dual;
	  end if;	
    elsif updating
    then
      :new.rv := :old.rv + 1;
    end if;
END
;
/



