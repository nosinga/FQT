CREATE OR REPLACE package urp_user_utils
is
--
--
function authenticate_on_orcl(p_username in varchar2, p_password in varchar2)
return number
;
function check_login_on_orcl(p_username in varchar2, p_password in varchar2)
return number
;
function ora_user_in_ata_parameters(p_username in varchar2)
return number
;
end urp_user_utils
; 
/

