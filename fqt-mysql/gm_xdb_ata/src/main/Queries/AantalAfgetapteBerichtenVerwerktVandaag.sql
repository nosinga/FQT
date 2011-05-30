select count(ber.sequence_id) as aantal
from gbaprs_aftap_bericht_queue ber
where trunc(ber.enqueue_timestamp) > sysdate -1
and ber.dequeue_timestamp is not null
