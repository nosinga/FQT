select count(res.msgtype) as aantal
from 
  trace_loginfo res
  left outer join trace_loginfo req on (req.correlationid = res.correlationid and req.msgtype = 'request' and req.loglevel = 'info')
where
    res.msgtype = 'response'
and res.loglevel = 'info'
and req.endpointuri like '%/gm/sozawe'
and trunc(res.logtime) > sysdate -1
