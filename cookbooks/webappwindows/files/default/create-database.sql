USE master;
GO
-- Create the learnchef database
CREATE DATABASE learnchef;
GO
USE learnchef;
GO
-- Create the customers table
CREATE TABLE customers(
    id uniqueidentifier NOT NULL DEFAULT newid(),
    PRIMARY KEY(id),
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    email VARCHAR(64)
);
GO
-- Add Sample customer database
INSERT INTO customers(id, first_name, last_name, email) VALUES(newid(), 'Tony', 'Stark', 'iron.man@pluralsight.com');
INSERT INTO customers(id, first_name, last_name, email) VALUES(newid(), 'Natasha', 'Romanoff', 'black.widow@pluralsight.com');
INSERT INTO customers(id, first_name, last_name, email) VALUES(newid(), 'Steve', 'Rodgers', 'captain.america@pluralsight.com');
GO

