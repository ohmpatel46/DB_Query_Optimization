# Principles of Database Systems  
## Mini-project Option 2: Query Optimization

**Name**: Ohm Patel  
**Net ID**: odp2008  
[GitHub Repository](https://github.com/ohmpatel46/DB_Query_Optimization).

### 1) Dataset

- The dataset was obtained from Kaggle's Brazilian E-commerce Public Dataset, which contains various CSV files that provide data on orders, customers, products, and transactions in the Brazilian e-commerce market.

- Out of the 9 tables in the dataset, only 4 tables (orders, order_items, products, customers) are relevant to our project.

### 2) Database Setup in SQL

- We began by setting up the database schema in MySQL to store the data from the CSV files. The database structure includes four main tables: `olist_orders_dataset`, `olist_order_items_dataset`, `olist_customers_dataset`, and `olist_products_dataset`.

- Foreign key relationships were established between the tables to ensure referential integrity. Specifically, the `olist_orders_dataset` table is linked to the `olist_customers_dataset` table via the `customer_id` column, and the `olist_order_items_dataset` table is linked to the `olist_orders_dataset` table via the `order_id` column. Additionally, the `olist_order_items_dataset` table is connected to the `olist_products_dataset` table through the `product_id` column.

### 3) Importing/Loading Data

- The CSV files were loaded into the corresponding tables in the SQL database using the `LOAD DATA INFILE` command.
- Each table's data was imported with proper handling of missing or null values, ensuring that each column's data was correctly inserted into the respective columns in the database.

Sample code handling missing values while loading data:

```sql
LOAD DATA INFILE 'your/directory'
    INTO TABLE miniproject.olist_orders_dataset
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (order_id, customer_id, order_status, order_purchase_timestamp,
     @order_approved_at,
     @order_delivered_carrier_date, @order_delivered_customer_date, @order_estimated_delivery_date)
    SET
        order_approved_at = IFNULL(NULLIF(@order_approved_at, ''), NULL),
        order_delivered_carrier_date = IFNULL(NULLIF(@order_delivered_carrier_date, ''), NULL),
        order_delivered_customer_date = IFNULL(NULLIF(@order_delivered_customer_date, ''), NULL),
        order_estimated_delivery_date = IFNULL(NULLIF(@order_estimated_delivery_date, ''), NULL);
```
### 4) Analyzing Query Performance Without Indexing

- To evaluate the query performance without any indexes, the `EXPLAIN ANALYZE` command was executed. This command provides detailed information about the execution plan, including the cost and actual time taken for each step of the query.

#### EXPLAIN ANALYZE Output:

```plaintext
-> Sort: o.order_purchase_timestamp DESC  (actual time=23.5..23.5 rows=16 loops=1)
    -> Stream results  (cost=19282 rows=10280) (actual time=1.65..23.4 rows=16 loops=1)
        -> Nested loop inner join  (cost=19282 rows=10280) (actual time=1.65..23.4 rows=16 loops=1)
            -> Nested loop inner join  (cost=15684 rows=10280) (actual time=1.64..23.4 rows=16 loops=1)
                -> Nested loop inner join  (cost=12412 rows=8974) (actual time=1.53..23.2 rows=17 loops=1)
                    -> Filter: (c.customer_unique_id = '8d50f5eadf50201ccdcedfb9e2ac8455')  (cost=9271 rows=8974) (actual time=1.5..22.9 rows=17 loops=1)
                        -> Table scan on c  (cost=9271 rows=89740) (actual time=0.129..19.2 rows=99441 loops=1)
                    -> Index lookup on o using idx_customer_id (customer_id=c.customer_id)  (cost=0.25 rows=1) (actual time=0.012..0.0125 rows=1 loops=17)
                -> Index lookup on oi using PRIMARY (order_id=o.order_id)  (cost=0.25 rows=1.15) (actual time=0.0115..0.0121 rows=0.941 loops=17)
            -> Single-row index lookup on p using PRIMARY (product_id=oi.product_id)  (cost=0.25 rows=1) (actual time=0.00313..0.00315 rows=1 loops=16)
```
#### Query Performance Table:

| Step                                           | Actual Time (ms)  | Comments                                    |
|------------------------------------------------|-------------------|--------------------------------------------|
| **Sort** (order_purchase_timestamp DESC)       | 23.5              | Sorting operation, minimal rows processed |
| **Stream results**                             | 1.65 to 23.4      | Streamed results from previous steps      |
| **Nested Loop Join (Customer Table Scan)**     | 19.2              | Full table scan on `olist_customers_dataset` |
| **Nested Loop Join (Order Items Lookup)**      | 0.012 to 0.0125   | Lookup on the `olist_order_items_dataset` |
| **Nested Loop Join (Product Table Lookup)**    | 0.00313 to 0.00315 | Lookup on the `olist_products_dataset`    |
| **Index Lookup on Order Table**                | 0.0115 to 0.0121  | Lookup on the `olist_orders_dataset`      |


### 5) Analyzing Query Performance After Adding Indices

In this step, the following indices were created to improve the performance of the query:

```sql
CREATE INDEX idx_order_purchase_timestamp ON olist_orders_dataset (order_purchase_timestamp DESC);
```
- This index was created to optimize sorting based on `order_purchase_timestamp`. Sorting can be a costly operation in queries, especially when dealing with large datasets. By adding this index, the database can efficiently perform the sort operation in descending order, improving the overall query performance.

```sql
CREATE INDEX idx_customer_unique_id ON olist_customers_dataset (customer_unique_id);
```

- This index was created on the `customer_unique_id` column in the `olist_customers_dataset` table to speed up the lookup of customer records based on a unique identifier. Since this column is used in the join condition for filtering specific customers, having an index on it significantly reduces the search time for matching rows, thus improving query performance.

```sql
CREATE INDEX idx_order_id_product_id ON olist_order_items_dataset (order_id, product_id);
```

- This composite index was created on the order_id and product_id columns in the olist_order_items_dataset table. These columns are used in a join between the order items and products tables. By indexing both columns together, the query can quickly retrieve the corresponding rows, optimizing the join and reducing the time spent on nested loop joins.

#### EXPLAIN ANALYZE Output (After Adding Indices):

```plaintext
-> Sort: o.order_purchase_timestamp DESC  (actual time=0.292..0.293 rows=16 loops=1)
    -> Stream results  (cost=22.4 rows=19.5) (actual time=0.0509..0.278 rows=16 loops=1)
        -> Nested loop inner join  (cost=22.4 rows=19.5) (actual time=0.0471..0.267 rows=16 loops=1)
            -> Nested loop inner join  (cost=15.6 rows=19.5) (actual time=0.0427..0.24 rows=16 loops=1)
                -> Nested loop inner join  (cost=9.41 rows=17) (actual time=0.034..0.157 rows=17 loops=1)
                    -> Covering index lookup on c using idx_customer_unique_id (customer_unique_id='8d50f5eadf50201ccdcedfb9e2ac8455')  (cost=3.46 rows=17) (actual time=0.0095..0.0139 rows=17 loops=1)
                    -> Index lookup on o using idx_customer_id (customer_id=c.customer_id)  (cost=0.256 rows=1) (actual time=0.00792..0.00829 rows=1 loops=17)
                -> Index lookup on oi using PRIMARY (order_id=o.order_id)  (cost=0.257 rows=1.15) (actual time=0.00431..0.00474 rows=0.941 loops=17)
            -> Single-row index lookup on p using PRIMARY (product_id=oi.product_id)  (cost=0.255 rows=1) (actual time=0.00153..0.00154 rows=1 loops=16)
```

#### Query Performance Table (After Adding Indices):

| Step                                           | Actual Time (ms)  | Comments                                    |
|------------------------------------------------|-------------------|--------------------------------------------|
| **Sort** (order_purchase_timestamp DESC)       | 0.292 to 0.293    | Sorting operation is now faster due to the index |
| **Stream results**                             | 0.0509 to 0.278   | Results are streamed more efficiently due to indexing |
| **Nested Loop Join (Customer Table Lookup)**   | 0.0095 to 0.0139  | Covering index lookup on `customer_unique_id` speeds up the lookup |
| **Nested Loop Join (Order Items Lookup)**      | 0.00431 to 0.00474 | Optimized join on `order_id` using the index |
| **Nested Loop Join (Product Table Lookup)**    | 0.00153 to 0.00154 | Faster lookup on `product_id` due to indexing |


#### 6) Comparison and Results

##### Query Performance Comparison

| Step                                      | Without Indexing (ms)          | With Indexing (ms)           | Percentage Improvement (%)  |
|-------------------------------------------|--------------------------------|------------------------------|-----------------------------|
| **Sort: o.order_purchase_timestamp DESC** | 23.5                           | 0.292                        | 98.8%                       |
| **Stream Results**                        | 1.65 to 23.4                   | 0.0509 to 0.278              | 96.9%                       |
| **Nested Loop Join (Customer Table Lookup)** | 1.5 to 22.9                    | 0.0095 to 0.0139             | 99.9%                       |
| **Nested Loop Join (Order Items Lookup)** | 0.0115 to 0.0121               | 0.00431 to 0.00474           | 63.5%                       |
| **Nested Loop Join (Product Table Lookup)** | 0.00313 to 0.00315             | 0.00153 to 0.00154           | 51.1%                       |

### Analyzing Performance Boost:

- **Sort:**
  - The `idx_order_purchase_timestamp` index significantly improved the sorting performance by reducing the time from 23.5ms to 0.292ms, resulting in a 98.8% improvement.

- **Stream Results:**
  - Stream processing was improved with indexing, reducing time from 1.65ms to 23.4ms to a much faster 0.0509ms to 0.278ms, with a performance boost of 96.9%.

- **Nested Loop Join (Customer Table Lookup):**
  - The `idx_customer_unique_id` index reduced the lookup time for the customer table from 1.5ms to 22.9ms down to 0.0095ms to 0.0139ms, resulting in a massive 99.9% improvement.

- **Nested Loop Join (Order Items Lookup):**
  - The `idx_order_id_product_id` index improved the order items lookup, reducing the time from 0.0115ms to 0.0121ms to 0.00431ms to 0.00474ms, providing a 63.5% boost in performance.

- **Nested Loop Join (Product Table Lookup):**
  - Adding the `PRIMARY` index on `product_id` improved the lookup from 0.00313ms to 0.00315ms down to 0.00153ms to 0.00154ms, yielding a 51.1% improvement in time.

### 7) Conclusion

The performance issues faced by the e-commerce platform, such as slow page load times and system unresponsiveness during peak hours, can be significantly alleviated by implementing indexing strategies. Indexing helps by optimizing query performance, reducing the amount of time spent searching through large datasets.

- **Slow Page Load Times:** By creating indices on frequently accessed columns, such as `order_purchase_timestamp`, `customer_unique_id`, and `order_id`, the time to retrieve customer order history and sort records is drastically reduced. This results in faster page loads and a more responsive user experience.
  
- **System Unresponsiveness During Peak Hours:** During peak traffic, database queries can become slow due to the high volume of requests. By adding appropriate indices, queries can be executed more efficiently, reducing the load on the database and preventing system slowdowns. This ensures the platform remains stable even under heavy usage.

