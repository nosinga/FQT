select ber.sequence_id
,  to_char(ber.enqueue_timestamp,'YYYYMMDD HH24:MI:ss') as enqueue_timestamp
, ber.correlation_id
, '#details#gbaprs_aftap_bericht_queue#sequence_id#'||sequence_id||'#' bericht_details
from  gbaprs_aftap_bericht_queue ber
where trunc(ber.enqueue_timestamp) > sysdate -1
and not exists (select res.correlation_id from gbaprs_aftap_response_queue res where res.correlation_id = ber.correlation_id)
order by ber.enqueue_timestamp desc
