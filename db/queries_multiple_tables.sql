/*running queries using two or more database tables*/

/*for item and supplier: counting total quantity of items under each supplier*/
SELECT Supplier, SUM(Quantity) AS TotalQuantity
FROM items
GROUP BY Supplier;

/*item and supplier: pulling items that belong to a certain supplier */
SELECT items.Name AS ItemName, suppliers.SupplierName
FROM items
JOIN suppliers ON items.Supplier = suppliers.SupplierName
WHERE suppliers.SupplierName = 'Texas Instruments'; /*can change su

/*listing all items from a specific category: can change the category*/
SELECT * FROM items WHERE categoryID = 'Basic Electronic Components';

/*count items per category*/
SELECT categoryID, COUNT(*) AS TotalItems 
FROM items 
GROUP BY CategoryID;

/*join users w orders*/
SELECT u.FirstName, u.LastName, u.Role, o.QuantityOrdered, o.OrderDate 
FROM users u
JOIN orders o ON u.Id = o.UserID;

/*count total orders placed by each user*/
SELECT u.FirstName, u.LastName, COUNT(o.OrderID) AS TotalOrders 
FROM users u
JOIN orders o ON u.Id = o.UserID
GROUP BY u.Id, u.FirstName, u.LastName;

/*find items ordered along w quantity and date*/
SELECT i.Name AS ItemName, o.QuantityOrdered, o.OrderDate 
FROM items i
JOIN orders o ON i.Id = o.ItemID;


/*find total quantity ordered per item*/
SELECT i.Name AS ItemName, SUM(o.QuantityOrdered) AS TotalOrdered 
FROM items i
JOIN orders o ON i.Id = o.ItemID
GROUP BY i.Id, i.Name;

/*list items along w their categories*/
SELECT i.Name AS ItemName, c.CategoryName 
FROM items i
JOIN category c ON i.CategoryID = c.CategoryName;

/*list items aling w their suppliers*/
SELECT i.Name AS ItemName, s.SupplierName 
FROM items i
JOIN suppliers s ON i.Supplier = s.SupplierName;

/*find detailed order information*/
SELECT u.FirstName, u.LastName, i.Name AS ItemName, o.QuantityOrdered, o.OrderDate 
FROM orders o
JOIN users u ON o.UserID = u.Id
JOIN items i ON o.ItemID = i.Id;

/*find total items ordered by each user*/
SELECT u.FirstName, u.LastName, SUM(o.QuantityOrdered) AS TotalItemsOrdered 
FROM orders o
JOIN users u ON o.UserID = u.Id
GROUP BY u.Id, u.FirstName, u.LastName;

/*find orders w item details and associated category*/
SELECT o.OrderID, u.FirstName, u.LastName, i.Name AS ItemName, c.CategoryName, o.QuantityOrdered, o.OrderDate 
FROM orders o
JOIN users u ON o.UserID = u.Id
JOIN items i ON o.ItemID = i.Id
JOIN category c ON i.CategoryID = c.CategoryName;

/*find total orders per category*/
SELECT c.CategoryName, COUNT(o.OrderID) AS TotalOrders 
FROM orders o
JOIN items i ON o.ItemID = i.Id
JOIN category c ON i.CategoryID = c.CategoryName
GROUP BY c.CategoryName;






