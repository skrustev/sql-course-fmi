use Movies

select *
from Movie, Studio

select *
from Movie, Studio
where studioname = name


select title, year, studioname, address
from Movie, Studio
where studioname = name and year > 1980

select title, year, studioname, address
from Movie
join Studio on studioname = name 
where year > 1980

--task 1.1
select starname
from starsin
join MovieStar on starName = name
where gender = 'M' and movietitle = 'Terms of Endearment'

--1.2
select distinct starName
from StarsIn
join Movie on movieTitle = title and movieYear = year
where studioName = 'MGM'

---------------------------------
--1.3
select *
from Movie

select *
from Movieexec

--1 solution
select distinct name
from Movieexec
join Movie on PRODUCERC# = Cert#
where studioname = 'MGM'

---------------------------------
--1.4
select m1.title
from Movie as m1, Movie as m2
where m2.title = 'Star Wars' and m1.length > m2.length


--task 2
use pc

---------------------------------
--2.2
select p.model, price
from product p join pc on p.model = pc.model
where maker = 'B'
union all
select p.model, price
from product p join laptop on p.model = laptop.model
where maker = 'B'
union all
select p.model, price
from product p join printer on p.model = printer.model
where maker = 'B';

---------------------------------
--2.3
select distinct p1.hd
from PC p1
join PC p2 on p1.hd = p2.hd
where p1.code <> p2.code;

---------------------------------
--2.4
select distinct p1.model, p2.model
from PC p1
join PC p2 on p1.speed = p2.speed
			and p1.ram = p2.ram
where p1.model < p2.model;


--task 3
use ships;

---------------------------------
--3.2
select s.name, c.displacement, c.numguns
from ships s
join classes c on s.class = c.class
join outcomes on s.name = ship
where battle = 'Guadalcanal';

---------------------------------
--3.3
-- 1 nachin - vqrno
select country
from Classes
where type = 'bb'
intersect 
select country
from Classes
where type = 'bc';

--2 nachin - vqrno
select distinct c1.country
from classes c1
join classes c2 on c1.country = c2.country
where c1.type = 'bb' and c2.type = 'bc'

--3 nachin - greshno!!
select distinct country
from classes
where type = 'bb' or type = 'bc'

--4 nachin - greshno!!
select distinct country
from classes
where type = 'bb' and type = 'bc'

-------------------------------------
--3.4
select o1.ship
from outcomes o1
join battles b1 on o1.battle = b1.name
join outcomes o2 on o1.ship = o2.ship
join battles b2 on o2.battle = b2.name
where o1.result = 'damaged' and b1.date  < b2.date