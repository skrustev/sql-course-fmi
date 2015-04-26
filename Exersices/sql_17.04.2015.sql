use ships;

-- (ot minaliqt put)
-- 2.5
select class, count(sunk.ship)
from (select * from outcomes where result = 'sunk') sunk
right join ships s on ship = name
where (select count(*) from ships where ships.class = s.class) > 4
group by class;

-- ����� �����
select class, (select count(*)
				from outcomes
				join ships on ship = name
				where ships.class = s.class and result = 'sunk') as sunkCount
from ships s
group by class
having count(*) > 4;


-- 2.6
-- �������� ������, ����� ������� �������� ����� �� ��������, �� ����� ������
select country, avg(displacement)
from ships join classes on ships.class = classes.class
group by country;


-- ��� ������ �� ���������


use movies;

-- ���.1
-- �� ����� ������/������� �������� ���� �� ���������� ������,
-- � ����� �� ��������� �����
select starname, count(distinct studioname) as studios
from starsin
join movie on movietitle = title and movieyear = year
group by starname;

-- ������������: �� ������� � ���� ������� ������, �� �����
-- �� ����� � ���  ����� �� ���������
select name, count(distinct studioname) as studios
from starsin
join movie on movietitle = title and movieyear = year
right join moviestar on starname = name
group by name;


-- ���. 2
-- �������� ������ �� ���������, ��������� � ���� 3 �����
-- ���� 1990
select starname
from starsin
where movieyear > 1990
group by starname
having count(*) >= 3;


use pc;
-- ���. 3
-- �� �� ������� ���������� ������ ��������, ��������� �� ����
-- �� ���-������ ��������� �������� �� ����� �����
select product.model
from product
join pc on product.model = pc.model
group by product.model
order by max(price);


use ships;

-- ���. 4
-- �� �� ����� ����� �� ���������� ����������� ������ �� �����
-- ��������� ����� � ���� ���� ������� ����������� �����;
select battle, count(*)
from classes c
join ships s on s.class = c.class
join outcomes o on s.name = o.ship
where c.country = 'USA' and result = 'sunk'
group by battle;


-- ���. 5
-- �������, � ����� �� ��������� ���� 3 ������ �� ���� � ���� �������
select distinct battle -- ��� ����. Guadacanal �� ��������� 3 ����������� �
						-- 3 ������� ������, ���� ����� ���� �� ������� � ���������
						-- ��� ���� - ������ ���������� distinct
from outcomes
join ships on ship = name
join classes on ships.class = classes.class
group by battle, country
having count(*) >= 3;



-- ������ ����� �� ����������� ���� ��������
-- ������� ��������

-- ��� 6
-- �� ����� ����� �� �� ������ ����� �� �������, � ����� � ��� �������
-- (result = 'damaged'). ��� ������� �� � �������� � ����� ��� ��� ������
-- �� � ��� ��������, � ��������� �� �� ������ 0
select name, count(battle) as times
from ships
left join outcomes on name = ship and result = 'damaged'
-- ������: where result = 'damaged' or result is null
group by name;


-- 2-�� �������:
select name, (select count(*)
				from outcomes
				where result = 'damaged'
					and ship = name) as damaged
from ships;


use movies;

-- ���. 7
-- �� ����� ������� ������ �� �� ������ �����, ��������� ���� 
-- � � ��� ������ �� �������� ���-����� �����
select name, birthdate, (select top 1 studioname
						from starsin
						join movie on movieTitle =  title and movieyear = year
						where starname = moviestar.name
						group by studioname
						order by count(*) desc) studio
from moviestar;


use pc;
-- ���. 8
-- �������� �� ������ ������������� �� ���� 2 �������
-- �������� ���� �� ������������� �� ��� PC-��
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
-- �� �� ������� ������ ������������
-- �� ����� �������� ���� �� ������������� ��������
-- � ��-����� �� �������� ���� �� ������� �������;
select maker
from product p
join pc on p.model = pc.model
group by maker
having avg(price) < (select avg(price)
					from product 
					join laptop on product.model = laptop.model
					where product.maker = p.maker);

-- 2-�� �������(�� ������� ���������)
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

-- 3-�� ������� (�� � ��-����� �� 2����)
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


-- ���. 10
-- ���� ����� �������� ���� �� �� �������� � ������� �������������
-- � ���������� �������� ����. �� �� ������� ���� ������ ��������,
-- ����� ������ ���� (�� ���������� �� �������������) � ��-�����
-- �� ���-������� ������, ����������� �� ����� ������������

-- 1�������
select p.model
from product p
join pc on p.model = pc.model
group by p.model, p.maker -- ��������� � �� maker, ������ �� �������� �� �����������
			-- ��������� � having! � ��������� �� �� ������ ������ �����!
having avg(price) < (select min(price)
					from product
					join laptop on product.model = laptop.model
					where product.maker = p.maker);


-- �������� �������
select p.model
from product p
join pc on p.model = pc.model
group by p.model
having avg(price) < (select min(price)
					from product
					join laptop on product.model = laptop.model
					where product.maker = min(p.maker)); -- min �� �� ����� � 
							-- where ��������, ���� �� �� � ��������� �� ���������;
							-- ����� �� � having � ���������� �� ������ �� �����.����.
							
-- ���� ������ �� ���������

--

-- http://dox.bg/files/dw?a=dd7d04995a