

--_________________________/* SQL SERVER 2016 Project */__________________________
--____________________/* Project Name: Book Catalog Database */___________________

--________________________________/* PART-01 */___________________________________
--_____________________________/*create Database*/________________________________
create database bookcatalog
go

use bookcatalog
go

--__________________________/*Create Required tables*/____________________________

create table tags 
(
	tagid int not null identity primary key,
	tag nvarchar (30) not null
)
go

create table publishers
( 
	 publisherid int identity primary key,
	 publishername nvarchar (40) not null,
	 publisheremail nvarchar (50) null
 )
 go

 create table authors
 (
		authorid int identity primary key,
		authorname nvarchar(50) not null,
		email nvarchar(50) null
)
go

 create table books
( 
	  bookid int identity primary key,
	  title nvarchar (40) not null,
	  coverprice money not null,
	  publishdate date not null,
	  available bit default 0,
	  publisherid int not null references publishers(publisherid)
 )
go

create table booktags
(
	  bookid int not null references books (bookid),
	  tagid int not null references tags (tagid),
	  primary key (bookid,tagid)
)
go

create table bookauthors 
(
	  bookid int not null references books (bookid),
	  authorid int not null references authors (authorid)
	  primary key (bookid, authorid)
)
go

--____________ stored procedure to insert, Update and Delete data_________________

--______________________________Insert Author_____________________________________

create proc	spInsertAuthor	
				@authorname nvarchar(50) ,
				@email nvarchar(50) = null,
				@authorid INT  output
as
	declare @id INT
	begin try
		insert into authors (authorname, email) values (@authorname, @email)
		SELECT @authorid = scope_identity()
		
	end try
	begin catch
		declare @errmessage nvarchar(500)
		set @errmessage = error_message()
		raiserror( @errmessage, 11, 1)
		return 
	end catch
go

--________________________________Update Author___________________________________

create proc spUpdateAuthor 	@authorid	int,
							@authorname nvarchar(50) = null ,
							@email		nvarchar(50) = null
							
as
begin try
	update authors 
	set		
			authorname	=	isnull(@authorname,authorname), 
			email		=	isnull(@email, email)
	where authorid = @authorid 	
end try
begin catch
	declare @errmessage nvarchar(500)
	set @errmessage = error_message()
	raiserror( @errmessage, 11, 1)
	return 
end catch
return 
go

--_________________________________Delete Author__________________________________

create proc spDeleteAuthor @authorid int, @cascade bit = 0
as
if exists (select 1 from bookauthors where authorid=@authorid)
begin
	 if NOT @cascade <> 1
	 begin
		raiserror ('Author has related books and cascade is enabled. That is why Cannot delete author', 11, 1)
		return
	 end
	 else
	 begin 
		delete bookauthors where authorid= @authorid
	 end
end
delete from authors where authorid = @authorid
go

---____________________________Insert Tag_________________________________________
create proc spInsertTag	@tag nvarchar(30) ,
							@tageid int  output
as
	declare @id int
	begin try
		insert into tags(tag) values (@tag)
		SELECT @tageid = scope_identity()
		
	end try
	begin catch
		declare @errmessage nvarchar(500)
		set @errmessage = error_message()
		raiserror( @errmessage, 11, 1)
		return 
	end catch
go

--_______________________________Update Tag_______________________________________

create proc spUpdateTag	@tageid int, @tag nvarchar(30) 						 
as
begin try
	update tags set tag=@tag
	where tagid = @tageid 
		
end try
begin catch
	declare @errmessage nvarchar(500)
	set @errmessage = error_message()
	raiserror( @errmessage, 11, 1)
	return 
end catch
go

--_________________________________Delete Tag_____________________________________

create proc spDeleteTag @tageid int, @cascade bit = 0
as
if EXISTS (select 1 from booktags where tagid=@tageid)
begin
	 if NOT @cascade <> 1
	 begin
		raiserror (' Tag has related books and cascade is enabled.For this reason,Cannot delete tag,', 11, 1)
		return
	 end
	 else
	 begin 
		delete booktags where tagid= @tageid
	 end
end
delete from tags where tagid = @tageid
go

--________________________________Insert Publisher________________________________

create proc spInsertPublisher	@publishername nvarchar(40),
								@pulisheremail nvarchar(50) = NULL,
								@publisherid INT OUTPUT
as
declare @id int
begin try
	insert into publishers(publishername, publisheremail) values (@publishername, @pulisheremail)
	select @publisherid = scope_identity()
		
end try
begin catch
	declare @errmessage nvarchar(500)
	set @errmessage = error_message()
	;
	throw 50001,@errmessage,1 

end catch
go

--____________________________Update Publisher____________________________________

create proc spUpdatePublisher	@publisherid int,
								@publishername nvarchar(40) =NULL,
								@pulisheremail nvarchar(50) = NULL
								 
as

begin try
	update publishers set publishername= isnull(@publishername, publishername), publisheremail = isnull(@pulisheremail, publisheremail)
	where publisherid = @publisherid
		
end try
begin catch
	declare @errmessage nvarchar(500)
	set @errmessage = error_message()
	;
	throw 50001,@errmessage,1 

end catch
go

--_________________________________Delete Publisher_______________________________

create proc spDeletePublicher @publisherid int
as
if exists (select 1 from books where publisherid=@publisherid)
begin

	raiserror ('Sorry...!!Cannot delete publisher', 11, 1)
	return
end
else
begin
	delete publishers where publisherid= @publisherid
end
go

--_________________________________Insert Book____________________________________

create proc spInsertBook @title nvarchar(40), @price money, @available bit, @publishdate date, @publisherid int, @tags nvarchar(max), @authors nvarchar(max)
as
	merge tags t using (select ririm(value) as v from string_split(@tags, ',')) as s
		on t.tag = s.v
	when not matched by target
		then insert (tag) values(s.v);

	insert into books (title, coverprice, publishdate,available,publisherid )
	values ( @title, @price,@publishdate, iif(@publishdate > cast(@publishdate as date), 0, @available), @publisherid)

	declare @id int

	set @id = scope_identity()
--___________________________________bookauthors__________________________________

	insert into bookauthors (bookid, authorid)
	select @id, rtrim(value)
	from string_split(@authors, ',') 

--_____________________________________booktags___________________________________

	insert into booktags (bookid, tagid)
	select @id, t.tagid
	from
	(select rtrim(value) as value
	from string_split(@tags, ',')) as s
	inner join tags t on t.tag = s.value

	return;
go

--___________________________________Views________________________________________

--__________1)

create view vBookWithDeatils 
as

select b.bookid, b.title, b.publishdate, b.coverprice, b.available, a.authorname, p.publishername
from books b
inner join publishers p on b.publisherid=p.publisherid
inner join bookauthors ba on b.bookid = ba.bookid
inner join booktags bt on b.bookid = bt.bookid
inner join authors a on ba.authorid = a.authorid
inner join tags t on bt.tagid = t.tagid
go

--____________2)

create view vAuthoBookCount
as
select a.authorname,count(ba.bookid) 'Books written'
from books b
inner join bookauthors ba on b.bookid = ba.bookid
inner join authors a on ba.authorid = a.authorid
group by a.authorname
go

--________________________a scalar UDF(User defined Function______________________

 create function fnBooksPublished (@year int) returns int
 as
 begin
 declare @c int
 select @c = count(*) from books
 where year(publishdate)= @year
 return @c
 end
 go

 --___________________________________TRIGGER_____________________________________
 --__________________a table values UDF(User defined Function)____________________

 create function fnBooksUnderTag(@tag nvarchar(30)) returns table
 as
return (select b.bookid, b.title, b.publishdate, b.coverprice, b.available, a.authorname, p.publishername
from books b
inner join publishers p on b.publisherid=p.publisherid
inner join bookauthors ba on b.bookid = ba.bookid
inner join booktags bt on b.bookid = bt.bookid
inner join authors a on ba.authorid = a.authorid
inner join tags t on bt.tagid = t.tagid
where t.tag = @tag
)
go

--______An AFTER trigger to Prevents insert book publishdate before today_________

create trigger trInsertBook
on books
for insert
as 
begin
	declare @pd date
	select @pd = publishdate from inserted
	 
	if cast(@pd as date) < cast(dateadd(year, -2, getdate()) as date) 
	begin
		raiserror('Invalid date', 11, 1)
		rollback Transaction
	end
end
go

--______________Trigger to Prevent Author for publihing book today________________

create trigger trAuthorDelete
on authors
after delete
as
begin
	 declare @id int
	 select @id = authorid from deleted
	 if exists (select 1 from bookauthors where authorid = @id)
	 begin
		rollback transaction
		raiserror ('Delete it Now..!!! Because Author has dependendent book. ', 16, 1)
		return
	 end
end
go

--________________________Trigger to Prevent Publisher date ______________________

create trigger trPublisherDelete
on publishers
after delete
as
begin
	 declare @id int
	 select @id = publisherid from deleted
	 if exists (select 1 from books where publisherid = @id)
	 begin
		rollback transaction
		raiserror ('Delete it Now..!!! Because Publisher has dependendent book.', 16, 1)
		return
	 end
end
go
--_______________________________Trigger To delete tag____________________________

create trigger trTagDelete
on tags
after delete
as
begin
	 declare @id int
	 select @id = tagid from tags
	 delete from booktags where tagid=@id
end
go


