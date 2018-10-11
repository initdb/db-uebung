/********************************************************/
/* set up tables										*/
/********************************************************/

create table Studenten
(
	Name varchar(30),
	Matrikel DECIMAL(4,0) primary key,
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
    Student DECIMAL(4,0),
    foreign key(Student) references Studenten(Matrikel),
	Name varchar(30),
	Veranstaltung varchar(30),
	Semester char(4),
    foreign key(Veranstaltung, Semester) references Veranstaltungen(Name, Semester),
	Note decimal(2,1),
	constraint gueltige_note check(Note >= 6 and Note <=1),
	primary key(Student, Veranstaltung, Semester)
);

/********************************************************/
/* fill with data										*/
/********************************************************/
select * from Student_in_Veranstaltung;

/********************************************************/
/* tear down tables										*/
/********************************************************/
drop table Student_in_Veranstaltung;
drop table Veranstaltungen;
drop table Dozenten;
drop table Studenten;