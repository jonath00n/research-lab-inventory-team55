SELECT * FROM Inventory_Tracker.orders;

/*find orders by a specific user*/
SELECT * FROM orders WHERE id = 5; /*can change the id number 

/*count total orders*/
SELECT COUNT(*) AS TotalOrders FROM orders;

/*find orders placed on a specific date: can change date*/
/*SELECT * FROM orders WHERE timestamp = '2025-03-03';

/*adding in a new order*/
INSERT INTO orders (item_id, item_name, returnable, quantity, user_name, user_email, timestamp)
VALUES (1, 'Resistors (1kΩ)', 0, 2, 'Lizzett Tapia', 'liztap06@gmail.com', NOW());

/*listing all order for a specific user*/
SELECT * FROM orders WHERE user_email = 'liztap06@gmail.com';

/*delete an orders entry*/
DELETE FROM orders WHERE id = 4; /*can change the id 

