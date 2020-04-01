-- Army Database DDL Script
-- Group Members
-- Anisha Arora
-- Kartikeya Shorya
-- Kinshuk Chaturvedi

CREATE DATABASE Armydb;
SET SEARCH_PATH TO Armydb;
USE Armydb;

SET FOREIGN_KEY_CHECKS=0;

-- Medals distributed to soldiers
CREATE TABLE Medal (
name_ VARCHAR(70) PRIMARY KEY
);

-- cateogry of Weapons
-- class describe the type of the weapons
CREATE TABLE Cateogry (
name_  VARCHAR(70) PRIMARY KEY,
class_ VARCHAR(70)
);

-- Weapons Details of the army
CREATE TABLE Weapons (
serialNo              INTEGER PRIMARY KEY,
name_                  VARCHAR(70) REFERENCES Cateogry(name_)
);

-- Each squad details
-- name_ represents the name of the squad
CREATE TABLE Squads (
squadNumber        VARCHAR(100),
Captain       INTEGER    NOT NULL,
yearNo 	      INTEGER 	 NOT NULL,
totalCapacity INTEGER    NOT NULL CHECK (totalCapacity > 0),
PRIMARY KEY(squadNumber, yearNo)
);

-- General location entity
CREATE TABLE Location (
PINCODE  VARCHAR(6) PRIMARY KEY CHECK (length(PINCODE) = 6),
District VARCHAR(100) NOT NULL,
State    VARCHAR(100) NOT NULL,
Country  VARCHAR(100) NOT NULL,
UNIQUE (PINCODE)
);

CREATE TABLE Company (
orgName VARCHAR(100) PRIMARY KEY,
CountryName VARCHAR(20) NOT NULL
);

-- Manufacturing details of the weapon
CREATE TABLE ManufacturingDetails (
Serial_no   INTEGER REFERENCES Weapons (serialNo)
ON UPDATE CASCADE ON DELETE CASCADE,
ManufaturingDate      DATE       NOT NULL,
ManufacturingLocation VARCHAR(100),
orgName VARCHAR(100) NOT NULL REFERENCES Company(orgName),
PRIMARY KEY(Serial_no, orgName)
);

-- Soldier Entity (Prime)
-- DOJ (Date of joining)
-- DOR (Date of retirement)
-- DOB (Date of Birth)
-- RANK is the rank at the time of posting
CREATE TABLE Soldier (
ID                 INTEGER NOT NULL,
name_               VARCHAR(100) NOT NULL,
RANK               VARCHAR(100) NOT NULL,
DOJ                DATE NOT NULL,
DOB		   DATE NOT NULL,
DOR		   DATE NOT NULL,
SquadNo            VARCHAR(100) NOT NULL,
yearNo            INTEGER NOT NULL,
BirthPlacePinCode  VARCHAR(6) NOT NULL REFERENCES Location(PINCODE)
ON UPDATE CASCADE ON DELETE CASCADE,
Sex         INTEGER NOT NULL CHECK (SEX = 1 OR SEX = 0),
Height INTEGER CHECK (Height > 152),
Weight INTEGER CHECK (Weight > 40),
Chest  INTEGER CHECK (Chest > 50),
UNIQUE (ID),
FOREIGN KEY (SquadNo, yearNo) REFERENCES Squads(SquadNumber, yearNo),
PRIMARY KEY (ID, SquadNo,yearNo, BirthPlacePinCode)
);

-- Places Visited by Soldier
CREATE TABLE Visited (
sold_id      INTEGER NOT NULL,
PINCODE VARCHAR(6) NOT NULL,
date_ DATE NOT NULL,
Reason  VARCHAR(100) NOT NULL,
PRIMARY KEY (sold_id, PINCODE, date_),
FOREIGN KEY (sold_id) REFERENCES Soldier(ID)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- War Catalog
-- Details of each war that has taken place
-- 0 from win
-- 1 for lost
-- 2 for undecisive
CREATE TABLE War (
pincode VARCHAR(6) NOT NULL REFERENCES Location (pincode)
ON UPDATE CASCADE ON DELETE CASCADE,
Status  INTEGER NOT NULL CHECK (Status = 0 OR Status = 1 OR Status = 2),
DateNo    INTEGER    NOT NULL,
UNIQUE(DateNo),
PRIMARY KEY (pincode, DateNo)
);

-- Work Type
CREATE TABLE WORK (
Type_   VARCHAR(100) PRIMARY KEY,
Salary INTEGER NOT NULL
);

-- Work assigned to soldier
CREATE TABLE Assign (
ID   INTEGER NOT NULL REFERENCES Soldier (ID)
ON UPDATE CASCADE ON DELETE CASCADE,
Type_ VARCHAR(100) NOT NULL REFERENCES Work(Type_)
ON UPDATE CASCADE ON DELETE CASCADE,
Date_ DATE,
PRIMARY KEY (ID, Type_)
);

-- Soldier status on a particular date
CREATE TABLE SoldierStatus (
ID          INTEGER NOT NULL REFERENCES Soldier(ID)
ON UPDATE CASCADE ON DELETE CASCADE,
ALIVE       INTEGER NOT NULL,
WarDateNo INTEGER NOT NULL,
Pincode VARCHAR(6) NOT NULL,
FOREIGN KEY (WarDateNo, Pincode) REFERENCES War(DateNo, pincode)
ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (ID, WarDateNo, Pincode),
UNIQUE(ID, WarDateNo, Pincode)
);


-- Place where posting of the soldier has happened
CREATE TABLE Posting (
ID INTEGER NOT NULL  REFERENCES SOLDIER(Id),
pincode VARCHAR(6) NOT NULL REFERENCES Location(PINCODE),
date_ DATE NOT NULL,
PRIMARY KEY (ID, pincode, date_)
);

-- Reward gained by the soldier
CREATE TABLE REWARD (
ID        INTEGER NOT NULL REFERENCES Soldier (ID)
ON UPDATE CASCADE ON DELETE CASCADE,
MedalName VARCHAR(100) NOT NULL REFERENCES Medal (name_)
ON UPDATE CASCADE ON DELETE CASCADE,
Year      INTEGER NOT NULL,
PRIMARY KEY (ID, MedalName)
);

-- Inventory of each soldier
CREATE TABLE Inventory (
Serial_No    INTEGER NOT NULL REFERENCES Weapons (serialNo)
ON UPDATE CASCADE ON DELETE CASCADE,
ID           INTEGER NOT NULL REFERENCES Soldier (ID)
ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY (Serial_No, ID)
);

SET FOREIGN_KEY_CHECKS=1;