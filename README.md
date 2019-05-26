+# slutprojektvt19webbserver

# Projektplan

## 1. Projektbeskrivning
#### Ett forum var man skall kunna skapa konto, logga in och skapa inlägg samt logga ut. Inläggen skall tillhöra vissa taggar/ämnen. Man skall kunna redigera sina inlägg. Användare ska kunna kolla vilka andra användare finns och kunna se deras inlägg. Användare skall kunna se inlägg till enskilda taggar/ämnen. Skall också gå att se alla inlägg samtidigt.
## 2. Vyer (sidor)
Följande sidor är planerade att vara med:
1. En Mainpage
2. En login-sida
3. En registreringssida
4. En sida med alla profiler
5. Olika personers personliga profil sidor(visar deras inlägg).
6. En allmän sida med inlägg.
7. En sida med taggar.
8. De enskilda tag sidorna(visar bilder med vald tag).
## 3. Funktionalitet (med sekvensdiagram)
#### 1. Logga in
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/loginsquence.PNG)
#### 2. Logga ut
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/loggingout.png)
#### 3. Registera sig
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/registration_sequence.png)
#### 4. Lägga upp bilder och text till olika ämnen/taggar
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/sekvens.png)
#### 5. Se inlägg via tagg/ämne, person samt alla inlägg samtidigt.
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/page_request_sequence.png)
#### 6. Kunna uppdatera/byta ut inlägg.
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/altersequence.PNG)
## 4. Arkitektur (Beskriv filer och mappar)
Jag har en mapp som heter views, som innehåller alla slim filer. Public innehåller min css samt mina bilder. En db fil som innehåller min databas. Jag har en fil som heter functions som innehåller olika ruby filer som innehåller funktioner. I functions filen har jag två stycken ruby filer, en som innehåller alla get funktioner och en som innehåller alla post funktioner. Utöver dessa två ruby filer har jag en app.rb som ligger i slutprojektvt19webbserver filen. app.rb är min controller, medan de två funktions-filerna är mina module filer. Jag har en fil som innehåller mina sekvensdiagram och en annan som innehåller mitt er-diagram. Jag har också en fil för min mappstrukturs bild. Allt detta står i en readme fil i projekt filen.
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/mappstruktur/strukt.PNG)
## 5. (Databas med ER-diagram)
https://www.lucidchart.com/invitations/accept/86fae7e4-3a6c-4148-ba01-0c736a9c08d7
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/er_diagram/erdiagram.PNG)
