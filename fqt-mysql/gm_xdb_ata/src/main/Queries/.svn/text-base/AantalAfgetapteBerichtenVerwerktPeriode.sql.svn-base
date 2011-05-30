select count(ber.sequence_id) as aantal
from gbaprs_aftap_bericht_queue ber
where 
    to_char(ber.enqueue_timestamp,'YYYYMMDD') >  :beginperiodeYYYYMMDD 
and to_char(ber.enqueue_timestamp,'YYYYMMDD') <= :eindeperiodeYYYYMMDD
and ber.dequeue_timestamp is not null

