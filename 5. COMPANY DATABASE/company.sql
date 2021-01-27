-----------------------------------------------------------------------------------------------------------------------------
-- Consider the schema for Company Database:

-- EMPLOYEE(SSN, Name, Address, Sex, Salary, SuperSSN, DNo) 
-- DEPARTMENT(DNo, DName, MgrSSN, MgrStartDate) 
-- DLOCATION(DNo,DLoc)
-- PROJECT(PNo, PName, PLocation, DNo)
-- WORKS_ON(SSN, PNo, Hours)

-----------------------------------------------------------------------------------------------------------------------------
-- CREATE STATEMENTS --

--Create Table DEPARTMENT with PRIMARY KEY as DNO
create table department(
dno int primary key,
dname varchar(10),
mgrssn int,
mgrstartdate date);

desc department;

--Create Table employee with ssn as primary key
create table employee(
SSN int primary key,
name varchar(10),
address varchar(10),
sex varchar(1),
salary int,
superssn int,
dno int,
foreign key(dno) references department(dno));

desc employee;

Alter table department add foreign key(mgrssn) references employee(ssn);
desc department;

--Create table dloc with dno, dloc as primary key
create table dloc(
dno int,
Dloc varchar(10),
primary key(dno,Dloc),
foreign key(dno) references department(dno));

desc dloc;

--Create table project with pno as primary key
create table project(
pno int primary key,
pname varchar(10),
plocation varchar(10),
dno int,
foreign key(dno) references department(dno));

desc project;

--Create table works_on with ssn and pno as primary key 
create table works_on(
ssn int,
pno int,
hours int,
primary key(ssn,pno),
foreign key(ssn) references employee(ssn),
foreign key(pno) references project(pno));

desc works_on;

-----------------------------------------------------------------------------------------------------------------------------
-- INSERT STATEMENTS -- 

--Inserting records into employee table
insert into employee values(1,'Kunal','Bangalore','M',1000000,null,null);
insert into employee values(2,'scott','Bangalore','M',6000000,1,null);
insert into employee values(3,'abcd','Bangalore','F',500000,2,null);
insert into employee values(4,'xyz','Bangalore','F',400000,1,null);
insert into employee values(5,'xyz','Bangalore','F',200000,3,null);
insert into employee values(6,'mnb','Bangalore','F',400000,3,null);
insert into employee values(7,'mnb','Bangalore','M',4000000,1,null);
insert into employee values(8,'ploki','Bangalore','M',800000,1,null);
insert into employee values(9,'pli','Bangalore','M',450000,2,null);
insert into employee values(10,'kljgsadd','Bangalore','M',950000,2,null);
select * from employee;

--Inserting records into department table 
insert into department values(101,'Accounts',1,'2019-05-10');
insert into department values(102,'HR',3,'2019-07-10');
insert into department values(103,'qweerty',2,'2018-07-10');
insert into department values(104,'qwey',4,'2018-07-05');
insert into department values(105,'qwssd',1,'2019-07-05');
select * from department;

--updating employee records table
update employee set dno=101 where SSN=1;
update employee set dno=101 where SSN=2;
update employee set dno=102 where SSN=3;
update employee set dno=103 where SSN=4;
update employee set dno=104 where SSN=5;
update employee set dno=105 where SSN=3;
update employee set dno=103 where SSN=6;
update employee set dno=103 where SSN=7;
update employee set dno=103 where SSN=8;
update employee set dno=103 where SSN=9;
update employee set dno=103 where SSN=10;
select * from employee;

--Inserting records into dloc table
insert into dloc values(101,'Bangalore');
insert into dloc values(102,'Bangalore');
insert into dloc values(103,'Bangalore');
insert into dloc values(104,'Bangalore');
insert into dloc values(105,'Bangalore');
select * from dloc;

--Inserting records into project table
insert into project values(51,'IOT','Bangalore',103);
insert into project values(52,'Finance','Bangalore',101);
insert into project values(53,'poi','Bangalore',105);
insert into project values(54,'qwert','Bangalore',104);
insert into project values(55,'tyuiop','Bangalore',102);
select * from project;

--Inserting records in to works_on table
insert into works_on values(1,52,6);
insert into works_on values(2,51,4);
insert into works_on values(3,51,6);
insert into works_on values(4,53,2);
insert into works_on values(5,54,7);
insert into works_on values(1,51,7);
select * from works_on;

-----------------------------------------------------------------------------------------------------------------------------
-- Write SQL queries to
-- 1. Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, 
-- either as a worker or as a manager of the department that controls the project.

(select pno from employee e, works_on w where e.ssn=w.ssn and e.name like '%scott') 
union 
(select pno from employee e,department d,project p 
where e.ssn=d.mgrssn and p.dno=d.dno and e.name like '%scott');

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.

select e.name,e.ssn,e.salary *1.1 
from employee e,works_on w,project p 
where e.ssn=w.ssn 
and w.pno=p.pno 
and pname='IOT';

-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as
-- well as the maximum salary, the minimum salary, and the average salary in this
-- department

select dname,sum(salary),max(salary),min(salary),avg(salary)
from employee e,department d 
where e.dno=d.dno 
group by d.dname 
having d.dname='Accounts';

-- 4. Retrieve the name of each employee who works on all the projects controlledby
-- department number 5 (use NOT EXISTS operator).

select e.name from employee e 
where not exists 
((select pno from project where dno=105 and  pno not in 
(select pno from works_on w where e.ssn=w.ssn)));

-- 5. For each department that has more than five employees, retrieve the department
-- number and the number of its employees who are making more than Rs. 6,00,000.

select dno,count(ssn) 
from employee where salary>600000 and 
dno in 
(select dno from employee group by dno having count(ssn)>5) 
group by dno;
-----------------------------------------------------------------------------------------------------------------------------