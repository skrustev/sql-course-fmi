-- week 5

use movies

select avg(netWorth)
from MovieExec


--Zad �� �������� ��� �� ���-������� ��������
--���� �������
use pc;

-- �����
select *
from printer
where price = (select max(price) from printer);

-- ������ ������ �� ���������� �� ��������� �������(3�� �������)
select *
from printer
where price = max(select price from printer);

-- ������(3�� �������)
select *
from printer
where price = max(price);


-----------------------------
use movies

SELECT studioName, SUM(length)
FROM Movie
GROUP BY studioName

-- ��������� �� �����:
-- ����� ������� ������ �� ������ ����� ������ (� ����� ��� ������ ������ ������):
select year(birthdate), count(*) as count
from moviestar
group by year(birthdate);

-- ��� � ������� �� having �� ������:
select studioName, sumLength
from (select studioName, sum(length) sumLength
		from Movie
		group by studioName) t

where sumLength > 200;

-- ������ having, select � order �� ���������� ���� group by,
-- �� ��� ����� ������ ������� ���� select


-- �� ���� avg(count( � ��. �������. �� �� �� �������!



--������
use pc;

-- 1.3
select avg(speed)
from laptop
where price > 1000;

-- 1.4
select avg(price) as avg
from laptop l
join product on l.model = product.model
where maker = 'A'

-- 1.5
select avg(price)
from (select price, model
		from pc
		union all
		select price, model
		from printer) prices
join product on prices.model = product.model
where maker = 'B'

-- 1.6
select speed, avg(price) as avarage
from pc
group by speed;
		
-- 1.7
select maker
from product
where type = 'PC'
group by maker
having count(model) >= 3;
-- ��� model �� ���� �������� - count(distinct model)
-- ��� ����� join-���� PC - ����

-- 1.9 
-- 1-�� ����� - ��-�������
select speed, avg(price) as avarage
from pc
where speed > 800
group by speed;

-- 2-�� �����
select speed, avg(price) as avarage
from pc
group by speed
having speed > 800;

-- 1.10
select avg(hd) as avarageHD
from pc
join product on pc.model = product.model
where maker in (select maker from product where type = 'Printer');

-- 1.11
select screen, max(price) - min(price) as diffMaxMin
from laptop
group by screen;

-------------------------------------------
use ships;

-- 2.2
select avg(numguns) as avgNumGuns
from ships
join classes on ships.class = classes.class;

-- 2.3
select class, min(launched) as firstYear, max(launched) as lastYear
from ships
group by class;

-- 2.4
-- �� �� ������� � ���������, ����� ����� ������, � ���� � ���������, ����� ����
-- ������, �� ���� ���� �� ��� �� � ������� - �� ��� �� ������ 0
select classes.class, count(sunk.ship) as numSunk
from (select * from outcomes where result = 'sunk') sunk -- ��� �� ���� where ��� ����� �� ������� ���� �������, �� ����� ���� ������ ����� ������
join ships on ship = name
right join classes on ships.class = classes.class
group by classes.class -- classes e, � �� ships ������ � ships ���� �� ���� ������ ����� �� ���������


