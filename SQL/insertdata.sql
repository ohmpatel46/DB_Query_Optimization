-- Load data into olist_order_items_dataset
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE miniproject.olist_order_items_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load data into olist_customers_dataset
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE miniproject.olist_customers_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load data into olist_products_dataset
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE miniproject.olist_products_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name,
 @product_name_lenght, @product_description_lenght, @product_photos_qty,
 @product_weight_g, @product_length_cm, @product_height_cm, @product_width_cm)
SET
    product_name_lenght = IFNULL(NULLIF(@product_name_lenght, ''), NULL),
    product_description_lenght = IFNULL(NULLIF(@product_description_lenght, ''), NULL),
    product_photos_qty = IFNULL(NULLIF(@product_photos_qty, ''), NULL),
    product_weight_g = IFNULL(NULLIF(@product_weight_g, ''), NULL),
    product_length_cm = IFNULL(NULLIF(@product_length_cm, ''), NULL),
    product_height_cm = IFNULL(NULLIF(@product_height_cm, ''), NULL),
    product_width_cm = IFNULL(NULLIF(@product_width_cm, ''), NULL);

-- Load data into olist_orders_dataset
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE miniproject.olist_orders_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
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
