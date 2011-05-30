select count(ber.sequence_id) as aantal
from  gbaprs_aftap_bericht_queue ber
where 
    to_char(ber.enqueue_timestamp,'YYYYMMDD') >  :beginperiodeYYYYMMDD 
and to_char(ber.enqueue_timestamp,'YYYYMMDD') <= :eindeperiodeYYYYMMDD
and not exists (select res.correlation_id from gbaprs_aftap_response_queue res where res.correlation_id = ber.correlation_id)
