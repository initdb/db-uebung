/*
Verbinden Sie sich mit der Datenbank der TH oder installieren Sie eine lokale Instanz die Sie auch offline verwenden können 
(äußerst praktisch für den weiteren Verlauf der Vorlesung):

https://www.microsoft.com/en-us/sql-server/sql-server-downloads
Paket SQL Express
Quellen manuell runterladen
nur LocalDB Paket
Über MSSQL Server Management Studio verbinden, google sagt ihnen wie.

Folgende Codeschnipsel lassen sich nun ausführen, spielen
Sie mal damit! 
*/

/*Folgende Codezeilen erzeugen ein einfaches Schema */
create table person(
	name varchar(100),
	tel varchar (100)
)
/* In dieses können Sie Daten einfügen */
insert into person(name,tel) values
	('Klaus','125234651346'),
	('Maria','43563456'),
	('Johanna','45674567');

/* Oder Daten abrufen */
select * from person;

delete from person where name = 'Klaus';
/* Oder die Tabelle löschen */
drop table person;