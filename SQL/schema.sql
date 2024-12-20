CREATE DATABASE miniproject;
USE miniproject;

CREATE TABLE miniproject.olist_products_dataset (
    product_id VARCHAR(50) NOT NULL, -- Unique identifier for products
    product_category_name VARCHAR(100), -- Category names
    product_name_lenght INT, -- Length of the product name
    product_description_lenght INT, -- Length of the product description
    product_photos_qty INT, -- Quantity of photos
    product_weight_g INT, -- Weight in grams
    product_length_cm INT, -- Length in centimeters
    product_height_cm INT, -- Height in centimeters
    product_width_cm INT, -- Width in centimeters
    PRIMARY KEY (product_id)
);

CREATE TABLE miniproject.olist_customers_dataset (
    customer_id VARCHAR(50) NOT NULL, -- Unique identifier for each customer
    customer_unique_id VARCHAR(50) NOT NULL, -- Unique customer identifier across orders
    customer_zip_code_prefix VARCHAR(10), -- ZIP code prefix
    customer_city VARCHAR(100), -- Customer's city
    customer_state CHAR(2), -- Customer's state abbreviation
    PRIMARY KEY (customer_id)
);

CREATE TABLE miniproject.olist_order_items_dataset (
    order_id VARCHAR(50) NOT NULL, -- Unique identifier for orders
    order_item_id INT NOT NULL, -- Item number within the order
    product_id VARCHAR(50) NOT NULL, -- Links to olist_products_dataset
    seller_id VARCHAR(50), -- Placeholder for seller information
    shipping_limit_date DATETIME, -- Deadline for shipping
    price DECIMAL(10, 2), -- Price of the item
    freight_value DECIMAL(10, 2), -- Shipping cost
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (product_id) REFERENCES miniproject.olist_products_dataset (product_id) -- Foreign key to products
);

CREATE TABLE miniproject.olist_orders_dataset (
    order_id VARCHAR(50) NOT NULL, -- Unique identifier for orders
    customer_id VARCHAR(50) NOT NULL, -- Links to olist_customers_dataset
    order_status VARCHAR(20), -- Status of the order
    order_purchase_timestamp DATETIME, -- Timestamp of purchase
    order_approved_at DATETIME, -- Timestamp of approval
    order_delivered_carrier_date DATETIME, -- Timestamp of carrier delivery
    order_delivered_customer_date DATETIME, -- Timestamp of customer delivery
    order_estimated_delivery_date DATETIME, -- Estimated delivery date
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES miniproject.olist_customers_dataset (customer_id) -- Foreign key to customers
);
