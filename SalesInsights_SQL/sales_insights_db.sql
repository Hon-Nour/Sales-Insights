-- Let's get an overview of the dataset --  
SELECT * FROM sales.customers;
SELECT * FROM sales.date;
SELECT * FROM sales.markets;
SELECT * FROM sales.products;
SELECT * FROM sales.transactions;

-- SELECT DISTINCT(sales.table_name.column_name) FROM sales.table;
SELECT DISTINCT(sales.transactions.currency) FROM sales.transactions;

SELECT * FROM sales.transactions WHERE sales.transactions.currency = 'INR' or sales.transactions.currency = 'INR\r'
	ORDER BY sales.transactions.product_code;
-- records with currency = 'INR' are duplictes of records with currency = 'INR\r'
DELETE FROM sales.transactions WHERE sales.transactions.currency = 'INR';

SELECT * FROM sales.transactions WHERE sales.transactions.currency = 'USD' or sales.transactions.currency = 'USD\r'
	ORDER BY sales.transactions.product_code;
    -- records with currency = 'USD' are duplictes of records with currency = 'USD\r'
DELETE FROM sales.transactions WHERE sales.transactions.currency = 'USD';

-- Added the column to convert USD sales_amount to its INR equivalent and normalize the sales amount
ALTER TABLE sales.transactions ADD COLUMN normalized_sales_amount double;

UPDATE sales.transactions SET sales.transactions.normalized_sales_amount = CASE
    WHEN sales.transactions.currency = 'USD\r' THEN sales.transactions.sales_amount * 81.85
    WHEN sales.transactions.currency = 'INR\r' THEN sales.transactions.sales_amount
    ELSE NULL
END;


-- How many transactions did our company execute in Total?
SELECT COUNT(*) FROM sales.transactions;

--  How many overall clients do we have?
SELECT COUNT(*) FROM sales.customers;

--  Who are the top 10 customers that patrnized us the most ?
SELECT sales.customers.custmer_name, sales.transactions.customer_code, COUNT(*) AS count_patronage 
	FROM sales.transactions
	JOIN sales.customers ON sales.customers.customer_code = sales.transactions.customer_code
	GROUP BY sales.transactions.customer_code, sales.customers.custmer_name
	ORDER BY count_patronage DESC
    LIMIT 10;

-- who are our oldest customers 
SELECT sales.customers.custmer_name, sales.transactions.customer_code, sales.transactions.order_date
	FROM sales.transactions
	JOIN sales.customers ON sales.customers.customer_code = sales.transactions.customer_code
	GROUP BY sales.transactions.customer_code, sales.customers.custmer_name
	ORDER BY sales.transactions.order_date
    LIMIT 10;

-- Our most profitable markets     
SELECT sales.markets.markets_name, sales.transactions.market_code, SUM(sales.transactions.sales_amount) AS revenue
	FROM sales.transactions
	JOIN sales.markets ON sales.markets.markets_code = sales.transactions.market_code
    WHERE sales.transactions.sales_amount >= 0
	GROUP BY sales.transactions.market_code
    ORDER BY revenue DESC;
    
-- 2020 sales
SELECT * FROM sales.transactions 
	INNER JOIN sales.date 
    ON sales.transactions.order_date = sales.date.date
    WHERE sales.date.year = 2020;
    
-- How much revenue was generated in 2020 
SELECT SUM(sales_amount) AS 2020_revenue FROM sales.transactions 
	INNER JOIN sales.date 
    ON sales.transactions.order_date = sales.date.date
    WHERE sales.date.year = 2020;