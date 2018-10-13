/********************************************************/
/* set up tables 2.2									*/
/********************************************************/

create table STUDENTEN
(
	Name varchar(30),
	Matrikel decimal(4,0) primary key,
);

create table DOZENTEN
(
	Name varchar(30) primary key,
	Buero varchar(30) not null,
    Tel varchar(30) null,
);

create table VERANSTALTUNGEN
(
    Name varchar(30),
    Semester char(4),
    primary key(Name, Semester),
    Raum varchar(8),
    Dozent varchar(30),
    foreign key(Dozent) references DOZENTEN(Name),
);

create table STUDENTEN_IN_VERANSTALTUNG
(
    Student decimal(4,0),
    foreign key(Student) references STUDENTEN(Matrikel),
	Veranstaltung varchar(30),
	Semester char(4),
    foreign key(Veranstaltung, Semester) references VERANSTALTUNGEN(Name, Semester),
	Note decimal(2,1),
	constraint gueltige_note check(Note <= 5 and Note >= 1),
	primary key(Student, Veranstaltung, Semester)
);

/********************************************************/
/* alter table 2.3										*/
/********************************************************/
alter table STUDENTEN add Geburtstag date;
alter table STUDENTEN alter column Geburtstag date not null;

/********************************************************/
/* fill with data (own)									*/
/********************************************************/
insert into STUDENTEN(Name, Matrikel, Geburtstag) values
	('Klaus','1252','19.10.1990'),
	('Maria','4356','11.09.1993'),
	('Johanna','4567','01.05.1996'),
	('Meemet','6969','27.12.1995');

insert into DOZENTEN(Name, Buero, Tel) values
	('Schmidt','A0.01','0800902'),
	('Ferrit','A0.05','12344567'),
	('Heftig','A0.07','10001000');

insert into VERANSTALTUNGEN(Name, Semester, Raum, Dozent) values
	('Programmieren 15','ws18','B0.14','Schmidt'),
	('Hochschulsport','ss18','R0.05','Ferrit'),
	('Mathematik 1','ss18','B0.03','Heftig');

insert into STUDENTEN_IN_VERANSTALTUNG(Student, Veranstaltung, Semester, Note) values
	('1252','Programmieren 15','ws18','3.3'),
	('4356','Mathematik 1','ss18','2.3'),
	('4567','Programmieren 15','ws18','1.0'),
	('6969','Hochschulsport','ss18','5.0');

/********************************************************/
/* fill with data 2.4									*/
/********************************************************/
insert into DOZENTEN(Name, Buero, Tel) values
	('Klaus','C201','123');

insert into VERANSTALTUNGEN(Name, Semester, Raum, Dozent) values
	('Tanzgymnastik','ws17','D111','Klaus'),
	('Tanzgymnastik','ss18','D111','Klaus'),
	('Tanzgymnastik','ws18',null,'Klaus');

insert into DOZENTEN(Name, Buero, Tel) values
	('Maria','D120',null);

insert into VERANSTALTUNGEN(Name, Semester, Raum, Dozent) values
	('Drachenfliegen','ss17','Strand'),
	('Drachenfliegen','ss18','Strand'),
	('Beachvollyball','ss17','Strand'),
	('Beachvollyball','ss18','Strand');

insert into STUDENTEN(Name, Matrikel, Geburtstag) values
	('Eva','3333','01.03.1990'),
	('Luise','3334','01.04.1990'),
	('Daniel','3335','01.05.1990'),
	('Dominik','3336','01.06.1990');

insert into STUDENTEN_IN_VERANSTALTUNG(Student, Veranstaltung, Semester, Note) values
	('3333','Beachvollyball','ss18',null),
	('3334','Beachvollyball','ss18',null),
	('3335','Beachvollyball','ss18',null);

insert into STUDENTEN_IN_VERANSTALTUNG(Student, Veranstaltung, Semester, Note) values
	('3333','Drachenfliegen','ss17',null),
	('3336','Drachenfliegen','ss17',null);

insert into STUDENTEN_IN_VERANSTALTUNG(Student, Veranstaltung, Semester, Note) values
	('3334','Tanzgymnastik','ws17',null),
	('3335','Tanzgymnastik','ws17',null),
	('3334','Beachvollyball','ss17',null),
	('3335','Beachvollyball','ss17',null);

update STUDENTEN_IN_VERANSTALTUNG  set Note = '4.0';
update DOZENTEN set Buero = 'D22' where Name = 'Maria';

/********************************************************/
/* show tables											*/
/********************************************************/
select * from STUDENTEN;
select * from DOZENTEN;
select * from VERANSTALTUNGEN;
select * from STUDENTEN_IN_VERANSTALTUNG;

/********************************************************/
/* tear down tables										*/
/********************************************************/
drop table STUDENTEN_IN_VERANSTALTUNG;
drop table VERANSTALTUNGEN;
drop table DOZENTEN;
drop table STUDENTEN;