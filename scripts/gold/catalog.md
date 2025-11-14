# Gold Layer Catalog (Markdown Version)

## gold.dim_customer
Provides a unified, enriched customer master profile for analytics and reporting.

| Column Name     | Data Type    | Description                                                                                        |
| --------------- | ------------ | -------------------------------------------------------------------------------------------------- |
| customer_key    | INT          | Surrogate key generated using `ROW_NUMBER()` for unique customer identification.                   |
| customer_id     | NVARCHAR(50) | Original CRM customer ID loaded directly from Silver.                                              |
| customer_number | NVARCHAR(50) | ERP/CRM key used as the business identifier for the customer.                                      |
| first_name      | NVARCHAR(50) | Cleaned first name (trimmed in Silver layer).                                                      |
| last_name       | NVARCHAR(50) | Cleaned last name (trimmed in Silver layer).                                                       |
| country         | NVARCHAR(50) | Standardized country name from ERP (`DE → Germany`, `US/USA → United States`).                     |
| marital_status  | NVARCHAR(50) | Cleaned marital status where **'S' → 'Single'**, **'M' → 'Married'**, others defaulted to `'n/a'`. |
| gender          | NVARCHAR(50) | Final gender derived from CRM (F/M → Female/Male); ERP used only when CRM gender was `'n/a'`.      |
| birthdate       | DATE         | Birthdate from ERP, invalid future dates replaced with NULL in Silver.                             |
| create_date     | DATE         | Customer creation date from CRM.                                                                   |




---

## gold.dim_products
Offers a standardized, category-enriched product master for consistent product analysis.

| Column Name    | Data Type    | Description                                                                                        |
| -------------- | ------------ | -------------------------------------------------------------------------------------------------- |
| product_key    | INT          | Surrogate key assigned for unique product identification.                                          |
| product_id     | INT          | Original CRM product ID from source.                                                               |
| product_number | NVARCHAR(50) | Clean business-friendly product code (derived by trimming CRM product key).                        |
| product_name   | NVARCHAR(50) | Standardized product name.                                                                         |
| category_id    | NVARCHAR(50) | Standardized category ID (first part of product key with `-` replaced by `_`).                     |
| category       | NVARCHAR(50) | Top-level product category from ERP.                                                               |
| subcategory    | NVARCHAR(50) | More specific product classification from ERP.                                                     |
| maintenance    | NVARCHAR(50) | Maintenance/support grouping from ERP.                                                             |
| product_cost   | INT          | Standardized product cost (NULL values handled in Silver).                                         |
| product_line   | NVARCHAR(50) | Cleaned product line (**M→Mountain**, **R→Road**, **S→Other Sales**, **T→Touring**, else `'n/a'`). |
| start_date     | DATE         | Date when the product became active (from CRM).                                                    |
| end_date       | DATE         | Date when product validity ends (calculated using LEAD logic in Silver).                           |




---

## gold.fact_sales
Delivers a transaction-level sales fact table linking customers and products for revenue analytics.

| Column Name   | Data Type    | Description                                                                                   |
| ------------- | ------------ | --------------------------------------------------------------------------------------------- |
| order_number  | NVARCHAR(50) | Unique identifier of the sales order.                                                         |
| product_key   | INT          | Foreign key linking to **gold.dim_products**.                                                 |
| customer_key  | INT          | Foreign key linking to **gold.dim_customer**.                                                 |
| order_date    | DATE         | Order date cleaned in Silver; invalid 0/incorrect-length dates converted to NULL.             |
| shipping_date | DATE         | Cleaned shipping date (invalid dates converted to NULL).                                      |
| due_date      | DATE         | Expected delivery date, cleaned similarly to other dates.                                     |
| sales_amount  | INT          | Corrected sales amount: recalculated when mismatch with `quantity × ABS(price)` was detected. |
| quantity      | INT          | Number of units sold.                                                                         |
| price         | INT          | Final validated unit price (negative → ABS, 0/NULL → recalculated using `sales/quantity`).    |

