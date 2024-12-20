-- Create an index on order_purchase_timestamp for sorting queries efficiently
CREATE INDEX idx_order_purchase_timestamp ON olist_orders_dataset (order_purchase_timestamp DESC);

-- Create an index on customer_unique_id for faster lookups on unique customers
CREATE INDEX idx_customer_unique_id ON olist_customers_dataset (customer_unique_id);

-- Create a composite index on order_id and product_id to optimize joins
CREATE INDEX idx_order_id_product_id ON olist_order_items_dataset (order_id, product_id);
