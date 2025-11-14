# Gold Layer Catalog (Markdown Version)

## gold.dim_customer
Provides a unified, enriched customer master profile for analytics and reporting.

| Column Name     | Data Type    | Description                                            |
| --------------- | ------------ | ------------------------------------------------------ |
| cust_id         | INT          | Unique customer identifier.                            |
| cust_first_name | NVARCHAR(50) | Customer's first name.                                 |
| cust_last_name  | NVARCHAR(50) | Customer's last name.                                  |
| cust_full_name  | NVARCHAR(50) | Combined full name derived during transformation.      |
| cust_address    | NVARCHAR(50) | Customer's address.                                    |
| cust_state      | NVARCHAR(50) | State where the customer resides.                      |
| cust_zip        | NVARCHAR(50) | Zip code of the customer's location.                   |
| effective_from  | DATE         | Start date the record became valid.                    |
| effective_to    | DATE         | End date of validity (NULL for active records).        |
| is_current      | INT          | Indicates active record (1 = current, 0 = historical). |

---

## gold.dim_products
Offers a standardized, category-enriched product master for consistent product analysis.

| Column Name    | Data Type    | Description                                        |
| -------------- | ------------ | -------------------------------------------------- |
| prd_key        | INT          | Unique product identifier.                         |
| prd_name       | NVARCHAR(50) | Product name.                                      |
| prd_brand      | NVARCHAR(50) | Product brand.                                     |
| effective_from | DATE         | Start date this product version is valid.          |
| effective_to   | DATE         | End date of validity (NULL for active products).   |
| is_current     | INT          | Indicates if current record (1 = active, 0 = old). |


---

## gold.fact_sales
Delivers a transaction-level sales fact table linking customers and products for revenue analytics.

| Column Name  | Data Type    | Description                                 |
| ------------ | ------------ | ------------------------------------------- |
| ord_num      | INT          | Unique sales order number.                  |
| prd_key      | INT          | Foreign key to dim_products.                |
| cust_id      | INT          | Foreign key to dim_customer.                |
| order_date   | DATE         | Date the order was placed.                  |
| due_date     | DATE         | Expected delivery date.                     |
| ship_date    | DATE         | Actual shipping date.                       |
| sales        | FLOAT        | Total sales amount.                         |
| quantity     | INT          | Number of units sold.                       |
| price        | FLOAT        | Unit price of product.                      |
| order_status | NVARCHAR(50) | Derived order status (On-time, Late, etc.). |

### Grain

One row per order line item, enriched with derived metrics like delivery status and linked to both customer and product dimensions.
