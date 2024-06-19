create database zomato;
use zomato;
create table RawData
(
RestaurantID int,
RestaurantName varchar(100),
CountryCode int,
City varchar(100),
Address varchar(500),
Locality varchar(100),
LocalityVerbose varchar(100),
Longitude double,
Latitude double,
Cuisines varchar(100),
Currency varchar(100),
Has_Table_booking varchar(10),
Has_Online_delivery varchar(10),
Is_delivering_now varchar(10),
Switch_to_order_menu varchar(10),
Price_range int,
Votes int,
Average_Cost_for_two int,
Rating double,
Rating_Range varchar(50),
Datekey_Opening date
);

SHOW VARIABLES LIKE "secure_file_priv";

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/zomato/RawData.csv'
into table rawdata
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

create table CurrencyMap
(
Currency varchar(50),
Average_Cost_for_two int,
Average_Cost_in_Dolloar double,
PriceBucket varchar(50)
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/zomato/CurrencyMapTable.csv'
into table CurrencyMap
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

create table CountryMap
(
CountryCode int,
CountryName varchar(50)
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/zomato/CountryMapTable.csv'
into table CountryMap
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

create table calender
(
Datekey_Opening date,
Year int,
Monthno int,
Monthfullname varchar(20),
Qtr varchar(5),
YearMonth varchar(50),
Weekdayno int,
Weekdayname varchar(50),
FinancialMonth varchar(10),
FinancialQuarter varchar(10)
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/zomato/CalendarTable.csv'
into table calender
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

# Find the Numbers of Resturants based on City and Country.

select
count(RestaurantID) as Number_of_Resturants,
countrymap.CountryName
from rawdata inner join countrymap on rawdata.CountryCode = countrymap.CountryCode
group by countrymap.CountryName
order by countrymap.CountryName;

select
count(RestaurantID) as Number_of_Resturants,
city
from zomato.rawdata
group by city
order by city;

# Numbers of Resturants opening based on Year , Quarter , Month

Select
count(RestaurantID) as Number_of_Resturants,
year(Datekey_Opening) as Opening_Year
from zomato.rawdata
group by year(Datekey_Opening)
order by year(Datekey_Opening);

Select
count(RestaurantID) as Number_of_Resturants,
quarter(Datekey_Opening) as Opening_Qtr
from zomato.rawdata
group by quarter(Datekey_Opening)
order by quarter(Datekey_Opening);

Select
count(RestaurantID) as Number_of_Resturants,
monthname(Datekey_Opening) as Opening_Month
from zomato.rawdata
group by monthname(Datekey_Opening);

# Count of Resturants based on Average Ratings

Select
Rating,
count(RestaurantID) as Number_of_Resturants 
from zomato.rawdata
group by Rating
Having Rating >= (select avg(Rating) from rawdata)
order by Rating;

# Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

set sql_mode=0;

Select
currencymap.PriceBucket as PriceBucket_in_USD,
count(rawdata.RestaurantID) as Number_of_Resturants
from rawdata left join currencymap on rawdata.Average_Cost_for_two = currencymap.Average_Cost_for_two
group by currencymap.PriceBucket
order by currencymap.PriceBucket;

# Percentage of Resturants based on "Has_Table_booking"

select
(count(Has_Table_booking) - (select count(Has_Table_booking) from zomato.rawdata where Has_Table_booking = 'No'))/count(Has_Table_booking) *100 as Percentage_Has_Table_Booking
from zomato.rawdata;

# Percentage of Resturants based on "Has_Online_delivery"

select
(count(Has_Online_delivery) - (select count(Has_Online_delivery) from zomato.rawdata where Has_Online_delivery = 'No'))/count(Has_Online_delivery) *100 as Percentage_Has_Online_delivery
from zomato.rawdata;

# No. of Cusines based on City

select
city,
count(Cuisines) as No_of_Cuisines
from zomato.rawdata
group by city
order by city;

# No. of Cusines based on Rating
select
Rating_Range,
count(Cuisines) as No_of_Cuisines
from zomato.rawdata
group by Rating_Range
order by Rating_Range;







