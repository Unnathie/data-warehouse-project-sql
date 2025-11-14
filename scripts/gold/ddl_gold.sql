/* 
1. Customer Dimension (dim_customer)
   Creates a unified customer dimension by merging CRM and ERP data.
   Standardizes gender and enriches profiles with country and birthdate.
   Supports accurate customer-level analytics and reporting.

2. Product Dimension (dim_products)
   Builds a comprehensive product dimension with category and subcategory mapping.
   Filters out inactive products and adds enriched ERP attributes.
   Acts as a single source of truth for product analytics.

3. Sales Fact (fact_sales)
   Combines sales transactions with customer and product dimensions.
   Provides order, shipping, and financial metrics for each transaction.
   Designed for BI dashboards, KPIs, and sales performance analysis.
*/
-------------------------customer_dim---------------------------------
IF OBJECT_ID('gold.dim_customer','V') IS NOT NULL
		DROP VIEW gold.dim_customer
GO
CREATE VIEW gold.dim_customer AS
SELECT
	ROW_NUMBER()OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id
	,ci.cst_key AS customer_number
	,ci.cst_firstname AS first_name
	,ci.cst_lastname AS last_name,
	ecc.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE	
			WHEN ci.cst_gndr IN ('Female','Male') THEN ci.cst_gndr ---Considering crm as the master
			WHEN ci.cst_gndr ='n/a' AND eci.gen IN ('Female','Male') THEN eci.gen
			ELSE 'n/a' ---or you could just use coalesce(eci.gen,'n/a')
	END AS gender,
	eci.bdate AS birthdate,
	ci.cst_create_date AS create_date

FROM
Silver.crm_cust_info AS ci
LEFT JOIN 
Silver.erp_cust_az12 AS eci 
ON		 eci.cid=ci.cst_key
LEFT JOIN 
Silver.erp_loc_a101 AS ecc 
ON		 ecc.cid=ci.cst_key;
GO
---------------------------product_dim-----------------------------------
IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
			DROP VIEW gold.dim_products
GO
CREATE VIEW gold.dim_products AS 
	SELECT
	ROW_NUMBER() OVER(ORDER BY cpi.prd_start_dt,cpi.prd_key) AS product_key,
	cpi.prd_id AS product_id
	,cpi.prd_key AS product_number
	,cpi.prd_nm AS product_name
	,cpi.cat_id AS category_id
	,epi.cat AS category
	,epi.subcat AS subcategory
	,epi.maintenance 
	,cpi.prd_cost AS product_cost
	,cpi.prd_line AS product_line
	,cpi.prd_start_dt AS start_date
	FROM
	Silver.crm_prd_info AS cpi
	LEFT JOIN
	Silver.erp_px_cat_g1v2 epi
	ON
	cpi.cat_id=epi.id
	WHERE cpi.prd_end_dt IS NULL ---FILTERING HISTORICAL DATA;
GO
-----------------------------------fact_sales----------------------------------------
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
		DROP VIEW gold.fact_sales
GO
CREATE VIEW gold.fact_sales AS
SELECT 
sls_ord_num AS order_number
,dpi.product_key 
,dci.customer_key
,cs.sls_order_dt AS order_date
,cs.sls_ship_dt AS shipping_date
,cs.sls_due_dt AS due_date
,cs.sls_sales AS sales_amount
,cs.sls_quantity AS quantity
,cs.sls_price AS price
FROM Silver.crm_sales_details cs
LEFT JOIN [gold].[dim_customer] dci
ON dci.customer_id=cs.sls_cust_id
LEFT JOIN
[gold].[dim_products] dpi
ON 
dpi.product_number=cs.sls_prd_key;
