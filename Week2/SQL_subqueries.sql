USE coffeeshop_db;

-- =========================================================
-- SUBQUERIES & NESTED LOGIC PRACTICE
-- =========================================================

-- Q1) Scalar subquery (AVG benchmark):
--     List products priced above the overall average product price.
--     Return product_id, name, price.
SELECT
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  s.name                                  AS store_name,
  o.order_datetime,
  SUM(oi.quantity * p.price)              AS order_total
FROM orders o
JOIN customers c   ON o.customer_id = c.customer_id
JOIN stores s      ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p    ON oi.product_id = p.product_id
WHERE o.status = 'paid'
GROUP BY o.order_id;

-- Q2) Scalar subquery (MAX within category):
--     Find the most expensive product(s) in the 'Beans' category.
--     (Return all ties if more than one product shares the max price.)
--     Return product_id, name, price.
SELECT
  p.product_id,
  p.name,
  p.price
FROM products p
JOIN categories c
  ON p.category_id = c.category_id
WHERE c.name = 'Beans'
  AND p.price = (
    SELECT MAX(p2.price)
    FROM products p2
    JOIN categories c2
      ON p2.category_id = c2.category_id
    WHERE c2.name = 'Beans'
  );
  
-- Q3) List subquery (IN with nested lookup):
--     List customers who have purchased at least one product in the 'Merch' category.
--     Return customer_id, first_name, last_name.
--     Hint: Use a subquery to find the category_id for 'Merch', then a subquery to find product_ids.
SELECT DISTINCT
  c.customer_id,
  c.first_name,
  c.last_name
FROM customers c
WHERE c.customer_id IN (
  SELECT o.customer_id
  FROM orders o
  WHERE o.order_id IN (
    SELECT oi.order_id
    FROM order_items oi
    WHERE oi.product_id IN (
      SELECT p.product_id
      FROM products p
      WHERE p.category_id = (
        SELECT category_id
        FROM categories
        WHERE name = 'Merch'
      )
    )
  )
);

-- Q4) List subquery (NOT IN / anti-join logic):
--     List products that have never been ordered (their product_id never appears in order_items).
--     Return product_id, name, price.
SELECT
  p.product_id,
  p.name,
  p.price
FROM products p
WHERE p.product_id NOT IN (
  SELECT oi.product_id
  FROM order_items oi
);

-- Q5) Table subquery (derived table + compare to overall average):
--     Build a derived table that computes total_units_sold per product
--     (SUM(order_items.quantity) grouped by product_id).
--     Then return only products whose total_units_sold is greater than the
--     average total_units_sold across all products.
--     Return product_id, product_name, total_units_sold.
WITH totals AS (
  SELECT
    product_id,
    SUM(quantity) AS total_units_sold
  FROM order_items
  GROUP BY product_id
)
SELECT
  t.product_id,
  p.name AS product_name,
  t.total_units_sold
FROM totals t
JOIN products p
  ON p.product_id = t.product_id
WHERE t.total_units_sold > (
  SELECT AVG(total_units_sold) FROM totals
);