-- -----------------------------------------------------------
-- Capstone 1: Sales Analysis
-- Analyst: Yanuris Campusano
-- Territory: New Jersey (In-Store)
-- Region: Northeast
-- Sales Manager: Miami Vue
-- -----------------------------------------------------------


USE sample_sales;

Show tables; 

SELECT Salesmanager, Region, State
FROM Management
Where Salesmanager = 'Miami Vue';

/* Question 1
What is total revenue overall for sales in the assigned territory, plus the start date and end date that 
tell you what period the data covers? 

The New Jersey territory made $5,175,405.87 in total sales between January 2022 and December 2025. */

select 
'New Jersey' as Territory,
'Northeast' as Region,
min(Transaction_Date) as Start_date,
max(Transaction_Date) as End_Date,
sum(Sale_Amount) as Total_Revenue
From Store_Sales ss 
Join Store_Locations s1 ON ss.Store_ID = s1.StoreId 
WHERE s1.State = 'New Jersey'; 
 
 
 /* Question 2
 What is the month by month revenue breakdown for the sales territory? 
 
New Jersey revenue grew every year from 2022 to 2025, with each year performing better than the 
last, and one surprising spike in October 2025 that stood out significantly above all other months. */

SELECT 
Year(ss.Transaction_Date) as Year,
Month(ss.Transaction_Date) as Month_Num,
sum(ss.Sale_Amount) as Monthly_Revenue
From Store_Sales ss 
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId 
WHERE s1.State = 'New Jersey'
GROUP BY year(ss.Transaction_Date), month(ss.Transaction_Date) 
ORDER BY year(ss.Transaction_Date), month(ss.Transaction_Date);


/* Question 3
 Provide a comparison of total revenue for the specific sales territory and the region it belongs to. 
 
New Jersey generated $5,175,405 while the full Northeast region made $24,237,526 in total sales. */

SELECT 
'New Jersey (Territory)' as Label,
sum(ss.Sale_Amount) as Total_Revenue
from Store_Sales ss 
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId
WHERE s1.State = 'New Jersey'
UNION ALL  
SELECT 'Northeast Region (All States)' as Label,
sum(ss.Sale_Amount) as Total_Revenue
FROM Store_Sales ss 
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId
JOIN management m on s1.State = m.State
WHERE m.Region = 'Northeast'; 

/* Question 4 
What is the number of transactions per month and average transaction size by product category for the sales territory? 

Stationery and supplies has the most transactions every month but the lowest average sale, while Technology has the 
fewest transactions but the highest average sale. */

SELECT 
Year(ss.Transaction_Date) as Year,
Month(ss.Transaction_Date) as Month_Num, 
ic.Category as Product_Category,
count(*) as Num_Transactions,
round(avg(ss.Sale_Amount), 2) as Avg_Transaction_Size
FROM Store_Sales ss
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId
JOIN products p on ss.prod_Num = p.ProdNum
JOIN inventory_categories ic on p.Categoryid = ic.Categoryid 
WHERE s1.State = 'New Jersey'
GROUP BY year(ss.Transaction_Date), month(ss.Transaction_Date), ic.Category 
ORDER BY year, Month_Num, Num_Transactions DESC;

/* Question 5
Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online 
sales performance by state within an online sales territory?

Ranking all 16 New Jersey stores by total revenue, the top stores are outperforming the bottom stores,
showing a clear gap in sales performance across the territory. */

SELECT
rank() over (order by sum(ss.Sale_Amount) desc) as Sales_Rank,
s1.StoreId as Store_ID,
s1.StoreLocation as City,
count(*) as Num_Transactions,
round(sum(ss.Sale_Amount), 2) as Total_Revenue,
round(avg(ss.Sale_Amount), 2) as Avg_Transaction_Size
FROM Store_Sales ss
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId
WHERE s1.State = 'New Jersey'
GROUP BY s1.StoreId, s1.StoreLocation
ORDER BY Sales_Rank;

/* Question 6
What is your recommendation for where to focus sales attention in the next quarter?

Based on my analysis I have two recommendations for Miami Vue. First, for the weakest locations to have a plan 
for better management and sales because not all 16 stores are pulling equal weight. For example, better training, 
promotions and closer manager attention. Second, customers who buy technology spend more than any other category 
so more customers need to be walking out with a tech purchases. I would suggest resources towards the weakest stores
and promotions for all technology in the stores. */

SELECT
sl.StoreLocation as City,
round(sum(ss.Sale_Amount), 2) as Total_Revenue,
rank() over (order by sum(ss.Sale_Amount) desc) as Sales_Rank
FROM Store_Sales ss
JOIN Store_Locations sl on ss.Store_ID = sl.StoreId
WHERE sl.State = 'New Jersey'
GROUP BY sl.StoreLocation
ORDER BY Sales_Rank;





