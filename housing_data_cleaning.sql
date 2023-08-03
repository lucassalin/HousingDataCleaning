SELECT * FROM sql_tuto.nashvillehousingdata;

-- 1) Standardize date format of SaleDate

ALTER TABLE sql_tuto.nashvillehousingdata
ADD NewSaleDate DATE;

UPDATE sql_tuto.nashvillehousingdata
SET NewSaleDate = str_to_date(SaleDate, '%M %d, %Y');

ALTER TABLE sql_tuto.nashvillehousingdata
DROP COLUMN SaleDate;

ALTER TABLE sql_tuto.nashvillehousingdata
CHANGE COLUMN NewSaleDate SaleDate DATE;

-- 2) The Property Address column currently contains both the street number and the city
--    Let's split this data into two separate columns

-- Address column
ALTER TABLE sql_tuto.nashvillehousingdata
ADD Address VARCHAR(255);

UPDATE sql_tuto.nashvillehousingdata
SET Address = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1));

-- City column
ALTER TABLE sql_tuto.nashvillehousingdata
ADD City VARCHAR(255);

UPDATE sql_tuto.nashvillehousingdata
SET City = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

ALTER TABLE sql_tuto.nashvillehousingdata
DROP COLUMN PropertyAddress;

-- 3) Remove duplicates
--    Remove duplicates. If several lines contain the same ParceID and the same Address,
--    only one line containing these values ​​is kept.

CREATE TABLE sql_tuto.nashvillehousingdata_temp LIKE sql_tuto.nashvillehousingdata;

-- SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

INSERT INTO sql_tuto.nashvillehousingdata_temp
SELECT * FROM sql_tuto.nashvillehousingdata
GROUP BY ParcelID, Address;

-- SET sql_mode=(SELECT CONCAT(@@sql_mode,',ONLY_FULL_GROUP_BY'));

DROP TABLE sql_tuto.nashvillehousingdata;
RENAME TABLE sql_tuto.nashvillehousingdata_temp TO sql_tuto.nashvillehousingdata;
