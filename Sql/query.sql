-- Count the total number of customers who joined in 2023

SELECT COUNT(customer_id) AS total_customer_2023
FROM customers
WHERE join_date BETWEEN '2023-01-01' AND '2023-12-31';


-- For each customer return customer_id, full_name, total_revenue(sum of total_amount from orders). Sort descending

SELECT c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o
USING (customer_id)
GROUP BY c.customer_id, c.full_name
ORDER BY total_revenue DESC;

-- Return the top 5 customers by total_revenue with their rank

WITH revenue_per_customer AS (
    -- Calculate total revenue for each customer
    SELECT c.customer_id,
        c.full_name,
        SUM(o.total_amount) AS total_revenue
    FROM customers c
    JOIN orders o 
    USING (customer_id)
    GROUP BY c.customer_id, c.full_name
),
ranked_customer_revenue AS (
    -- Assign rank based on total revenue (from highest to lowest)
    SELECT full_name,
        total_revenue,
        DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS customer_rank
    FROM revenue_per_customer
)
-- Select all customers whose rank is 5 or less to get the top 5
SELECT full_name,
    total_revenue,
    customer_rank
FROM ranked_customer_revenue
WHERE customer_rank <= 5
ORDER BY customer_rank, total_revenue DESC;


-- Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically
SELECT EXTRACT (YEAR FROM order_date) AS order_year,
    EXTRACT (MONTH FROM order_date) AS order_month,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

 -- 