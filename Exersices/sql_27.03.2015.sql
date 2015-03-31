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


--������ �� left join.
--�� ������ ������, ������� �� ���� ����� 1930;
--�� �� ������� ������� �� � ������� �� ������ �����
-- � ����� �� ��������� (� ��������� �� ��� 2 ������ - ��� �� ����� � ��� �� �����)
-- ��� ����� ����� �� � �������� � �����, ����� �������� ��� �� ���� NULL
use ships

select name, battle
from ships
left join outcomes on name = ship
where launched < 1930


--�����: ��� outer join ��� ������� ���� ������ �������
--�� ���� � ON ��� Where (��� inner ����, ������ �� ������ �� ������������
-- �� ��������� ������������):
-- �� ����� ���� �� ������� ������ ������ ������ �� 1921 �.:
select c.class, name
from classes c
join ships s on c.class = s.class
where launched = 1921;

--���� 1) ������ � ���������, ����� ����� ������, ��� 2) ���� ������, �� ���� ���� �� 1921
--������:
select c.class, name
from classes c
left join ships s on c.class = s.class
where launched = 1921;

--�������� �, �� �� �������� NULL � 1921, ������ ���� ������ � ���� �� ��������� � ��� �� � ���� ������ �����
--������� ��������� ���� 1)
select c.class, name
from classes c
left join ships s on c.class = s.class
where launched = 1921
	or launched is null

--I-�� ������� ��������� 1) � 2)
select c.class, name
from classes c
left join ships s on c.class = s.class and launched = 1921;

--II-�� ������� ��������� 1) � 2)
select c.class, name
from classes c
left join (select name, class
			from ships
			where launched = 1921) ships1921
on c.class = ships1921.class


--!!! ��� ����������� ���� 3 �������� � ���� ���� �� ������������ � ������,
-- ��� �������� � ����� ��� ������ ������!
-- �� ����� ���� ��������� ������ �� �� ������� ������� �� (�� ���������)
-- � ������� �� ������ �����, � ����� �� ��������� ������ �� ���� ����
-- ��� ����� ���� ���� ������ ��� ���, �� �� �� �� ��������� � �����, ����
-- �� �� �������.
select distinct classes.class, battle
from outcomes
join ships on ship = name
right join classes on ships.class = classes.class
where country = 'Gt.Britain';

--������
--��� ���� left join + inner join, ���� �� � ������!!!
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
join outcomes on ship = name
where country = 'Gt.Britain';

--������
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
left join outcomes on ship = name
where country = 'Gt.Britain';


-- ���� ������


--���1
-- �� �� ������� ���������� � �������� �� ������ �����, ����� �������� 
-- ������� ������������ ���� ��������� "the" � "w" (�� ���������� � ���� ���)
-- ���������� �� ���� �������� �� ������ (����� ���-������), � ����� ��
-- ���� � ���� ������ �� ����� ��������� �� ������� ���
use movies;

select title, year
from movie
where title like '%the%' and title like '%w%'
order by year desc, title


--���2
-- ���������, ����� ���� ������� � �������� �������
-- (����. ��� ���� ���� � bore=14 �  ������� � bore=16,
-- ������ �������������� ��� ���� ������� � 15)
use ships;

select distinct c1.country
from classes c1
join classes c2 on c1.country = c2.country
where c1.bore <> c2.bore;
-- �����������: c1.bore < c2.bore - �� ������ �������� �� distinct ��-����



--���3
-- ��������, ����� �� ��-������ �� ����� ������
-- � ������� �� ����� ������������
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

-- ��� ����������� ����� ������ ������, ��������� 
-- price < all (..) �� ���� true


--���4 - ��������� ����, �� ���� ������
-- ������� �� ������ ������, �� ����� ������������ �� ���������:
-- (1) ��������� �� � ���� ���� �����
-- (2) ������� �� (�� ��������) �������� � C ��� �.
use ships;

select distinct ship
from outcomes
where ship like 'C%' or ship like 'K%'


-- �����, ��������� � �������� (bore) �� ������ ������� ������ � 6, 8 ��� 10
-- ������. ��������� �� �� ������ � ���������� (1 ��� � ������������� 2.54 ��).
select class, country, bore * 2.54 as bore_cm
from classes
where numguns in (6,8, 10);


-- (�� �������� ����� ������)
-- ������� �� ���������, ����� ���� �����, ������ �� ���� (launched) ����
-- 1921 �. ��� �� ����� ���� ������ ������� ������ ��� ���� ������ �� ������
-- � ���������
-- (�� ��������� �� � �� ������� ��� � �����, ��� ������ ������� ����)

-- ������:
select distinct class
from ships
where launched <= 1921;

--�����:
select class
from classes
where class not in (select class 
					from ships 
					where launched > 1921)

--�����:
select c.class
from classes c
where not exists (select 1
					from ships t
					where t.class = c.class
						and t.launched > 1921);

--�����:
select classes.class
from classes
left join ships on classes.class = ships.class and launched > 1921
where name is null;