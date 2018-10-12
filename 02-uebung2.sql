/********************************************************/
/* set up tables										*/
/********************************************************/

create table Studenten
(
	Name varchar(30),
	Matrikel decimal(4,0) primary key,
);

create table Dozenten
(
	Name varchar(30) primary key,
	Buero varchar(30) not null,
    Tel varchar(30) null,
);

create table Veranstaltungen
(
    Name varchar(30),
    Semester char(4),
    primary key(Name, Semester),
    Raum varchar(8),
    Dozent varchar(30),
    foreign key(Dozent) references Dozenten(Name),
);

create table Student_in_Veranstaltung
(
    Student decimal(4,0),
    foreign key(Student) references Studenten(Matrikel),
	Veranstaltung varchar(30),
	Semester char(4),
    foreign key(Veranstaltung, Semester) references Veranstaltungen(Name, Semester),
	Note decimal(2,1),
	constraint gueltige_note check(Note <= 5 and Note >= 1),
	primary key(Student, Veranstaltung, Semester)
);

alter table Studenten add Geburtstag date;
alter table Studenten alter column Geburtstag date not null;

/********************************************************/
/* fill with data										*/
/********************************************************/
insert into Studenten(Name, Matrikel, Geburtstag) values
	('Klaus','1252','19.10.1990'),
	('Maria','4356','11.09.1993'),
	('Johanna','4567','01.05.1996'),
	('Meemet','6969','27.12.1995');

insert into Dozenten(Name, Buero, Tel) values
	('Schmidt','A0.01','0800902'),
	('Ferrit','A0.05','12344567'),
	('Heftig','A0.07','10001000');

insert into Veranstaltungen(Name, Semester, Raum, Dozent) values
	('Programmieren 15','4','B0.14','Schmidt'),
	('Hochschulsport','1','R0.05','Ferrit'),
	('Mathematik 1','2','B0.03','Heftig');

insert into Student_in_Veranstaltung(Student, Veranstaltung, Semester, Note) values
	('1252','Programmieren 15','4','3.3'),
	('4356','Mathematik 1','2','2.3'),
	('4567','Programmieren 15','4','1.0'),
	('6969','Hochschulsport','1','5.0');

select * from Studenten;
select * from Dozenten;
select * from Veranstaltungen;
select * from Student_in_Veranstaltung;

/********************************************************/
/* tear down tables										*/
/********************************************************/
drop table Student_in_Veranstaltung;
drop table Veranstaltungen;
drop table Dozenten;
drop table Studenten;