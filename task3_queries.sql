
-- Create fixed table with correct types
CREATE TABLE online_retail_fixed (
  InvoiceNo TEXT,
  StockCode TEXT,
  Description TEXT,
  Quantity INTEGER,
  InvoiceDate TEXT,
  UnitPrice REAL,
  CustomerID REAL,
  Country TEXT
);

-- Copy data from original table
INSERT INTO online_retail_fixed
SELECT * FROM online_retail_cleaned;

-- Drop original table
DROP TABLE online_retail_cleaned;

-- Rename the fixed table to original name
ALTER TABLE online_retail_fixed RENAME TO online_retail;

-- Preview first 10 rows
SELECT * FROM online_retail LIMIT 10;

-- Top 10 bestselling products
SELECT Description, SUM(Quantity) AS TotalSold
FROM online_retail
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10;

-- Top-selling item in December 2010 (subquery example)
SELECT Description, TotalSold FROM (
  SELECT Description, SUM(Quantity) AS TotalSold
  FROM online_retail
  WHERE InvoiceDate LIKE '2010-12%'
  GROUP BY Description
) 
ORDER BY TotalSold DESC
LIMIT 1;

-- Monthly revenue
SELECT substr(InvoiceDate, 1, 7) AS Month,
       ROUND(SUM(UnitPrice * Quantity), 2) AS Revenue
FROM online_retail
GROUP BY Month
ORDER BY Month;

-- Create view for country-wise revenue
CREATE VIEW CountryRevenue AS
SELECT Country,
       ROUND(SUM(UnitPrice * Quantity), 2) AS Revenue
FROM online_retail
GROUP BY Country;

-- Query the created view-Selecting top 5 countries by revenue
SELECT * FROM CountryRevenue ORDER BY Revenue DESC;



-- Create indexes to optimize queries-Index on CustomerID
CREATE INDEX idx_customer ON online_retail(CustomerID);
-- Create indexes to optimize queries-Index on InvoiceNo
CREATE INDEX idx_invoice ON online_retail(InvoiceNo);
