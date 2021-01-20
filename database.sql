/*CORAL HERNANDEZ*/

DROP TABLE Customer CASCADE CONSTRAINTS;
CREATE TABLE Customer
    (CustomerID INTEGER,
    CustomerName CHAR(40),
    CustomerAddress CHAR(60),
    CustomerCity CHAR(40),
    CustomerState CHAR(40),
    CustomerPostalCode CHAR(60), 
    CustomerEmail CHAR(60),
    CustomerUserName CHAR(40),
    CustomerPassword CHAR(60), 
    PRIMARY KEY(CustomerID));


DROP TABLE Territory CASCADE CONSTRAINTS;
CREATE TABLE Territory
    (TerritoryID INTEGER, 
    TerritoryName CHAR(60),
    PRIMARY KEY(TerritoryID));
    

DROP TABLE Salesperson CASCADE CONSTRAINTS;    
CREATE TABLE Salesperson
    (SalespersonID INTEGER, 
    SalespersonName CHAR(40),
    SalespersonPhone CHAR(40),
    SalespersonEmail CHAR(60),
    SalespersonUsername CHAR(40), 
    SalespersonPassword CHAR(60),
    TerritoryID INTEGER,
    PRIMARY KEY(SalespersonID),
    FOREIGN KEY(TerritoryID) REFERENCES Territory);

DROP TABLE DoesBusinessIn CASCADE CONSTRAINTS;
CREATE TABLE DoesBusinessIn
    (CustomerID INTEGER, 
    TerritoryID INTEGER, 
    FOREIGN KEY(CustomerID) REFERENCES Customer, 
    FOREIGN KEY(TerritoryID) REFERENCES Territory);

DROP TABLE ProductLine CASCADE CONSTRAINTS;
CREATE TABLE ProductLine
    (ProductLineID INTEGER,
    ProductLineName CHAR(60), 
    PRIMARY KEY(ProductLineID));
  

DROP TABLE Product CASCADE CONSTRAINTS;
CREATE TABLE Product
    (ProductID INTEGER, 
    ProductName CHAR(60),
    ProductFinish CHAR(40),
    ProductStandardPrice FLOAT,
    ProductLineID INTEGER, 
    PHOTO CHAR(60),
    PRIMARY KEY(ProductID), 
    FOREIGN KEY(ProductLineID) REFERENCES ProductLine);

DROP TABLE CustomerOrder CASCADE CONSTRAINTS;
CREATE TABLE CustomerOrder
    (OrderID INTEGER,
    OrderDate DATE, 
    CustomerID INTEGER, 
    PRIMARY KEY(OrderID),
    FOREIGN KEY(CustomerID) REFERENCES Customer);

DROP TABLE OrderLine CASCADE CONSTRAINTS;
CREATE TABLE OrderLine
    (OrderID INTEGER, 
    ProductID INTEGER, 
    OrderedQuantity INTEGER, 
    SalePrice FLOAT, 
    FOREIGN KEY(OrderID) REFERENCES CustomerOrder,
    FOREIGN KEY(ProductID) REFERENCES Product);

DROP TABLE PriceUpdate CASCADE CONSTRAINTS;
CREATE TABLE PriceUpdate
    (PriceUpdateID INTEGER, 
    DateChanged DATE,
    OldPrice FLOAT,
    NewPrice FLOAT,
    PRIMARY KEY(PriceUpdateID));
    
CREATE SEQUENCE se_update
MINVALUE 1
START WITH 1
INCREMENT BY 1;

/*View1*/
DROP VIEW ProductManagerSupport;
CREATE VIEW ProductManagerSupport(customerID, customerName, customerZipCode, productID, productName, productFinish, productPrice, productLineName, orderNumber, orderPlacementDate, orderQuantity) AS
    SELECT C.CustomerID, C.CustomerName, C.CustomerPostalCode, P.ProductID, P.ProductName, P.ProductFinish, P.ProductStandardPrice, PL.ProductLineName, O.OrderID, O.OrderDate, OL.OrderedQuantity
    FROM Customer C, Product P, ProductLine PL, CustomerOrder O, OrderLine OL
    WHERE C.CustomerID = O.CustomerID AND O.OrderID = OL.OrderID AND OL.ProductID = P.ProductID AND P.ProductLineID = PL.ProductLineID;

/*view 2*/
DROP VIEW Salescomparison;
CREATE VIEW SALESCOMPARISON(ProductId, ProductDescription, TotalSales)
AS SELECT O.ProductId, PR.ProductName, SUM(O.OrderedQuantity)
FROM OrderLine O INNER JOIN Product PR ON PR.ProductID=O.ProductID
GROUP BY O.ProductID, PR.ProductName;

SELECT * FROM Salescomparison;

/*view3*/
DROP VIEW TotalValueforProducts;
CREATE VIEW TotalValueforProducts(ProductName, TotalValue) 
AS SELECT PR.ProductName, (SUM(O.OrderedQuantity)*PR.ProductStandardPrice)
FROM OrderLine O INNER JOIN Product PR ON PR.ProductID=O.ProductID
GROUP BY O.ProductID, pr.productname, pr.productstandardprice;

/*view4*/
DROP VIEW CUSTOMERREPORT;
CREATE VIEW CUSTOMERREPORT(ProductName, ProductPrice)
AS SELECT PR.ProductName, PR.PRODUCTSTANDARDPRICE  
FROM DoesBusinessIn DBI, CustomerOrder O, OrderLine OL, Product PR
WHERE O.CustomerId=DBI.CustomerID AND O.OrderID=OL.OrderID AND OL.ProductID=Pr.ProductID;

/*view5*/
DROP VIEW CUSTOMERBYSTATE;
CREATE VIEW CUSTOMERBYSTATE(CustomerState, NumberofCustomers)
AS SELECT CS.CUSTOMERSTATE, COUNT(*)
FROM Customer CS
GROUP BY CS.CUSTOMERSTATE;

/*view6*/
DROP VIEW PURCHASEHISTORY;  
CREATE VIEW PURCHASEHISTORY(OrderDate, Quantity, Price, ProductName)
AS SELECT CO.ORDERDATE, OL.OrderedQuantity, PR.PRODUCTSTANDARDPRICE, PR.PRODUCTNAME
FROM OrderLine OL, CustomerOrder CO, Product PR
WHERE OL.OrderId=CO.OrderID AND OL.PRODUCTID=PR.PRODUCTID
ORDER BY CO.CUSTOMERID;

/* Insert Customer*/
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(1,'Contemporary Casuals', '1355 S Hines Blvd', 'Gainesville', 'FL', '32601-2871', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(2, 'Value Furnitures', '15145 S.W. 17th St.', 'Plano', 'TX', '75094-7734', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(3, 'Home Furnishings', '1900 Allard Ave', 'Albany', 'NY', '12209-1125','homefurnishings?@gmail.com', 'CUSTOMER1', 'CUSTOMER1#');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(4, 'Eastern Furniture', '1925 Beltline Rd.', 'Carteret', 'NJ', '07008-3188', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(5, 'Impressions', '5585 Westcott Ct.', 'Sacramento', 'CA', '94206-4056', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(6, 'Furniture Gallery', '325 Flatiron Dr.', 'Boulder', 'CO', '80514-4432', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(7, 'New Furniture', 'Palace Ave', 'Farmington', 'NM', '', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(8, 'Dunkins Furniture', '7700 Main St', 'Syracuse', 'NY', '31590', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(9, 'A Carpet', '434 Abe Dr', 'Rome', 'NY', '13440', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(12, 'Flanigan Furniture', 'Snow Flake Rd', 'Ft Walton Beach', 'FL', '32548', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(13, 'Ikards', '1011 S. Main St', 'Las Cruces', 'NM', '88001', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(14, 'Wild Bills', 'Four Horse Rd', 'Oak Brook', 'Il', '60522', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(15, 'Janet''s Collection', 'Janet Lane', 'Virginia Beach', 'VA', '10012', '', '', '');
INSERT INTO Customer(CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerState, CustomerPostalCode, CustomerEmail, CustomerUserName, CustomerPassword) VALUES(16, 'ABC Furniture Co.', '152 Geramino Drive', 'Rome', 'NY', '13440', '', '', '');

/* Territory */ 
INSERT INTO Territory(TerritoryID, TerritoryName) VALUES(1, 'SouthEast');
INSERT INTO Territory(TerritoryID, TerritoryName) VALUES(2, 'SouthWest');
INSERT INTO Territory(TerritoryID, TerritoryName) VALUES(3, 'NorthEast');
INSERT INTO Territory(TerritoryID, TerritoryName) VALUES(4, 'NorthWest');
INSERT INTO Territory(TerritoryID, TerritoryName) VALUES(5, 'Central');

/* Salesperson */
INSERT INTO Salesperson(SalespersonID, SalespersonName, SalespersonPhone, SalespersonEmail, SalespersonUserName, SalespersonPassword,TerritoryID) VALUES(1, 'Doug Henny', '8134445555', 'salesperson?@gmail.com', 'SALESPERSON', 'SALESPERSON#',1);
INSERT INTO Salesperson(SalespersonID, SalespersonName, SalespersonPhone, SalespersonEmail, SalespersonUserName, SalespersonPassword,TerritoryID) VALUES(2, 'Robert Lewis', '8139264006', '', '', '', 2);
INSERT INTO Salesperson(SalespersonID, SalespersonName, SalespersonPhone, SalespersonEmail, SalespersonUserName, SalespersonPassword,TerritoryID) VALUES(3, 'William Strong', '5053821212', '', '', '', 3);
INSERT INTO Salesperson(SalespersonID, SalespersonName, SalespersonPhone, SalespersonEmail, SalespersonUserName, SalespersonPassword,TerritoryID) VALUES(4, 'Julie Dawson', '4355346677', '', '', '', 4);
INSERT INTO Salesperson(SalespersonID, SalespersonName, SalespersonPhone, SalespersonEmail, SalespersonUserName, SalespersonPassword,TerritoryID) VALUES(5, 'Jacob Winslow', '2238973498', '', '', '', 5);

/* DoesBusinessIn */
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(1,1);
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(2,2);
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(3,3);
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(4,4);
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(5,5);
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(6,1);
INSERT INTO DoesBusinessIn(CustomerID, TerritoryID) VALUES(7,2);

/*Product Line*/
INSERT INTO ProductLine(ProductLineID, ProductLineName) VALUES(1, 'Cherry Tree');
INSERT INTO ProductLine(ProductLineID, ProductLineName) VALUES(2, 'Scandinavia');
INSERT INTO ProductLine(ProductLineID, ProductLineName) VALUES(3, 'Country Look');

/*Order*/
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1001, '21/Aug/16', 1);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1002, '21/Jul/16', 8);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1003, '22/ Aug/16', 15);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1004, '22/Oct/16', 5);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1005, '24/Jul/16', 3);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1006, '24/Oct/16', 2);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1007, '27/ Aug/16', 5);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1008, '30/Oct/16', 12);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1009, '05/Nov/16', 4);
INSERT INTO CustomerOrder(OrderID, OrderDate, CustomerID) VALUES(1010, '05/Nov/16', 1);

/* Product */
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(1, 'End Table', 'Cherry', 175, 1, 'table.jpg');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(2, 'Coffee Table', 'Natural Ash', 200, 2, '');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(3, 'Computer Desk', 'Natural Ash', 375, 2, '');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(4, 'Entertainment Center', 'Natural Maple', 650, 3, '');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(5, 'Writers Desk', 'Cherry', 325, 1, '');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(6, '8-Drawer Desk', 'White Ash', 750, 2, '');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(7, 'Dining Table', 'Natural Ash', 800, 2, '');
INSERT INTO Product(ProductID, ProductName, ProductFinish, ProductStandardPrice, ProductLineID, Photo) VALUEs(8, 'Computer Desk', 'Walnut', 250, 3, '');

/*  Order Line */
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1001, 1, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1001, 2, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1001, 4, 1, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1002, 3, 5, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1003, 3, 3, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1004, 6, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1004, 8, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1005, 4, 4, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1006, 4, 1, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1006, 5, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1006, 7, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1007, 1, 3, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1007, 2, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1008, 3, 3, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1008, 8, 3, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1009, 4, 2, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1009, 7, 3, '');
INSERT INTO OrderLine(OrderID, ProductID, OrderedQuantity, SalePrice) VALUES(1010, 8, 10, '');

/*Q3.1: Which products have a standard price of less than $ 275? 
PRODUCTNAME                                                 
------------------------------------------------------------
End Table                                                   
Coffee Table                                                
Computer Desk  
*/
SELECT PR.ProductName
FROM Product PR
WHERE PR.ProductStandardPrice < 275;

/*3.2: List the unit price, product name, and product ID for all products in the Product table. 
PRODUCTSTANDARDPRICE PRODUCTNAME                                                   PRODUCTID
-------------------- ------------------------------------------------------------ ----------
                 175 End Table                                                             1
                 200 Coffee Table                                                          2
                 375 Computer Desk                                                         3
                 650 Entertainment Center                                                  4
                 325 Writers Desk                                                          5
                 750 8-Drawer Desk                                                         6
                 800 Dining Table                                                          7
                 250 Computer Desk                                                         8
*/
SELECT PR.ProductStandardPrice, PR.ProductName, PR.ProductID
FROM Product PR;

/*3.3: What is the average standard price for all products in inventory? 
AVG(PR.PRODUCTSTANDARDPRICE)
----------------------------
                     440.625
*/
SELECT AVG(PR.ProductStandardPrice) AS AveragePrice
FROM Product PR;
    
/*3.4: How many different items were ordered on order number 1004? 
SUM(OL.ORDEREDQUANTITY)
-----------------------
                      4
*/
SELECT SUM(OL.OrderedQuantity) AS TotalItems
FROM OrderLine OL
WHERE OL.OrderID = '1004';

/*3.5: Which orders have been placed since 10/ 24/ 2010? 
   ORDERID
----------
      1001
      1002
      1003
      1004
      1005
      1006
      1007
      1008
      1009
      1010
*/
SELECT O.OrderID
FROM CustomerOrder O
WHERE O.OrderDate BETWEEN '24/Oct/2010' AND '29/Dec/2020';

/*3.6: SELECT PR.ProductName
PRODUCTNAME                                                 
------------------------------------------------------------
Coffee Table                                                
Computer Desk                                               
Entertainment Center                                        
8-Drawer Desk                                               
Dining Table                                                
Computer Desk                                               
*/
SELECT PR.ProductName
FROM Product PR
WHERE PR.ProductFinish NOT LIKE 'Cherry%';

/*3.7: ist product name, finish, and standard price for all desks and all tables that cost more than $ 300 in the Product table. 
PRODUCTNAME                                                  PRODUCTFINISH                            PRODUCTSTANDARDPRICE
------------------------------------------------------------ ---------------------------------------- --------------------
Computer Desk                                                Natural Ash                                               375
Entertainment Center                                         Natural Maple                                             650
Writers Desk                                                 Cherry                                                    325
8-Drawer Desk                                                White Ash                                                 750
Dining Table                                                 Natural Ash                                               800
*/
SELECT PR.ProductName, PR.ProductFinish, PR.ProductStandardPrice
FROM Product PR
WHERE PR.ProductStandardPrice > 300;

/*3.8: Which products in the Product table have a standard price between $ 200 and $ 300? 
PRODUCTNAME                                                 
------------------------------------------------------------
Coffee Table                                                
Computer Desk                                               
*/
SELECT PR.ProductName
FROM Product PR
WHERE PR.ProductStandardPrice BETWEEN 200 AND 300;

/*3.9: List customer, city, and state for all customers in the Customer table whose address is Florida, Texas, California, or Hawaii. List the customers alphabetically by state and alphabetically by customer within each state. 
CUSTOMERNAME                             CUSTOMERCITY                             CUSTOMERSTATE                           
---------------------------------------- ---------------------------------------- ----------------------------------------
Contemporary Casuals                     Gainesville                              FL                                      
Flanigan Furniture                       Ft Walton Beach                          FL                                      
Impressions                              Sacramento                               CA                                      
Value Furnitures                         Plano                                    TX                                      
*/
SELECT C.CustomerName, C.CustomerCity, C.CustomerState FROM Customer C
WHERE C.CustomerState='FL'OR C.CustomerState='TX' OR C.CustomerState='CA' OR C.CustomerState='HI'
ORDER BY C.CustomerName;

/*3.10: Count the number of customers with addresses in each state to which we ship. 
CUSTOMERSTATE                              COUNT(*)
---------------------------------------- ----------
CO                                                1
NM                                                2
FL                                                2
NY                                                4
Il                                                1
VA                                                1
TX                                                1
CA                                                1
NJ                                                1
*/
SELECT C.CustomerState, COUNT(*)
FROM Customer C
GROUP BY C.CustomerState;

/*3.11: Count the number of customers with addresses in each city to which we ship. List the cities by state. 
CUSTOMERSTATE                            CUSTOMERCITY                             NUMBEROFCUSTOMERS
---------------------------------------- ---------------------------------------- -----------------
CA                                       Sacramento                                               1
CO                                       Boulder                                                  1
FL                                       Ft Walton Beach                                          1
FL                                       Gainesville                                              1
Il                                       Oak Brook                                                1
NJ                                       Carteret                                                 1
NM                                       Farmington                                               1
NM                                       Las Cruces                                               1
NY                                       Albany                                                   1
NY                                       Rome                                                     2
NY                                       Syracuse                                                 1
*/
SELECT C.CustomerState, C.CustomerCity, COUNT(*) AS NumberofCustomers
FROM Customer C
GROUP BY C.CustomerCity, C.CustomerState
ORDER BY C.CustomerState;

/*3.12: Find only states with more than one customer. 
CUSTOMERSTATE                           
----------------------------------------
NM                                      
FL                                      
NY                                      
*/
SELECT C.CustomerState
FROM Customer C
GROUP BY C.CustomerState
HAVING 1 < COUNT(C.CustomerID);

/*3.13: List, in alphabetical order, the product finish and the average standard price for each finish for selected finishes having an average standard price less than 750. 
PRODUCTFINISH                            AVERAGEPRICE
---------------------------------------- ------------
Walnut                                            250
Natural Maple                                     650
Natural Ash                                458.333333
Cherry                                            250
*/
SELECT PR.ProductFinish, AVG(PR.ProductStandardPrice) AS AveragePrice
FROM Product PR
GROUP BY PR.ProductFinish
HAVING AVG(PR.ProductStandardPrice) < 750;

/*3.14: What is the total value of orders placed for each furniture product? 
PRODUCTNAME                                                  TOTALVALUE
------------------------------------------------------------ ----------
8-Drawer Desk                                                      1500
Writers Desk                                                        650
Computer Desk                                                      3750
End Table                                                           875
Computer Desk                                                      4125
Dining Table                                                       4000
Coffee Table                                                        800
Entertainment Center                                               5200
*/
SELECT PR.ProductName, SUM(O.OrderedQuantity)*PR.ProductStandardPrice AS TotalValue
FROM OrderLine O INNER JOIN Product PR
ON O.ProductID=PR.ProductID
GROUP BY PR.ProductName, O.ProductID, PR.ProductStandardPrice;


/*Create Procedure*/
CREATE OR REPLACE PROCEDURE ProductLineSales
AS 
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABlE Product ADD SalePrice DECIMAL(6,2)';
    
    EXECUTE IMMEDIATE 'UPDATE Product SET SalePrice = 
    (
        CASE 
            WHEN ProductStandardPrice >= 400 THEN ProductStandardPrice-(ProductStandardPrice*.1)
            ELSE ProductStandardPrice-(ProductStandardPrice*.15)
        END
    )';
END;  

/*Create Trigger*/
CREATE OR REPLACE TRIGGER StandardPriceUpdate
AFTER UPDATE OF ProductStandardPrice ON Product FOR EACH ROW
BEGIN
    INSERT INTO PriceUpdate VALUES (se_update.nextval, SYSDATE, :old.ProductStandardPrice, :new.ProductStandardPrice);
END;

UPDATE Product
SET ProductStandardPrice = 666
WHERE ProductID = 5;

SELECT * FROM PriceUpdate;
