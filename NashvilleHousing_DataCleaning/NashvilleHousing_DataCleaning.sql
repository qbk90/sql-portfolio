/*
Data Cleaning using SQL Querries */

Select *
From NashvilleHousing

/*
Extract a Standard Date format from the SaleDate column */

Select SaleDate--, CONVERT(date, SaleDate)
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConv DATE

UPDATE NashvilleHousing
SET SaleDateConv = CONVERT(DATE, SaleDate)

SELECT SaleDate, SaleDateConv
FROM NashvilleHousing

/*
Correct column names */

EXEC sp_rename 'NashvilleHousing.[UniqueID ]','UniqueID', 'COLUMN'; 

/*
Populate PropertyAddress */

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.PropertyAddress, b.PropertyAddress, a.ParcelID, b.ParcelID, a.UniqueID, b.UniqueID
--,ISNULL(a.PropertyAddress, b.PropertyAddress)
/*a.ParcelID = b.ParcelID means same owner, then a.PropertyAddress = b.PropertyAddress*/
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
--WHERE a.PropertyAddress IS NULL;

--Update the table
UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

/*
Break out Address into Individual Columns (Address, City, State) */

SELECT PropertyAddress, OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM NashvilleHousing;

SELECT	PARSENAME(REPLACE(OwnerAddress, ',','.'), 3) AS 'Address',
		PARSENAME(REPLACE(OwnerAddress, ',','.'), 2) AS 'City',
		PARSENAME(REPLACE(OwnerAddress, ',','.'), 1) AS 'State'
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1);

/*
Change 'Y' and 'N' to 'Yes' and 'No' respectively in SoldAsVacant column */

-- Check the different answers:

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant, CASE
			WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant =  CASE
			WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
END;