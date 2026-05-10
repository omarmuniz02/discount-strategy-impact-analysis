WITH cte AS
(
SELECT 
		Sales_Channel,
        Product_Category,
        CASE 
    WHEN Discount < 0.10 THEN 'Low Discount'
    WHEN Discount >= 0.10 AND Discount < 0.20 THEN 'Medium Discount'
    ELSE 'High Discount'
	END AS discount_tier,
        ROUND(SUM(Sales_Amount), 2) AS sales_amount, 
		ROUND(SUM(Quantity_Sold * Unit_Cost), 2) AS cogs,
        ROUND(SUM(Sales_Amount) - SUM(Quantity_Sold * Unit_Cost), 2) AS gp,
        SUM(Quantity_Sold) AS units_sold,
        ROUND(AVG(Discount) * 100, 1) AS avg_discount
FROM retail_sales_raw
GROUP BY 
		Product_Category, 
		Sales_Channel,
        CASE 
    WHEN Discount < 0.10 THEN 'Low Discount'
    WHEN Discount >= 0.10 AND Discount < 0.20 THEN 'Medium Discount'
    ELSE 'High Discount'
	END 
)
SELECT 
		Sales_Channel,
        Product_Category,
        discount_tier,
		sales_amount,
        cogs,
        gp,
        units_sold,
        avg_discount,
        ROUND((gp/sales_amount) * 100, 2) AS margin_pct
FROM cte
ORDER BY Sales_Channel,
        Product_Category,
        discount_tier;
