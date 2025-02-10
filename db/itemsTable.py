"""
import sqlite3
from faker import Faker
import random

# Create a Faker instance
fake = Faker()

# Connect to the SQLite database (replace 'inventoryTracker1.db' with your actual database file)
conn = sqlite3.connect('inventoryTracker1.db')
cur = conn.cursor()

# Function to randomly select categories (for demonstration purposes, you can expand this)
def random_category():
    categories = ['Electronics', 'Prototyping', 'Power Supplies', 'Soldering']
    return random.choice(categories)

# Function to insert random item data using Faker
def insert_random_items(num_items):
    for _ in range(num_items):
        item_name = fake.word().capitalize() + " Kit"  # Generate a random item name
        description = fake.sentence()  # Generate a random description
        category = random_category()  # Randomly select a category
        quantity = random.randint(1, 500)  # Random quantity between 1 and 500
        unit = random.choice(['pieces', 'kits', 'units'])  # Random unit type
        location = fake.city()  # Fake city as a random location for the item
        supplier = fake.company()  # Random supplier name

        # Insert the random item into the Items table
        cur.execute('''
            INSERT INTO Items (Name, Description, CategoryID, Quantity, Unit, Location, Supplier)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (item_name, description, category, quantity, unit, location, supplier))
    
    conn.commit()
    print(f"{num_items} random items added successfully!")

# Insert 10 random items with Faker-generated data
insert_random_items(10)

 
# Fetch and display the Items table
cur.execute("SELECT * FROM Items;")
items = cur.fetchall()

for item in items:
    print(item)

# Close the connection
conn.close()
"""

"""import sqlite3
from faker import Faker
import random

# Create a Faker instance
fake = Faker()

# Connect to the SQLite database
conn = sqlite3.connect('inventoryTracker1.db')
cur = conn.cursor()

# Create the Items table if it does not exist
cur.execute('''
    CREATE TABLE IF NOT EXISTS Items (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT NOT NULL,
        Description TEXT NOT NULL,
        CategoryID TEXT NOT NULL,
        Quantity INTEGER NOT NULL,
        Unit TEXT NOT NULL,
        Location TEXT NOT NULL,
        Supplier TEXT NOT NULL
    )
''')

# Function to randomly select categories
def random_category():
    categories = ['Electronics', 'Prototyping', 'Power Supplies', 'Soldering']
    return random.choice(categories)

# Function to insert random item data using Faker
def insert_random_items(num_items):
    for _ in range(num_items):
        item_name = fake.word().capitalize() + " Kit"  # Generate a random item name
        description = fake.sentence()  # Generate a random description
        category = random_category()  # Randomly select a category
        quantity = random.randint(1, 500)  # Random quantity between 1 and 500
        unit = random.choice(['pieces', 'kits', 'units'])  # Random unit type
        location = fake.city()  # Fake city as a random location for the item
        supplier = fake.company()  # Random supplier name

        # Insert the random item into the Items table
        cur.execute('''
            INSERT INTO Items (Name, Description, CategoryID, Quantity, Unit, Location, Supplier)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (item_name, description, category, quantity, unit, location, supplier))
    
    conn.commit()
    print(f"{num_items} random items added successfully!")

# Insert 10 random items with Faker-generated data
insert_random_items(10)

# Fetch and display the Items table
cur.execute("SELECT * FROM Items;")
items = cur.fetchall()

for item in items:
    print(item)

# Close the connection
conn.close()
"""



# import sqlite3
# from faker import Faker
# import random

# # Create a Faker instance
# fake = Faker()

# # Connect to the SQLite database (replace 'inventoryTracker1.db' with your actual database file name)
# conn = sqlite3.connect('inventoryTracker2.db')
# cur = conn.cursor()

# # Create the Items table if it does not exist
# cur.execute('''
#     CREATE TABLE IF NOT EXISTS Items (
#         Id INTEGER PRIMARY KEY AUTOINCREMENT,
#         Name TEXT NOT NULL,
#         Description TEXT NOT NULL,
#         CategoryID TEXT NOT NULL,
#         Quantity INTEGER NOT NULL,
#         Unit TEXT NOT NULL,
#         Location TEXT NOT NULL,
#         Supplier TEXT NOT NULL
#     )
# ''')

# # Define categories and items
# categories_items = {
#     'Basic Electronic Components': ['Resistors', 'Capacitors', 'Inductors', 'Diodes', 'Transistors'],
#     'Integrated Circuits': ['Op-Amps', 'Microcontrollers', 'Logic Gates', 'DACs', 'ADCs'],
#     'Power Components': ['Batteries', 'Power Supplies', 'Voltage Regulators', 'Transformers'],
#     'Prototyping and Development Tools': ['Breadboards', 'Jumper Wires', 'Soldering Kits']
# }

# # Define suppliers to randomly select from
# suppliers = [
#     "Digikey Electronics",
#     "Texas Instruments",
#     "Mouser Electronics",
#     "Farnell (Newark)"
# ]

# # Define possible locations
# locations = ['Bin A', 'Bin B', 'Bin C', 'Checkout Area']

# # Function to insert predefined items with random quantities and specific locations
# def insert_items_with_random_data():
#     for category, items in categories_items.items():
#         for item in items:
#             description = f"A useful component for {category.lower()}"  # General description
#             quantity = random.randint(1, 500)  # Random quantity between 1 and 500
#             unit = random.choice(['pieces', 'kits', 'units'])  # Random unit type
#             location = random.choice(locations)  # Randomly select a location
#             supplier = random.choice(suppliers)  # Randomly select a supplier

#             # Insert the item into the Items table
#             cur.execute('''
#                 INSERT INTO Items (Name, Description, CategoryID, Quantity, Unit, Location, Supplier)
#                 VALUES (?, ?, ?, ?, ?, ?, ?)
#             ''', (item, description, category, quantity, unit, location, supplier))

#     conn.commit()
#     print("Items added to the Items table successfully!")

# # Insert items with the specified categories, suppliers, and locations
# insert_items_with_random_data()

# # Fetch and display the Items table
# cur.execute("SELECT * FROM Items;")
# items = cur.fetchall()

# for item in items:
#     print(item)

# # Close the connection
# conn.close()



#updated code below for a better organized items table 
import sqlite3 #importing sqlite3 librayr, which allows interaction btwn the SQLIte databses 
from faker import Faker #importing faker library, helps generate random fake data 
import random #importing random module to randomly select values or help generate random nums

fake = Faker() #creating a Faker instance

#Connect to the SQLite database
conn = sqlite3.connect('inventoryTracker2.db') #connecting to the SQLite database. if file doesnt exist, then it'll be created
cur = conn.cursor() #creating cursor object, cur, which helps execute SQL commands for the database

#Create the Items table if it does not exist
cur.execute('''
    CREATE TABLE IF NOT EXISTS Items (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT NOT NULL,
        Description TEXT NOT NULL,
        CategoryID TEXT NOT NULL,
        Quantity INTEGER NOT NULL,
        Unit TEXT NOT NULL,
        Location TEXT NOT NULL,
        Supplier TEXT NOT NULL
    )
''')

#Updated categories and items with specific variations
categories_items = { #dictironary wehre keys are the category names and the values are lists of items w specific attributes, such as the value of resistor or capactior
    'Basic Electronic Components': [
        'Resistors: 1kΩ, 10kΩ, 100kΩ',
        'Capacitors: 1µF, 10µF, 100µF',
        'Inductors: 10µH, 100µH, 1mH',
        'Diodes: Standard, Zener, LEDs, Schottky',
        'Transistors: BJTs, MOSFETs, JFETs',
        'Wires: 22AWG, 24AWG, 26AWG'
    ],
    'Integrated Circuits': [
        'Op-Amps: LM741, TL081',
        'Microcontrollers: Arduino Uno, Raspberry Pi 4',
        'Logic Gates: AND, OR, XOR, NAND, NOR',
        'DACs: 8-bit DAC, 12-bit DAC',
        'ADCs: 8-bit ADC, 12-bit ADC'
    ],
    'Power Components': [
        'Batteries: 9V, AA, AAA',
        'Power Supplies: DC Power Supply, AC-DC Converter',
        'Voltage Regulators: Buck Converter, Boost Converter',
        'Transformers: Step-Up, Step-Down'
    ],
    'Measurement and Testing Equipment': [
        'Multimeters: Digital Multimeter, Analog Multimeter',
        'Oscilloscopes: 2-Channel, 4-Channel',
        'Function Generators: 10MHz, 50MHz'
    ],
    'Prototyping and Development Tools': [
        'Breadboards: Large, Medium, Small',
        'Jumper Wires: Male-to-Male, Female-to-Female',
        'Soldering Kits: Basic, Advanced'
    ]
}

#Define suppliers to randomly select from
suppliers = [ #list of suppliers name
    "Digikey Electronics",
    "Texas Instruments",
    "Mouser Electronics",
    "Farnell (Newark)"
]

#Define possible locations
locations = ['Bin A', 'Bin B', 'Bin C', 'Checkout Area'] #list of storage locations

#Function to help insert items with detailed data
def insert_items_with_detailed_data(): #defines a function to insert detailed item datat into the Items database table 
    for category, items in categories_items.items(): #categories_items.items(): returns each category and list of items, category: current category name, items: list of items in that specific category 
        for item in items: #looping through each item in the items list
            #extracting base name and variations (e.g., 'Resistors: 1kΩ, 10kΩ')
            base_name, *variations = item.split(': ') #split the item string into the name od the item and its description/value
            if variations: #if variuation exist, then split them into a list of individual variations
                variations = variations[0].split(', ')  # Split variations into a list
            else: #if no variation exist, then treat it as just one 
                variations = [base_name] #if no variations, treat as single item

            #insert each variation with random data (generate random data for each variation)
            for variation in variations: #variation is the current variation we're working with 
                description = f"A {variation} for {category.lower()}"  #more specific description of the item 
                quantity = random.randint(1, 500) #generating a random quantity between 1 and 500
                unit = random.choice(['pieces', 'kits', 'units']) #random unit type
                location = random.choice(locations) #randomly select a location
                supplier = random.choice(suppliers) #randomly select a supplier

                #insert the item into the Items table
                cur.execute('''
                    INSERT INTO Items (Name, Description, CategoryID, Quantity, Unit, Location, Supplier)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                ''', (f"{base_name} ({variation})", description, category, quantity, unit, location, supplier))
                #adds a new row to the items table, speciifies which columns to insert data into, and ? serves as placeholders for these values we're working with

    conn.commit() #save all chnages made to the database (all the inserted rows and colummns)
    print("Detailed items added to the Items table successfully!") #print confirmation message 

insert_items_with_detailed_data() #calls the function to insert items into databse with detailed data

#fetch and display the Items table
cur.execute("SELECT * FROM Items;") #fetch all rows from the items table 
items = cur.fetchall() #return the rows are list of tuples 

for item in items: #loop through each item 
    print(item) #print each item

conn.close() #close the connection
