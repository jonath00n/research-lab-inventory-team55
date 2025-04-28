/*to select all the items*/
SELECT * FROM Inventory_Tracker.items;

/*selecting certain items where quantity is a certain number*/
SELECT * FROM items
WHERE Quantity < 100; /*can change the quantity*/

/*pulling a certain amount of items and counting their quantities and putting in descending order*/
SELECT Name, Quantity
FROM items
ORDER BY Quantity DESC
LIMIT 10; /*can change this number 

/*updating the quantity of a certain item*/
UPDATE items
SET Quantity = 100 /*can change the quantity*/
WHERE Id = 1; /*can change the Id num*/

DELETE FROM items
WHERE Id = 67;

/*adding a new item to the inventory*/
INSERT INTO items (Name, Description, CategoryID, Quantity, Unit, Location, Supplier, returnable)
VALUES ('Breadboard', 'Used for prototyping circuits', 'Basic Electronic Components', 75, 'pieces', 'Bin D', 'Texas Instruments', 1);

/*update item quantity after restocking*/
UPDATE items SET Quantity = Quantity + 50 WHERE Name = 'Resistors (1kΩ)';


