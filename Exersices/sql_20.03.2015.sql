use movies

--заглавията на всички фирми, чиято дължина е по-голяма от тази на Star Wars
--с подзаявка на скаларна стойност

select title 
from movie
where length > (select length 
				from movie
				where title = 'Star Wars');


--условия при подзаявки

--1 начин без 'in'
select *
from movie 
where year = 1980 or year = 1985 or year = 1990;

--2 начин с 'in'
select *
from movie 
where year in (1980, 1985, 1990);


-----------------------------------------------
--Задачи упр. 3

--Ex. 1.1
select name
from MovieStar
where gender = 'F' and
		name in (select name	
				from MovieExec
				where networth > 10 000 000);

-- Ex. 1.2
select name
from MovieStar
where name not in (select name
					from MovieExec);




use pc

--Ex. 2.2
select *
from printer
where price >= all(select price
					from printer);

--ако искаме точно едит от най-скъпите
select top 1 *
from printer
where price >= all(select price
					from printer);


--Ex. 2.3
select *
from Laptop
where speed < all(select speed
					from PC);

-- Ex. 2.4
select model
from (select model, price
		from pc
		union all
		select model, price
		from laptop
		union all
		select model, price
		from printer) prices
where price >= all(select price
					from pc
					union
					select price
					from laptop
					union
					select price
					from printer);

--Ex. 2.5
select distinct maker
from product
where model in (select model
				from printer
				where color = 'y' and
					price <= all(select price
								from printer
								where color = 'y'));

--Ex. 2.6
-- Начин 1 - не много ефективен
select distinct maker
from product
where model in (select model
				from PC
				where ram <= all(select ram from PC)
					and speed >= all(select speed
									from pc
									where ram <= all(select ram from pc)));

-- Начин 2 - с корелативна подзаявка
select distinct maker
from product
where model in (select model
				from PC p
				where ram <= all(select ram from pc)
					and speed >= all(select speed
									from pc
									where ram =p.ram));



use ships;

-- Ex. 3.2
select distinct class
from ships
where name in (select ship
				from outcomes
				where result = 'sunk');						

-- Ex. 3.5
select name
from ships s
join classes c on s.class = c.class
where numguns >= all(select numguns
					from classes
					where bore = c.bore);

--Зад: Имената на всички актьори, които са играли във филм след
--навършване на 40г, възраст
use movies

--1 начин - с join
select distinct name
from MovieStar
join StarsIn on name = starname
where movieyear >= year(birthdate) + 40;

--2 начин - с подзаявка
select name
from MovieStar
where exists(select 1
			from starsin
			where starname = name
				and movieyear >= year(birthdate)+40);







