---- cleaning data in sql
select *
from 
portfolioproject..NashvilleHousing

---standardize date format

select saledateconverted,CONVERT(DATE,SaleDate) AS CONVERTEDSALEDATE
from 
portfolioproject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

alter table NashvilleHousing
add saledateconverted date;


update NashvilleHousing
set saledateconverted = convert(date,SaleDate)

---populate property address data

select *
from
portfolioproject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from
portfolioproject..NashvilleHousing  a

join portfolioproject..NashvilleHousing b

on
a.ParcelID=b.ParcelID

and a.[UniqueID ]<> b.[UniqueID ]

where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from
portfolioproject..NashvilleHousing  a

join portfolioproject..NashvilleHousing b

on
a.ParcelID=b.ParcelID

and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--- breaking out address into  individual columns(address,city,sate)
select PropertyAddress
from
portfolioproject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
substring(propertyAddress,1, charindex(',', PropertyAddress)-1) as Address
,charindex(',', PropertyAddress)
from
portfolioproject..NashvilleHousing

select 
substring(propertyAddress,1, charindex(',', PropertyAddress)-1) as Address
  ,substring(propertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) as Address

from
portfolioproject..NashvilleHousing

alter table NashvilleHousing
add propertysplitaddress nvarchar(255);


update NashvilleHousing
set propertysplitaddress = substring(propertyAddress,1, charindex(',', PropertyAddress)-1) 

alter table NashvilleHousing
add propertysplitcity nvarchar(255);


update NashvilleHousing
set propertysplitcity = substring(propertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress))

select
*
from 
portfolioproject..NashvilleHousing


select
OwnerAddress
from portfolioproject..NashvilleHousing

select 
PARSENAME(replace(owneraddress,',','.'),3) ,
PARSENAME(replace(owneraddress,',','.'),2) ,
PARSENAME(replace(owneraddress,',','.'),1) 
from portfolioproject..NashvilleHousing


alter table NashvilleHousing
add ownersplitadddress nvarchar(255);


update NashvilleHousing
set ownersplitadddress = PARSENAME(replace(owneraddress,',','.'),3)

alter table NashvilleHousing
add ownersplitcity nvarchar(255);

update NashvilleHousing
set ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2)

alter table NashvilleHousing
add ownersplitstate nvarchar(255);

update NashvilleHousing
set ownersplitstate = PARSENAME(replace(owneraddress,',','.'),1)



----change y and n to yes and no in "sold" as "vacant" field

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from portfolioproject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2



select SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN  'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END
from portfolioproject..NashvilleHousing



-----REMOVE DUPLICATES
with rownumCTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) ROW_NUM
FROM portfolioproject..NashvilleHousing)

select * FROM rownumCTE
WHERE row_num > 1



--ORDER BY ParcelID

--delete unused columns

select *
from portfolioproject..NashvilleHousing

alter table 
 portfolioproject..NashvilleHousing
 drop column OwnerAddress, TaxDistrict,PropertyAddress




 
