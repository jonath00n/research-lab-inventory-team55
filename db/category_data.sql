SELECT * FROM Inventory_Tracker.category;

/*counting the total num of categories: should return 5*/
SELECT COUNT(*) AS TotalCategories FROM category;


/*in case I rereun the category table code and it add 5 more of the same category, can delete the new ones added*/
DELETE FROM Inventory_Tracker.category
WHERE CategoryID >= 6;

