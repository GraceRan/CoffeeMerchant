-- CoffeeMerchant datawarehouse developed and written by Colin Burnett, Amy Karlzen, Grace Ransler
-- Originally Written: October 2017
---------------------------------------------------------------
-- Replace <data_path> with the full path to this file 
-- Ensure it ends with a backslash. 
-- E.g., C:\MyDatabases\ See line 17
---------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'CoffeeMerchantDW')
	CREATE DATABASE CoffeeMerchantDW
GO
USE CoffeeMerchantDW
GO
--
-- Alter the path so the script can find the CSV files
--

--
-- =======================================
-- Delete existing tables
--

--DROP fact table
IF EXISTS (
	SELECT * 
	FROM sys.tables
	WHERE name = N'FactSales'
		)
		DROP TABLE DimDate
-- drop date table
IF EXISTS (
	SELECT * 
	FROM sys.tables
	WHERE name = N'DimDate'
		)
		DROP TABLE DimDate
-- drop consumer table
IF EXISTS (
	SELECT * 
	FROM sys.tables
	WHERE name = N'DimConsumer'
		)
		DROP TABLE DimConsumer
-- drop inventory table
IF EXISTS (
	SELECT * 
	FROM sys.tables
	WHERE name = N'DimInventory'
		)
		DROP TABLE DimInventory
-- drop employee table
IF EXISTS (
	SELECT * 
	FROM sys.tables
	WHERE name = N'DimEmployee'
		)
		DROP TABLE DimEmployee


---------------------------------------
---------------------------------------
--Build the Tables---------------------

--Consumer
CREATE TABLE dbo.DimConsumer
	(Consumer_SK  INT IDENTITY (1,1) Not Null CONSTRAINT pk_consumer PRIMARY KEY ,
	Consumer_AK  INT NOT NULL,
	ConsumerState NVARCHAR(2),
	ConsumerCity NVARCHAR(50),
	ConsumerZipCode NVARCHAR(11),
	ConsumerCreditLimit INT
	);
--Employee

CREATE TABLE DimEmployee
	(Employee_SK  INT IDENTITY (1,1) NOT NULL CONSTRAINT pk_employee PRIMARY KEY,
	Employee_AK  INT NOT NULL,
	LastName NVARCHAR(30),
	CommissionRate NUMERIC(4,4),
	HireDate DATE,
	BirthDate DATE,
	Gender NVARCHAR(1)
	);
--Inventory

CREATE TABLE DimInventory
	(Inventory_SK  INT IDENTITY (1,1) NOT NULL CONSTRAINT pk_inventory PRIMARY KEY,
	Inventory_AK  INT NOT NULL,
	Name NVARCHAR(40),
	ItemType NVARCHAR(1),
	Country NVARCHAR(40)
	);
	-- Date
CREATE TABLE [dbo].[DimDate](
	[DateKey] INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_date PRIMARY KEY,
	[Date] DATETIME NOT NULL UNIQUE,
	[DateName] NVARCHAR(50) NULL,
	[Month] INT NOT NULL,
	[MonthName] NVARCHAR(50) NOT NULL,
	[Quarter] INT NOT NULL,
	[QuarterName] NVARCHAR(50) NOT NULL,
	[Year] INT NOT NULL,
	[YearName] NVARCHAR(50) NOT NULL,
);
GO

--FactSales

CREATE TABLE FactSales  (
	DateKey INT CONSTRAINT fk_datekey FOREIGN KEY REFERENCES DimDate (DateKey),
	Consumer_SK INT CONSTRAINT fk_consumer FOREIGN KEY REFERENCES DimConsumer (Consumer_SK),
	Inventory_SK INT CONSTRAINT fk_inventory FOREIGN KEY REFERENCES DimInventory (Inventory_SK),
	Employee_SK INT CONSTRAINT fk_employee FOREIGN KEY REFERENCES DimEmployee (Employee_SK),
	Quantity INT NOT NULL,
	Inventory_Price NUMERIC(6,2) NOT NULL,
	Discount NUMERIC (4,4)
	);
GO

