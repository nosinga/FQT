Voor het bouwen dient maven geinstalleerd te zijn en de FQT database aangemaakt.

Bouwen:

   mvn clean install

Jetty starten:

   mvn jetty:run -Dtarget=dev

Testen:

    http://localhost:8080/fqt-web/

Inloggen:

   e10369 / geheim
    