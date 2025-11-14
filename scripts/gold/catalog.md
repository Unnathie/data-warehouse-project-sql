# Gold Layer Catalog (Markdown Version)

## gold.dim_customer
Provides a unified, enriched customer master profile for analytics and reporting.

| Column Name     | Data Type    | Description                                                                  |
| --------------- | ------------ | ---------------------------------------------------------------------------- |
| customer_key    | INT          | Surrogate key assigned in the Gold layer for unique customer identification. |
| customer_id     | INT          | Original CRM customer ID from source data.                                   |
| customer_number | NVARCHAR(50) | Business-facing customer code from CRM.                                      |
| first_name      | NVARCHAR(50) | Cleaned and standardized customer first name.                                |
| last_name       | NVARCHAR(50) | Cleaned and standardized customer last name.                                 |
| country         | NVARCHAR(50) | Customer’s country derived from ERP location data.                           |
| marital_status  | NVARCHAR(50) | Final standardized marital status from CRM.                                  |
| gender          | NVARCHAR(50) | Standardized gender resolved using CRM first, then ERP when needed.          |
| birthdate       | DATE         | Customer birthdate from ERP records.                                         |
| create_date     | DATE         | Original CRM customer creation date.                                         |


---

## gold.dim_products
Offers a standardized, category-enriched product master for consistent product analysis.

| Column Name    | Data Type     | Description                                               |
| -------------- | ------------- | --------------------------------------------------------- |
| product_key    | INT           | Surrogate key assigned for unique product identification. |
| product_id     | INT           | Original CRM product ID from source.                      |
| product_number | NVARCHAR(50)  | Business-friendly product code used in CRM.               |
| product_name   | NVARCHAR(50)  | Standardized product name.                                |
| category_id    | NVARCHAR(50)  | CRM category ID used to map ERP category metadata.        |
| category       | NVARCHAR(50)  | Top-level product category from ERP.                      |
| subcategory    | NVARCHAR(50)  | More specific product classification.                     |
| maintenance    | NVARCHAR(50)  | Indicates product maintenance/support grouping.           |
| product_cost   | DECIMAL(10,2) | Standardized product cost value.                          |
| product_line   | NVARCHAR(50)  | Product division/line cleaned from CRM.                   |
| start_date     | DATE          | Date when the product became active.                      |



---

## gold.fact_sales
Delivers a transaction-level sales fact table linking customers and products for revenue analytics.

| Column Name   | Data Type     | Description                           |
| ------------- | ------------- | ------------------------------------- |
| order_number  | NVARCHAR(50)  | Unique identifier of the sales order. |
| product_key   | INT           | Foreign key linking to dim_products.  |
| customer_key  | INT           | Foreign key linking to dim_customer.  |
| order_date    | DATE          | Date the order was placed.            |
| shipping_date | DATE          | Date the order was shipped.           |
| due_date      | DATE          | Expected order delivery date.         |
| sales_amount  | DECIMAL(10,2) | Total sale amount for the order line. |
| quantity      | INT           | Number of units sold.                 |
| price         | DECIMAL(10,2) | Final unit price after validation.    |


### Grain

One row per order line item, enriched with derived metrics like delivery status and linked to both customer and product dimensions.
