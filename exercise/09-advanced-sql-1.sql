--use Vorlesung_DB;


/************************************************/
/* create tables								*/	
/************************************************/
create table Studenten2(
	Name varchar(30),
	Matrikel decimal(4,0),
	Geburtstag date,
	primary key (Matrikel),
	constraint matrikel_nicht_negativ2 check(Matrikel>=0)
);
create table Dozenten2(
	Name varchar(30),
	Buero varchar(30) not null,
	Tel varchar(30),
	primary key(Name)
);
create table Veranstaltungen2(
	Name varchar (30),
	Semester char(4),
	Raum varchar (8),
	Dozent varchar (30),
	primary key (Name, Semester),
	foreign key (Dozent) references Dozenten2(Name)
);
create table Student_in_Veranstaltung2(
	Student decimal(4,0),
	Veranstaltung varchar(30),
	Semester char(4),
	Note Decimal(2,1),
	foreign key (Student) references Studenten2(Matrikel),
	foreign key (Veranstaltung, Semester) references Veranstaltungen2(Name,Semester),
	constraint schulnote2 check(Note >= 1 and Note<=5),
	primary key (Student, Veranstaltung, Semester)
);

/************************************************/
/* fill tables									*/	
/************************************************/
insert into Dozenten2 (Name, Tel, Buero) values ('Klaus', '123', 'C201');
insert into Veranstaltungen2 (Dozent, Name, Raum, Semester) values 
	('Klaus','Tanzgymnastik','D111','ss18'),
	('Klaus','Tanzgymnastik','D111','ws17'),
	('Klaus','Sackhüpfen',null,'ws17');

insert into Dozenten2 (Name, Buero) values ('Maria', 'D120');
insert into Veranstaltungen2 (Dozent, Name, Raum, Semester) values 
	('Maria','Drachenfliegen','Strand','ss17'),
	('Maria','Drachenfliegen','Strand','ss18'),
	('Maria','Beachvolleyball','Strand','ss17'),
	('Maria','Beachvolleyball','Strand','ss18');

insert into Dozenten2 (Name, Buero) values ('Sepp', 'D10');

insert into Studenten2 (Name, Matrikel, Geburtstag) values 
	('Eva',3333,'1990-03-01'),
	('Luise',3334,'1990-06-02'),
	('Daniel',3335,'1990-07-01'),
	('Sepp',3331,'1993-02-01'),
	('Dominik',3336,'1990-08-01');

insert into Student_in_Veranstaltung2 (Student, Veranstaltung, Semester, Note) values 
	(3333,'Beachvolleyball','ss18',1.0),
	(3334,'Beachvolleyball','ss18',2.2),
	(3335,'Beachvolleyball','ss18',2.4),
	(3331,'Beachvolleyball','ss18',2.4),
	(3336,'Beachvolleyball','ss18',2.4),
	(3333,'Drachenfliegen','ss17',4.0),
	(3336,'Drachenfliegen','ss17',4.0),
	(3334,'Tanzgymnastik','ws17',5),
	(3335,'Tanzgymnastik','ws17',2.2),
	(3334,'Beachvolleyball','ss17',1.2),
	(3335,'Beachvolleyball','ss17',1.3);
	
create table Ahnen2 
(
	Name varchar(50) not null,
	Vater varchar(50),
	Mutter varchar(50),
	primary key (Name),
	foreign key (Vater) references Ahnen2(Name),
	foreign key (Mutter) references Ahnen2(Name)
)

insert into Ahnen2 (Name, Vater, Mutter) values 
	('Adam',null,null), 
	('Eva',null,null) ,
	('Kain','Adam','Eva') ,
	('Abel','Adam','Eva') ,
	('Seth','Adam','Eva') ,
	('Tharah','Seth',null),
	('Abraham','Tharah',null),
	('Nahor','Tharah',null),
	('Haran','Tharah',null),
	('Ismael','Abraham',null),
	('Isaak','Abraham',null),
	('Simran','Abraham',null),
	('Joksan','Abraham',null),
	('Medan','Abraham',null),
	('Midian','Abraham',null),
	('Jesbak','Abraham',null),
	('Suah','Abraham',null),
	('Jakob','Isaak',null),
	('Josef','Jakob',null) ,
	('Maria',null,null) ,
	('Jesus','Josef','Maria');

/************************************************/
/* Aggregatfunktionen							*/	
/************************************************/
--beste Note eines Dozenten zu jeder Veranstaltung
select 
	Student_in_Veranstaltung2.Veranstaltung,
	Veranstaltungen2.Dozent,
	min(Student_in_Veranstaltung2.Note) as "Beste Note"
from
	Student_in_Veranstaltung2 join Veranstaltungen2 on Student_in_Veranstaltung2.Veranstaltung = Veranstaltungen2.Name
group by
	Student_in_Veranstaltung2.Veranstaltung,
	Veranstaltungen2.Dozent

--schlechteste Note eines Dozenten zu jeder Veranstaltung
select 
	Student_in_Veranstaltung2.Veranstaltung,
	Veranstaltungen2.Dozent,
	max(Student_in_Veranstaltung2.Note) as "Schlechteste Note"
from
	Student_in_Veranstaltung2 join Veranstaltungen2 on Student_in_Veranstaltung2.Veranstaltung = Veranstaltungen2.Name
group by
	Student_in_Veranstaltung2.Veranstaltung,
	Veranstaltungen2.Dozent

--Anzahl der Studenten zu jeder Veranstaltung
select
	Student_in_Veranstaltung2.Veranstaltung,
	Veranstaltungen2.Dozent,
	count(distinct Student_in_Veranstaltung2.Student) as "Anzahl Studenten"
from
	Student_in_Veranstaltung2 join Veranstaltungen2 on Student_in_Veranstaltung2.Veranstaltung = Veranstaltungen2.Name
group by
	Student_in_Veranstaltung2.Veranstaltung,
	Veranstaltungen2.Dozent

--durchschnittliche Anzahl an Studenten zu jeder Veranstaltung
select
	Anz.Dozent,
	avg(Anz.Anz_Studenten) as "Durchschnittliche Anzahl"
from (	
	select
		Student_in_Veranstaltung2.Veranstaltung,
		Veranstaltungen2.Dozent,
		cast(count(distinct Student_in_Veranstaltung2.Student) as real) as Anz_Studenten
	from
		Student_in_Veranstaltung2 join Veranstaltungen2 on Student_in_Veranstaltung2.Veranstaltung = Veranstaltungen2.Name
	group by
		Student_in_Veranstaltung2.Veranstaltung,
		Veranstaltungen2.Dozent
) as Anz
group by
	Anz.Dozent

/************************************************/
/* de-init										*/	
/************************************************/
drop table Student_in_Veranstaltung2;
drop table Veranstaltungen2;
drop table Dozenten2;
drop table Studenten2;
drop table Ahnen2;