import sqlite3 #importing sqlite3 librayr, which allows interaction btwn the SQLIte databses 
from faker import Faker #importing faker library, helps generate random fake data 
import random #importing random module to randomly select values or help generate random nums
from datetime import datetime #importing this toll inorder w to work w dates and times

fake = Faker() #creating a Faker instance for fake data, such as the date/time

#Connect to the SQLite database
conn = sqlite3.connect('inventoryTracker2.db') #connecting to the SQLite database. if file doesnt exist, then it'll be created
cur = conn.cursor() #creating cursor object, cur, which helps execute SQL commands for the database

#Create the Orders table
cur.execute('''
    CREATE TABLE IF NOT EXISTS Orders (
        OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
        UserID INTEGER NOT NULL,
        ItemID INTEGER NOT NULL,
        QuantityOrdered INTEGER NOT NULL,
        OrderDate TEXT NOT NULL,
        FOREIGN KEY (UserID) REFERENCES Users(Id),
        FOREIGN KEY (ItemID) REFERENCES Items(Id)
    )
''')
    #unique identifier for each order and automatically increase num for each new row, refer to teh ID of the user pacing the order (must match an ID in the users table)
    #refer to teh ID of the item ordered (must also match an ID in the Items table)
    #also include number of ordered items, date that order was placed (stored as text),
    #ensure that UserID refers to the Id column in the Users Table, and also ensure that ItemID refers to teh Id column in the Items table 

#Fetch Users and Items from the database
cur.execute("SELECT Id FROM Users") #fetch all userIds from the users table
users = [row[0] for row in cur.fetchall()] #get all rows returned by the SELECT query statement

cur.execute("SELECT Id, Quantity FROM Items") #fetch all itemIds and their quantities from the Items table
items = cur.fetchall() #items stores the result as a list of tuples, in which eachtuple contains the item Id and quanityt

#Generate random orders
def generate_orders(num_orders=50): #fnction that helps generate a specified number of rnandom orders 
    for _ in range(num_orders): #loop num_orders times to help create a specified number of orders
        user_id = random.choice(users) #randomly select a user ID from the users list table
        item_id, available_quantity = random.choice(items) #randomly selecte an item_id and available_quanitty from the itemslist table 
        
        #Random quantity ordered (1 to 10, but not exceeding available quantity) . available_quanityt helps make sure that the quanitht ordered does not exceed how much is in stock
        quantity_ordered = random.randint(1, min(available_quantity, 10)) #generates a ranom number btwn 1 and the smaller value of available_quanityt and 10 (10: limits the max quanityt per order to be 10)
        
        #Generate a random order date
        order_date = fake.date_between_dates( #helps generate a random date btwn jan 1, 2024 and dec 31, 2024
            date_start=datetime(2024, 1, 1), date_end=datetime(2024, 12, 31)
        ).strftime('%Y-%m-%d') #what helps convert date format (year, month, day)
        
        #Insert the order into the Orders table database
        cur.execute('''
            INSERT INTO Orders (UserID, ItemID, QuantityOrdered, OrderDate)
            VALUES (?, ?, ?, ?)
        ''', (user_id, item_id, quantity_ordered, order_date)) #adds a new row to the Orders table, ? serves as placeholders for the values that are to be inserted

    conn.commit() #save all chnages made to the database (all the inserted rows and colummns)
    print(f"{num_orders} orders have been added to the Orders table successfully!") #print confirmation message 

#generate and insert 5 random orders into the orders table 
generate_orders(5) #can change this number 

#fetch and display the Orders table sorted by OrderDate
cur.execute("SELECT * FROM Orders ORDER BY OrderDate ASC") #retrieves all the tows from the Orders table and sorts the row ib orderdate in ascending order 
orders = cur.fetchall() #helps return the orders as a list of tuples

for order in orders: #loop through each order 
    print(order) #print each item 

conn.close() #close the connection