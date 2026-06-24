USE coffeeshop_db;

-- =========================================================
-- SUBQUERIES & NESTED LOGIC PRACTICE
-- =========================================================

-- Q1) Scalar subquery (AVG benchmark):
--     List products priced above the overall average product price.
--     Return product_id, name, price.
select product_id, name, price
from products
where price > (
	select AVG(price)
    from products);
    
-- Q2) Scalar subquery (MAX within category):
--     Find the most expensive product(s) in the 'Beans' category.
--     (Return all ties if more than one product shares the max price.)
--     Return product_id, name, price.
select product_id, name, price
from products
where product_id in (
	select product_id
    from products
    where category_id = (
		select category_id
        from categories
        where name = 'Beans'
	)
);

-- Q3) List subquery (IN with nested lookup):
--     List customers who have purchased at least one product in the 'Merch' category.
--     Return customer_id, first_name, last_name.
--     Hint: Use a subquery to find the category_id for 'Merch', then a subquery to find product_ids.
select distinct c.customer_id, c.first_name, c.last_name
from customers c	
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
where oi.product_id in (
	select product_id
    from products
    where category_id = (
		select category_id
		from categories
		where name = 'Merch'
	)
);

-- Q4) List subquery (NOT IN / anti-join logic):
--     List products that have never been ordered (their product_id never appears in order_items).
--     Return product_id, name, price.
select product_id, name, price
from products
where product_id not in (
	select product_id
    from order_items
);

-- Q5) Table subquery (derived table + compare to overall average):
--     Build a derived table that computes total_units_sold per product
--     (SUM(order_items.quantity) grouped by product_id).
--     Then return only products whose total_units_sold is greater than the
--     average total_units_sold across all products.
--     Return product_id, product_name, total_units_sold.
select p.product_id, p.name, sum(oi.quantity) as total_units_sold
from products p
join order_items oi on p.product_id = oi.product_id
group by product_id
having sum(oi.quantity) > (
	select avg(quantity)
    from order_items
);