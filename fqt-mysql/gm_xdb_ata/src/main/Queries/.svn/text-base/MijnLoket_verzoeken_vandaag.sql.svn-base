select 
  to_char(res.logtime,'YYYYMMDD HH24:MI:ss') as logtime
, res.elapsedtime
, res.iserrormsg
, '#details#vraag#messageid#'||req.messageid||'#' vraag_details
, '#details#antwoord#messageid#'||res.messageid||'#' antwoord_details
from 
  trace_loginfo res
  left outer join trace_loginfo req on (req.correlationid = res.correlationid and req.msgtype = 'request' and req.loglevel = 'info')
where
    res.msgtype = 'response'
and res.loglevel = 'info'
and req.endpointuri like '%/gm/prs'
and trunc(res.logtime) > sysdate -1
order by res.logtime desc

