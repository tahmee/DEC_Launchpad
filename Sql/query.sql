#DROP TABLE IF EXISTS orders CASCADE;

-- Count the total number of customers who joined in 2023
SELECT COUNT(customer_id) AS total_customer_2023
FROM customers
WHERE join_date BETWEEN '2023-01-01' AND '2023-12-31';

-- For each customer return customer_id, full_name, total_revenue(sum of total_amount from orders). sort descending
SELECT c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o
USING (customer_id)
GROUP BY c.customer_id, c.full_name
ORDER BY total_revenue DESC;

-- Return the top 5 customers by total_revenue with their rank
SELECT c.full_name,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER(ORDER BY SUM(o.total_amount) DESC) AS rank
FROM customers c
JOIN orders o
USING (customer_id)
GROUP BY c.customer_id, c.full_name
LIMIT 5;

SELECT full_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS rank
FROM (
    SELECT c.customer_id,
        c.full_name,
        SUM(o.total_amount) AS total_revenue
    FROM customers c
    JOIN orders o USING (customer_id)
    GROUP BY c.customer_id, c.full_name
) AS revenue_per_customer
ORDER BY total_revenue DESC
LIMIT 5;

-- Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically
SELECT EXTRACT (YEAR FROM order_date) AS order_year,
    EXTRACT (MONTH FROM order_date) AS order_month,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

 -- 