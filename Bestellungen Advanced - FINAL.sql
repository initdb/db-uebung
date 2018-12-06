--use Vorlesung_DB;


create table kunde(
	id int identity(1,1),
	name varchar(200),
	email varchar(200),
	primary key (id asc)
);

create table bestellung(
	id int identity(1,1),
	datum date,
	lieferadresse varchar(200),
	kundennummer int,
	bestellwert int,
	foreign key (kundennummer) references kunde(id),
	primary key (id asc)
);


insert into kunde(name,email) values 
	('Michaela','123@456.de'),
	('Test','123@456.de'),
	('Deike','123er@456.de'),
	('Klaus','12w3@456.de'),
	('Matze','12sss3@456.de'),
	('Herbert','1wwdc23@456.de'),
	('Carolin','1wewd23@456.de');

insert into bestellung(datum,lieferadresse, kundennummer, bestellwert) values
	('2018-04-21','Marx Straße 4',1,1),
	('2018-03-11','Lauterweg 12',1,2),
	('2018-04-21','Marx Straße 8',1,10),
	('2018-05-11','Bananengasse 189',2,2),
	('2018-06-03','Lauterweg 12',2,7),
	('2018-07-04','Wie auch immer Straße 9',5,1),
	('2018-02-05','Marx Straße 4',5,1),
	('2018-02-05','Marx Straße 4',5,10),
	('2018-02-05','Marx Straße 4',6,1),
	('2018-02-05','Marx Straße 4',6,1),
	('2018-02-05','Marx Straße 4',7,1),
	('2018-02-05','Marx Straße 4',7,15),
	('2018-02-05','Marx Straße 4',3,1),
	('2018-02-05','Marx Straße 4',4,1),
	('2018-03-06','Marx Straße 4',null,0);



-- alle joins einmal durch
select * from kunde inner join bestellung on bestellung.kundennummer=kunde.id;
select * from kunde left join bestellung on bestellung.kundennummer=kunde.id;
select * from kunde left join bestellung on bestellung.kundennummer=kunde.id where bestellung.id is null;
select * from kunde right join bestellung on bestellung.kundennummer=kunde.id;
select * from kunde right join bestellung on bestellung.kundennummer=kunde.id where kunde.id is null;
select * from kunde full outer join bestellung on kunde.id=bestellung.kundennummer;


select * from kunde left join bestellung on bestellung.kundennummer=kunde.id
union 
select * from kunde right join bestellung on bestellung.kundennummer=kunde.id;


-- wir bauen uns einen Full Outer Join zusammen
SELECT	    kunde.name, bestellung.id, bestellung.datum  FROM 	    kundeLEFT JOIN    bestellung 
ON 	    kunde.id = bestellung.kundennummer
WHERE 	    bestellung.kundennummer IS NULL

UNION all 

SELECT	    kunde.name, bestellung.id, bestellung.datum  FROM 	    kundeINNER JOIN  bestellung 
ON 	    kunde.id = bestellung.kundennummer

UNION all

SELECT	      kunde.name, bestellung.id, bestellung.datum  FROM 	      kundeRIGHT JOIN    bestellung 
ON 	      kunde.id = bestellung.kundennummer
WHERE 	      bestellung.kundennummer IS NULL;

-- jeder left join ist ein right join
select kunde.*, bestellung.* from kunde left join bestellung on bestellung.kundennummer=kunde.id
except
select kunde.*, bestellung.* from bestellung right join kunde on bestellung.kundennummer=kunde.id;



SELECT	    kunde.name, bestellung.id, bestellung.datum  FROM 	    kundeLEFT JOIN    bestellung 
ON 	    kunde.id = bestellung.kundennummer


UNION 


SELECT	      kunde.name, bestellung.id, bestellung.datum  FROM 	      kundeRIGHT JOIN    bestellung 
ON 	      kunde.id = bestellung.kundennummer
WHERE 	      bestellung.kundennummer IS NULL

-- Order by ausprobiert
select * from kunde order by email ASC, name desc;



-- In der Vorlesung kam die Frage nach kumulierten Werten. 
-- Beispiel mit with, Kunden die	80% vom Umsatz machen (A Kunden) 
--									95% vom Umsatz machen (B Kunden)
--									Der Rest (C-Kunden)
with 
	ABC_Punkte(A,B,C) as(
		select	sum(bestellwert)*0.8, 
				sum(bestellwert)*0.95,
				sum(bestellwert)
		from bestellung
	),
	Kundenumsatz(kunde, id, umsatz) as(
		select	kunde.name, 
				kunde.id, 
				isnull(sum(bestellung.bestellwert),0) as umsatz 
		from	kunde left join bestellung on (kunde.id=bestellung.kundennummer)
		group by kunde.name, kunde.id
	),
	ABC_Kunden (kunde, umsatz, kumuliert, typ) as(
		select	K.kunde, 
				K.umsatz, 
				(Select sum(V.umsatz) from Kundenumsatz as V where V.umsatz>=K.umsatz),
				case 
					when (Select sum(V.umsatz) from Kundenumsatz as V where V.umsatz>=K.umsatz)<=(select A from ABC_Punkte) then 'A'
					when (Select sum(V.umsatz) from Kundenumsatz as V where V.umsatz>=K.umsatz)<=(select B from ABC_Punkte) then 'B'
					when (Select sum(V.umsatz) from Kundenumsatz as V where V.umsatz>=K.umsatz)<=(select C from ABC_Punkte) then 'C'
				end
		from	Kundenumsatz as K
	)

select * from ABC_Kunden order by umsatz desc

drop table bestellung;
drop table kunde;

