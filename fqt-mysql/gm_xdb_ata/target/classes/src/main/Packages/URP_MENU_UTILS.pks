CREATE OR REPLACE package urp_menu_utils
is
/**
This packes contains the functions which are used in
to add row_versions and flow and page labels.
**/-----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
  --SUBVERSION INFO : DO NOT CHANGE!!!!
  s_spec_date       constant varchar (4000) := '$Date: 2010-11-22 07:43:30 +0100 (Mon, 22 Nov 2010) $';
  s_spec_revision   constant varchar (4000) := '$Revision: 26460 $';
  s_spec_author     constant varchar (4000) := '$Author: nosinga $';
  s_spec_url        constant varchar (4000) := '$URL: http://nosinga@svn.ioo.rotterdam.nl/projecten/abkr/trunk/gm_xdb_ata/src/main/Packages/URP_MENU_UTILS.pks $';
  s_spec_id         constant varchar (4000) := '$Id: URP_MENU_UTILS.pks 26460 2010-11-22 06:43:30Z nosinga $';

  -----------------------------------------------------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------
--
  -- ------------------------------------------------------------------------------- --
  -- Functies/Procedures                                                             --
  -- ------------------------------------------------------------------------------- --
  function ora_info
    return varchar2;
-- --
-- De package urp_menu_utils is voor het onderhoud van menu's
-- --
-- Menu's maken het mogelijk voor de gebruiker om op eenvoudige
-- wijze rapporten uit te voeren, documenten te raadplegen of
-- om de configurate van de GUC te bekijken of bijvoorbeeld
-- de status van het geheugengebruik van de GUC
-- --
-- TODO
-- Daarnaast kunnen via de menu's de filters worden gewijzigd
-- voor bronhouders of afnemers
-- TODO TODO
-- --
-- Omdat niet iedere gebruiker elk menu mag raadplegen is er
-- een autorisatie laag ingebouwd in de menus. Deze autorisatie
-- op de menus en en onderliggende te raadplegen elementen
-- (documenten, rapporten, urls (oa guc configuratie) en schermen
-- worden onderhouden via dit package
-- --
-- Er zijn drie typen menu's gedefinieerd
-- 1.1. MAIN   hoofdmenu's (dit zijn de menu's die zichtbaar zijn in het hoofdmenu)
-- 1.2. RPT    rapport menu's (dit zijn de menu's waaronder de rapporten functioneel zijn gegroepeerd)
-- 1.3. URL    url menu's (hieronder zijn de url's naar bv de GUC Mule Configuratie terug te vinden)
-- --
-- Alle menu's worden geidentificeerd op basis van hun naam en hun type, maw binnen een type moet
-- de naam uniek zijn maar er kan een main menu zijn met de dezelfde naam als een rapport menu
-- Naast een naam kan een menu ook nog een beschrijving bevatten, een volgorde en een submenutype
-- Op dit moment is alleen bij een hoofdmenu een beschrijving, volgorde en een submenutype
-- geimplementeerd
-- --
-- 1.1. MAIN   hoofdmenu's (dit zijn de menu's die zichtbaar zijn in het hoofdmenu)
-- Nasst een naam kan een MAIN menu ook nog een beschrijving bevatten, een volgorde en een submenutype
-- - De beschrijving geeft een nadere uitleg over de het menu en wordt oa bij een mouse over getoond
-- - De volgorde bepaald de volgorde waarin de main menu's op het scherm getoond worden
-- - Het submenutype is bepalend voor de submenu types die getoond worden bij het aanklikken
--   van het betreffende hoodmenu
--
-- Een hoofmenu kan verwijzen naar twee submenutypes en drie submenutypeitems
-- 1.1.1. RPT     rapport menu's (dit zijn de menu's waaronder de rapporten functioneel zijn gegroepeerd)
-- 1.1.2. URL     url menu's (hieronder zijn de url's naar bv de GUC Mule Configuratie terug te vinden)
-- 1.1.3. DOC     Dit zijn verwijzingen naar directories, deze menu items zijn eindpunten van het menu
--              en hebben dezelfde naam als de directory waar ze naar verwijzen
--              In deze directories zijn de documenten functioneel gegroepeerd
-- 1.1.4. DCA     document administratie menu's ( deze menu's lopen een op een mee met de DOC menu's en
--              zijn voor administratie op de documenten )
-- 1.1.5. STATIC  Dit zijn verwijzingen naar schermen, deze menu items zijn eindpunten van het menu
--
-- Van de bovenstaande 5 typen zijn er 4 dynamisch en 1 statisch (STATIC). Er kan maar 1 hoofdmenu
-- zijn met een bepaald dynamisch subtype, Alle menu's van dat dynamische type hangen vervolgens onder dat
-- specifieke hoofdmenu. Met andere woorden alle Rapport menu's hangen onder dat ene hoofdmenu dat als
-- subtype menu RPT heeft.
--
-- 1.2. RPT    rapport menu's (dit zijn de menu's waaronder rapporten functioneel zijn gegroepeerd)
-- Deze RPT menu's hangen allemaal onder 1 hoofdmenu dat submenutype RPT heeft. Onder deze RPT menu's
-- kunnen alleen MenuLeafs van het type RPT hangen, dit zijn de Rapporten
--
-- 1.3. URL    url menu's (dit zijn de menu's waaronder links functioneel zijn gegroepeerd)
-- Deze URL menu's hangen allemaal onder 1 hoofdmenu dat submenutype URL heeft. Onder deze URL menu's
-- kunnen alleen MenuLeafs van het type URL hangen, dit zijn de links naar bv GUC Mule configuratie
--
--
-- Aan het einde van de Menu's zitten MenuLeafs (de bladeren aan de boom) eerder zijn deze leafs al
-- ter sprake gekomen. Er zijn vijf typen te onderscheiden
-- 2.1. STATIC (scherm    , kan alleen aan hoofdmenu hangen)
-- 2.2. RPT    (rapport   , kan alleen aan rapportmenu hangen)
-- 2.3. URL    (url/link  , kan alleen aan urlmenu hangen)
-- 2.4. DOC    (directory , kan alleen aan hoofdmenu hangen)
-- 2.5. DCA    (directory , kan alleen aan hoofdmenu hangen)
-- -
-- Alle menuleafs worden geidentificeerd op basis van hun naam en hun type, maw binnen een type moet
-- de naam uniek zijn maar er kan een rapport zijn met dezelfde naam als een directory of een link.
-- Een menuleaf heeft ook een menuitemresourcelocation. Dit attribuut is alleen in gebruik bij
-- het type STATIC en het type URL. Bij document directories en rapporten is gekozen om de naam
-- van de menuleaf gelijk te houden aan respectievelijk de directory naam of de rapportnaam.
-- --
-- Een menuleaf hangt altijd aan 1 menu en in het geval van een static menuleaf (de schermen) kan
-- er ook een volgorde opgegeven worden. Op dit moment is alleen bij de STATIC menuleafs de volgorde
-- geimplementeerd.
-- Een menuleaf moet ook altijd aan een rol hangen, op die manier is een gebruiker geautoriseerd
-- om de menuleaf te benaderen. De naar de leafs toewijzende menu's zijn pas zichtbaar als de
-- gebruiker minimaal voor 1 van de onderliggende menuleafs geautoriseerd is.
-- Een menuleaf kan aan meerdere rollen hangen, maar hangt zoals eerder gezegd altijd maar aan 1
-- menu. Bij iedereen zit dus een menuleaf op dezelfde plaats.
-- Bij een rapport hoort ook altijd een specifieke database. Dit is aangegeven bij de menuleaf
-- van het RPT middels de eigenschap connectionname
--
-- 2.1. STATIC (scherm    , kan alleen aan hoofdmenu hangen)
-- Dit zijn de schermen
--
--
--
--
--              STATIC menu items worden aangemaakt met de addMenuLeaf functie.
--
--    menu1 (MAIN rpt)    - menu11 (RPT)                     - menuleaf111 (RPT)
--                                                           - menuleaf112 (RPT)
--                        - menu12 (RPT)                     - menuleaf121 (RPT)
--                        - menu13 (RPT)                     - menuleaf131 (RPT)
--                                                           - menuleaf132 (RPT)
--                                                           - menuleaf133 (RPT)
--                                                           - menuleaf134 (RPT)
--    menu2 (MAIN static) - menuleaf21  (STATIC screen)
--                        - menuleaf22  (STATIC screen)
--    menu3 (MAIN doc)    - menuleaf31a (DOC directory)
--                                                           - document311 (niet in menu)
--                                                           - document312 (niet in menu)
--                        - menuleaf32a (DOC directory)
--                                                           - document311 (niet in menu)
--                                                           - document312 (niet in menu)
--                                                           - document313 (niet in menu)
--    menu4 (MAIN dca)    - menuleaf31b (DCA document admin)
--                                                           - document311 (niet in menu)
--                                                           - document312 (niet in menu)
--                        - menuleaf32b (DCA document admin)
--                                                           - document311 (niet in menu)
--                                                           - document312 (niet in menu)
--                                                           - document313 (niet in menu)
--    menu5 (MAIN static) - menuleaf51  (STATIC screen)
--                        - menuleaf52  (STATIC screen)
--                        - menuleaf53  (STATIC screen)
--    menu6 (MAIN static) - menuleaf61  (STATIC screen)
--                        - menuleaf62  (STATIC screen)
--
--
function addMenu(   p_menuname         in varchar2
                  , p_menutype         in varchar2
                  , p_menudescription  in varchar2 default null
                  , p_parentmenu_id    in integer  default null
                  , p_order            in varchar2 default null
                  , p_submenutype      in varchar2 default null
                  )
return integer
;
procedure addMenu(  p_menuname         in varchar2
                  , p_menutype         in varchar2
                  , p_menudescription  in varchar2 default null
                  , p_order            in varchar2 default null
                  , p_submenutype      in varchar2 default null
--
-- Methode beschrijving
--   Deze methode voegt menu's toe
--
-- Parameters
--   menuname         = naam van het Menu (max 30)
--   menutype         = ['MAIN','RPT','URL']
--   menudescription  = beschrijving van het menu (max 50)
--     alleen van toepassing bij menutype MAIN
--   order           = volgorde van de menu's onderling
--     alleen van toepassing bij menutype MAIN
--   submenutype = ['STATIC','RPT','URL','DOC','DCA']
--     alleen van toepassing bij menutype MAIN
--
-- Voorbeelden
-- addMenu ( 'Rapporten'               , 'MAIN' , 'Rapporten (oa Berichten Auditen)'        , '10', 'RPT');
-- addMenu ( 'Rapporten Administratie' , 'MAIN' , 'Administratie Audit Rapporten'           , '11', 'STATIC');
-- addMenu ( 'GUC Configuratie'        , 'MAIN' , 'GUC Configuratie & Systeem (Mule) Audit' , '20', 'URL');
--
);
function menu2rolename(p_menuname in varchar2)
return varchar2
--
-- Dit is een hulp functie voornamelijk voor het testen
-- uiteindelijk verdwijnt deze functie
--
-- Bij de technische implementatie worden de menu's nog opgeslagen in de urp_roles tabel
--
;
function modifyMenu(  p_id               in integer
                    , p_rv               in integer
                    , p_menuname         in varchar2
                    , p_menudescription  in varchar2 default null
                    , p_order            in varchar2 default null
)
return integer
;
procedure modifyMenu( p_menuname         in varchar2
                    , p_menutype         in varchar2
                    , p_newmenuname      in varchar2 default null
                    , p_menudescription  in varchar2 default null
                    , p_order            in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een een aantal eigenschappen van een menu veranderen
--
-- Parameters
--   menuname         = naam van het Menu (max 30)
--   menutype         = ['MAIN','RPT','URL']
--     Bovenstaande twee eigenschappen zijn de identifier van het menu
--
--   newmenuname      = nieuwe naam van het Menu (max 30)
--     Het menutype van het menu kan niet veranderd worden (menutype ontbreekt)
--
--   menudescription  = beschrijving van het menu (max 50)
--     alleen van toepassing bij menutype MAIN
--   order           = volgorde van de menu's onderling
--     alleen van toepassing bij menutype MAIN
--     Het submenutype van het menu kan niet veranderd worden (submenutype ontbreekt)
--
);
function removeMenu(   p_id       in integer
                     , p_rv       in integer
                     , p_cascade  in varchar2 default 'no'
                   )
return integer
;
procedure removeMenu(  p_menuname in varchar2
                     , p_menutype in varchar2
                     , p_cascade  in varchar2 default 'no'
--
-- Methode beschrijving
--   Deze methode kan een menu verwijderen
--
-- Parameters
--   menuname         = naam van het Menu (max 30)
--   menutype         = ['MAIN','RPT','URL']
--     Bovenstaande twee eigenschappen zijn de identifier van het menu
--
--   cascade          = ['yes','nos']
--     als deze parameter op yes staat dan worden alle submenu's en
--     menuleafs ook verwijderd
--     als deze parameter op no staat dan kan alleen het menu verwijderd
--     worden als er geen submenu's en menuleafs meer aanwezig zijn
--
);
function addMenuLeaf (   p_menuleafname             in varchar2
                       , p_menuleaftype             in varchar2
                       , p_menu_id                  in integer
                       , p_menuleafresourcelocation in varchar2 default null
                       , p_order                    in varchar2 default null
                       , p_connectionname           in varchar2 default null
) return integer
;
procedure addMenuLeaf (  p_menuleafname             in varchar2
                       , p_menuleaftype             in varchar2
                       , p_menuleafresourcelocation in varchar2 default null
                       , p_menuname                 in varchar2 default null
                       , p_order                    in varchar2 default null
                       , p_rolename                 in varchar2 default null
                       , p_connectionname           in varchar2 default null
--
-- Methode beschrijving
--   Deze methode voegt menuleafs toe
--
-- Parameters
--   menuleafname          = naam van de MenuLeaf (max 30)
--   menuleaftype          = ['STATIC','RPT','URL','DOC']
--   menuresourcelocation  = technische verwijzing naar scherm of naar url van link
--     alleen van toepassing bij menutype STATIC en URL
--   menuname              = naam van het met menu waaronder de menuleaf komt te hangen
--     alleen van toepassing bij menutype STATIC, URL en RPT
--   order                 = volgorde in het menu
--     alleen van toepassing bij menutype STATIC
--   rolename              = aan welke autorisatie role wordt het menu opgehangen
--     dit kunnen meerdere rollen zijn
--   connectionname        = aan welke connectie een rapport opgehangen wordt
--     dit kunnen meerdere connecties zijn
--     alleen van toepassing bij menutype RPT
--
-- Voorbeelden
--
-- begin
--   urp_menu_utils.addMenuLeaf (
--     p_menuleafname             => 'Rapporten'
--    ,p_menuleaftype             => 'STATIC'
--    ,p_menuleafresourcelocation => 'QUERIES'
--    ,p_menuname                 => 'Rapporten Administratie'
--    ,p_order                    => '1'
--    ,p_rolename                 => 'role_rapporten_admin'
--   );
-- end;
-- /
-- begin
--   urp_menu_utils.addMenuLeaf (
--     p_menuleafname             => 'Google'
--    ,p_menuleaftype             => 'URL'
--    ,p_menuleafresourcelocation => 'http://www.google.com'
--    ,p_menuname                 => 'External Example'
--    ,p_rolename                 => 'role_grt_admin'
--   );
-- end;
-- /
-- begin
--   urp_menu_utils.addMenuLeaf (
--     p_menuleafname             => 'ArchitectuurDocumenten'
--    ,p_menuleaftype             => 'DOC'
--    ,p_rolename                 => 'role_grt_admin'
--   );
-- end;
-- /
);
procedure addMenuLeafReport ( p_reportname               in varchar2
                            , p_menuname                 in varchar2
                            , p_rolename                 in varchar2
                            , p_connectionname           in varchar2
--
-- Methode beschrijving
--   Deze methode voegt menuleafs toe voor rapporten
--   Dit is een interface op de addMenuLeaf methode
--      hierbij krijgen de addMenuLeaf parameters de volgende waardes
--         menuleafname             => p_reportname
--         menuleaftype             => 'RPT'
--         menuname                 => p_menuname
--         rolename                 => p_rolename
--         connectionname           => p_connectionname
--
--
-- Parameters
--   reportname            = naam van de MenuLeaf (max 30)
--   menuname              = naam van het met menu waaronder de menuleaf komt te hangen
--   rolename              = aan welke autorisatie role wordt het menu opgehangen
--     dit kunnen meerdere rollen zijn
--   connectionname        = aan welke connectie een rapport opgehangen wordt
--     dit kunnen meerdere connecties zijn
--
-- Voorbeelden
--    addMenuLeafReport('ATA_ACTIONS'               ,'ATA Usage'     ,'role_audit_ata_usage' ,'ata@ABKR'  )
--    addMenuLeafReport('ATA_LOGINS'                ,'ATA Usage'     ,'role_audit_ata_usage' ,'ata@ABKR'  )
--    addMenuLeafReport('urp_users_example'         ,'Examples'      ,'role_rapporten_admin' ,'ata@ABKR'  )
--
);
function menuleaf2permission (p_id in integer
                            , p_rv in integer
)
return varchar2
;
function menuleaf2permission (p_menuleafname in varchar2
                            , p_menuleaftype in varchar2
                            , p_connectionname in varchar2 default null)
return varchar2
----
-- Dit is een hulp functie voornamelijk voor het testen
-- uiteindelijk verdwijnt deze functie
--
-- Bij de technische implementatie worden de menuleafs nog opgeslagen in de urp_permissions tabel
--
;
function modifyMenuLeaf (   p_id                       in integer
                          , p_rv                       in integer
                          , p_menuleafname             in varchar2
                          , p_menuleafresourcelocation in varchar2 default null
                          , p_menuname                 in varchar2 default null
                          , p_order                    in varchar2 default null
                         )
return integer
;
procedure modifyMenuLeaf (  p_menuleafname             in varchar2
                          , p_menuleaftype             in varchar2
                          , p_newmenuleafname          in varchar2 default null
                          , p_menuleafresourcelocation in varchar2 default null
                          , p_menuname                 in varchar2 default null
                          , p_order                    in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een een aantal eigenschappen van een menuleaf veranderen
--
-- Parameters
--   menuname         = naam van het MenuLeaf (max 30)
--   menutype         = ['STATIC','RPT','URL','DOC']
--  (connectioname    = aan welke connectie een rapport opgehangen is)
--     Bovenstaande twee/drie eigenschappen zijn de identifier van de menuleaf
--
--   newmenuleafname  = nieuwe naam van het MenuLeaf (max 30)
--     Het menutype van het menu kan niet veranderd worden (newmenuleaftype ontbreekt)
--
--   menuresourcelocation  = technische verwijzing naar scherm of naar url van link
--     alleen van toepassing bij menutype STATIC en URL
--   menuname              = naam van het met menu waaronder de menuleaf komt te hangen
--     alleen van toepassing bij menutype STATIC, URL en RPT
--   order                 = volgorde in het menu
--     alleen van toepassing bij menutype STATIC
--
);
function removeMenuLeaf(  p_id       in integer
                        , p_rv       in integer)
return integer
;
procedure removeMenuLeaf(  p_menuleafname       in varchar2
                         , p_menuleaftype       in varchar2
                         , p_connectionname     in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een menuleaf verwijderen
--
-- Parameters
--   menuleafname         = naam van het Menu (max 30)
--   menuleaftype         = ['STATIC','RPT','URL','DOC']
--     Bovenstaande twee eigenschappen zijn de identifier van het menu
--
-- Voor rapporten is er een extra parameter
--  connectioname         = als deze ingevuld is wordt alleen deze connectie verwijderd
--                          en anders alle rapport toestemmingen en dus de gehele leaf
--
);
procedure linkMenuLeaf2Menu (  p_menuleafname       in varchar2
                             , p_menuleaftype       in varchar2
                             , p_menuname           in varchar2
--
-- Methode beschrijving
--   Deze methode kan een menuleaf toevoegen aan een menu of omhangen naar
--   een ander menu, een menu leaf kan maar aan 1 menu hangen
--
-- Parameters
--   menuleafname         = naam van het Menu (max 30)
--   menuleaftype         = ['STATIC','RPT','URL','DOC']
--     Bovenstaande twee eigenschappen zijn de identifier van het menu
--
-- Voor rapporten is er een extra parameter
--  connectioname         = als deze ingevuld is wordt alleen deze connectie verwijderd
--                          en anders alle rapport toestemmingen en dus de gehele leaf
--
);
procedure linkMenuLeaf2Role (  p_menuleafname       in varchar2
                             , p_menuleaftype       in varchar2
                             , p_rolename           in varchar2
                             , p_connectionname     in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een menuleaf toevoegen aan een role
--
-- Parameters
--   menuleafname         = naam van het Menu (max 30)
--   menuleaftype         = ['STATIC','RPT','URL','DOC']
--     Bovenstaande twee eigenschappen zijn de identifier van het menu
--
-- Voor rapporten is er een extra parameter
--  connectioname         = als deze ingevuld is wordt alleen deze connectie aan
--                          een de nieuwe rol toegevoegd
--                          en anders worden alle rapporten met deze naam
--                          aan de nieuwe rol toegevoegd
--
);
procedure unlinkMenuLeaf4Role (  p_menuleafname       in varchar2
                               , p_menuleaftype       in varchar2
                               , p_rolename           in varchar2
                               , p_connectionname     in varchar2 default null
--
-- Methode beschrijving
--   Deze methode kan een menuleaf verwijderen van een role
--
-- Parameters
--   menuleafname         = naam van het Menu (max 30)
--   menuleaftype         = ['STATIC','RPT','URL','DOC']
--     Bovenstaande twee eigenschappen zijn de identifier van het menu
--
-- Voor rapporten is er een extra parameter
--  connectioname         = als deze ingevuld is wordt alleen deze connectie
--                          van de rol verwijderd
--                          en anders worden alle rapporten met deze naam
--                          van de rol verwijderd
--
--
);
function submenutype2mainmenuid(p_menutype in varchar2)
return integer
-- hulp functie om inserts via scripts makkelijker te maken
--
;
function menuname2id(p_menuname in varchar2)
return integer
-- hulp functie om inserts via scripts makkelijker te maken
--
;
end urp_menu_utils; 
/

