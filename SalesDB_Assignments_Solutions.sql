/* =====================================================================
   SQL & RELATIONAL DATABASE DESIGN - Combined Student Assignment Pack
   Student: ______________________________   Group: ______________
   DBMS   : MySQL 8.x / MariaDB (alternative syntax is given in comments
            where SQL Server / PostgreSQL / SQLite differ)

   CONTENTS
     PART 0 - Database setup (CREATE TABLE + sample INSERTs + checks)
     PART I - Ten foundational SQL tasks
     PART II- Assignment 1 (7 tasks), Assignment 2 (9 tasks),
              Assignment 3 (12 tasks)  = 28 scenario solutions
     (Assignments 4 and 5 are ERD projects - see the separate PDF/PNG files.)
   ===================================================================== */


/* =====================================================================
   PART 0 - DATABASE SETUP
   ===================================================================== */

DROP DATABASE IF EXISTS SalesDB;
CREATE DATABASE SalesDB;
USE SalesDB;

-- A. Create the four tables (parents first, child table Orders last) ----

CREATE TABLE Customers (
    CustomerID  INTEGER      NOT NULL,
    FirstName   VARCHAR(50)  NOT NULL,
    LastName    VARCHAR(50)  NOT NULL,
    Country     VARCHAR(50),
    Score       INTEGER,
    CONSTRAINT pk_customers PRIMARY KEY (CustomerID)
);

CREATE TABLE Products (
    ProductID   INTEGER        NOT NULL,
    Product     VARCHAR(100)   NOT NULL,
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    CONSTRAINT pk_products PRIMARY KEY (ProductID)
);

CREATE TABLE Employees (
    EmployeeID  INTEGER        NOT NULL,
    FirstName   VARCHAR(50)    NOT NULL,
    LastName    VARCHAR(50)    NOT NULL,
    Department  VARCHAR(50),
    BirthDate   DATE,
    Gender      VARCHAR(10),
    Salary      DECIMAL(10,2),
    ManagerID   INTEGER,                         -- optional (NULL = no manager)
    CONSTRAINT pk_employees PRIMARY KEY (EmployeeID),
    CONSTRAINT fk_employees_manager
        FOREIGN KEY (ManagerID) REFERENCES Employees (EmployeeID)   -- self-reference
);

CREATE TABLE Orders (
    OrderID        INTEGER        NOT NULL,
    ProductID      INTEGER        NOT NULL,
    CustomerID     INTEGER        NOT NULL,
    SalesPersonID  INTEGER        NOT NULL,
    OrderDate      DATE,
    ShipDate       DATE,                          -- NULL = not shipped yet
    OrderStatus    VARCHAR(30),
    ShipAddress    VARCHAR(150),
    BillAddress    VARCHAR(150),
    Quantity       INTEGER,
    Sales          DECIMAL(10,2),
    CreationTime   DATETIME,
    CONSTRAINT pk_orders PRIMARY KEY (OrderID),
    CONSTRAINT fk_orders_product   FOREIGN KEY (ProductID)     REFERENCES Products  (ProductID),
    CONSTRAINT fk_orders_customer  FOREIGN KEY (CustomerID)    REFERENCES Customers (CustomerID),
    CONSTRAINT fk_orders_employee  FOREIGN KEY (SalesPersonID) REFERENCES Employees (EmployeeID)
);

-- C. Insert sample data (the given rows + extra test rows) --------------

INSERT INTO Customers (CustomerID, FirstName, LastName, Country, Score) VALUES
(1, 'Ayla',   'Karimova', 'Azerbaijan', 720),
(2, 'John',   'Miller',   'USA',        450),
(3, 'Emma',   'Schmidt',  'Germany',    860),
(4, 'Sara',   'Martin',   'France',     280),
(5, 'Lukas',  'Weber',    'Germany',    550),
-- extra test rows
(6, 'Nigar',  'Aliyeva',  'Azerbaijan', 610),
(7, 'Tom',    'Becker',   'USA',        390),   -- will have no orders
(8, 'Claire', 'Dubois',   'France',     520);

INSERT INTO Products (ProductID, Product, Category, Price) VALUES
(101, 'Wireless Mouse',    'Electronics', 55.00),
(102, 'Office Chair',      'Furniture',   230.00),
(103, 'Laptop',            'Electronics', 850.00),
(104, 'Notebook',          'Stationery',  12.00),
(105, 'Smart Phone',       'Electronics', 420.00),
-- extra test rows
(106, 'Standing Desk',     'Furniture',   640.00),
(107, 'Desk Lamp',         'Furniture',   45.00),   -- will have no orders
(108, 'Bluetooth Speaker', 'Electronics', 120.00);

-- Manager (12) is inserted first so that the self-referencing FK is valid
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(12, 'Maya',  'Brown',    'Sales',   '1985-07-22', 'Female', 2400.00, NULL),
(11, 'David', 'Lee',      'Sales',   '1990-03-14', 'Male',   2200.00, 12),
(13, 'Alex',  'Green',    'Support', '1992-11-05', 'Male',   1900.00, 12),
(14, 'Leyla', 'Hasanova', 'Sales',   '1994-02-18', 'Female', 2100.00, 12);

INSERT INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus,
 ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
-- the four given rows
(201, 101, 1, 11, '2026-10-04', '2026-10-06', 'Delivered', '12 Nizami St, Baku',        '12 Nizami St, Baku',        2,  110.00, '2026-10-04 09:15:00'),
(202, 103, 3, 12, '2026-10-08', '2026-10-10', 'Shipped',   '8 Hauptstrasse, Berlin',    '8 Hauptstrasse, Berlin',    1,  850.00, '2026-10-08 11:40:00'),
(203, 102, 2, 11, '2026-10-12', NULL,         'Pending',   '77 Broadway, New York',     '77 Broadway, New York',     1,  230.00, '2026-10-12 14:05:00'),
(204, 105, 5, 12, '2026-10-15', '2026-10-17', 'Delivered', '3 Marktplatz, Munich',      '3 Marktplatz, Munich',      1,  420.00, '2026-10-15 10:20:00'),
-- extra test rows (OrderIDs 105 and 110 are required by Assignment 2)
(105, 104, 6, 14, '2026-10-02', NULL,         'Pending',   '9 Fuzuli St, Baku',         '9 Fuzuli St, Baku',        10,  120.00, '2026-10-02 08:30:00'),
(110, 108, 8, 14, '2026-10-20', '2026-10-22', 'Shipped',   '5 Rue de Rivoli, Paris',    '5 Rue de Rivoli, Paris',    3,  360.00, '2026-10-20 16:45:00'),
(205, 106, 3, 12, '2026-09-25', '2026-10-05', 'Delivered', '8 Hauptstrasse, Berlin',    '8 Hauptstrasse, Berlin',    1,  640.00, '2026-09-25 13:10:00'),
(206, 103, 3, 12, '2026-10-21', '2026-11-02', 'Shipped',   '8 Hauptstrasse, Berlin',    '8 Hauptstrasse, Berlin',    5, 4250.00, '2026-10-21 09:00:00'),
(207, 101, 6, 11, '2026-11-03', NULL,         'Pending',   '9 Fuzuli St, Baku',         '9 Fuzuli St, Baku',         3,  165.00, '2026-11-03 12:25:00'),
(208, 105, 8, 14, '2026-10-28', '2026-10-30', 'Delivered', '5 Rue de Rivoli, Paris',    '5 Rue de Rivoli, Paris',    2,  840.00, '2026-10-28 15:50:00'),
(209, 102, 1, 11, '2026-10-30', '2026-11-01', 'Delivered', '12 Nizami St, Baku',        '12 Nizami St, Baku',        4,  920.00, '2026-10-30 10:05:00');

-- D. Verify every table --------------------------------------------------
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Orders;


/* =====================================================================
   PART I - TEN FOUNDATIONAL SQL TASKS
   ===================================================================== */

-- Task 1 (a): Explore a table - all columns
SELECT * FROM Customers;

-- Task 1 (b): only selected columns
SELECT FirstName, LastName, Country
FROM Customers;

-- Task 2: Customers from Germany
SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';

-- Task 3: Score >= 300 AND (Germany OR France); show their scores
SELECT CustomerID, FirstName, LastName, Country, Score
FROM Customers
WHERE Score >= 300
  AND Country IN ('Germany', 'France');

-- Task 4: Products sorted from most to least expensive
SELECT ProductID, Product, Category, Price
FROM Products
ORDER BY Price DESC;

-- Task 5: Products costing between 50 and 300 (BETWEEN is inclusive)
SELECT Product, Price
FROM Products
WHERE Price BETWEEN 50 AND 300;

-- Task 6: Product names containing the word "Phone"
SELECT Product, Category
FROM Products
WHERE Product LIKE '%Phone%';

-- Task 7: Unique categories in alphabetical order
SELECT DISTINCT Category
FROM Products
ORDER BY Category;

-- Task 8: Each OrderID together with the customer's first and last name
SELECT o.OrderID, c.FirstName, c.LastName
FROM Orders AS o
INNER JOIN Customers AS c
        ON c.CustomerID = o.CustomerID;

-- Task 9: Number of orders and total Sales per OrderStatus (highest total first)
SELECT OrderStatus,
       COUNT(*)   AS OrderCount,
       SUM(Sales) AS TotalSales
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;

-- Task 10: Safe data change (insert -> update -> verify -> delete)
-- 10.1 Insert a new product with an unused ID (900)
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (900, 'USB Cable', 'Electronics', 9.99);

-- 10.2 Update ONLY its price
UPDATE Products
SET    Price = 14.99
WHERE  ProductID = 900;

-- 10.3 Verify the update
SELECT * FROM Products WHERE ProductID = 900;      -- Price must be 14.99

-- 10.4 Delete ONLY that new product
DELETE FROM Products
WHERE  ProductID = 900;

-- 10.5 Verify the deletion (must return 0 rows)
SELECT * FROM Products WHERE ProductID = 900;

/* Explanation: UPDATE and DELETE act on EVERY row that satisfies the WHERE
   condition. Without a WHERE clause they apply to the WHOLE table - e.g.
   "UPDATE Products SET Price = 14.99;" would change the price of all
   products, and "DELETE FROM Products;" would remove all products. The WHERE
   clause (preferably on the primary key) limits the change to the intended
   row(s). Always preview with SELECT using the same WHERE first. */


/* =====================================================================
   PART II - ASSIGNMENT 1: CUSTOMER LOYALTY AND SALES ANALYSIS
   ===================================================================== */

-- Assignment 1, Task 1: High-score customers
-- Customers with Score > 500, best score first.
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score > 500
ORDER BY Score DESC;

-- Assignment 1, Task 2: Target countries
-- Germany, France or USA customers with Score >= 300 (candidates for promotions).
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Country IN ('Germany', 'France', 'USA')
  AND Score >= 300;

-- Assignment 1, Task 3: Purchase history
-- INNER JOIN keeps only customers that really have orders.
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,   -- SQL Server/SQLite: c.FirstName + ' ' + c.LastName  /  ||
       o.OrderID,
       o.OrderDate,
       o.Sales
FROM Customers AS c
INNER JOIN Orders AS o
        ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate;

-- Assignment 1, Task 4: Inactive customers
-- LEFT JOIN keeps all customers; no matching order => o.OrderID IS NULL.
SELECT c.CustomerID, c.FirstName, c.LastName, c.Country
FROM Customers AS c
LEFT JOIN Orders AS o
       ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;

-- Assignment 1, Task 5: Total spending per customer (only customers with >= 1 order)
SELECT c.CustomerID,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       SUM(o.Sales)                         AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o
        ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSales DESC;

-- Assignment 1, Task 6: Loyalty threshold
-- HAVING filters AFTER aggregation (WHERE cannot filter on SUM()).
SELECT c.CustomerID,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       SUM(o.Sales)                         AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o
        ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > 1000
ORDER BY TotalSales DESC;

-- Assignment 1, Task 7: Top-five customers by total spending
-- MySQL/PostgreSQL/SQLite: LIMIT 5   |   SQL Server: SELECT TOP 5 ...
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
       c.Country,
       SUM(o.Sales)                         AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o
        ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSales DESC
LIMIT 5;


/* =====================================================================
   PART II - ASSIGNMENT 2: ORDER AND DELIVERY INVESTIGATION
   ===================================================================== */

-- Assignment 2, Task 1: October 2026 orders (inclusive range)
SELECT OrderID, CustomerID, OrderDate, ShipDate, OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY OrderDate;

-- Assignment 2, Task 2: Pending queue, oldest first
SELECT *
FROM Orders
WHERE OrderStatus = 'Pending'
ORDER BY OrderDate ASC;

-- Assignment 2, Task 3: Late shipments (ShipDate more than 7 days after OrderDate)
-- MySQL      : DATEDIFF(ShipDate, OrderDate) > 7
-- SQL Server : DATEDIFF(day, OrderDate, ShipDate) > 7
-- PostgreSQL : (ShipDate - OrderDate) > 7
-- SQLite     : julianday(ShipDate) - julianday(OrderDate) > 7
-- Unshipped orders (ShipDate IS NULL) give NULL and are automatically excluded.
SELECT o.OrderID,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderDate,
       o.ShipDate
FROM Orders AS o
INNER JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
WHERE DATEDIFF(o.ShipDate, o.OrderDate) > 7;

-- Assignment 2, Task 4: Customers affected by the delayed orders of Task 3
-- DISTINCT: a customer with several late orders is listed only once.
SELECT DISTINCT
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       c.Country
FROM Orders AS o
INNER JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
WHERE DATEDIFF(o.ShipDate, o.OrderDate) > 7;

-- Assignment 2, Task 5: Status correction for OrderID 105
-- 5.1 Preview the row first
SELECT OrderID, OrderStatus, ShipDate FROM Orders WHERE OrderID = 105;
-- 5.2 Update only this order
UPDATE Orders
SET    OrderStatus = 'Shipped',
       ShipDate    = '2026-11-05'
WHERE  OrderID = 105;
-- 5.3 Verify
SELECT OrderID, OrderStatus, ShipDate FROM Orders WHERE OrderID = 105;

-- Assignment 2, Task 6: Address correction for OrderID 110
SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;      -- preview
UPDATE Orders
SET    ShipAddress = '45 Main Street, Baku'
WHERE  OrderID = 110;
SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;      -- verify

-- Assignment 2, Task 7: Remove the temporary test record OrderID 999
-- 7.0 Prepare the practice copy: create the temporary test order (999 must exist)
INSERT INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus,
 ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES
(999, 101, 1, 11, '2026-10-31', NULL, 'Test', 'TEST', 'TEST', 1, 0.00, '2026-10-31 23:59:00');
-- 7.1 Preview
SELECT * FROM Orders WHERE OrderID = 999;
-- 7.2 Delete only this row
DELETE FROM Orders
WHERE  OrderID = 999;
-- 7.3 Verify (0 rows expected)
SELECT * FROM Orders WHERE OrderID = 999;

-- Assignment 2, Task 8: Status distribution
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

-- Assignment 2, Task 9: Unshipped orders (ShipDate IS NULL - never "= NULL")
SELECT o.OrderID,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderDate,
       o.OrderStatus
FROM Orders AS o
INNER JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
WHERE o.ShipDate IS NULL;


/* =====================================================================
   PART II - ASSIGNMENT 3: PRODUCTS AND EMPLOYEE PERFORMANCE
   ===================================================================== */

-- Assignment 3, Task 1: Affordable products (50-300 inclusive), cheapest first
SELECT Product, Category, Price
FROM Products
WHERE Price BETWEEN 50 AND 300
ORDER BY Price ASC;

-- Assignment 3, Task 2: Premium electronics (Price > 500)
SELECT *
FROM Products
WHERE Category = 'Electronics'
  AND Price > 500;

-- Assignment 3, Task 3: Product sales (product name, category, quantity, sales)
SELECT p.Product, p.Category, o.Quantity, o.Sales
FROM Products AS p
INNER JOIN Orders AS o
        ON o.ProductID = p.ProductID;

-- Assignment 3, Task 4: Best-selling products - top five by total Quantity
SELECT p.ProductID,
       p.Product,
       SUM(o.Quantity) AS TotalQuantity
FROM Products AS p
INNER JOIN Orders AS o
        ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.Product
ORDER BY TotalQuantity DESC
LIMIT 5;                                   -- SQL Server: SELECT TOP 5 ...

-- Assignment 3, Task 5: Unsold items (products with no order)
-- LEFT JOIN + IS NULL on the child key keeps products without orders.
SELECT p.ProductID, p.Product, p.Category, p.Price
FROM Products AS p
LEFT JOIN Orders AS o
       ON o.ProductID = p.ProductID
WHERE o.OrderID IS NULL;

-- Assignment 3, Task 6: Employee performance (EmployeeID = SalesPersonID)
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Department,
       SUM(o.Sales)                         AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o
        ON o.SalesPersonID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department;

-- Assignment 3, Task 7: Top-performing staff (total Sales > 5000), highest first
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Department,
       SUM(o.Sales)                         AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o
        ON o.SalesPersonID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department
HAVING SUM(o.Sales) > 5000
ORDER BY TotalSales DESC;

-- Assignment 3, Task 8: Register a new product (ID 501 is unused)
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (501, 'Wireless Keyboard', 'Electronics', 75.00);

-- Assignment 3, Task 9: Price correction 75 -> 90 for ProductID 501 only
UPDATE Products
SET    Price = 90.00
WHERE  ProductID = 501;
SELECT * FROM Products WHERE ProductID = 501;      -- verify

-- Assignment 3, Task 10: Add an integer inventory column
ALTER TABLE Products
ADD COLUMN StockQuantity INTEGER;                  -- SQL Server: ADD StockQuantity INT;
SELECT * FROM Products;                            -- verify (new column is NULL for all rows)

-- Assignment 3, Task 11: Combined directory of unique names (Customers + Employees)
-- UNION removes duplicate rows; UNION ALL would keep them.
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees;

-- Assignment 3, Task 12: Category performance - categories with total Sales > 2000
-- WHERE cannot filter aggregates, so HAVING is used.
SELECT p.Category,
       SUM(o.Quantity) AS TotalQuantity,
       SUM(o.Sales)    AS TotalSales
FROM Products AS p
INNER JOIN Orders AS o
        ON o.ProductID = p.ProductID
GROUP BY p.Category
HAVING SUM(o.Sales) > 2000
ORDER BY TotalSales DESC;

-- ============================ END OF FILE ============================
