--_________________________________/* PART 02 */____________________________________

use bookcatalog
go

--___________________________/*Insert Initial Data*/________________________________

insert into Tags values
	('Programming'),('C#'),('Database'),('SQL Server'), ('SQL'),('Blazer'), ('Web Assembly'), ('SPA')
go

insert into Publishers values
	('The Pragmatic Bookshelf',null),('Packt Publishing',null),('Northwick publishing',null),('Southwick publishing',null)
go

insert into authors values 
	('Bruce Tate', null), ('Robert Martin', 'robertm@aol.com'), ('McDonnel', null), ('Jo Finn', 'jofinn@alo.com'),
	('K watson', 'watson@mc.co.nz'), ('J Sharp', 'jsharp@magamail.com'), ('J Robbs', null)
GO

insert into Books values
('c# step by step',67.99,'2021-08-05',1,1),
('SQL server 2016 for developer',88.99,'2020-08-16',1,2),
('Blazeor guide',99.99,'2019-01-24',0,1)
Go

Insert into BookTags values
(1,1),(1,2),(2,3),(2,4),(2,5),(3,6),(3,7),(3,8)
go

insert into BookAuthors values
(1,1),(1,2),(2,3),(2,4),(3,5)
Go

select * from Tags
select * from Publishers
select * from authors
select * from Books
select * from BookTags
select * from BookAuthors
go
--_______/*insert authors data using stored procedure spInsertAuthor*/______________

declare @id int
exec spInsertAuthor 'Lalon', null, @id output
select @id as 'inserted with id'
exec spInsertAuthor 'Jerry', 'jerry@gmail.com', @id output
select @id as 'inserted with id'
exec spInsertAuthor 'Mina', null, @id output
select @id as 'inserted with id'
exec spInsertAuthor 'Mahmud', null, @id output
select @id as 'inserted with id'
exec spInsertAuthor 'Sohan', 'sohan@gmail.com', @id output
select @id as 'inserted with id'
exec spInsertAuthor 'Polash', 'polash@gamail.com', @id output
select @id as 'inserted with id'
go
select * from authors
go

--_________/*update authors data using stored procedure spInsertAuthor*/____________

exec spUpdateAuthor @authorid=1, @email = 'g1@gmail.com'
exec spUpdateAuthor @authorid=4, @email = 'g2@gmail.com'
exec spUpdateAuthor 3,'Munna','g3@gmail.com'
go
select * from authors
go

--________/*delete authors data using stored procedure spInsertAuthor*/_____________

exec spDeleteAuthor 6, 1
go
select * from authors
go

--____________/*insert tags data using stored procedure spInsertTag*/_______________

declare @id int
exec spInsertTag 'Programming', @id output
select @id as 'inserted with id'
exec spInsertTag '.NET', @id output
select @id as 'inserted with id'
exec spInsertTag 'C#', @id output
select @id as 'inserted with id'
exec spInsertTag 'Database', @id output
select @id as 'inserted with id'
exec spInsertTag 'SQL Server', @id output
select @id as 'inserted with id'
exec spInsertTag 'ASP', @id output
select @id as 'inserted with id'
exec spInsertTag 'ASP.NET', @id output
select @id as 'inserted with id'
go
select * from tags
go

--____________/*update tags data using stored procedure spInsertTag*/_______________

exec spUpdateTag 5, 'SQL Server 2016'
go
select * from tags
go

--_____________/*delete tags data using stored procedure spInsertTag*/______________

exec spDeleteTag 7
go
select * from tags
go

--_______/*insert publisher data using stored procedure spInsertPublisher*/_________

declare @id int
exec spInsertPublisher 'Wroxy publishing',null,  @id output
select @id as 'inserted with id'
exec spInsertPublisher 'APres',null,  @id output
select @id as 'inserted with id'
exec spInsertPublisher 'MPress',null,  @id output
select @id as 'inserted with id'
exec spInsertPublisher 'Wielley',null,  @id output
select @id as 'inserted with id'
exec spInsertPublisher 'Manning',null,  @id output
select @id as 'inserted with id'
go
select * from publishers
go

--______/*update publishers data using stored procedure spInsertPublisher*/_________

exec spUpdatePublisher 5, 'Manning Inc',';sales@manning.com'
go
select * from publishers
go

--/*insert books,bookauthors & booktags data using stored procedure spInsertBook*/__

exec spInsertBook @title ='C#',
		@price = 59.99,
		@available = 1, 
		@publishdate ='2021-07-11',
		@publisherid=1,
		@tags = 'Programming, C#, .NET',
		@authors = '1, 2'
exec spInsertBook @title ='SQL',
		@price = 59.99,
		@available = 1, 
		@publishdate ='2021-07-11',
		@publisherid=1,
		@tags = 'SQL Server',
		@authors = '3'
exec spInsertBook @title ='UML',
		@price = 59.99,
		@available = 1, 
		@publishdate ='2021-07-11',
		@publisherid=1,
		@tags = 'PHP, Laravel',
		@authors = '5'
go
select * from books
select * from bookauthors
select * from booktags
go

--______________________________/* View */__________________________________________

SELECT * FROM vBookWithDeatils
GO
SELECT * FROM vAuthoBookCount
GO

--______________________________/* Test UDF */_____________________________________

select dbo.fnBooksPublished(2017)
go
select * from fnBooksUnderTag('C#')

--____________________________/* Test Tigger */____________________________________

exec spDeletePublicher 1
go
select * from publishers
go
exec spDeletePublicher 2
go
select * from publishers
go
select * from books
go

delete from authors where authorid=1

delete from publishers where publisherid=1

select * from tags
select * from booktags
go
delete from tags where tagid=3
go
select * from tags
select * from booktags
go

--___________________________Queries Added__________________________________________
--____________________________1 Inner JOIN__________________________________________

select        p.publishername, b.title, b.coverprice, a.authorname, t.tag
from            publishers p
inner join
                         books b on p.publisherid = b.publisherid 
inner join
                         bookauthors ba on b.bookid = ba.bookid 
inner join
                         authors a on ba.authorid = a.authorid 
inner join
                         booktags bt on b.bookid = bt.bookid 
inner join
                         tags t on bt.tagid = t.tagid
go

--_____________________________2 Inner JOIN FILTER_________________________________

select        p.publishername, b.title, b.coverprice, a.authorname, t.tag
from            publishers p
inner join
                         books b on p.publisherid = b.publisherid 
inner join
                         bookauthors ba on b.bookid = ba.bookid 
inner join
                         authors a on ba.authorid = a.authorid 
inner join
                         booktags bt on b.bookid = bt.bookid 
inner join
                         tags t on bt.tagid = t.tagid
where t.tag IN ('Programming', '.NET')
go

--_____________________________3 Inner JOIN FILTER_________________________________

select        p.publishername, b.title, b.coverprice, a.authorname, t.tag
from            publishers p
inner join
                         books b on p.publisherid = b.publisherid 
inner join
                         bookauthors ba on b.bookid = ba.bookid 
inner join
                         authors a on ba.authorid = a.authorid 
inner join
                         booktags bt on b.bookid = bt.bookid 
inner join
                         tags t on bt.tagid = t.tagid
where p.publishername = 'The Pragmatic Bookshelf'
go

--_______________________________4 RIGHT JOIN ______________________________________

select       p.publishername, b.title, b.coverprice, a.authorname, t.tag
from            bookauthors as ba 
inner join
                         books as b on ba.bookid = b.bookid 
inner join
                         authors as a on ba.authorid = a.authorid 
inner join
                         booktags as bt on b.bookid = bt.bookid 
inner join
                         tags as t on bt.tagid = t.tagid 
right outer join
                         publishers as p on b.publisherid = p.publisherid
go

--______________________5 RIGHT JOIN cahnge to CTE__________________________________

with cte as
(
select       b.publisherid, b.title, b.coverprice, a.authorname, t.tag
from            bookauthors as ba 
inner join
                         books as b on ba.bookid = b.bookid 
inner join
                         authors as a on ba.authorid = a.authorid 
inner join
                         booktags as bt on b.bookid = bt.bookid 
inner join
                         tags as t on bt.tagid = t.tagid 
)
select  p.publishername, c.title, c.coverprice, c.authorname, c.tag
from cte c
right outer join publishers p on p.publisherid = c.publisherid
go

--_______________________6 RIGHT JOIN non-maching__________________________________

select        p.publishername, b.title, b.coverprice, a.authorname, t.tag
from            bookauthors as ba 
inner join
                         books as b on ba.bookid = b.bookid 
inner join
                         authors as a on ba.authorid = a.authorid 
inner join
                         booktags as bt on b.bookid = bt.bookid 
inner join
                         tags as t on bt.tagid = t.tagid 
right outer join
                         publishers as p on b.publisherid = p.publisherid
where b.bookid is null
go

--____________________7 RIGHT JOIN non-maching subquery_____________________________

select        p.publishername, b.title, b.coverprice, a.authorname, t.tag
from            bookauthors as ba 
inner join
                         books as b on ba.bookid = b.bookid 
inner join
                         authors as a on ba.authorid = a.authorid 
inner join
                         booktags as bt on b.bookid = bt.bookid 
inner join
                         tags as t on bt.tagid = t.tagid 
RIGHT OUTER JOIN
                         publishers as p on b.publisherid = p.publisherid
where NOT( b.bookid IS NOT NULL AND b.bookid IN (select bookid from books))
go

--___________________________8 aggregate____________________________________________

select        p.publishername, t.tag, COUNT(b.bookid)
from            publishers p
inner join
                         books b on p.publisherid = b.publisherid 
inner join
                         bookauthors ba on b.bookid = ba.bookid 
inner join
                         authors a on ba.authorid = a.authorid 
inner join
                         booktags bt on b.bookid = bt.bookid 
inner join
                         tags t on bt.tagid = t.tagid
group by p.publishername, t.tag
go

--_________________________9 aggregate having_____________________________________

select        p.publishername, t.tag, COUNT(b.bookid)
from            publishers p
inner join
                         books b on p.publisherid = b.publisherid 
inner join
                         bookauthors ba on b.bookid = ba.bookid 
inner join
                         authors a on ba.authorid = a.authorid 
inner join
                         booktags bt on b.bookid = bt.bookid 
inner join
                         tags t on bt.tagid = t.tagid
group by p.publishername, t.tag
having t.tag = 'C#'
go

--____________________________10 window____________________________________________

select        p.publishername, t.tag, 
count(b.bookid) over (order by p.publisherid, b.bookid) 'bookcount',
raw_number() over (order by p.publisherid, b.bookid) 'rownum',
rank() over (order by p.publisherid, b.bookid) 'rank',
dense_rank() over (order by p.publisherid, b.bookid) 'denserank',
ntile(3) over (order by p.publisherid, b.bookid) 'ntile'
from            publishers p
inner join
                         books b on p.publisherid = b.publisherid 
inner join
                         bookauthors ba on b.bookid = ba.bookid 
inner join
                         authors a on ba.authorid = a.authorid 
inner join
                         booktags bt on b.bookid = bt.bookid 
inner join
                         tags t on bt.tagid = t.tagid
go
--=====11 CASE=============----
select        a.authorname, a.email, 
case
	when count(ba.bookid)= 0 then 'No book'
	else cast(count(ba.bookid) as varchar)
end bookcount
from            authors a
left outer join
                         bookauthors ba on a.authorid = ba.authorid 

group by a.authorname, a.email
go

--_______________/* Project done by Md. Amirul Momenin / ID: 1270321 */___________