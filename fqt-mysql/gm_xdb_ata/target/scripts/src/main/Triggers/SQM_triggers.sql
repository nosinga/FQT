PROMPT CREATE OR REPLACE TRIGGER SQM_CON_TRG_BRIU
CREATE OR REPLACE TRIGGER SQM_CON_TRG_BRIU
BEFORE INSERT OR UPDATE OR DELETE
ON SQM_CONNECTIONS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    IF INSERTING THEN
      :NEW.rv := 1;
      :NEW.PASSWORD := Urp_Utils.password_encrypt(:NEW.PASSWORD);
      SELECT SQM_sequence.NEXTVAL INTO :NEW.id FROM dual;
    ELSIF UPDATING
    THEN
      :NEW.rv := :OLD.rv + 1;
	  IF :NEW.PASSWORD != :OLD.PASSWORD
	  OR :OLD.PASSWORD is null
	  THEN
        :NEW.PASSWORD := Urp_Utils.password_encrypt(:NEW.PASSWORD);
	  END IF;
    END IF;
END
;
/

PROMPT CREATE OR REPLACE TRIGGER SQM_SQL_TRG_BRIU
CREATE OR REPLACE TRIGGER SQM_SQL_TRG_BRIU
BEFORE INSERT OR UPDATE OR DELETE
ON sqm_queries
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    if inserting then
      :new.rv := 1;
      SELECT SQM_sequence.NextVal into :new.id from dual;
    elsif updating
    then
      :new.rv := :old.rv + 1;
    end if;
END
;
/

--PROMPT CREATE OR REPLACE TRIGGER SQM_SQL_TRG_BRIUD
--CREATE OR REPLACE TRIGGER SQM_SQL_TRG_BRIUD
--BEFORE INSERT OR UPDATE OR DELETE
--ON SQM_QUERIES
--REFERENCING NEW AS NEW OLD AS OLD
--FOR EACH ROW
--BEGIN
--    IF INSERTING THEN
--	  Sqm_Utils.update_urp_permissions('INSERTING',:NEW.queryname);
--    ELSIF UPDATING
--    THEN
--	  Sqm_Utils.update_urp_permissions('UPDATING',:NEW.queryname,:OLD.queryname);
--    ELSIF DELETING
--    THEN
--	  Sqm_Utils.update_urp_permissions('DELETING',:NEW.queryname,:OLD.queryname);
--    END IF;
--END
--;
--/

