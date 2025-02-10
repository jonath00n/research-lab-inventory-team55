import sqlite3 #importing sqlite3 librayr, which allows interaction btwn the SQLIte databses 

#Connect to SQLite database
conn = sqlite3.connect('inventoryTracker2.db') #connecting to the SQLite database. if file doesnt exist, then it'll be created
cur = conn.cursor() #creating cursor object, cur, which helps execute SQL commands for the database

#Create the Suppliers table if it does not exists, with all info of SupplierId, SUpplierName, phone number, and email 
cur.execute('''
    CREATE TABLE IF NOT EXISTS Suppliers (
        SupplierID INTEGER PRIMARY KEY AUTOINCREMENT,
        SupplierName TEXT NOT NULL,
        PhoneNumber TEXT,
        Email TEXT
    )
''')

suppliers = [ #List of suppliers with sample contact information
    ("Digikey Electronics", "1-800-344-4539", "support@digikey.com"),
    ("Texas Instruments", "1-800-336-5236", "support@ti.com"),
    ("Mouser Electronics", "1-800-346-6873", "info@mouser.com"),
    ("Farnell (Newark)", "1-800-463-9275", "support@newark.com")
]

for supplier in suppliers: #looping through each supplier in the suppliers list. insert suppliers into the Suppliers table
    cur.execute('INSERT INTO Suppliers (SupplierName, PhoneNumber, Email) VALUES (?, ?, ?)', supplier) #execute SQL command to insert data into suppliers table
    # adds a new row to the suppliers tbale w three columns: SUpplierName, phone number, and email
    #VALUES (?, ?, ?): placeholder syntac for inserting values in correctly and safely. ? symbol get replaced by the valies in the supplier during execution of code

#Commit changes and close the connection
conn.commit() #save all chnages made to the database (all the inserted rows and colummns)
print("Suppliers have been added to the Suppliers table.") #print confirmation message to show that suppliers have been added to the Suppliers table 

#Fetch and display the contents of the Suppliers table to verify insertion
cur.execute("SELECT * FROM Suppliers;") #execute the SQL query to retrieve/select all rows and column from the Suppliers table
rows = cur.fetchall() #retrieve all rows returned by the query select command
for row in rows: #loop through each row in the list of data
    print(row) #print each row of data of suppliers and their info

conn.close() #Close the database connection