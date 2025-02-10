'''
import sqlite3

# Connect to SQLite database (replace 'inventoryTracker.db' with your actual database file name)
conn = sqlite3.connect('inventoryTracker1.db')
cur = conn.cursor()

# Create the Category table
# Ensures the table is created only if it does not already exist, 
cur.execute('''
    #CREATE TABLE IF NOT EXISTS Category (  
    #    CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,
    #    CategoryName TEXT NOT NULL
    #)
''')

# List of categories to be added to the Category table
categories = [
    "Basic Electronic Components",
    "Integrated Circuits",
    "Power Components",
    "Measurement and Testing Equipment",
    "Prototyping and Development Tools"
]

# Insert categories into the Category table
for category in categories:
    cur.execute('INSERT INTO Category (CategoryName) VALUES (?)', (category,))

# Commit changes and close the connection
conn.commit()
print("Categories have been added to the Category table.")

# Verification: fetch and display the contents of the Category table to verify insertion
cur.execute("SELECT * FROM Category;")
rows = cur.fetchall() #fetching and printing the rows confrims that data has correctly been added 
for row in rows:
    print(row)

# Close the database connection
conn.close()
'''

# modified code below to make sure that the categories are only added once into the category database, and therefore avoiding any duplicates:
import sqlite3 #importing sqlite3 librayr, which allows interaction btwn the SQLIte databses 

#Connect to SQLite database 
conn = sqlite3.connect('inventoryTracker2.db') #connecting to the SQLite database. if file doesnt exist, then it'll be created
cur = conn.cursor() #creating cursor object, cur, which helps execute SQL commands for the database

#Create the Category table if it does not already exists
cur.execute('''
    CREATE TABLE IF NOT EXISTS Category (
        CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,
        CategoryName TEXT NOT NULL UNIQUE
    )
''')

categories = [ #List of categories to be added to the Category table
    "Basic Electronic Components",
    "Integrated Circuits",
    "Power Components",
    "Measurement and Testing Equipment",
    "Prototyping and Development Tools"
]

#Insert categories into the Category table if they do not already exist
for category in categories: #looping through each category name in the categories list. category represents the current categury name during each iteration 
    cur.execute('''
        INSERT OR IGNORE INTO Category (CategoryName) VALUES (?)
    ''', (category,))
    #inserts the row, and if a row w the same category name already exists, then it skips the iteration. ? is the placeholder for the value to be added/inserted

# Commit changes and close the connection
conn.commit() #save all chnages made to the database (all the inserted rows and colummns)
print("Categories have been added to the Category table (if not already present).") #print confirmation message to show that the categories have been added to the Category table 

#Verification: fetch and display the contents of the Category table to verify insertion
cur.execute("SELECT * FROM Category;") #executing SQL query to fetch all rwos in the ctategory databse table 
rows = cur.fetchall() #get all rows returned by teh select query as a list of tuples 
for row in rows: #looping through each row in the data that was pulled/grabbed 
    print(row) #printing each row to the terminal when code is ran 

conn.close() #Close the database connection