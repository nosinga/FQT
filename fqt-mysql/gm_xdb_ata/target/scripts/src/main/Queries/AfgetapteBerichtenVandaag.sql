select ber.sequence_id
,  to_char(ber.enqueue_timestamp,'YYYYMMDD HH24:MI:ss') as enqueue_timestamp
, ber.correlation_id
, '#details#gbaprs_aftap_bericht_queue#sequence_id#'||sequence_id||'#' bericht_details
, '#details#gbaprs_aftap_response_queue#correlation_id#'||correlation_id||'#' response_details
from gbaprs_aftap_bericht_queue ber
where trunc(ber.enqueue_timestamp) > sysdate -1
order by ber.enqueue_timestamp desc

