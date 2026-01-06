use farmers_market;
select * from customer_purchases;
-- List all the products and their product categories.
select product_name,product_category_name from product
join product_category on product_category_name= product_category_name;
-- Get all the Customers who have purchased nothing from the market yet.
SELECT * FROM customer c
left JOIN customer_purchases cp ON c.customer_id = cp.customer_id
WHERE cp.customer_id IS NULL;
-- List all the customers and their associated purchases
SELECT
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    cp.customer_id,
    cp.product_id,
    cp.quantity,
    cp.cost_to_customer_per_qty
FROM
    customer AS c
INNER JOIN
    customer_purchases AS cp
    ON c.customer_id = cp.customer_id
ORDER BY
    c.customer_id;

-- Write a query that returns a list of all customers who did not purchase on March 2, 2019
SELECT 
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    cp.market_date
FROM 
    customer AS c
 inner join customer_purchases AS cp   
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM customer_purchases AS cp
        WHERE cp.customer_id = c.customer_id
          AND DATE(cp.market_date) = '2019-03-02'
    );
-- filter out vendors who brought at least 10 items to the farmer’s market over the time period - 2019-05-02 and 2019-05-16
SELECT 
    v.vendor_id,
    v.vendor_name,
    COUNT(i.product_id) AS total_items_brought
FROM 
    vendor AS v
JOIN 
    vendor_inventory AS i
    ON v.vendor_id = i.vendor_id
WHERE 
    i.market_date BETWEEN '2019-05-02' AND '2019-05-16'
GROUP BY 
    v.vendor_id, v.vendor_name
HAVING 
    COUNT(i.product_id) >= 10;

-- Show details about all farmer’s market booths and every vendor booth assignment for every market date
select * from product;
select * from vendor_booth_assignments;
SELECT 
    b.booth_number,
    b.booth_type,
    b.booth_price_level,
    v.vendor_id,
    v.vendor_name,
    a.market_date
FROM 
    booth AS b
LEFT JOIN 
    vendor_booth_assignments AS a
    ON b.booth_number = a.booth_number
LEFT JOIN 
    vendor AS v
    ON a.vendor_id = v.vendor_id
ORDER BY 
    a.market_date, b.booth_number;

-- find out how much this customer had spent at each vendor, regardless of date? (Include customer_first_name, customer_last_name, customer_id, vendor_name, vendor_id, price)
SELECT 
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    v.vendor_id,
    v.vendor_name,
    SUM(cp.cost_to_customer_per_qty) AS total_spent
FROM 
    customer AS c
JOIN 
    customer_purchases AS cp
    ON c.customer_id = cp.customer_id
JOIN 
    vendor AS v
    ON cp.vendor_id = v.vendor_id
GROUP BY 
    c.customer_id, 
    c.customer_first_name, 
    c.customer_last_name,
    v.vendor_id,
    v.vendor_name
ORDER BY 
    c.customer_id, v.vendor_id;
select * from customer_purchases;
-- get the lowest and highest prices within each product category include (product_category_name, product_category_id, lowest price, highest _price)
SELECT
    pc.product_category_id,
    pc.product_category_name,
    MIN(p.product_size) AS lowest_price,
    MAX(p.product_size) AS highest_price
FROM 
    product AS p
JOIN 
    product_category AS pc
    ON p.product_category_id = pc.product_category_id
GROUP BY 
    pc.product_category_id,
    pc.product_category_name
ORDER BY 
    pc.product_category_name;

-- Count how many products were for sale on each market date, or how many different products each vendor offered.
SELECT
    cp.market_date,
    COUNT(DISTINCT cp.product_id) AS total_products_for_sale
FROM 
    customer_purchases AS cp
GROUP BY 
    cp.market_date
ORDER BY 
    cp.market_date;

-- In addition to the count of different products per vendor, we also want the average original price of a product per vendor?
SELECT
    v.vendor_id,
    v.vendor_name,
    COUNT(DISTINCT vi.product_id) AS total_products_offered,
    AVG(vi.original_price) AS avg_original_price
FROM 
    vendor AS v
JOIN 
    vendor_inventory AS vi
    ON v.vendor_id = vi.vendor_id
GROUP BY 
    v.vendor_id,
    v.vendor_name
ORDER BY 
    total_products_offered DESC;
