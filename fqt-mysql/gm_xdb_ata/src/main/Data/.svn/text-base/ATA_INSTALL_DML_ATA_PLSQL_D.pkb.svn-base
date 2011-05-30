prompt CREATE OR REPLACE PACKAGE BODY ATA_INSTALL_DML_ATA_PLSQL_D
CREATE OR REPLACE package body ATA_INSTALL_DML_ATA_PLSQL_D
is
--
  g_package_name   constant varchar2 (35)
                                         default 'ATA_INSTALL_DML_ATA_PLSQL_D';
--
  procedure install_all
  is
  begin
--
-- de koppeling loopt via string "rptmenu" 
    ata_install_dml.insert_report_menu('ATA PLSQL DOC');
-- de rapporten linken aan een connectie en dan aan rapport_menu 
    ata_install_dml.link_sqm_pms_conn_to_rptmenu ('ATA_PLSQL_DOC', 'ata@ABKR', 'ATA PLSQL DOC');
    ata_install_dml.link_sqm_pms_conn_to_rptmenu ('ATA_PLSQL_DOC_dependencies',
                               'ata@ABKR',
                               'ATA PLSQL DOC'
                              );
    ata_install_dml.link_sqm_pms_conn_to_rptmenu ('ATA_PLSQL_DOC_documentation',
                               'ata@ABKR',
                               'ATA PLSQL DOC'
                              );
    ata_install_dml.link_sqm_pms_conn_to_rptmenu ('ATA_PLSQL_DOC_source',
                               'ata@ABKR',
                               'ATA PLSQL DOC'
                              );
    ata_install_dml.link_sqm_pms_conn_to_rptmenu ('ATA_PLSQL_DOC_tabledetails',
                               'ata@ABKR',
                               'ATA PLSQL DOC'
                              );
--
    ata_install_dml.link_user2report_menu ('meta_super_admin', 'ATA PLSQL DOC');
--
  end install_all;
--
end ATA_INSTALL_DML_ATA_PLSQL_D; 
/

