select guc.transactie_id, stf.bericht_key, guc.correlationid, stf.status
from   stuf300_in.stf300_stuurgegevens  stf
,      guc_log.bericht_in   guc
where  guc.transactie_id = stf.bericht_key (+)
and   (stf.bericht_key is null or stf.status <> 'V')