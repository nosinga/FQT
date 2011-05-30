SELECT typ.sub_entiteittype
      ,typ.target_tabel
      ,typ.target_procedure
      ,typ.ind_actief
      ,SUM(aant_sel) AS selected
      ,SUM(aud.aant_ins_vrwsrt_i)+
       SUM(aud.aant_ins_vrwsrt_t)+
       SUM(aud.aant_ins_vrwsrt_w)+
       SUM(aud.aant_ins_vrwsrt_v)+
       SUM(aud.aant_ins_vrwsrt_e)+
       SUM(aud.aant_ins_vrwsrt_r)+
       SUM(aud.aant_ins_vrwsrt_o)+
       SUM(aud.aant_ins_vrwsrt_s) AS inserts
      ,SUM(aud.aant_upd_vrwsrt_i)+
       SUM(aud.aant_upd_vrwsrt_t)+
       SUM(aud.aant_upd_vrwsrt_t)+
       SUM(aud.aant_upd_vrwsrt_v)+
       SUM(aud.aant_upd_vrwsrt_e)+ 
       SUM(aud.aant_upd_vrwsrt_r)+
       SUM(aud.aant_upd_vrwsrt_o)+
       SUM(aud.aant_upd_vrwsrt_s) AS updates
  FROM dvgm.dvgm_entiteittype typ
      ,dvgm.dvgm_audit aud
 WHERE typ.entiteittype='PRS'
   AND typ.target_tabel=aud.tabelnaam
 GROUP BY typ.sub_entiteittype
         ,typ.target_tabel
         ,typ.target_procedure
         ,typ.ind_actief
