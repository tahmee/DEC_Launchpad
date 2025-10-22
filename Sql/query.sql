-- ----------------------------------------------
-- Count the total number of customers who joined in 2023
-- ----------------------------------------------
SELECT COUNT(customer_id) AS total_customer_2023
FROM customers
WHERE join_date BETWEEN '2023-01-01' AND '2023-12-31';

-- ----------------------------------------------
/* For each customer return customer_id, full_name, total_revenue(sum of total_amount from orders). 
Sort descending */
-- ----------------------------------------------
SELECT c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o
USING (customer_id)
GROUP BY c.customer_id, c.full_name
ORDER BY total_revenue DESC;

-- ----------------------------------------------
-- Return the top 5 customers by total_revenue with their rank
-- ----------------------------------------------
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
-- sort records in ascending order for customer_rank (i.e 1, 2 ..) and descending order for total_revenue
ORDER BY customer_rank, total_revenue DESC;

-- ----------------------------------------------
-- Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically
-- ----------------------------------------------
SELECT EXTRACT (YEAR FROM order_date) AS order_year,
    EXTRACT (MONTH FROM order_date) AS order_month,
    SUM(total_amount) AS monthly_revenue
FROM orders
-- This filters ensures only records year 2023 is produced
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- ----------------------------------------------
/* Find customers with no orders in the last 60 days relative to 2023-12-31 (i.e consider last active date
up to 2023-12-31. Return customer_id, full_name, last_order_date */
-- ----------------------------------------------

WITH last_order_date AS (
    -- the query returns the highest order date as the last order date
    SELECT customer_id,
        MAX(order_date) AS last_order_date
    FROM orders
    GROUP BY customer_id
)
-- compares customer's last order if it's less than 2023-11-01 which is the assumed date 60 days before 2023-12-31
SELECT c.customer_id,
    c.full_name,
    lod.last_order_date
FROM customers c 
LEFT JOIN last_order_date lod
USING (customer_id)  
WHERE lod.last_order_date <= '2023-11-01'
    OR lod.last_order_date IS NULL

-- ----------------------------------------------
/* Calculate the average order value (AOV) for each customer: return customer_id, full_name, aov (average 
total_amount of their orders). Exclude customers with no orders */
-- ----------------------------------------------

SELECT c.customer_id,
    c.full_name,
    ROUND(AVG(o.total_amount), 2) AS aov
FROM customers c
--  used an inner join to eliminate records with NULL values
INNER JOIN orders o
USING(customer_id)
GROUP BY c.customer_id, c.full_name
ORDER BY aov DESC;

-- ----------------------------------------------
/* For all customers who have at least one order, compute customer_id, full_name, total_revenue, spend_rank
where spend_rank is a dense rank highest spender = rank 1 */
-- ----------------------------------------------

WITH highest_spender AS (
    SELECT c.customer_id,
        c.full_name,
        SUM(o.total_amount) AS total_revenue
    FROM customers c 
    INNER JOIN orders o
    USING (customer_id)
    GROUP BY c.customer_id, c.full_name
)
SELECT customer_id,
    full_name,
    total_revenue,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS spend_rank
FROM highest_spender
ORDER BY total_revenue DESC, customer_id;

SELECT c.customer_id,
       c.full_name,
       SUM(o.total_amount) AS total_revenue,
       DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank
FROM customers c
INNER JOIN orders o USING (customer_id)
GROUP BY c.customer_id, c.full_name
ORDER BY total_revenue DESC, c.customer_id;

-- ----------------------------------------------
/* List customers who placed more than 1 order and show customer_id, full_name, order_count,
first_order_date, last_order_date */
-- ----------------------------------------------
