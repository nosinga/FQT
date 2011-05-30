select count(ber.sequence_id) as aantal
from  gbaprs_aftap_bericht_queue ber
 join gbaprs_aftap_response_queue res on (res.correlation_id = ber.correlation_id)
where 
    to_char(ber.enqueue_timestamp,'YYYYMMDD') >  :beginperiodeYYYYMMDD 
and to_char(ber.enqueue_timestamp,'YYYYMMDD') <= :eindeperiodeYYYYMMDD
and res.payload like '%Bv01%'

