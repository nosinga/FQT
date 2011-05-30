select 
  to_char(msg.logtime,'YYYYMMDD HH24:MI:ss') as logtime
, ber.zender_app
, ber.functie
, ber.entiteittype
, ber.referentienummer
, '#details#bericht_in#messageid#'||msg.messageid||'#' bericht_details
, '#details#event#messageid#'||msg.messageid||'#' error_details
from 
  trace_loginfo msg
  left outer join bericht_in ber on (ber.messageid = msg.messageid)
where
    msg.msgtype = 'request'
and msg.endpointuri like '%.vulgm.toLoaderService'
and msg.loglevel = 'info'
and trunc(msg.logtime) > sysdate -1
order by msg.logtime desc
