-- Create a Database "Layoffs"
CREATE DATABASE IF NOT EXISTS Layoffs;
USE Layoffs;

--The first step in cleaning the dataset is to create a **staging table** where all transformations and cleaning operations will be performed.
--This ensures that the original raw data remains intact in case we need to reference it later.

Create table layoffs_staging  
like layoffs;

-- Inserting the values from original(layoffs) table.
INSERT layoffs_staging
SELECT * FROM 
layoffs;



