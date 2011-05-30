delete SQM_QUERIES
where queryname in
('AantalGeraadpleegdeMLOServices'
,'AantalUniekeMLObezoekersopDag'
,'UniekeMLObezoekersopDag'
)
;

SET DEFINE OFF;
Insert into SQM_QUERIES
   (QUERYNAME, SQLSTATEMENT, DESCRIPTION)
 Values
   ('AantalGeraadpleegdeMLOServices', 'SELECT count(1) aantal
,      webmethode
,      datum
from   getburgersubservice_rpt 
WHERE TO_CHAR(datum,''yyyymmdd'') >= NVL(:datum_vanaf_yyyymmdd,TO_CHAR(SYSDATE,''yyyymmdd''))
AND TO_CHAR(datum,''yyyymmdd'') <= NVL(:datum_totenmet_yyyymmdd,TO_CHAR(SYSDATE,''yyyymmdd''))
group by datum, webmethode
ORDER BY 3,2
', 'getBurgerSubService');
Insert into SQM_QUERIES
   (QUERYNAME, SQLSTATEMENT, DESCRIPTION)
 Values
   ('AantalUniekeMLObezoekersopDag', 'SELECT count(1) aantal
,        to_char(DATUM, ''yyyymmdd'') DATUM
,      ''getBurgerResponse'' webmethode
from
(select * from getburger_rpt
 union
 select * from getburger_rpt_today
)
WHERE to_char(datum,''yyyymmdd'') >= nvl(:datum_vanaf_yyyymmdd,to_char(sysdate,''yyyymmdd''))
and to_char(datum,''yyyymmdd'') <= nvl(:datum_totenmet_yyyymmdd,to_char(sysdate,''yyyymmdd''))
GROUP BY datum
order by datum
', 'AantalUniekeMLObezoekersopDag');
Insert into SQM_QUERIES
   (QUERYNAME, SQLSTATEMENT, DESCRIPTION)
 Values
   ('UniekeMLObezoekersopDag', 'SELECT ID  
,        BSN
,        GESLACHTSNAAM
,        VOORNAMEN
,        to_char(DATUM, ''yyyymmdd'') DATUM
,        to_char(MIN_TIJD, ''hh24:mi:ss'') start_TIJD
,        to_char(MAX_TIJD, ''hh24:mi:ss'') eind_TIJD
,        AANTAL_WS_CALL
,        MIN_VERWERK
,        MAX_VERWERK
,        AVG_VERWERK 
from
(select * from getburger_rpt
 union
 select * from getburger_rpt_today
)
WHERE to_char(datum,''yyyymmdd'') >= nvl(:datum_vanaf_yyyymmdd,to_char(sysdate,''yyyymmdd''))
and to_char(datum,''yyyymmdd'') <= nvl(:datum_totenmet_yyyymmdd,to_char(sysdate,''yyyymmdd''))
ORDER BY min_tijd
', 'getBurger calls');
COMMIT;
