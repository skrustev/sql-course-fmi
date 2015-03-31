--Exercise 3

use movies


--Examples:
/*
select name, coalesce(movieexec.prcert#, movie.prcert#), title, year
from MovieExec
full join movie on movieexec.presc# = movie.presc#
*/

--Tasks:

--1.4
select distinct starname
from starsin
join moviestar on starname = name
join movie on title = movietitle and year = movieyear
where gender = 'F' and studioname = 'MGM';

--1.6
select name
from moviestar
left join starsin on name = starname
where starname is null


--Пример за left join.
--За всички кораби, пуснати на вода преди 1930;
--да се изведат имената им и имената на всички битки
-- в които са участвали (в резултата да има 2 колони - име на кораб и име на битка)
-- Ако някой кораб не е участвал в битка, срещу неговото име да пише NULL
use ships

select name, battle
from ships
left join outcomes on name = ship
where launched < 1930


--Важно: при outer join има разлика дали дадено условие
--ще бъде в ON Или Where (при inner няма, понеже се свежда до подмножество
-- на декартово произведение):
-- за всеки клас да изведем всички негови кораби от 1921 г.:
select c.class, name
from classes c
join ships s on c.class = s.class
where launched = 1921;

--нека 1) искаме и класовете, които нямат кораби, или 2) имат корави, но нито един от 1921
--ГРЕШНО:
select c.class, name
from classes c
left join ships s on c.class = s.class
where launched = 1921;

--проблема е, че ще сравнява NULL с 1921, където няма кораби и това ги елиминира и пак ще е като първия начин
--Решение покриващо само 1)
select c.class, name
from classes c
left join ships s on c.class = s.class
where launched = 1921
	or launched is null

--I-во Решение покриващо 1) и 2)
select c.class, name
from classes c
left join ships s on c.class = s.class and launched = 1921;

--II-ро Решение покриващо 1) и 2)
select c.class, name
from classes c
left join (select name, class
			from ships
			where launched = 1921) ships1921
on c.class = ships1921.class


--!!! Ако съединяваме поне 3 траблици и поне одно от съединенията е външно,
-- има значение в какъв ред правим нещата!
-- За всеки клас британски кораби да се изведат имената им (на класовете)
-- и имената на всички битки, в които са участвали кораби от този клас
-- Ако даден клас няма кораби или има, но те не са участвали в битка, също
-- да се изведат.
select distinct classes.class, battle
from outcomes
join ships on ship = name
right join classes on ships.class = classes.class
where country = 'Gt.Britain';

--Грешно
--ако беше left join + inner join, щеше да е грешно!!!
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
join outcomes on ship = name
where country = 'Gt.Britain';

--Грешно
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
left join outcomes on ship = name
where country = 'Gt.Britain';


-- Общи задачи


--зад1
-- Да се изведат заглавията и годините на всички филми, чието заглавие 
-- съдържа едновременно като поднизове "the" и "w" (не напременно в този ред)
-- Резултатът да бъде сортиран по година (първо най-новите), а филми от
-- една и съща година да бъдат подредени по азбучен ред
use movies;

select title, year
from movie
where title like '%the%' and title like '%w%'
order by year desc, title


--зад2
-- Държавите, които имат класове с различен калибър
-- (напр. САЩ имат слас с bore=14 и  класове с bore=16,
-- докато Великобритания има само класове с 15)
use ships;

select distinct c1.country
from classes c1
join classes c2 on c1.country = c2.country
where c1.bore <> c2.bore;
-- оптимизация: c1.bore < c2.bore - ще улесни работата на distinct по-горе



--зад3
-- Компютри, които са по-евтини от всеки лаптоп
-- и принтер на същия производител
use pc;

select pc.*
from pc
join product p on pc.model = p.model
where price < all (select price
					from laptop
					join product p1 on laptop.model = p1.model
					where p1.maker = p.maker)
	and price < all (select price
					from printer
					join product p1 on printer.model = p1.model
					where p1.maker = p.maker)

-- ако подзаявката върне празен списък, условието 
-- price < all (..) ще бъде true


--зад4 - интересни неща, не цяла задача
-- Имената на всички кораби, за които едновременно са изпълнени:
-- (1) участвали са в поне една битка
-- (2) имената им (на корабите) започват с C или К.
use ships;

select distinct ship
from outcomes
where ship like 'C%' or ship like 'K%'


-- Името, държавата и калибъра (bore) на всички класове кораби с 6, 8 или 10
-- оръдия. Калибърът да се изведе в сантиметри (1 инч е приблизително 2.54 см).
select class, country, bore * 2.54 as bore_cm
from classes
where numguns in (6,8, 10);


-- (От държавен изпит задача)
-- Имената на класовере, които няма кораб, пуснат на вода (launched) след
-- 1921 г. Ако за класа няма пуснат никакъв корабм той също трябва да излезе
-- в резултата
-- (на държавния ще е да казваме кое е вярно, тук даваме примери само)

-- грешно:
select distinct class
from ships
where launched <= 1921;

--вярно:
select class
from classes
where class not in (select class 
					from ships 
					where launched > 1921)

--вярно:
select c.class
from classes c
where not exists (select 1
					from ships t
					where t.class = c.class
						and t.launched > 1921);

--вярно:
select classes.class
from classes
left join ships on classes.class = ships.class and launched > 1921
where name is null;