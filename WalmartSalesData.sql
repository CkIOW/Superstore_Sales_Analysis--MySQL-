create database if not exists walmartsales;
use walmartsales;
create table if not exists sales_sheet(
     Invoice_ID varchar(30) not null primary key,
     Branch varchar(5) not null,
     City varchar(30) not null,
     Customer_type varchar(30) not null,
     Gender varchar(10) not null,
     Product_Line varchar(100) not null,
     Unit_Price decimal(10,2) not null,
     Quantity int not null,
     VAT float(6,4) not null,
     Total decimal (10,2) not null,
     `Date` datetime not null,
     `Time` time not null,
     Payment varchar(15) not null,
     Cogs decimal(10,2) not null,
     Gross_Margin_Pct float(11,9) not null,
     Gross_Income decimal(10,2) not null,
     Rating float(2,1) not null
);

select * from sales_sheet;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------- FEATURE ENGINEERING -----------------------------------------------------------------------------------------
 
 ## Time_of_day
 
 select `Time`,
		(case
             when `Time` between "00:00:00" and "12:00:00" then "Morning"
             when `Time` between "12:00:00" and "16:00:00" then "Afternoon"
             else "Evening"
		end
		) as Time_of_Day
From sales_sheet;

alter table sales_sheet add column Time_of_Day varchar(20);
update sales_sheet 
set Time_of_Day = (case
             when `Time` between "00:00:00" and "12:00:00" then "Morning"
             when `Time` between "12:00:00" and "16:00:00" then "Afternoon"
             else "Evening"
		end);
			
select dayname(`Date`) as Day_Name
from sales_sheet;
alter table sales_sheet add column Day_Name varchar(10) not null;
update sales_sheet
set Day_Name = (select dayname(`Date`) as Day_Name);

alter table sales_sheet add column Month_Name varchar(10) not null;
update sales_sheet
set Month_Name = monthname(`Date`);

# Unique cities in the dataset
select distinct City 
from sales_sheet;

# unique branch in the dataset
select distinct Branch
from sales_sheet;

# Number of unique product line in the dataset
select distinct Product_Line
from sales_sheet
group by Product_Line;

# what is the most common payment method
select Payment, count(Payment) as cnt
from sales_sheet
group by Payment
order by cnt desc;

# what is the most selling product line
select Product_Line, count(Quantity) as Sales
from sales_sheet
group by Product_Line
order by Sales desc;

# What is the total revenue by month
select Month_Name, sum(Total) as Total_Revenue
from sales_sheet
group by Month_Name
order by Total_Revenue desc;

# which month had highest cogs
select Month_Name, sum(cogs) as Highest_Cogs
from sales_sheet
group by Month_Name
order by Highest_Cogs desc
limit 1;

# which product line has the largest revenue
select Product_Line, sum(Total) as Highest_Revenue
from sales_sheet
group by Product_Line
order by Highest_Revenue desc
limit 1;

# which city has highest revenue
select City, sum(Total) as Highest_Revenue
from sales_sheet
group by City
order by Highest_Revenue desc;

# which product line highest VAT
select Product_Line, avg(VAT) as Highest_Vat
from sales_sheet
group by Product_Line
order by Highest_Vat desc;

# classify the product line into good or bad product, good when sales is greater than avg sales
select Product_Line, case when avg(Quantity) > (select avg(quantity) as avg_sales
																			from sales_sheet) then 'Good'
                                                                            else 'Bad'
                                                                            end as Avg_sales
                                                                            
from sales_sheet
group by Product_Line; 

# which branch has more sales than average product sold
select Branch, sum(Quantity) as Total_qty
from sales_sheet
group by Branch
having Total_qty > (select avg(Quantity) from sales_sheet)
order by Total_qty desc;

# what is most common product line by gender
select Gender, Product_Line, count(Gender) as Counts
from sales_sheet
group by Gender, Product_Line
order by Counts desc;

# Average Rating of each product line
select Product_Line, format(avg(Rating), 2) as Avg_Rating
from sales_sheet
group by Product_Line
order by Avg_Rating desc;

# -----------------------------------SALES----------------------------------------------------
# Number of sales made in each time of the day per week day
select Time_of_Day, count(*) as Total_sale
from sales_sheet
group by Time_of_Day
order by Total_Sale desc;

# which customer types brings more revenue
select Customer_Type, sum(Total) as Total_Revenue
from sales_sheet
group by Customer_Type
order by Total_Revenue desc;

# which city has highest VAT
select City, avg(VAT) as Highest_VAT
from sales_sheet
group by City
order by Highest_VAT desc;

# which customer_type pays most in the vat
select Customer_type, avg(VAT) as Highest_VAT
from sales_sheet
group by Customer_type
order by Highest_VAT desc;

#--------------------------------------------------customer------------------------------------------------------------------
# How many customer type in the data
select distinct Customer_type
from sales_sheet;

# How many unique payment type
select distinct Payment
from sales_sheet;

# who is the most common customer type
select Customer_type, count(Customer_type) as cnt
from sales_sheet
group by Customer_type;

# which customer purchase the most
select Customer_type, count(distinct Invoice_ID) as cnt
from sales_sheet
group by Customer_type;

# which gender is the most active
select Gender, Customer_type, count(distinct Invoice_ID) as cnt
from sales_sheet
group by Customer_type, Gender
order by cnt desc;

# what is the gender distribution by branch
select Branch, Gender, count(Gender) as cnt
from sales_sheet
group by Branch, Gender;

# which time of the day most ratings has been given
select Time_of_Day, avg(Rating) as Rating_avg
from sales_sheet
group by Time_of_Day
order by Rating_avg desc;

# which time of the day most ratings has been given by branch
select Branch, Time_of_Day, avg(Rating) as Rating_avg
from sales_sheet
group by Branch, Time_of_Day
order by Rating_avg desc;

# which day of the week has best average rating
select Day_Name, avg(Rating) as Avg_Rating
from sales_sheet
group by Day_Name
order by Avg_Rating desc;

# which day of the week has best average rating by branch
select Branch, Day_Name, avg(Rating) as Avg_Rating
from sales_sheet
group by Branch, Day_Name
order by Avg_Rating desc
limit 1;


