-----------------------------------------------------------------------------------------------------------------------------
-- Consider the following schema for a Library Database:

-- BOOK(Book_id, Title, Publisher_Name, Pub_Year)
-- BOOK_AUTHORS(Book_id, Author_Name)
-- PUBLISHER(Name, Address, Phone)
-- BOOK_COPIES(Book_id, Programme_id, No-of_Copies)
-- BOOK_LENDING(Book_id, Programme_id, Card_No, Date_Out, Due_Date)
-- LIBRARY_PROGRAMME(Programme_id, Programme_Name, Address)

-----------------------------------------------------------------------------------------------------------------------------
-- CREATE STATEMENTS --

-- Creating book table
create table book(
Book_id int primary key,
title varchar(30),
publisher_name varchar(30),
pub_year year);

-- Creating publisher table
create table publisher(
name varchar(20) primary key,
address varchar(30),
phone bigint);

-- Adding foreign key to book table
alter table book add foreign key (publisher_name) references publisher(name) on delete cascade;

desc book;
desc publisher;

-- Creating book_author table
create table book_author(
book_id int primary key,
author_name varchar(20),
foreign key(book_id)references book(Book_id)on delete cascade);
desc book_author;

-- Creating library_programme table
create table library_programme(
programme_id int primary key,
programme_name varchar(20),
address varchar(20));
desc library_programme;

-- Creating book_copies table
create table book_copies(
book_id int,
programme_id int,
no_of_copies int,
primary key(book_id,programme_id),
foreign key(book_id)references book(Book_id) on delete cascade,
foreign key(programme_id)references library_programme(programme_id) on delete cascade);
desc book_copies;

--creating book_lending table
create table book_lending(
book_id int,
programme_id int,
card_no varchar(10),
date_out date,
due_date date,
primary key(book_id,programme_id,card_no),
foreign key(book_id)references book(book_id)on delete cascade,
foreign key(programme_id)references library_programme(programme_id)on delete cascade);
desc book_lending;


-----------------------------------------------------------------------------------------------------------------------------
-- INSERT STATEMENTS -- 

--Inserting records in publisher table
insert into publisher values('scholastic','london',6658564346);
insert into publisher values('black swann','california',7658564346);
insert into publisher values('pearson','london',7658564346);
select * from publisher;

-- Inserting records in book table
insert into book values(001,'Sorceres Stones','scholastic',1997);
insert into book values(002,'Chamber of Secrets','pearson',1997);
insert into book values(003,'Prisoner of Azkaban','pearson',1999);
insert into book values(004,'Goblet of fire','black swann',1999);
insert into book values(005,'Order of Pheonix','black swann',2000);
insert into book values(006,'Half Blood Prince','pearson',2000);
insert into book values(007,'Deathly Hallows','scholastic',2001);
insert into book values(008,'Deathly Hallows-2','scholastic',2002);
select * from book;

--Inserting record in book_author table
insert into book_author values(001,'JK Rowling');
insert into book_author values(002,'QW Rowling');
insert into book_author values(003,'EW Rowling');
insert into book_author values(004,'YU Rowling');
insert into book_author values(005,'IO Rowling');
insert into book_author values(006,'LK Rowling');
insert into book_author values(007,'DF Rowling');
insert into book_author values(008,'BV Rowling');
select * from book_author;

--Inserting record in library_programme table
insert into library_programme values(101,'Qudditch','Northumberland');
insert into library_programme values(102,'Defenses','London');
insert into library_programme values(103,'Potions','London');
insert into library_programme values(104,'Flying','GodriC Hollow');
insert into library_programme values(105,'Muggles','Diagon Alley');
select * from library_programme;

-- Inserting record in book_copies table
insert into book_copies values(1,101,10);
insert into book_copies values(002,102,20);
insert into book_copies values(003,103,30);
insert into book_copies values(004,104,40);
insert into book_copies values(005,105,50);
insert into book_copies values(006,101,10);
insert into book_copies values(007,102,20);
insert into book_copies values(008,103,50);
select * from book_copies;

-- Inserting records in book_lending table
insert into book_lending values(001,101,'A1','2017-01-01','2017-01-15');
insert into book_lending values(002,101,'A1','2017-03-01','2017-03-15');
insert into book_lending values(002,102,'A1','2017-02-01','2017-02-15');
insert into book_lending values(002,103,'A1','2017-02-01','2017-02-15');
insert into book_lending values(003,103,'B1','2017-04-01','2017-04-15');
insert into book_lending values(005,105,'B1','2018-04-01','2018-04-15');
insert into book_lending values(006,105,'C1','2019-05-01','2019-05-15');
insert into book_lending values(007,103,'D1','2018-08-01','2018-08-15');
select * from book_lending;

-----------------------------------------------------------------------------------------------------------------------------
-- Write SQL queries to

-- 1. Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each Programme, etc.

select b.*,a.author_name,c.no_of_copies 
from book b,book_author a,book_copies c 
where b.Book_id=a.book_id and b.Book_id=c.book_id;

-- 2. Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2017 to Jun 2017.

select card_no 
from book_lending 
where date_out >="2017-01-01" and date_out<="2017-06-30" 
group by card_no having count(*)>3;

-- 3. Delete a book in BOOK table. Update the contents of other tables to reflect this data manipulation operation.

delete from book where book_id=2;

select *from book_author;
select *from book_lending;
select *from book_copies;

-- 4. Partition the BOOK table based on year of publication. Demonstrate its working with a simple query.

create table book1( 
book_id int ,
title varchar(20),
publisher_name varchar(20),
pub_year year,
primary key(book_id,pub_year));
desc book1;

insert into book1 values(001,'Sorceres Stones','scholastic',1997);
insert into book1 values(002,'Chamber of Secrets','pearson',1997);
insert into book1 values(003,'Prisoner of Azkaban','pearson',1999);
insert into book1 values(004,'Goblet of fire','black swann',1999);
insert into book1 values(005,'Order of Pheonix','black swann',2000);
insert into book1 values(006,'Half Blood Prince','pearson',2000);
insert into book1 values(007,'Deathly Hallows','scholastic',2001);
insert into book1 values(008,'Deathly Hallows-2','scholastic',2002);
select * from book1;

alter table book1 partition by range(pub_year)
	(partition p0 values less than(1999),
	partition p1 values less than(2002),
	partition p2 values less than maxvalue);

select partition_name,table_rows from information_schema.partitions where table_name="book1";

-- 5. Create a view of all books and its number of copies that are currently available in the Library.

create view total_books as select Book_id,sum(no_of_copies) as sum from book_copies group by Book_id;
select * from total_books;

create view books_borrowed as select Book_id,count(*) as sum from book_lending group by Book_id;
select * from books_borrowed;

select a.Book_id,ifnull(a.sum-b.sum,a.sum) as books_available 
from total_books a left outer join books_borrowed b on a.Book_id=b.Book_id;

----------------------------------------------------------------------------------------------------------------------------