use ships;

-- (ot minaliqt put)
-- 2.5
select class, count(sunk.ship)
from (select * from outcomes where result = 'sunk') sunk
right join ships s on ship = name
where (select count(*) from ships where ships.class = s.class) > 4
group by class;

-- втори начин
select class, (select count(*)
				from outcomes
				join ships on ship = name
				where ships.class = s.class and result = 'sunk') as sunkCount
from ships s
group by class
having count(*) > 4;


-- 2.6
-- Напишете заявка, която извежда средното тегло на корабите, за всяка страна
select country, avg(displacement)
from ships join classes on ships.class = classes.class
group by country;


-- Още задачи за групиране


use movies;

-- Зад.1
-- За всеки актьор/актриса изведете броя на различните студиа,
-- с които са записвали филми
select starname, count(distinct studioname) as studios
from starsin
join movie on movietitle = title and movieyear = year
group by starname;

-- допълнително: да включим и тези филмови звезди, за които
-- не знаем в кои  филми са участвали
select name, count(distinct studioname) as studios
from starsin
join movie on movietitle = title and movieyear = year
right join moviestar on starname = name
group by name;


-- Зад. 2
-- Изведете иманта на актьорите, участвали в поне 3 филма
-- след 1990
select starname
from starsin
where movieyear > 1990
group by starname
having count(*) >= 3;


use pc;
-- Зад. 3
-- Да се изведат различните модели компютри, подредени по цена
-- на най-скъпия конкретен компютър от даден модел
select product.model
from product
join pc on product.model = pc.model
group by product.model
order by max(price);


use ships;

-- Зад. 4
-- Да се извде броят на потъналите американски кораби за всяка
-- проведена битка с поне един потънал американски кораб;
select battle, count(*)
from classes c
join ships s on s.class = c.class
join outcomes o on s.name = o.ship
where c.country = 'USA' and result = 'sunk'
group by battle;


-- Зад. 5
-- Битките, в които са участвали поне 3 кораба на една и съща държава
select distinct battle -- ако напр. Guadacanal са участвали 3 американски и
						-- 3 японски кораба, тази битка щеше да попадне в резултата
						-- два пъти - затова използваме distinct
from outcomes
join ships on ship = name
join classes on ships.class = classes.class
group by battle, country
having count(*) >= 3;



-- Задачи важни за контролното като трудност
-- подобна трудност

-- Зад 6
-- За всеки кораб да се изведе броят на битките, в които е бил увреден
-- (result = 'damaged'). Ако корабът не е участвал в битки или път никога
-- не е бил увреждан, в резултата да се вписва 0
select name, count(battle) as times
from ships
left join outcomes on name = ship and result = 'damaged'
-- грешно: where result = 'damaged' or result is null
group by name;


-- 2-ро решение:
select name, (select count(*)
				from outcomes
				where result = 'damaged'
					and ship = name) as damaged
from ships;


use movies;

-- Зад. 7
-- За всяка филмова звезда да се изведе името, рождената дата 
-- и с кое студио са записали най-много филми
select name, birthdate, (select top 1 studioname
						from starsin
						join movie on movieTitle =  title and movieyear = year
						where starname = moviestar.name
						group by studioname
						order by count(*) desc) studio
from moviestar;


use pc;
-- Зад. 8
-- Намерете за всички производители на поне 2 лазерни
-- принтера броя на произведените от тях PC-та
select maker, count(pc.code)
from product p
left join pc on p.model = pc.model
where (select count(*) 
		from product
		join printer on product.model = printer.model
		where product.maker = p.maker
			and printer.type = 'Laser') >= 2
group by maker;


-- Zad. 9
-- Да се изведат всички прозводители
-- за които средната цена на произведените компютри
-- е по-ниска от средната цена на техните лаптопи;
select maker
from product p
join pc on p.model = pc.model
group by maker
having avg(price) < (select avg(price)
					from product 
					join laptop on product.model = laptop.model
					where product.maker = p.maker);

-- 2-ро решение(на толкова ефективно)
select distinct maker
from product p
where (select avg(price)
		from product 
		join pc on product.model = pc.model
		where product.maker = p.maker)
	< (select avg(price)
		from product 
		join laptop on product.model = laptop.model
		where product.maker = p.maker)

-- 3-то решение (не е по-добро от 2рото)
select distinct maker
from product p
group by maker
having (select avg(price)
		from product 
		join pc on product.model = pc.model
		where product.maker = p.maker)
	< (select avg(price)
		from product 
		join laptop on product.model = laptop.model
		where product.maker = p.maker)


-- Зад. 10
-- Един модел компютри може да се предлага в няколко разновидности
-- с евентуално различни цена. Да се изведат тези модели компютри,
-- чиято средна цена (на различните му разновидности) е по-ниска
-- от най-евтиния лаптоп, произвеждан от същия производител

-- 1решение
select p.model
from product p
join pc on p.model = pc.model
group by p.model, p.maker -- групираме и по maker, понеже го подаваме на корелативна
			-- подзаявка в having! и внимаваме да не станат повече групи!
having avg(price) < (select min(price)
					from product
					join laptop on product.model = laptop.model
					where product.maker = p.maker);


-- откачено решение
select p.model
from product p
join pc on p.model = pc.model
group by p.model
having avg(price) < (select min(price)
					from product
					join laptop on product.model = laptop.model
					where product.maker = min(p.maker)); -- min не се смята в 
							-- where клаузата, така че не е нарушение на правилата;
							-- смята се в having и резултатът се подава на корел.подз.
							
-- Общи задачи за групиране

--

-- http://dox.bg/files/dw?a=dd7d04995a