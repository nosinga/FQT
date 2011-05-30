CREATE OR REPLACE TRIGGER urp_menu_vw_ioiud
INSTEAD OF INSERT OR UPDATE OR DELETE ON urp_menu_vw
FOR EACH ROW
DECLARE
   l_return integer;
BEGIN
  if    inserting 
  then
    l_return := urp_menu_utils.addMenu(
       p_menuname        => :NEW.MENUNAME
      ,p_menutype        => :NEW.MENUTYPE
      ,p_menudescription => :NEW.MENUDESCRIPTION
      ,p_parentmenu_id   => :NEW.PARENT_ID
      ,p_order           => :NEW.MENUORDER
      ,p_submenutype     => :NEW.SUBMENUTYPE
      );
  elsif updating
  then 
    l_return := urp_menu_utils.modifyMenu(
       :OLD.ID
      ,:OLD.RV 
      ,:NEW.MENUNAME
      ,:NEW.MENUDESCRIPTION
      ,:NEW.MENUORDER
      );
  elsif deleting
  then
    l_return := urp_menu_utils.removeMenu(
       :OLD.ID
      ,:OLD.RV
    );
  end if;
END;
/

CREATE OR REPLACE TRIGGER urp_menuleaf_vw_ioiud
INSTEAD OF INSERT OR UPDATE OR DELETE ON urp_menuleaf_vw
FOR EACH ROW
DECLARE
   l_return integer;
BEGIN
  if    inserting 
  then
    l_return := urp_menu_utils.addMenuLeaf(
       :NEW.MENULEAFNAME
      ,:NEW.MENULEAFTYPE
      ,:NEW.MENU_ID
      ,:NEW.MENURESOURCELOCATION
      ,:NEW.MENULEAFORDER
      ,:NEW.CONNECTIONNAME
      );
  elsif updating
  then 
    l_return := urp_menu_utils.modifyMenuLeaf(
       :OLD.ID
      ,:OLD.RV 
      ,:NEW.MENULEAFNAME
      ,:NEW.MENURESOURCELOCATION
      ,:NEW.MENU_ID
      ,:NEW.MENULEAFORDER
      );
  elsif deleting
  then
    l_return := urp_menu_utils.removeMenuLeaf(
       :OLD.ID
      ,:OLD.RV
    );
  end if;
END;
/

