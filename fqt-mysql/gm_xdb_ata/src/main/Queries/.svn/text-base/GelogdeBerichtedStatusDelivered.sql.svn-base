select guc.transactie_id, guc.correlationid, guc.status, stf.status
from   stuf300_in.stf300_stuurgegevens  stf
,      guc_log.bericht_in   guc
where  guc.transactie_id = stf.bericht_key
and   (guc.status = 'processing-delivered')
and   (stf.status <> 'V')