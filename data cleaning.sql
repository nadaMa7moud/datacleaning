/* data cleaning queries

-- standarise date format
*/
select seledateconverted , convert (date,saleDate)
from 
nashville_data_cleaning 


alter table nashville_data_cleaning
add seledateconverted date

update nashville_data_cleaning 
set seledateconverted = convert (date,saleDate)

---------------------------------------------------------------------------------------------
-- populate property address data
select a.propertyaddress ,a.ParcelID,b.propertyaddress,b.ParcelID,isnull (a.propertyaddress,b.propertyaddress )
from nashville_data_cleaning a
join nashville_data_cleaning b
on a.ParcelID <> b.ParcelID
and a.[UniqueID ]=b.[UniqueID ]

where  a.propertyaddress is  null


update   a
set propertyaddress = isnull (a.propertyaddress,b.propertyaddress )
from nashville_data_cleaning a
join nashville_data_cleaning b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]=b.[UniqueID ]

where  a.propertyaddress is null



-- breaking address into individual colums (adress,city,state)
-----------------------------------------------------------------------------------------------------------------------------------------------
select 
SUBSTRING (propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address
, SUBSTRING (propertyaddress,CHARINDEX(',',propertyaddress)+1, len (propertyaddress)) as address
from Nashville_Data_Cleaning

alter table Nashville_Data_Cleaning
add propertyspiltaddress nchar (255);

update Nashville_Data_Cleaning
set propertyspiltaddress = substring (propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 

alter table Nashville_Data_Cleaning
add propertyspiltcity nchar (255);

update Nashville_Data_Cleaning
set 
propertyspiltcity = convert (date,saledate)

Select OwnerAddress
From Nashville_Data_Cleaning


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville_Data_Cleaning



ALTER TABLE Nashville_Data_Cleaning
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_Data_Cleaning
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville_Data_Cleaning
Add OwnerSplitCity Nvarchar(255);

Update Nashville_Data_Cleaning
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Nashville_Data_Cleaning
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ' ,', '.') , 1)



Select *
From Nashville_Data_Cleaning



-- Change Y and N to Yes and No in "Sold as Vacant" field
------------------------------------------------------------------------------------------------------------------------------------------
select Distinct(soldasvacant) , count(soldasvacant)
from Nashville_Data_Cleaning
group by soldasvacant

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from Nashville_Data_Cleaning

update Nashville_Data_Cleaning
set SoldAsVacant=
 CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   from Nashville_Data_Cleaning

	   -- remove the duplicats
	   ---------------------------------------------------------------------------------------------------------------------------------
	   WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_nuM
				   
from 	 Nashville_Data_Cleaning  

)
--delete 
--from RowNumCTE
--where row_num >1

select * from RowNumCTE
where row_num >1

-- delete unused columns
---------------------------------------------------------------------------------------------------------------------
alter table Nashville_Data_Cleaning  
drop column OwnerAddress, TaxDistrict, propertyaddress,saledate


select * from Nashville_Data_Cleaning
