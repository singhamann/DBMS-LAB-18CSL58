-----------------------------------------------------------------------------------------------------------------------------
-- Consider the schema for College Database: 

-- STUDENT(USN, SName, Address, Phone, Gender) 
-- SEMSEC(SSID, Sem, Sec)
-- CLASS(USN, SSID)
-- COURSE(Subcode, Title, Sem, Credits)
-- IAMARKS(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA) 

-----------------------------------------------------------------------------------------------------------------------------
-- CREATE STATEMENTS --

--Create table STUDENT with PRIMARY KEY as USN

create table Student(
USN varchar(20),
SNAME varchar(30),
ADDRESS varchar(30),
PHONE varchar(11),
GENDER varchar(1),
primary key(USN));

desc Student;

--Create table Sem_sec
create table Sem_Sec(
SSID int,
SEM int,
SEC varchar(1),
primary key(SSID));

desc Sem_Sec;

--Create table Class
create table Class(
USN varchar(20),
SSID int,
foreign key(USN) references Student(USN),
foreign key(SSID) references Sem_Sec(SSID),
primary key(USN));

desc Class;

--Create table Course
create table COURSE(
SUBCODE int,
TITLE varchar(30),
SEM int,
CREDITS int,
primary key(SUBCODE));

desc COURSE;

--Create table Iat_marks
create table IAT_Marks(
USN varchar(20),
SUBCODE int,
SSID int,
Test1 int,
Test2 int,
Test3 int,
FinalIA int,
foreign key(USN) references Class(USN),
foreign key(SUBCODE) references COURSE(SUBCODE),
foreign key(SSID) references Class(SSID),
primary key(USN));

desc IAT_Marks;

-----------------------------------------------------------------------------------------------------------------------------
-- INSERT STATEMENTS -- 

--Inserting into student table 

insert into Student values("1CR18CS101","Kunal","BANGALORE",8092649366,"M");
insert into Student values("1CR18CS102","VIDYYA","KOLKATA",9838784887,"F");
insert into Student values("1CR18CS103","SHASHANK","LUCKNOW",7864379840,"M");
insert into Student values("1CR18CS104","SAMUEL","SHILLONG",8774009478,"M");
insert into Student values("1CR18CS105","MONICA","BANGALORE",9973476578,"F");
insert into Student values("1CR18CS106","MOHIT","BANGALORE",6475648989,"M");
insert into Student values("1CR18CS107","UTKARSH","MUMBAI",7898353567,"M");
insert into Student values("1CR18CS108","MAYANK","AHMEDABAD",8990037655,"M");
insert into Student values("1CR18CS109","ALIA","LUCKNOW",4563789786,"F");
insert into Student values("1CR18CS110","ARUSHI","JALANDHAR",7647886678,"F");
insert into Student values("1CR18CS111","KAVIN","BANGALORE",8467787878,"M");
insert into Student values("1CR18CS112","MICHAEL","AMRITSAR",9098746677,"M");
insert into Student values("1CR18CS113","PRIYANKA","KOLKATA",7748977644,"F");
insert into Student values("1CR18CS114","NISHA","MUMBAI",6748886645,"F");
insert into Student values("1CR18CS115","AKAASH","MUMBAI",9846789476,"M");

select * from Student;

--Inserting into Sem_sec table

insert into Sem_Sec values(101,2,"A");
insert into Sem_Sec values(102,4,"A");
insert into Sem_Sec values(103,4,"C");
insert into Sem_Sec values(104,6,"A");
insert into Sem_Sec values(105,8,"A");
insert into Sem_Sec values(106,8,"B");
insert into Sem_Sec values(107,8,"C");

select * from Sem_Sec;


--Inserting into Class table 

insert into Class values("1CR18CS101",101);
insert into Class values("1CR18CS102",101);
insert into Class values("1CR18CS103",102);
insert into Class values("1CR18CS104",103);
insert into Class values("1CR18CS105",103);
insert into Class values("1CR18CS106",103);
insert into Class values("1CR18CS107",104);
insert into Class values("1CR18CS108",104);
insert into Class values("1CR18CS109",105);
insert into Class values("1CR18CS110",105);
insert into Class values("1CR18CS111",106);
insert into Class values("1CR18CS112",106);
insert into Class values("1CR18CS113",107);
insert into Class values("1CR18CS114",107);
insert into Class values("1CR18CS115",107);

select * from Class;

--Inserting into course table 

insert into COURSE values(201,"DBMS",2,4);
insert into COURSE values(202,"MATH 2",4,5);
insert into COURSE values(203,"JAVA",6,5);
insert into COURSE values(204,"WEB DESIGN",8,9);

select * from COURSE;

--Inserting into IAT_Marks table 

insert into IAT_Marks values("1CR18CS101",201,101,19,20,20,NULL);
insert into IAT_Marks values("1CR18CS102",201,101,19,12,10,NULL);
insert into IAT_Marks values("1CR18CS103",202,102,10,7,4,NULL);
insert into IAT_Marks values("1CR18CS104",202,103,20,18,12,NULL);
insert into IAT_Marks values("1CR18CS105",202,103,13,12,12,NULL);
insert into IAT_Marks values("1CR18CS106",202,103,19,18,18,NULL);
insert into IAT_Marks values("1CR18CS107",203,104,11,10,11,NULL);
insert into IAT_Marks values("1CR18CS108",203,104,19,15,18,NULL);
insert into IAT_Marks values("1CR18CS109",204,105,10,9,6,NULL);
insert into IAT_Marks values("1CR18CS110",204,105,20,18,19,NULL);
insert into IAT_Marks values("1CR18CS111",204,106,19,20,17,NULL);
insert into IAT_Marks values("1CR18CS112",204,106,14,13,15,NULL);
insert into IAT_Marks values("1CR18CS113",204,107,18,17,20,NULL);
insert into IAT_Marks values("1CR18CS114",204,107,8,7,7,NULL);
insert into IAT_Marks values("1CR18CS115",204,107,14,11,15,NULL);

select * from IAT_Marks;


-----------------------------------------------------------------------------------------------------------------------------
-- Write SQL queries to

-- 1. List all the student details studying in fourth semester ‘C’ section.

select S.* from Student S, Sem_Sec SS, Class C
where S.USN=C.USN and
SS.SSID=C.SSID and
SEM=4 and SEC="C";

-- 2. Compute the total number of male and female students in each semester and in
-- each section.

select SEM, SEC, GENDER, COUNT(GENDER)
from Student NATURAL JOIN Class NATURAL JOIN Sem_Sec
group by SEM, SEC, GENDER;

-- 3. Create a view of Test1 marks of student USN ‘1BI15CS101’ in all Courses.

create view TEST1_1CR18CS101
as select USN, SUBCODE, TEST1
from IAT_Marks
where USN="1CR18CS101";
select * from TEST1_1CR18CS101;

-- 4. Calculate the FinalIA (average of best two test marks) and update the
-- corresponding table for all students.

update IAT_Marks
set FINALIA=(TEST1+TEST2+TEST3-LEAST(TEST1,TEST2,TEST3))/2;
select * from IAT_Marks;

-- 5. Categorize students based on the following criterion:
-- If FinalIA = 17 to 20 then CAT = ‘Outstanding’
-- If FinalIA = 12 to 16 then CAT = ‘Average’
-- If FinalIA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students.

select I.USN, I.SUBCODE, "OUTSTANDING" as CAT from
	IAT_Marks I, Class C, Sem_Sec SS where I.USN=C.USN and C.SSID=SS.SSID
and
	FINALIA between 17 and 20 and SEM=8 and SEC in("A","B","C")
UNION
	select I.USN, I.SUBCODE, "AVERAGE" as CAT from IAT_Marks I, Class C,
Sem_Sec SS
	where I.USN=C.USN and C.SSID=SS.SSID and FINALIA between 12 and 16
and 
	SEM=8 and SEC IN("A","B","C")
UNION
	select I.USN, I.SUBCODE, "WEAK" as CAT from IAT_Marks I, Class C, Sem_Sec
	SS where I.USN=C.USN and C.SSID=SS.SSID
and
	FINALIA < 12 and SEM=8 and SEC in("A","B","C");
  
-----------------------------------------------------------------------------------------------------------------------------