select ber.correlationid, que.correlation_id 
from   guc_queue.gbaprs_aftap_bericht_queue  que
,      guc_log.bericht_in   ber
where  que.dequeue_timestamp is not null
and    que.correlation_id = ber.correlationid (+)
and    ber.correlationid is null
