USE coffeeshop_db;

-- =========================================================
-- JOINS & RELATIONSHIPS PRACTICE
-- =========================================================

-- Q1) Join products to categories: list product_name, category_name, price.
SELECT 
    p.name AS product_name,
    c.name AS category_name,
    p.price
FROM products p
JOIN categories c 
    ON p.category_id = c.category_id;
    
-- Q2) For each order item, show: order_id, order_datetime, store_name,
--     product_name, quantity, line_total (= quantity * products.price).
--     Sort by order_datetime, then order_id.
SELECT 
    oi.order_id,
    o.order_datetime,
    s.name AS store_name,
    p.name AS product_name,
    oi.quantity,
    oi.quantity * p.price AS line_total
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
JOIN stores s
    ON o.store_id = s.store_id
JOIN products p
    ON oi.product_id = p.product_id
ORDER BY o.order_datetime, oi.order_id;

-- Q3) Customer order history (PAID only):
--     For each order, show customer_name, store_name, order_datetime,
--     order_total (= SUM(quantity * products.price) per order).

-- Q4) Left join to find customers who have never placed an order.
--     Return first_name, last_name, city, state.

-- Q5) For each store, list the top-selling product by units (PAID only).
--     Return store_name, product_name, total_units.
--     Hint: Use a window function (ROW_NUMBER PARTITION BY store) or a correlated subquery.

-- Q6) Inventory check: show rows where on_hand < 12 in any store.
--     Return store_name, product_name, on_hand.

-- Q7) Manager roster: list each store's manager_name and hire_date.
--     (Assume title = 'Manager').

-- Q8) Using a subquery/CTE: list products whose total PAID revenue is above
--     the average PAID product revenue. Return product_name, total_revenue.

-- Q9) Churn-ish check: list customers with their last PAID order date.
--     If they have no PAID orders, show NULL.
--     Hint: Put the status filter in the LEFT JOIN's ON clause to preserve non-buyer rows.

-- Q10) Product mix report (PAID only):
--     For each store and category, show total units and total revenue (= SUM(quantity * products.price)).
