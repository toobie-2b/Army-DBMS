-- Queries Need to be performed on the database

-- Q1|Count the medals gained by the soldier during its course by soldier id

select count(ID)
from REWARD
where ID = 11053;

-- Q2|Find the squad in which the soldier is trained

select DISTINCT s.* from Soldier as sold
Inner join Squads as s on s.squadNumber = sold.SquadNo;

-- Q3|No of soldier trained in the squad in which the soldier is trained

select DISTINCT squadNumber from (
select s.* from Soldier as sold
Inner join Squads as s on s.squadNumber = sold.SquadNo
) AS r1;

-- Q4|How many soldier belong to same city in its squad (Can use the Same year)

select count(Soldier.ID)
from Soldier
inner join Soldier as sold2 on Soldier.BirthPlacePincode = sold2.BirthPlacePincode
where Soldier.SquadNo in (
select SquadNo from Soldier
where Soldier.ID = 49158
);

-- Q5|Check wheter a given war in a particular year is win or not
-- 0 stands for win
-- 1 stands for loose
-- 2 stands for undecisive

select * from War
where War.Status = 0;

-- Q6|Name of soldiers died in a particular war

select name_
from Soldier
inner join SoldierStatus as stat on stat.ID = Soldier.ID
where stat.WarDateNo = '2005' and stat.Pincode = '126239' and ALIVE = 0;

-- Q7|Count of the soldiers that died in that war

select count(SoldierStatus.id)
from Soldier
inner join SoldierStatus as stat on stat.ID = Soldier.ID
where stat.WarDateNo = '2005' and stat.Pincode = '126239' and ALIVE = 0;

-- Q7|Give the physical stats of a soldier

select Height, Weight, Chest
from Soldier
where Soldier.ID = '12105';

-- Q8|Check on which places the soldier is transfered

select District, PINCODE
from Posting as pos
natural join Location as loc
where pos.ID = '28613';

-- Q9|Find  the war loaction where soldier is posted

select *
from Posting as post
inner join (
select loc.PINCODE, loc.District, loc.State, loc.Country
from War
inner join Location as loc on loc.PINCODE = war.PINCODE)
as r on r.PINCODE = post.pincode;

-- Q10| Find the soldier who are posted in war after 2003
select distinct(sold.name_)
from Posting as pos
inner join War on War.pincode = pos.pincode
inner join Soldier as sold on sold.ID = pos.ID
where DateNo > 2003;

-- Q11|Find the details of the given weapon

select distinct wep.name_, mad.*, comp.countryname
from Weapons as wep
inner join ManufacturingDetails as mad on mad.Serial_no = wep.serialNo
inner join Company as comp on mad.orgName = comp.orgName
where wep.name_ = 'Ikbiza';

-- Q12|Find the Salary of the Soldier

select *
from Assign as asgn
inner join WORK as wrk on wrk.Type_ = asgn.Type_
where asgn.Type_ = 'Soldier';

-- Q13|Places where the soldier has been transfered.

select pst.ID, loc.District, loc.State
from Posting as pst
inner join Location as loc on loc.PINCODE = pst.pincode
where pst.ID = 33998;

-- Q14|No of transferes in every year (Ascending order)

select count(ID), extract(year from date_) as yr
from Posting
group by yr
order by yr ASC;

-- Q15|Details of Soldiers had done more than 35 years of service

select *
from Soldier as sold
where extract(year from DOJ) - extract(year from DOJ) > 35;

-- Q16|Current Income of the Soldier

SELECT Salary
FROM Work AS w
  JOIN Soldier
    AS s
    ON (s.RANK = w.Type_)
WHERE s.ID = 44668;

-- Q17|Print captain of the general from their respective squads

select sold.ID, sold.name_, sqd.squadNumber, sqd.Captain
from Soldier as sold
inner join Squads as sqd on sqd.squadNumber = sold.SquadNo
inner join Assign as asgn on asgn.ID = sold.ID
where asgn.Type_ = 'Major General';

-- Q18|Print the total capacity and captain of the squad from which the soldier belongs.

select sqd.Captain, sqd.totalCapacity
from Soldier as sold
inner join Squads as sqd on sqd.squadNumber = sold.SquadNo
where sold.ID = 19339;

-- Q19| Check the inventory of a given soldier and give the manufacturing dates of the weapons.
SET SEARCH_PATH to Armydb;
SELECT ManufaturingDate, ManufacturingLocation, orgName FROM ManufacturingDetails AS manu JOIN (
SELECT serialNo, name_ FROM Weapons AS w join
(SELECT Serial_No FROM Inventory AS i JOIN Soldier AS s ON (i.ID = s.ID) WHERE s.name_= 'Sandeep Singh') As s
  ON (w.serialno = s.serial_no)) AS t ON (manu.serial_no = t.serialno);

-- Q20| Find the number of soldiers which are soldiers as well as brigadiers.
SET SEARCH_PATH to Armydb;
(SELECT count(ID) FROM Soldier AS s WHERE s.RANK = 'Soldier')
UNION
(SELECT count(ID) FROM soldier AS s WHERE s.RANK = 'Brigadier');

-- -- Q21| Find the number of male soldiers.
-- SET SEARCH_PATH to Armydb;
-- SELECT name_ FROM soldier as s WHERE s.sex = 1;

-- --Q22| Find the number of female soldiers
-- SET SEARCH_PATH to Armydb;
-- SELECT name_ FROM soldier as s WHERE s.sex = 0;

-- -- Q23| Find the number of soldiers who have participated in atleast one war.
-- SET SEARCH_PATH to Armydb;
-- SELECT s.id FROM soldier AS s JOIN soldierstatus AS ss ON (s.id = ss.id);

-- -- Q24| Find the number of soldiers who have participated in atleast one war and who are still alive
-- -- 1 is for alive
-- -- 0 is for dead
-- SET SEARCH_PATH to Armydb;
-- SELECT s.id FROM soldier AS s JOIN soldierstatus AS ss ON (s.id = ss.id) WHERE ss.alive = 1;

-- -- Q25| Print the soldier and havildar with their location and salaries

-- select sold.name_, sold.id, loc.district, loc.state, wrk.salary
-- from soldier as sold
-- inner join assign as asgn on asgn.id = sold.id
-- inner join work as wrk on wrk.type_ = asgn.type_
-- inner join location as loc on loc.pincode = sold.birthplacepincode
-- where asgn.type_ = 'Soldier' or asgn.type_ = 'Havildar';


-- -- Q26| Count no. of weapons shipped by each organisation

-- select count(name_), orgname
-- from weapons as wep
-- inner join manufacturingdetails as mad on mad.serial_no = wep.serialno
-- group by orgname
-- order by count(name_) ASC;

-- --Q27| Name the weapons were issued betweem two particular years
-- SET SEARCH_PATH to Armydb;
-- SELECT r1.name_, w.name_ FROM weapons AS w JOIN (
-- SELECT name_, i.id,serial_no
-- FROM soldier
--   AS s
--   JOIN inventory as i
--     ON (s.id = i.id) WHERE s.doj BETWEEN '2010-01-01' AND '2015-04-15') AS r1
--     ON (r1.serial_no = w.serialno);

-- -- Q28| How many soldiers were martyrs from each squad
-- SET SEARCH_PATH to Armydb;
-- SELECT count(s.name_),s.squadno
-- FROM soldier
--   as s
--   JOIN soldierstatus
--     as ss
--     ON (s.id = ss.id)
-- WHERE (ss.alive = 0)
-- GROUP BY s.squadno;

-- -- Q29| Find the average height, average chest and average weight of male soldiers from a particular year
-- SET SEARCH_PATH to Armydb;
-- SELECT s.yearno,avg(s.height),avg(s.chest),avg(s.weight)
-- FROM soldier
--   as s
-- WHERE s.sex = 1
--       AND s.yearno = 2015
-- GROUP BY S.yearno;

-- -- Q30| Update the salary of soldier

-- set search_path to Armydb;
-- update work set salary = salary + 1000
-- where type_ = 'Soldier';

-- -- Q31| Find the soldiers who visited a particular place and give date and reason of visiting

-- SET SEARCH_PATH to Armydb;
-- SELECT id,name_,date_,reason FROM soldier AS s JOIN visited AS v ON (s.id = v.sold_id) WHERE pincode = '613519';
