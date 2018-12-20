--use Vorlesung_DB;

/************************************************/
/* create tables								*/	
/************************************************/
create table Stud(
	Name varchar(30),
	Matrikel decimal(4,0),
	Geburtstag date,
	primary key (Matrikel),
	constraint matrikel_nicht_nega check(Matrikel>=0)
);
create table Doz(
	Name varchar(30),
	Buero varchar(30) not null,
	Tel varchar(30),
	primary key(Name)
);
create table Veranstalt(
	Name varchar (30),
	Semester char(4),
	Raum varchar (8),
	Dozent varchar (30),
	primary key (Name, Semester),
	foreign key (Dozent) references Doz(Name)
);
create table Stud_in_Veranstaltung(
	Student decimal(4,0),
	Veranstaltung varchar(30),
	Semester char(4),
	Note Decimal(2,1),
	foreign key (Student) references Stud(Matrikel),
	foreign key (Veranstaltung, Semester) references Veranstalt(Name,Semester),
	constraint schulnot check(Note >= 1 and Note<=5),
	primary key (Student, Veranstaltung, Semester)
);

insert into Doz (Name, Tel, Buero) values ('Klaus', '123', 'C201');
insert into Veranstalt (Dozent, Name, Raum, Semester) values 
	('Klaus','Tanzgymnastik','D111','ss18'),
	('Klaus','Tanzgymnastik','D111','ws17'),
	('Klaus','Sackhüpfen',null,'ws17');

insert into Doz (Name, Buero) values ('Maria', 'D120');
insert into Veranstalt (Dozent, Name, Raum, Semester) values 
	('Maria','Drachenfliegen','Strand','ss17'),
	('Maria','Drachenfliegen','Strand','ss18'),
	('Maria','Beachvolleyball','Strand','ss17'),
	('Maria','Beachvolleyball','Strand','ss18');

insert into Doz (Name, Buero) values ('Sepp', 'D10');

insert into Stud (Name, Matrikel, Geburtstag) values 
	('Eva',3333,'1990-03-01'),
	('Luise',3334,'1990-06-02'),
	('Daniel',3335,'1990-07-01'),
	('Sepp',3331,'1993-02-01'),
	('Dominik',3336,'1990-08-01');

insert into Stud_in_Veranstaltung (Student, Veranstaltung, Semester, Note) values 
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
	
create table Ahn 
(
	Name varchar(50) not null,
	Vater varchar(50),
	Mutter varchar(50),
	primary key (Name),
	foreign key (Vater) references Ahnen(Name),
	foreign key (Mutter) references Ahnen(Name)
)

/************************************************/
/* insert data									*/	
/************************************************/
insert into Ahn (Name, Vater, Mutter) values 
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
/* functions									*/	
/************************************************/
go
create function getMed()
returns decimal(2,1) as
begin
	declare @top_med int; set @top_med = 0;
	declare @bottom_med int; set @bottom_med = 0;
	declare @med decimal(2,1); set @med = 0;
	declare @anz int; set @anz=(select count(*) from Stud_in_Veranstaltung);
	declare @tmp_anz int; set @tmp_anz = 0;

	declare cur scroll cursor for
		select Note from Stud_in_Veranstaltung
	open cur
	set @tmp_anz = round((@anz / 2), 0)
	fetch absolute @tmp_anz from cur into @bottom_med
	set @tmp_anz = round((@anz / 2), 1)
	fetch absolute @tmp_anz from cur into @top_med
	close cur;
	deallocate cur;
	
	set @med = (@top_med + @bottom_med) / 2

	return @med;
end;


select dbo.getMed() as Median

go
drop function getMed;
go

/************************************************/
/* clean up										*/	
/************************************************/	
drop table Stud_in_Veranstaltung;
drop table Veranstalt;
drop table Doz;
drop table Stud;
drop table Ahn;