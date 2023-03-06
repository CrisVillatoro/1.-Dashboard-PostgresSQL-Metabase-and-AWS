-----************************************************************
-- CATEGORIES
-----************************************************************
DROP TABLE IF EXISTS categories cascade;
CREATE TABLE categories(
    categoryID SERIAL PRIMARY KEY,
    categoryName VARCHAR(42),
    description VARCHAR(255),
    picture bytea
);


COPY categories FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/categories.csv'
DELIMITER ',' 
CSV HEADER; 

-----************************************************************
-- CUSTOMERS
-----************************************************************
DROP TABLE IF EXISTS customers cascade;
CREATE TABLE customers(
    customerID VARCHAR(20) PRIMARY KEY,
    companyName VARCHAR(150), 
    contactName VARCHAR(200),
    contactTitle VARCHAR(100),
    address VARCHAR(255), 
    city VARCHAR(50),
    region VARCHAR(50), 
    postalCode VARCHAR(50),
    country VARCHAR(20),
    phone VARCHAR(25),
    fax VARCHAR(25)
);

COPY customers FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/customers.csv'
DELIMITER ',' 
CSV HEADER; 

SELECT * FROM customers;

-----************************************************************
-- EMPLOYEES
-----************************************************************

DROP TABLE IF EXISTS employees cascade;
CREATE TABLE employees(
    employeeID INTEGER PRIMARY KEY,
    lastName VARCHAR,
    firstName VARCHAR,
    title VARCHAR,
    titleOfCourtesy VARCHAR,
    birthDate TIMESTAMP,
    hireDate TIMESTAMP, 
    address VARCHAR,
    city VARCHAR,
    region VARCHAR,
    postalCode VARCHAR,
    country VARCHAR,
    homePhone VARCHAR,
    extension INTEGER, 
    photo bytea,
    notes TEXT,
    resportsTo VARCHAR,
    photoPath VARCHAR
);

COPY employees FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/employees.csv'
DELIMITER ',' 
CSV HEADER; 

SELECT * FROM employees;


-----************************************************************
-- SHIPPERS
-----************************************************************

DROP TABLE IF EXISTS shippers cascade;
CREATE TABLE shippers(
    shipperID SERIAL PRIMARY KEY,
    companyName CHAR(20),
    phone VARCHAR(20)
);

COPY shippers FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/shippers.csv'
DELIMITER ',' 
CSV HEADER;

SELECT * FROM shippers;



-----************************************************************
-- ORDERS
-----************************************************************

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
    orderID INTEGER PRIMARY KEY,
    customerID VARCHAR(20),
    employeeID SERIAL,
    orderDate TIMESTAMP,
    requiredDate TIMESTAMP,
    shippedDate TIMESTAMP,
    shipVia INTEGER,
    freight NUMERIC,
    shipName VARCHAR(50),
    shipAddress VARCHAR(50),
    shipCity VARCHAR(50),
    shipRegion VARCHAR(50),
    shipPostalCode VARCHAR(50),
    shipCountry VARCHAR(20),
    FOREIGN KEY (customerID) REFERENCES customers(customerID),
    FOREIGN KEY (shipVia) REFERENCES shippers(shipperID),
    FOREIGN KEY (employeeID) REFERENCES employees(employeeID)
);

COPY orders FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/orders.csv'
DELIMITER ',' 
CSV HEADER NULL 'NULL';

SELECT * FROM orders;

-----************************************************************
-- SUPPLIERS
-----************************************************************

DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers(
    supplierID SERIAL PRIMARY KEY,
    companyName VARCHAR(255),
    contactName VARCHAR(255),
    contactTitle VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    region VARCHAR(255),
    postalCode VARCHAR(255),
    country VARCHAR(255),
    phone VARCHAR(255),
    fax VARCHAR(255),
    homePage TEXT
);

COPY suppliers FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/suppliers.csv'
DELIMITER ',' 
CSV HEADER;

-----************************************************************
-- PRODUCTS
-----************************************************************

DROP TABLE IF EXISTS products cascade;
CREATE TABLE products (
    productID SERIAL PRIMARY KEY, 
    productName VARCHAR(100) NOT NULL, 
    supplierID INTEGER,
    categoryID INTEGER, 
    quatityPerUnit VARCHAR(100),
    unitPrice NUMERIC,
    unitsInStock INTEGER,
    unitsOnOrder INTEGER,
    reorderLevel INTEGER,
    discontinued INTEGER,
    FOREIGN KEY (supplierID) REFERENCES suppliers (supplierID),
    FOREIGN KEY (categoryID) REFERENCES categories (categoryID)
);

\copy products FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/products.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM products;

-----************************************************************
-- ORDER DETAILS
-----************************************************************

DROP TABLE IF EXISTS order_details cascade;
CREATE TABLE order_details(
    orderID INTEGER NOT NULL,
    productID INTEGER,
    unitPrice NUMERIC, 
    quantity INTEGER,
    discount NUMERIC,
    FOREIGN KEY (orderID) REFERENCES orders (orderID),
    FOREIGN KEY (productID) REFERENCES products (productID)
);

COPY order_details FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/order_details.csv'
DELIMITER ',' 
CSV HEADER;

SELECT * FROM order_details;
-----************************************************************
-- REGIONS
-----************************************************************

DROP TABLE IF EXISTS regions cascade;
CREATE TABLE regions(
    regionID SERIAL PRIMARY KEY,
    regionDescription VARCHAR(255)
);

COPY regions FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/regions.csv'
DELIMITER ',' 
CSV HEADER;

SELECT * FROM regions;

-----************************************************************
-- TERRITORIES
-----************************************************************

DROP TABLE IF EXISTS territories cascade;
CREATE TABLE territories(
    territoryID SERIAL PRIMARY KEY, 
    territoryDescription VARCHAR(50),
    regionID INTEGER,
    FOREIGN KEY (regionID) REFERENCES regions (regionID)
);

COPY territories FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/territories.csv'
DELIMITER ',' 
CSV HEADER;

SELECT * FROM territories;

-----************************************************************
-- EMPLOYEES TERRITORIES
-----************************************************************

DROP TABLE IF EXISTS employee_territories cascade;
CREATE TABLE employee_territories(
    employeeID INTEGER,
    territoryID INTEGER NOT NULL,
    FOREIGN KEY (employeeID) REFERENCES employees (employeeID),
    FOREIGN KEY (territoryID) REFERENCES territories (territoryID)
);

COPY employee_territories FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/employee_territories_copy.csv'
DELIMITER ',' 
CSV HEADER NULL 'NULL'; 

SELECT * FROM employee_territories;

-----************************************************************
-- Country codes
-----************************************************************
DROP TABLE IF EXISTS country_code cascade;
CREATE TABLE country_code(
    country VARCHAR PRIMARY KEY,
    code VARCHAR
);

COPY country_code (country,code) FROM '/Users/CristaVillatoro/Desktop/tahini-tensor-student-code/week5/northwind_data_clean-master/data/country_code.csv'
DELIMITER ',' 
CSV HEADER NULL 'NULL'; 

SELECT * FROM country_code;

INSERT INTO country_code(country, code) VALUES('UK', 'UK');
SELECT * FROM country_code;