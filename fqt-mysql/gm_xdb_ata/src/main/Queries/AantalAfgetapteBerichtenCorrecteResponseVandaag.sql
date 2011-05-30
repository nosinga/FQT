select count(ber.sequence_id) as aantal
from  gbaprs_aftap_bericht_queue ber
 join gbaprs_aftap_response_queue res on (res.correlation_id = ber.correlation_id)
where trunc(ber.enqueue_timestamp) > sysdate -1
and res.payload like '%Bv01%'

