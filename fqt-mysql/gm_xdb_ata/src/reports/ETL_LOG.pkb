CREATE OR REPLACE package body            etl_log
is
  procedure extract_antwoord
  is
    l_max antwoord.antwoord_key%type;
  begin
    select max( antwoord_key ), 0)
    into l_max
    from antwoord;
    --
    insert into antwoord
      select *
        from guc_log.antwoord@guc_log_ro#geglog_prd.ioo.local
       where antwoord_key > l_max;
  end extract_antwoord;

  procedure extract_vraag
  is
    l_max vraag.vraag_key%type;
  begin
    select max( vraag_key ), 0 )
    into l_max
    from vraag;
    --
    insert into vraag
      select *
      from guc_log.vraag@guc_log_ro#geglog_prd.ioo.local
      where vraag_key > l_max;
  end extract_vraag;

  procedure load_getburger_service
  is
    cursor csr_getburger_max_id
    is
      select nvl (max (id), 0) max_id,
             nvl (to_char (max (datum), 'yyyymmdd'), '20090101') max_datum
        from getburger_rpt;

    cursor csr_getburger_service (b_startdate varchar2, b_enddate varchar2)
    is
      select   xmlp.ev (inhoud, 'bsn') bsn,
               xmlp.ev (inhoud, 'geslachtsnaam') geslachtsnaam,
               xmlp.ev (inhoud, 'voornamen') voornamen,
               trunc (verstuurdtijd) datum, min (verstuurdtijd) min_tijd,
               max (verstuurdtijd) max_tijd, count (1) aantal_ws_call,
               min (verwerk_millis) min_verwerk,
               max (verwerk_millis) max_verwerk,
               trunc (avg (verwerk_millis)) avg_verwerk,
               'getBurgerResponse' webmethode
          from antwoord
         where instr (inhoud, 'getBurgerResponse') > 1
           and xmlp.ev (inhoud, 'bsn') is not null
           and xmlp.ev (inhoud, 'bsn') != 'dummy'
           and to_char (verstuurdtijd, 'yyyymmdd') > b_startdate
           and to_char (verstuurdtijd, 'yyyymmdd') < b_enddate
      group by trunc (verstuurdtijd),
               xmlp.ev (inhoud, 'bsn'),
               xmlp.ev (inhoud, 'geslachtsnaam'),
               xmlp.ev (inhoud, 'voornamen')
      order by min_tijd;

    i             integer;
    l_startdate   varchar2 (10);
  begin
    for r in csr_getburger_max_id
    loop
      i := r.max_id;
      l_startdate := r.max_datum;
    end loop;

    for r in csr_getburger_service (l_startdate,
                                    to_char (sysdate, 'yyyymmdd'))
    loop
      i := i + 1;

      insert into getburger_rpt
                  (id, bsn, geslachtsnaam, voornamen, datum,
                   min_tijd, max_tijd, aantal_ws_call, min_verwerk,
                   max_verwerk, avg_verwerk, webmethode
                  )
           values (i, r.bsn, r.geslachtsnaam, r.voornamen, r.datum,
                   r.min_tijd, r.max_tijd, r.aantal_ws_call, r.min_verwerk,
                   r.max_verwerk, r.avg_verwerk, r.webmethode
                  );
    end loop;

    delete      getburger_rpt_today;

    for r in csr_getburger_service (to_char (sysdate - 1, 'yyyymmdd'),
                                    to_char (sysdate + 1, 'yyyymmdd')
                                   )
    loop
      i := i + 1;

      insert into getburger_rpt_today
                  (id, bsn, geslachtsnaam, voornamen, datum,
                   min_tijd, max_tijd, aantal_ws_call, min_verwerk,
                   max_verwerk, avg_verwerk, webmethode
                  )
           values (i, r.bsn, r.geslachtsnaam, r.voornamen, r.datum,
                   r.min_tijd, r.max_tijd, r.aantal_ws_call, r.min_verwerk,
                   r.max_verwerk, r.avg_verwerk, r.webmethode
                  );
    end loop;
  end load_getburger_service;

  procedure load_getburger_subservice
  is
    cursor csr_getburgersubservice_max_id
    is
      select nvl (max (id), 0) max_id
        from getburgersubservice_rpt;

    cursor csr_getburgersubservice (b_id integer)
    is
      select a.antwoord_key id, xmlp.ev (v.inhoud, 'bsn') bsn,
             trunc (a.verstuurdtijd) datum, a.verstuurdtijd,
             a.verwerk_millis response_tijd, a.webmethode
        from (select antwoord_key, correlationid, verstuurdtijd,
                     verwerk_millis, 'getOudersResponse' webmethode
                from antwoord
               where instr (inhoud, 'getOudersResponse') > 1
              union
              select antwoord_key, correlationid, verstuurdtijd,
                     verwerk_millis, 'getKinderenResponse' webmethode
                from antwoord
               where instr (inhoud, 'getKinderenResponse') > 1
              union
              select antwoord_key, correlationid, verstuurdtijd,
                     verwerk_millis, 'getPartnersResponse' webmethode
                from antwoord
               where instr (inhoud, 'getPartnersResponse') > 1
              union
              select antwoord_key, correlationid, verstuurdtijd,
                     verwerk_millis, 'getReisdocumentenResponse' webmethode
                from antwoord
               where instr (inhoud, 'getReisdocumentenResponse') > 1
              union
              select antwoord_key, correlationid, verstuurdtijd,
                     verwerk_millis, 'getNationaliteitenResponse' webmethode
                from antwoord
               where instr (inhoud, 'getNationaliteitenResponse') > 1) a,
             vraag v
       where a.correlationid = v.correlationid and a.antwoord_key > b_id;

    l_max_id   integer;
  begin
    for r in csr_getburgersubservice_max_id
    loop
      l_max_id := r.max_id;
    end loop;

    for r in csr_getburgersubservice (l_max_id)
    loop
      insert into getburgersubservice_rpt
                  (id, bsn, datum, verstuurdtijd, response_tijd,
                   webmethode
                  )
           values (r.id, r.bsn, r.datum, r.verstuurdtijd, r.response_tijd,
                   r.webmethode
                  );
    end loop;
  end load_getburger_subservice;

  procedure load_getburger
  is
  begin
    load_getburger_service;
    load_getburger_subservice;
  end load_getburger;
  
  procedure main
  is
  begin
    extract_vraag;
    extract_antwoord;
    load_getburger;
    commit;
  end main;  
end;
/


