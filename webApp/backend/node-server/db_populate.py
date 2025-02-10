import os
import sqlite3

# Get the full path to the database file
db_path = os.path.join(os.path.dirname(__file__), 'database.db')

# Connect to the SQLite database
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Recreate the items table
cursor.execute('''CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE,
    description TEXT,
    category TEXT,
    quantity INTEGER,
    unit TEXT,
    location TEXT,
    supplier TEXT,
    returnable BOOLEAN DEFAULT 0
)''')

# Check if the table is empty
cursor.execute('SELECT COUNT(*) FROM items')
item_count = cursor.fetchone()[0]
print(f"Items in the table: {item_count}")

if item_count == 0:
    # List of items to insert
    items_data = [
        ('Resistors',   'Assorted resistor pack (10Ω to 1MΩ)',       'Electronics', 1000, 'pieces', 'Drawer A', 'Electrical General', 0),
        ('Capacitors',  'Assorted ceramic capacitors',               'Electronics', 500, 'pieces', 'Drawer B', 'Electrical General', 0),
        ('Raspberry',   'Raspberry Pi 4 Model B kit',                'Electronics', 10, 'kits', 'Shelf 1', 'Tech Wizard', 1),
        ('Jumper Wire', 'Male-to-male jumper wires for breadboards', 'Prototyping ', 200, 'pieces', 'Drawer C', 'Prototype2Day', 0),
        ('Breadboard',  '830-point breadboards',                     'Prototyping ', 50, 'pieces', 'Shelf A', 'Prototype2Day', 1),
        ('Soldering',   'Chisel and conical soldering tips',         'Soldering', 30, 'pieces', 'Shelf D', 'Super Solder', 1),
        ('Connectors',  'Assorted pin headers and jumper cables',    'Prototyping', 0, 'pieces', 'Drawer E', 'Prototype2Day', 0),
        ('Batteries',   'AA and 9V batteries',                       'Power Supplies', 100, 'pieces', 'Shelf F', 'Power UP', 0),
        ('IC Sockets',  '8-pin and 16-pin IC sockets',               'Prototyping', 150, 'pieces', 'Drawer G', 'Prototype2Day', 0),
    ]
    
    try:
        # Insert data into the table
        cursor.executemany('''INSERT INTO items (name, description, category, quantity, unit, location, supplier, returnable)
                              VALUES (?, ?, ?, ?, ?, ?, ?, ?)''', items_data)
        print("Items table populated with default data.")
    except sqlite3.Error as e:
        print(f"An error occurred: {e}")

# Commit changes and close the connection
conn.commit()
conn.close()
