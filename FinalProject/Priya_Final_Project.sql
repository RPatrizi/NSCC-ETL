--Create Database
CREATE DATABASE Drug_Status_Database;
Go

USE Drug_Status_Database;
Go

--Create Tables
CREATE TABLE Company (
    [city_name] varchar(255),
    [company_code] varchar(255),
    [company_name] varchar(255),
    [company_type] varchar(255),
    [country_name] varchar(255),
    [post_office_box] varchar(255),
    [postal_code] varchar(255),
    [province_name] varchar(255),
    [street_name] varchar(255),
    [suite_number] varchar(255),
	CONSTRAINT [PK_Company] PRIMARY KEY (company_name) 
);
Go

CREATE TABLE [Route] (
    [drug_code] varchar(255),
    [route_of_administration_code] varchar(255),
    [route_of_administration_name] varchar(255),
	CONSTRAINT [PK_Route] PRIMARY KEY (drug_code, route_of_administration_code)
);
Go

CREATE TABLE Veterinary_Species (
    [drug_code] varchar(255),
    [vet_species_name] varchar(255),
	CONSTRAINT [PK_Veterinaty_Species] PRIMARY KEY (drug_code, vet_species_name)
);
Go

CREATE TABLE Drug_Product (
    [drug_code] varchar(255),
    [class_name] varchar(255),
    [drug_identification_number] varchar(255),
    [brand_name] varchar(255),
    [descriptor] varchar(255),
    [number_of_ais] int,
    [ai_group_no] varchar(255),
    [company_name] varchar(255),
    [last_update_date] date
	CONSTRAINT [PK_Drug_Product] PRIMARY KEY (drug_code)
);
Go

CREATE TABLE Active_Ingredients (
    [drug_code] varchar(255),
    [dosage_unit] varchar(255),
    [dosage_value] float,
    [ingredient_name] varchar(255),
    [strength] float,
    [strength_unit] varchar(255)
	CONSTRAINT [PK_Active_Ingredients] PRIMARY KEY (drug_code, ingredient_name, strength)
);
Go

CREATE TABLE [Status] (
    [drug_code] varchar(255),
    [status] varchar(255),
    [history_date] date,
    [original_market_date] varchar(255),
    [external_status_code] varchar(255),
    [expiration_date] varchar(255),
    [lot_number] varchar(255)
	CONSTRAINT [PK_Status] PRIMARY KEY (drug_code)
);
Go

--Add constraints
ALTER TABLE Drug_Product
ADD CONSTRAINT FK_Company_Drug_Product FOREIGN KEY (company_name) REFERENCES Company(company_name) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [Route]
ADD CONSTRAINT FK_Drug_Product_Route FOREIGN KEY (drug_code) REFERENCES Drug_Product(drug_code) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [Status]
ADD CONSTRAINT FK_Drug_Product_Status FOREIGN KEY (drug_code) REFERENCES Drug_Product(drug_code) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Active_Ingredients
ADD CONSTRAINT FK_Drug_Product_Active_Ingredients FOREIGN KEY (drug_code) REFERENCES Drug_Product(drug_code) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Veterinary_Species
ADD CONSTRAINT FK_Drug_Product_Veterinary_Species FOREIGN KEY (drug_code) REFERENCES Drug_Product(drug_code) ON UPDATE CASCADE ON DELETE CASCADE;
Go

--Questions

--Alexander Quingley
-- What is the most common route of administration of approved and Marketed drugs?

SELECT COUNT(*) Frequency, route_of_administration_name
FROM Drug_Product dp
INNER JOIN Status s ON
s.drug_code = dp.drug_code AND s.status IN ('Approved', 'Marketed')
INNER JOIN Route r ON
r.drug_code = dp.drug_code
GROUP BY route_of_administration_name
Order By COUNT(*) DESC;
Go

--Calvin Slaunwhite
--Are drugs containg certain ingredients being denied more often?

USE[Drug_Status_Database]
GO

--Shows all that have been rejected. 
SELECT dp.brand_name, ai.ingredient_name, s.[status]
FROM  [dbo].[Status] s
INNER JOIN [dbo].[Drug_Product] dp ON dp.drug_code = s.drug_code
INNER JOIN [dbo].[Active_Ingredients] ai on ai.drug_code  = dp.drug_code
WHERE status = 'Cancelled (Safety Issue)' OR STATUS = 'Authorization By Interim Order Revoked'

--Daniel Nichols
--Which active ingredients are used in both human and animal use?
SELECT DISTINCT x.ingredient_name [Shared Ingredients]
FROM
(
    SELECT DISTINCT ai.ingredient_name FROM Active_Ingredients ai
    INNER JOIN Drug_Product dpx
    ON dpx.drug_code = ai.drug_code AND dpx.class_name LIKE 'Human'
    INNER JOIN Route r ON
    r.drug_code = ai.drug_code AND r.route_of_administration_name NOT LIKE 'Disinfectant%'
) x
INNER JOIN
(
    SELECT DISTINCT ai.ingredient_name FROM Active_Ingredients ai
    INNER JOIN Drug_Product dpy
    ON dpy.drug_code = ai.drug_code AND dpy.class_name LIKE 'Veterinary'
    INNER JOIN Route r ON
    r.drug_code = ai.drug_code AND r.route_of_administration_name NOT LIKE 'Disinfectant%'
) y
ON y.ingredient_name = x.ingredient_name 

--Rodrigo Borges
--From which country are the TOP 5 companies with more approved drug products? DRUG_PRODUCT	COMPANY	STATUS

USE Drug_Status_Database;
Go

SELECT TOP 5 x.country_name, x.company_name, x.Count_of_Drugs
FROM (
SELECT co.country_name, dp.company_name, COUNT(dp.brand_name) AS Count_of_Drugs, st.[status]
FROM Drug_Product dp
INNER JOIN Company co
ON co.company_name = dp.company_name
INNER JOIN [Status] st
ON st.drug_code = dp.drug_code
GROUP BY co.country_name, dp.company_name, st.status
HAVING st.[status] = 'Approved' OR st.[status] = 'Marketed'
) x
ORDER BY x.Count_of_Drugs DESC;
Go
