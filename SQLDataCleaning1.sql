/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [HousingProject].[dbo].[housing]

  select *
  from housing

  select SaleDate,CONVERT(date,SaleDate) as newSaleDate
  from housing

  alter table housing 
  add convSaleDate date;

  update housing
  set convSaleDate=CONVERT(date,SaleDate)

  select SaleDate,convSaleDate
  from housing

  --address
  select PropertyAddress
  from HousingProject..housing

  select ParcelID,PropertyAddress
  from HousingProject..housing
--  where PropertyAddress is null
  order by 1

  select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
  from HousingProject..housing A
  Join HousingProject..housing B
  On A.ParcelID=B.ParcelID
  where  A.PropertyAddress is null
		and A.[UniqueID ] <> B.[UniqueID ]

  update A
  set A.PropertyAddress=ISNULL(A.PropertyAddress,B.PropertyAddress)
  from HousingProject..housing A
  Join HousingProject..housing B
  On A.ParcelID=B.ParcelID
  where  A.PropertyAddress is null
		and A.[UniqueID ] <> B.[UniqueID ]

  select distinct(PropertyAddress)
  from HousingProject..housing
--  where PropertyAddress is null

--break address
  
  select 
  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(propertyAddress)) as City
  from HousingProject..housing

  Alter table housing
  add Address NVARCHAR(255)
 
  Alter table housing
  add City NVARCHAR(255)

  update housing
  set Address =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

  update housing
  set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(propertyAddress))


  select PropertyAddress,Address,City
  from HousingProject..housing

  select 
  PARSENAME(Replace(OwnerAddress,',','.'),3),
  PARSENAME(Replace(OwnerAddress,',','.'),2),
  PARSENAME(Replace(OwnerAddress,',','.'),1)
  from HousingProject..housing

    Alter table housing
  add ownerSplitAddress NVARCHAR(255)
 
  Alter table housing
  add ownerCity NVARCHAR(255)

   Alter table housing
  add ownerState NVARCHAR(255)

  update housing
  set ownerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

  update housing
  set ownerCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

  update housing
  set ownerState = PARSENAME(Replace(OwnerAddress,',','.'),1)

  select OwnerAddress,ownerSplitAddress,ownerCity,ownerState
  from HousingProject..housing

 --soldAsVaccant

 select distinct(SoldAsVacant)
 from HousingProject..housing

  select distinct(SoldAsVacant),count(SoldAsVacant)
 from HousingProject..housing
 group by SoldAsVacant

 Select SoldAsVacant,
 case when SoldAsVacant= 'Y' then 'Yes'
	  when SoldAsVacant= 'N' then 'No'
	  else SoldAsVacant
	  end
 from HousingProject..housing

 update housing
 set SoldAsVacant= case when SoldAsVacant= 'Y' then 'Yes'
	  when SoldAsVacant= 'N' then 'No'
	  else SoldAsVacant
	  end

 select distinct(SoldAsVacant),count(SoldAsVacant)
 from HousingProject..housing
 group by SoldAsVacant

 -- remove columns
  
  alter table housingProject..housing
  drop column ownerAddress,propertyAddress,TaxDistrict

  alter table housingProject..housing
  drop column SaleDate
 
 select * 
  from HousingProject..housing

