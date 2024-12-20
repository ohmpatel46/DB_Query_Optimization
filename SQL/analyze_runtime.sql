EXPLAIN ANALYZE
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    p.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value
FROM
    olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE
    c.customer_unique_id = '8d50f5eadf50201ccdcedfb9e2ac8455'
ORDER BY
    o.order_purchase_timestamp DESC;
