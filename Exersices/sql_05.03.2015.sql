--examples
use movies;

select * 
from movie;

select studioname as name, title
from movie;

select title, year, length / 60.0 as hours
from movie;

select *
from movie
where studioName = 'DiSNey' and year = 1990;

select *
from movie
where title like 'Star%';

select * from moviestar
where birthdate >= '1977-07-06';

--date functions: year, month, etc.
select *
from moviestar
where month(birthdate) = 7;

select * 
from movie
where length < 120;


select * 
from movie
where length >= 120;


select * 
from movie
where not (length < 120);


select * 
from movie
where length is NULL;

select *
from movie
order by length desc, studioname asc

--exercises
-- 1.1
select address
from studio
where name = 'MGM'

--1.2


--1.3
select starname
from starsin
where movieyear = 1980 and movietitle like '%Empire%'