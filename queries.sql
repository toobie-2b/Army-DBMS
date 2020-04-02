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
inner join Location as loc on loc.PINCODE = War.pincode)
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
FROM WORK AS w
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
SELECT ManufaturingDate, ManufacturingLocation, orgName FROM ManufacturingDetails AS manu JOIN (
SELECT serialNo, name_ FROM Weapons AS w join
(SELECT Serial_No FROM Inventory AS i JOIN Soldier AS s ON (i.ID = s.ID) WHERE s.name_= 'Sandeep Singh') As s
  ON (w.serialno = s.serial_no)) AS t ON (manu.serial_no = t.serialno);

-- Q20| Find the number of soldiers which are soldiers as well as brigadiers.
(SELECT count(ID) FROM Soldier AS s WHERE s.RANK = 'Soldier')
UNION
(SELECT count(ID) FROM Soldier AS s WHERE s.RANK = 'Brigadier');