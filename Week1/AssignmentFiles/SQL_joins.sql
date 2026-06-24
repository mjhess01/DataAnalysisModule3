USE coffeeshop_db;

-- =========================================================
-- JOINS & RELATIONSHIPS PRACTICE
-- =========================================================

-- Q1) Join products to categories: list product_name, category_name, price.

select p.name, c.name, p.price
from products p
join categories c
on p.category_id = c.category_id; 

-- Q2) For each order item, show: order_id, order_datetime, store_name,
--     product_name, quantity, line_total (= quantity * products.price).
--     Sort by order_datetime, then order_id.

select oi.order_id, o.order_datetime, o.store_id, oi.product_id, oi.quantity, oi.quantity * p.price as line_total
from orders o
join (
	order_items oi join products p on oi.product_id = p.product_id)
on oi.order_id = o.order_id
order by order_datetime, order_id;

-- Q3) Customer order history (PAID only):
--     For each order, show customer_name, store_name, order_datetime,
--     order_total (= SUM(quantity * products.price) per order).

select o.order_id, concat(c.first_name, ' ', c.last_name) as customer_name, s.name, o.order_datetime, sum(oi.quantity * p.price) as order_total
from orders o
inner join customers c on c.customer_id = o.customer_id
inner join stores s on s.store_id = o.store_id
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
where status = 'paid'
group by order_id;

-- Q4) Left join to find customers who have never placed an order.
--     Return first_name, last_name, city, state.

select c.first_name, c.last_name, c.city, c.state
from customers c
left join orders o on c.customer_id = o.customer_id
and o.order_id = null;

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
