-- Author: Kai Höfig
-- Wintersemester 2018
-- Dieses Script können Sie so nicht ausführen.
-- Es dient Ihnen nur als Spickzettel.
-- Es ist also nur syntaktisch korrekt, macht aber keinen Sinn.
-- Es kommen alle relevanten Befehle aus dem Kapitel SQL Einführung vor

use INFDB00;

create table rezepte(
	drinkname varchar(30),
	zutatname varchar(30)	,
	menge int,
	foreign key (drinkname) references drinks(name),
	foreign key (zutatname) references zutaten(name),
	primary key (drinkname,zutatname),
);

drop table zutaten;

alter table rezepte add neues_feld varchar(30);
alter table rezepte drop column neues_feld;
alter table rezepte add constraint kein_negativer_inhalt check (menge >0);
alter table rezepte drop constraint kein_negativer_inhalt

insert into drinks (name, preis) values 
	('TQS',3.99),
	('PGDG',10.00);
	
update drinks set name='TQS' where name like '%TQS_'

select 
	d.name,
	r.zutatname,
	cast(z.volproz as varchar)+'%',
	z.volproz,
	case 
		when z.volproz = 0 then 'jedes Alter'
		else 'Mindestens 16'
	end as 'Altersfreigabe',
	substring(d.name,1,1) as 'Erster Buchstabe vom Drinknamen',
	charindex('act', z.name) as 'An welcher Position ist die Zeichenkette "act"?',
	'Es ist jetzt '+cast(convert(time, current_timestamp) as varchar(5))+' Uhr' as Uhrzeit
from
	drinks as d
	inner join rezepte as r on (d.name = r.drinkname)
	inner join zutaten as z on (r.zutatname = z.name)
where
	d.name like '_G%' and
	d.name not in ('TQS','PGDG') and
	d.preis >= all(select preis from drinks)

