/*MySQL query to create cart table*/
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100),
    item_id VARCHAR(50),
    quantity VARCHAR(50)
);

SELECT * FROM Inventory_Tracker.cart;