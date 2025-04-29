SELECT * FROM Inventory_Tracker.suppliers;

SELECT * FROM suppliers
WHERE SupplierName = 'Digikey Electronics';

SELECT 
    (SELECT COUNT(*) FROM users) AS TotalUsers,
    (SELECT COUNT(*) FROM items) AS TotalItems,
    (SELECT COUNT(*) FROM category) AS TotalCategories;
    
    SHOW TABLES;



