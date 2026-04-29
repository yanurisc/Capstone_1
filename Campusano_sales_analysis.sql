USE sample_sales;

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?

select 
'New Jersey' as Territory,
'Northeast' as Region,
min(Transaction_Date) as Start_date,
max(Transaction_Date) as End_Date,
sum(Sale_Amount) as Total_Revenue
From Store_Sales ss 
Join Store_Locations s1 ON ss.Store_ID = s1.StoreId 
WHERE s1.State = 'New Jersey'; 
 
 -- What is the month by month revenue breakdown for the sales territory?

SELECT 
Year(ss.Transaction_Date) as Year,
Month(ss.Transaction_Date) as Month_Num,
sum(ss.Sale_Amount) as Monthly_Revenue
From Store_Sales ss 
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId 
WHERE s1.State = 'New Jersey'
GROUP BY year(ss.Transaction_Date), month(ss.Transaction_Date) 
ORDER BY year(ss.Transaction_Date), month(ss.Transaction_Date);

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
SELECT 
'New Jersey (Territory)' as Label,
sum(ss.Sale_Amount) as Total_Revenue
from Store_Sales ss 
JOIN Store_Locations s1 on ss.Store_ID = s1.StoreId
WHERE s1.State = 'New Jersey'
UNION ALL  


-- What is the number of transactions per month and average transaction size by product category for the sales territory?



-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?



-- What is your recommendation for where to focus sales attention in the next quarter?