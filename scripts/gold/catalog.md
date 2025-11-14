# Gold Layer Catalog (Markdown Version)

## gold.dim_customer
Provides a unified, enriched customer master profile for analytics and reporting.

| Column Name     | Data Type      | Description                                                                                        |
| --------------- | ---------      | -------------------------------------------------------------------------------------------------- |
| customer_key    | INT            | Surrogate key generated using `ROW_NUMBER()` for unique customer identification.                   |
| customer_id     | NVARCHAR(50)   | Original CRM customer ID loaded directly from Silver.                                              |
| customer_number | NVARCHAR(50)   | ERP/CRM key used as the business identifier for the customer.                                      |
| first_name      | NVARCHAR(50)   | Cleaned first name (trimmed in Silver layer).                                                      |
| last_name       | NVARCHAR(50)   | Cleaned last name (trimmed in Silver layer).                                                       |
| country         | NVARCHAR(50)   | Standardized country name pulled from ERP (`DE → Germany`, `US/USA → United States`).              |
| marital_status  | NVARCHAR(50)   | Cleaned marital status where **'S' → 'Single'**, **'M' → 'Married'**, others defaulted to `'n/a'`. |
| gender          | NVARCHAR(50)   | Final gender using CRM as master; **CRM 'F/M' → Female/Male**, fallback to ERP if CRM had `'n/a'`. |
| birthdate       | DATE           | Birthdate from ERP, invalid future dates replaced with NULL in Silver.                             |
| create_date     | DATE           | Customer creation date from CRM, unchanged.                                                        |


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
                                 | (Standardized category ID created by replacing - with _   |
                                 | in the first part of product key.                         |
| category       | NVARCHAR(50)  | Top-level product category from ERP.                      |
| subcategory    | NVARCHAR(50)  | More specific product classification.                     |
| maintenance    | NVARCHAR(50)  | Indicates product maintenance/support grouping.           |
| product_cost   | INT           | Standardized product cost value.                          |
| product_line   | NVARCHAR(50)  | Cleaned product line where M→Mountain,                    |
                                 |  R→Road, S→Other Sales, T→Touring, else 'n/a'.            |
| start_date     | DATE          | Date when the product became active.                      |



---

## gold.fact_sales
Delivers a transaction-level sales fact table linking customers and products for revenue analytics.

| Column Name   | Data Type     | Description                           |
| ------------- | ------------- | ------------------------------------- |
| order_number  | NVARCHAR(50)  | Unique identifier of the sales order. |
| product_key   | INT           | Foreign key linking to dim_products.  |
| customer_key  | INT           | Foreign key linking to dim_customer.  |
| order_date    | DATE          | Date validated in Silver:             |
                                | invalid 0/incorrect length → NULL.   |
| shipping_date | DATE          | Date the order was shipped.           |
| due_date      | DATE          | Expected order delivery date.         |
| sales_amount  | INT           | Total sale amount for the order line. |
| quantity      | INT           | Number of units sold.                 |
| price         | INT           | Final unit price after validation.    |
