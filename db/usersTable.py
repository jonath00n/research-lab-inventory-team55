"""
import sqlite3
from faker import Faker 
import random

#Create a Faker instance
fake = Faker()

#Connect to the SQLite database
conn = sqlite3.connect('inventoryTracker1.db')
cur = conn.cursor()

#Function to generate random data with Faker and random
def random_tamu_email():
    #Generate a realistic username and append '@tamu.edu'
    return f"{fake.user_name()}@tamu.edu"

def random_role():
    #Randomly select a role
    roles = ['Admin', 'Student', 'Graduate TA', 'Professor']
    return random.choice(roles)

#Function to insert random user data using Faker
def insert_random_users(num_users):
    for _ in range(num_users):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = random_tamu_email()  #using @tamu.edu domain
        role = random_role()
        username = fake.user_name()  #generate a realistic username
        password_hash = "hashed_" + ''.join(random.choices('abcdefghijklmnopqrstuvwxyz0123456789', k=10))
        
        # Insert the random user into the Users table
        cur.execute('''
            INSERT INTO Users (FirstName, LastName, Email, Role, Username, PasswordHash)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (first_name, last_name, email, role, username, password_hash))
    
    conn.commit()
    print(f"{num_users} random users with @tamu.edu emails added successfully!")

# Insert 10 random users with Faker-generated data
insert_random_users(10)

# Fetch and display the Users table
cur.execute("SELECT * FROM Users;")
users = cur.fetchall()

for user in users:
    print(user)

# Close the connection
conn.close()
""" 

"""
import sqlite3
from faker import Faker
import random

# Create a Faker instance
fake = Faker()

# Connect to the SQLite database
conn = sqlite3.connect('inventoryTracker1.db')
cur = conn.cursor()

# Create the Users table if it does not exist
cur.execute('''
    CREATE TABLE IF NOT EXISTS Users (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        FirstName TEXT NOT NULL,
        LastName TEXT NOT NULL,
        Email TEXT NOT NULL UNIQUE,
        Role TEXT NOT NULL,
        Username TEXT NOT NULL UNIQUE,
        PasswordHash TEXT NOT NULL
    )
''')

# Function to generate random data with Faker and random
def random_tamu_email():
    # Generate a realistic username and append '@tamu.edu'
    return f"{fake.user_name()}@tamu.edu"

def random_role():
    # Randomly select a role
    roles = ['Admin', 'Student', 'Graduate TA', 'Professor']
    return random.choice(roles)

# Function to insert random user data using Faker
def insert_random_users(num_users):
    for _ in range(num_users):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = random_tamu_email()  # using @tamu.edu domain
        role = random_role()
        username = fake.user_name()  # generate a realistic username
        password_hash = "hashed_" + ''.join(random.choices('abcdefghijklmnopqrstuvwxyz0123456789', k=10))
        
        # Insert the random user into the Users table
        cur.execute('''
            INSERT INTO Users (FirstName, LastName, Email, Role, Username, PasswordHash)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (first_name, last_name, email, role, username, password_hash))
    
    conn.commit()
    print(f"{num_users} random users with @tamu.edu emails added successfully!")

# Insert 10 random users with Faker-generated data
insert_random_users(10)

# Fetch and display the Users table
cur.execute("SELECT * FROM Users;")
users = cur.fetchall()

for user in users:
    print(user)

# Close the connection
conn.close()
"""

import sqlite3 #importing sqlite3 librayr, which allows interaction btwn the SQLIte databses 
#import mysql.connector
from faker import Faker #importing faker library, helps generate random fake data fro the names and emails 
import random #importing random module to make random selections (in this case, the role of each user)

fake = Faker() #creating a Faker instance, which is used to generate fake emails, names, etc

#Connect to the SQLite database
conn = sqlite3.connect('inventoryTracker2.db') #connecting to the SQLite database. if file doesnt exist, then it'll be created
#conn = mysql.connector.connect(
    #host='database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com',  # e.g., 'database-1.abcdefghijk.us-east-1.rds.amazonaws.com'
    #user='lizzetttapia',
    #password='admin123',
    #database='LizzettTapia_database'
#)
cur = conn.cursor() #creating cursor object, cur, which helps execute SQL commands for the database

#Create the Users table if it does not exist with all info of Id, firstname, last name, email, role, username, and password, and stores into columns
cur.execute('''
    CREATE TABLE IF NOT EXISTS Users (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        FirstName TEXT NOT NULL,
        LastName TEXT NOT NULL,
        Email TEXT NOT NULL UNIQUE,
        Role TEXT NOT NULL,
        Username TEXT NOT NULL UNIQUE,
        PasswordHash TEXT NOT NULL
    )
''')

def generate_email(first_name, last_name): #Function to generate an email based on the first and last name w specific format
    return f"{first_name.lower()}.{last_name.lower()}@tamu.edu" #Use lowercase first and last name separated by a dot and append '@tamu.edu'

def generate_username(first_name, last_name): #Function to generate a username based on the first and last name
    return f"{first_name.lower()}{last_name.lower()}" #Combine lowercase first and last name with no space

def random_role(): #Function to randomly select a role for the user from the list
    roles = ['Admin', 'Student', 'Graduate TA', 'Professor']
    return random.choice(roles)

def insert_random_users(num_users): #Function to insert random user data
    for _ in range(num_users): #loops to create num_users random users
        first_name = fake.first_name() #generating a random first name 
        last_name = fake.last_name() #generating a random last name
        email = generate_email(first_name, last_name) #calling the generate email function to create an email based on generated name
        role = random_role() #calling the random_role function to assign a random role to the user
        username = generate_username(first_name, last_name)  #callinf the generate_username function to genearte username based on names
        password_hash = "hashed_" + ''.join(random.choices('abcdefghijklmnopqrstuvwxyz0123456789', k=10)) #creating fake password (hashed_ + random string of 10 characters)
        
        #Insert the random user data into the Users table
        cur.execute('''
            INSERT INTO Users (FirstName, LastName, Email, Role, Username, PasswordHash)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (first_name, last_name, email, role, username, password_hash)) #? represents placeholder for values to prevent SQL injection, and these are the values to be added into the users table
    
    conn.commit() #save all chnages made to the database (all the inserted rows and colummns)
    print(f"{num_users} random users with @tamu.edu emails added successfully!") #print confirmation message to show how many users were added

#Insert 10 random users with modified data
insert_random_users(10) #the number can vary, therefore can change it 

#Fetch and display the Users table
cur.execute("SELECT * FROM Users;") #fetching all rows from the Users table 
users = cur.fetchall() #retrieve all rows

for user in users: #loop through the list if users 
    print(user) #print each row of users

conn.close() #Close the connection

#summary: code create 10 random users (num can be chnaged) with random first and last name, 
#   email formatted as frst.last@tamu.edu, a random role assigned to the user, and a random generated hashed password
#   all users are added to the Users table in the SQLite database (locally), and data gets printed in order to confirm the insertions
