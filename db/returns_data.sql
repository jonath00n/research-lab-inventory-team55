/*MySQL query to create returns table*/
CREATE TABLE returns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id VARCHAR(50),
    item_name VARCHAR(50),
    email VARCHAR(100),
    check_out_date DATE,
    return_date DATE
);

SELECT * FROM Inventory_Tracker.returns;
ALTER TABLE returns
ADD COLUMN quantity VARCHAR(50);


