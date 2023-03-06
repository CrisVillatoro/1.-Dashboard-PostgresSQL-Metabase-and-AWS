-- Get the names and the quantities in stock for each products.

SELECT productName, unitsInStock FROM products;

-- Get a list of current products (Product ID and name).

SELECT productID, productName FROM products;

-- Get a list of the most and least expensive products (name and unit price).

SELECT MAX(unitPrice), MIN(unitPrice)
FROM products;

-- Get products that cost less than $20.

SELECT productName, unitPrice FROM products
WHERE (unitPrice>20);

-- Get products that cost between $15 and $25.

SELECT productName, unitPrice FROM products
WHERE (unitPrice>15) AND (unitPrice<25);

-- Get products above average price.

SELECT products.productName, products.unitPrice
FROM products
WHERE products.unitPrice>(SELECT AVG(unitPrice) FROM products)
ORDER BY products.unitPrice DESC;

-- Find the ten most expensive products.

SELECT productName, MAX(unitPrice) FROM products
GROUP BY productName
ORDER BY MAX(unitPrice) DESC
LIMIT 10;

-- Get a list of discontinued products (Product ID and name).

SELECT productID, productName, discontinued FROM products
WHERE discontinued = 1;

-- Count current and discontinued products.

SELECT productID, productName, discontinued FROM products
GROUP BY productID
HAVING discontinued =1;

SELECT productID, productName, discontinued FROM products
GROUP BY productID
HAVING discontinued = 0;

-- Find products with less units in stock than the quantity on order.

SELECT productName, unitsInStock, unitsOnOrder FROM products
WHERE unitsOnOrder>unitsInStock;

-- Find the customer who had the highest order amount

SELECT customers.customerID, customers.companyName, COUNT(orders.orderID) as AmountOfOrders
FROM customers
INNER JOIN orders on customers.customerID = orders.customerID
GROUP BY customers.customerID
ORDER BY AmountOfOrders DESC
LIMIT 10; 


-- Get orders for a given employee and the according customer

SELECT employees.firstName || ',' || employees.lastName as Employee_Name, 
COUNT(orders.orderID) as number_of_orders_per_employee
FROM orders
JOIN employees ON orders.employeeID = employees.employeeID
GROUP BY Employee_Name
ORDER BY COUNT(orders.orderID) DESC 
LIMIT 10;


-- Find the hiring age of each employee

SELECT lastName, EXTRACT(YEAR FROM hireDate) - EXTRACT(YEAR FROM birthDate) AS hire_age
FROM employees;

-- Create views and/or named queries for some of these queries

--- Get Subtotal for each order
DROP view IF EXISTS "Subtotal for each order";
CREATE view "Subtotal for each order" AS
SELECT orderID, ROUND(SUM(unitPrice * quantity * (1.0 - discount)), 2) AS Subtotal
FROM order_details
GROUP BY orderID
ORDER BY orderID;
SELECT * FROM "Subtotal for each order";


-- Customers and suppliers by cities
DROP view IF EXISTS "Customers and Suppliers by Cities";
CREATE view "Customers and Suppliers by Cities" AS
SELECT city, companyName, contactName, 'Customers' AS relationship
FROM customers
UNION SELECT city, companyName, contactName, 'Suppliers'
FROM suppliers
ORDER BY city, companyName;
SELECT * FROM "Customers and Suppliers by Cities";


---- Sales price for each order after discount is applied.
DROP view IF EXISTS "Order Details Extended";
CREATE view "Order Details Extended" AS
SELECT order_details.orderID, order_details.productID, products.productName,
order_details.unitPrice, order_details.quantity, order_details.discount, 
(order_details.unitPrice * order_details.quantity * (1-order_details.discount)) as Sales_price_after_discount
FROM products INNER JOIN order_details ON products.productID = order_details.productID
ORDER BY Sales_price_after_discount DESC;

SELECT * FROM "Order Details Extended";

--- Sales by category
SELECT categories.categoryID, categories.categoryName, products.productName,
SUM("Order Details Extended".Sales_price_after_discount) AS productssales
FROM categories INNER JOIN(
    products INNER JOIN 
    (orders INNER JOIN "Order Details Extended" ON orders.orderID = "Order Details Extended".orderID)
    ON products.productID = "Order Details Extended".productID
) ON categories.categoryID = products.categoryID
GROUP BY categories.categoryID, categories.categoryName, products.productName
ORDER BY categories.categoryName;



--- *****************************Sales by year


WITH revenue AS (
    SELECT 
        EXTRACT(YEAR FROM orders.shippedDate) as Shipped_Date,
        orders.orderID, 
        ROUND(SUM(unitPrice * quantity * (1.0 - discount)), 2) AS Subtotal 
    FROM order_details
    JOIN orders 
        ON orders.orderID = order_details.orderID
    GROUP BY orders.orderID 
    ORDER BY orders.orderID
    ) 
SELECT Shipped_Date, SUM(Subtotal)
FROM revenue
WHERE Shipped_Date = 1996
GROUP BY Shipped_Date
ORDER BY Shipped_Date ASC;


WITH revenue AS (
    SELECT 
        EXTRACT(DAY FROM orders.shippedDate) as day,
        orders.orderID, 
        ROUND(SUM(unitPrice * quantity * (1.0 - discount)), 2) AS Subtotal 
    FROM order_details
    JOIN orders 
        ON orders.orderID = order_details.orderID
    GROUP BY orders.orderID 
    ORDER BY orders.orderID
    ) 
SELECT day, Subtotal, orderID
FROM revenue
WHERE day IS NOT NULL;



--- Products and categories
SELECT products.productName, categories.categoryID, categories.categoryName
FROM categories
INNER JOIN products ON products.categoryID=categories.categoryID
WHERE products.discontinued = 0
ORDER BY products.productName;






