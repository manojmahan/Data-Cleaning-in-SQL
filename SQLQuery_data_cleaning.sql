select * from Housing

---change date format from datetime to date
select saledate from Housing

select convert(date,saledate)
from Housing

update Housing
set SaleDate= cast(saledate as date)  --- this method is not working so i will created a another column with date type

alter table housing
add Saledateconverted date;

update Housing
set Saledateconverted= cast(saledate as date)

select Saledateconverted from Housing


--- populate property address date
--- remove null from PropertyAddress
--- 
select a.uniqueid,a.ParcelID,isnull(a.PropertyAddress,b.PropertyAddress),b.uniqueid,b.ParcelID,b.PropertyAddress
from housing a join Housing b
	on a.ParcelID=b.ParcelID
	and a.UniqueID <> b.[UniqueID]
order by a.ParcelID 

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from housing a join Housing b
	on a.ParcelID=b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

select PropertyAddress
from Housing
where PropertyAddress is null -- now row retruned means that there is no null in PropertyAddress

---breaking out address into individual columns(address,city,state)
select substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1),substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))
from housing

-- creating two columns

alter table housing
add propertysplitaddress nvarchar(255);

alter table housing
add propertysplitcity nvarchar(255);

update Housing
set propertysplitaddress=substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1);

update Housing
set propertysplitcity=substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))


--- split owner address
select OwnerAddress,propertysplitaddress,propertysplitcity
from Housing

alter table housing
add ownersplitaddress nvarchar(255);

alter table housing
add ownersplitcity nvarchar(255);

alter table housing
add ownersplitstate nvarchar(255);
--- parsename will return a value from a specified position in a "Dot" delimited string
select OwnerAddress,
	PARSENAME(replace(owneraddress,',','.'),3),
	PARSENAME(replace(owneraddress,',','.'),2),
	PARSENAME(replace(owneraddress,',','.'),1)
from Housing

update Housing
set ownersplitaddress=isnull(PARSENAME(replace(owneraddress,',','.'),3),'No Address')

update Housing
set ownersplitcity=isnull(PARSENAME(replace(owneraddress,',','.'),2),'No Address')

update Housing
set ownersplitstate=isnull(PARSENAME(replace(owneraddress,',','.'),1),'No Address')

-- select * from Housing


--  change Y to Yes and N to no in soldasvacant column

select soldasvacant,
case 
		when soldasvacant='Y' then 'Yes'
	    when soldasvacant='N' then 'No' 
		else soldasvacant
end
from Housing

update Housing
set soldasvacant=case 
		when soldasvacant='Y' then 'Yes'
	    when soldasvacant='N' then 'No' 
		else soldasvacant
end;

select distinct soldasvacant from Housing


-- remove duplicates

select distinct(parcelid) from Housing

--BACKUP DATABASE SQLproject TO DISK = 'F:\sqldatabase\SQLproject.bak';
with RownumCTE as(
select *,
	ROW_NUMBER() over (
		partition by 
					ParcelId,
					PropertyAddress,
					SaleDate,
					Saleprice,
					Legalreference
		order by uniqueid )  row_num
from Housing
)
--delete from Rownumcte where row_num >1

SELECT * from 
Rownumcte
where row_num >1


--- delete unusedcolumns

alter table housing
drop column owneraddress,propertyaddress

select * from Housing

