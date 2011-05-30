select ber.sequence_id
,  to_char(ber.enqueue_timestamp,'YYYYMMDD HH24:MI:ss') as enqueue_timestamp
, ber.correlation_id
, '#details#gbaprs_aftap_bericht_queue#sequence_id#'||ber.sequence_id||'#' bericht_details
, '#details#gbaprs_aftap_response_queue#correlation_id#'||ber.correlation_id||'#' response_details
from gbaprs_aftap_bericht_queue ber
 join gbaprs_aftap_response_queue res on (res.correlation_id = ber.correlation_id)
where trunc(ber.enqueue_timestamp) > sysdate -1
and res.payload not like '%Bv01%'
order by ber.enqueue_timestamp desc

