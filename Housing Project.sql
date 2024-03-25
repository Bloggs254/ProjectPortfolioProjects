SELECT *
--FROM ProjectPortfolio.dbo.HousingProject

--Starndadize Date Format 

SELECT SaleDateConverted, CONVERT (Date, SaleDate)
FROM ProjectPortfolio.dbo.HousingProject

ALTER TABLE HousingProject
Add SaleDateConverted Date;

Update HousingProject
SET SaleDateConverted = CONVERT (Date , SaleDate)


--Populate Property Address Data
SELECT*
FROM ProjectPortfolio.dbo.HousingProject
--WHERE PropertyAddress is null
Order by ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.ParcelID, b.PropertyAddress ISNULL
FROM ProjectPortfolio.dbo.HousingProject a
JOIN ProjectPortfolio.dbo.HousingProject b
     on a.ParcelID = b.ParcelID
	 AND a. [UniqueID] <> b. [UniqueID ]
WHERE a.PropertyAddress is NULL


UPDATE a
SET PropertyADDRESS = ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM ProjectPortfolio.dbo.HousingProject a
JOIN ProjectPortfolio.dbo.HousingProject b
     on a.ParcelID = b.ParcelID
	 AND a. [UniqueID] <> b. [UniqueID ]
WHERE a.PropertyAddress is NULL


--Breaking out Address into Individual Colums (Address,city, state)

SELECT PropertyAddress
FROM ProjectPortfolio.dbo.HousingProject
--WHERE PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1,  CHARINDEX(',' , PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',' , PropertyAddress) + 1, LEN(PropertyAddress)) as Address

FROM ProjectPortfolio.dbo.HousingProject


ALTER TABLE HousingProject
Add PropertySplitAdress varchar (240);

Update HousingProject
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1,  CHARINDEX(',' , PropertyAddress) - 1)

ALTER TABLE HousingProject
Add PropertySplitCity varchar (240);

Update HousingProject
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',' , PropertyAddress) + 1, LEN(PropertyAddress) )

SELECT*
FROM ProjectPortfolio.dbo.HousingProject


--Change y and N to yes and No in  "sold as vacant' field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM ProjectPortfolio.dbo.HousingProject
GROUP BY SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM ProjectPortfolio.dbo.HousingProject

Update HousingProject
SET SoldAsVacant = CASE When SoldAsVacant = 'y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM ProjectPortfolio.dbo.HousingProject

--REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT* ,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					) row_num



FROM ProjectPortfolio.dbo.HousingProject
--order by ParcelID
)
SELECT *
FROM RowNumCTE
Where row_num > 1
--Order by PropertyAddress


--DELETE UNUSED COLUMS

SELECT*
FROM ProjectPortfolio.dbo.HousingProject

ALTER Table ProjectPortfolio.dbo.HousingProject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER Table ProjectPortfolio.dbo.HousingProject
DROP COLUMN SaleDate
