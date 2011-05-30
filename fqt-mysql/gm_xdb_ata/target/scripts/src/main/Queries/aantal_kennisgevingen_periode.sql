select count(msg.msgtype) as aantal
from 
  trace_loginfo msg
where
    msg.msgtype = 'request'
and msg.endpointuri like '%.vulgm.toLoaderService'
and msg.loglevel = 'info'
and to_char(msg.logtime,'YYYYMMDD') >  :beginperiodeYYYYMMDD 
and to_char(msg.logtime,'YYYYMMDD') <= :eindeperiodeYYYYMMDD
