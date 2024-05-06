
select * 
from NashvilleHousing

-- Standardized date format

--update NashvilleHousing
--set SaleDate = cast(SaleDate as int)

--update NashvilleHousing
--set SaleDate = case(SaleDate set as int)

alter table NashvilleHousing 
add SaleDateConverted date

update NashvilleHousing 
set SaleDateConverted = convert(date, SaleDate)

select SaleDateConverted
from NashvilleHousing

-- Populating property address data

select PropertyAddress
from NashvilleHousing
where PropertyAddress is null
order by ParcelID

select Nashville.ParcelID, Nashville.PropertyAddress, Housing.ParcelID, Housing.PropertyAddress, 
	isnull(Nashville.PropertyAddress, Housing.PropertyAddress)
from NashvilleHousing as Nashville
join NashvilleHousing as Housing on
Nashville.ParcelID = Housing.ParcelID
and Nashville.[UniqueID ] <> Housing.[UniqueID ]
where Nashville.PropertyAddress is null

update Nashville
set Nashville.PropertyAddress = isnull(Nashville.PropertyAddress, Housing.PropertyAddress)
from NashvilleHousing as Nashville
join NashvilleHousing as Housing on
Nashville.ParcelID = Housing.ParcelID
and Nashville.[UniqueID ] <> Housing.[UniqueID ]

-- Separating address into individual columns

select PropertyAddress
from NashvilleHousing

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as City
from NashvilleHousing

--alter table NashvilleHousing
--add
--PropertyStreetAddress nvarchar(255),
--City nvarchar(255)

update NashvilleHousing
set 
PropertyStreetAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1),
City = substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress))
 
select PropertyStreetAddress, City
from NashvilleHousing


-- Populating owner address

select OwnerAddress
from NashvilleHousing

select nash.ParcelID,nash.OwnerAddress, hous.ParcelID, hous.OwnerAddress, isnull(nash.OwnerAddress, hous.OwnerAddress)
from NashvilleHousing as nash
join NashvilleHousing as hous on 
nash.ParcelID = hous.ParcelID and
nash.[UniqueID ] = hous.[UniqueID ]

update nash
set OwnerAddress = isnull(nash.OwnerAddress, hous.OwnerAddress)
from NashvilleHousing as nash
join NashvilleHousing as hous on 
nash.ParcelID = hous.ParcelID and
nash.[UniqueID ] = hous.[UniqueID ]

-- Separating owner address into individual columns

select OwnerAddress
from NashvilleHousing

select 
parsename(replace(OwnerAddress, ',', '.'), 1),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 3)
from NashvilleHousing

--alter table NashvilleHousing
--add 
--OwnerStreetAddress nvarchar(255),
--OwnerCity nvarchar(255)
--OwnerState nvarchar(50)

update NashvilleHousing
set
OwnerState = parsename(replace(OwnerAddress, ',', '.'), 1),
OwnerCity = parsename(replace(OwnerAddress, ',', '.'), 2),
OwnerStreetAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

select OwnerStreetAddress, OwnerCity, OwnerState
from NashvilleHousing

--Changing values

select SoldAsVacant
from NashvilleHousing

select distinct SoldAsVacant, count(SoldAsVacant) as YNC
from NashvilleHousing
group by SoldAsVacant
order by YNC

update NashvilleHousing
set SoldAsVacant = case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
from NashvilleHousing

-- Remove duplicates

select *
from NashvilleHousing

with RowNumCTE as (
select *,
	row_number() over (
	partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by UniqueID
) as RowNum
from NashvilleHousing
)

select * 
from RowNumCTE
where RowNum > 1


-- Deleting columns from table

select *
from NashvilleHousing

--alter table NashvilleHousing
--drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table NashvilleHousing
drop column SaleDate