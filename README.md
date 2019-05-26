+# slutprojektvt19webbserver

# Projektplan

## 1. Projektbeskrivning
#### Ett forum var man skall kunna skapa konto, logga in och skapa inlägg samt logga ut. Inläggen skall tillhöra vissa taggar/ämnen. Man skall kunna redigera sina inlägg. Användare ska kunna kolla andras profiler och kunna se deras inlägg. Användare skall kunna se inlägg till enskilda taggar/ämnen.
## 2. Vyer (sidor)
Följande sidor är planerade att vara med:
1. En Mainpage
2. En login-sida
3. En registreringssida
4. En sida med alla profiler
5. Olika personers personliga profil sidor.
6. En allmän sida med inlägg.
7. En sida med taggar.
8. De enskilda tag sidorna.
## 3. Funktionalitet (med sekvensdiagram)
#### 1. Logga in
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/loginsequence.PNG)
#### 2. Logga ut
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/loggingout.PNG)
#### 3. Registera sig
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/registration_sequence.PNG)
#### 4. Lägga upp bilder och text till olika ämnen/taggar
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/registration_sequence.PNG)
#### 5. Se inlägg via tagg/ämne, person samt alla inlägg samtidigt.
![pic](https://github.com/itggot-simon-hammerlid/slutprojektvt19webbserver/blob/master/Sekvensdiagram/page_request_sequence.PNG)
## 4. Arkitektur (Beskriv filer och mappar)
Jag har en mapp som heter views, som innehåller alla slim filer. Public innehåller min css samt mina bilder. En db fil som innehåller min databas. Jag har en fil som heter functions som innehåller olika ruby filer som innehåller funktioner. I functions filen har jag två stycken ruby filer, en som innehåller alla get funktioner och en som innehåller alla post funktioner. Utöver dessa två ruby filer har jag en app.rb som ligger i slutprojektvt19webbserver filen.
## 5. (Databas med ER-diagram)
https://www.lucidchart.com/invitations/accept/86fae7e4-3a6c-4148-ba01-0c736a9c08d7
