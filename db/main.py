'''
will be taking an already existing SQLite database and migrating it to MySQL using python and external python package SQLalchemy
    - object relational mapping: using python and SQLalchemy to take tables to map them to classes, and then take those classes and map them to MySQL tables

    -first thing to do: open MySQL workbench and connect to instance and create a new database so we can migrate all of this to 
        - had to install SQLAlchemy 'pip3 install SQLAlchemy'
'''

'''
Instead of defining the database schema with SQL commands, you define it as Python classes, 
which SQLAlchemy will use to create tables in the database

SQLAlchemy: an object relational mapper, which basically means that it allows us to translate python classes and python objects to database tables and database entries
    -when working w these python objects, for example we create a new pythin object, we delete it, we change it etc., the respective action will also be translated
    into a database action without having to write any SQL code, so dont need to do anything like create table, insert into, select from,,.. 
    everything will be done automatically by SQLAlchemy, and can therefore just focus on the python object/code

'''
'''
#Define the base class for the database models
from sqlalchemy import create_engine, Column, Integer, String, Date, ForeignKey, UniqueConstraint
#from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker  

Base = declarative_base()

# Define the User model
class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    role = Column(String(50), nullable=False)
    username = Column(String(50), unique=True, nullable=False)
    password_hash = Column(String(100), nullable=False)

    def __repr__(self): #how we want to print 
        return f"<User(first_name='{self.first_name}', last_name='{self.last_name}', email='{self.email}')>"
    
# Setup database connections
sqlite_engine = create_engine('sqlite:///inventoryTracker1.db')
#mysql_engine = create_engine('mysql+mysqlconnector://username:password@host/database_name')
#mysql_engine = create_engine('mysql+mysqlconnector://lizzetttapia:admin123@host/database-1')
mysql_engine = create_engine('mysql+mysqlconnector://lizzetttapia:admin123@database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com:3306/Inventory_Tracker')


# Create sessions for both databases
SQLiteSession = sessionmaker(bind=sqlite_engine)
sqlite_session = SQLiteSession()

MySQLSession = sessionmaker(bind=mysql_engine)
mysql_session = MySQLSession()

# Step 4: Create tables in MySQL if they don't exist
#Base.metadata.create_all(mysql_engine)
Base.metadata.create_all(sqlite_engine)  # This ensures the `users` table exists in SQLite
Base.metadata.create_all(mysql_engine) 

# Step 5: Transfer data from SQLite to MySQL
# Query all users from SQLite
sqlite_users = sqlite_session.query(User).all()

# Add users to MySQL session
for user in sqlite_users:
    mysql_session.add(User(
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        role=user.role,
        username=user.username,
        password_hash=user.password_hash
    ))

# Commit the transaction to MySQL
mysql_session.commit()
print("Data transferred successfully from SQLite to MySQL.")

# Close sessions
sqlite_session.close()
mysql_session.close()
'''

'''
# Import required modules
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, declarative_base

# Define the base class for models
Base = declarative_base()

# Define the User model
class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    role = Column(String(50), nullable=False)
    username = Column(String(50), unique=True, nullable=False)
    password_hash = Column(String(100), nullable=False)

    def __repr__(self):
        return f"<User(first_name='{self.first_name}', last_name='{self.last_name}', email='{self.email}')>"

# Setup SQLite and MySQL database connections
sqlite_engine = create_engine('sqlite:///inventoryTracker1.db')
mysql_engine = create_engine('mysql+mysqlconnector://lizzetttapia:admin123@database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com:3306/Inventory_Tracker')

# Create sessions for both databases
SQLiteSession = sessionmaker(bind=sqlite_engine)
sqlite_session = SQLiteSession()

MySQLSession = sessionmaker(bind=mysql_engine)
mysql_session = MySQLSession()

# Step 1: Ensure tables exist in both databases
Base.metadata.create_all(sqlite_engine)  # Ensures SQLite has the necessary tables
Base.metadata.create_all(mysql_engine)   # Ensures MySQL has the necessary tables

# Step 2: Transfer data from SQLite to MySQL
def transfer_data():
    # Query all users from SQLite
    sqlite_users = sqlite_session.query(User).all()

    # Add users to MySQL session, avoiding duplicate entries by checking existing emails
    for user in sqlite_users:
        # Check if the user already exists in MySQL by email
        if not mysql_session.query(User).filter_by(email=user.email).first():
            mysql_session.add(User(
                first_name=user.first_name,
                last_name=user.last_name,
                email=user.email,
                role=user.role,
                username=user.username,
                password_hash=user.password_hash
            ))

    # Commit the transaction to MySQL
    mysql_session.commit()
    print("Data transferred successfully from SQLite to MySQL.")

# Run the data transfer function with error handling
try:
    transfer_data()
except Exception as e:
    print("An error occurred during data transfer:", e)
    mysql_session.rollback()
finally:
    # Close both sessions
    sqlite_session.close()
    mysql_session.close()
'''

'''
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, declarative_base

Base = declarative_base()

# User Model
class User(Base):
    __tablename__ = 'users'
    
    id = Column("Id", Integer, primary_key=True, autoincrement=True)
    first_name = Column("FirstName", String(50), nullable=False)  # Match exact SQLite column name
    last_name = Column("LastName", String(50), nullable=False)
    email = Column("Email", String(100), unique=True, nullable=False)
    role = Column("Role", String(50), nullable=False)
    username = Column("Username", String(50), unique=True, nullable=False)
    password_hash = Column("PasswordHash", String(100), nullable=False)

# Category Model
class Category(Base):
    __tablename__ = 'category'
    
    id = Column("CategoryID", Integer, primary_key=True, autoincrement=True)
    name = Column("CategoryName", String(100), nullable=False)

# Item Model
class Item(Base):
    __tablename__ = 'items'
    
    id = Column("Id", Integer, primary_key=True, autoincrement=True)
    name = Column("Name", String(100), nullable=False)
    description = Column("Description", String(255), nullable=False)
    category_id = Column("CategoryID", String(100), nullable=False)  # Note: Foreign key relationship can be defined if CategoryID is integer.
    quantity = Column("Quantity", Integer, nullable=False)
    unit = Column("Unit", String(50), nullable=False)
    location = Column("Location", String(100), nullable=False)
    supplier = Column("Supplier", String(100), nullable=False)

# Supplier Model
class Supplier(Base):
    __tablename__ = 'suppliers'
    
    id = Column("SupplierID", Integer, primary_key=True, autoincrement=True)
    name = Column("SupplierName", String(100), nullable=False)
    phone_number = Column("PhoneNumber", String(50))
    email = Column("Email", String(100))


    #def __repr__(self):
       #return f"<User(first_name='{self.first_name}', last_name='{self.last_name}', email='{self.email}')>"

# Setup database connections
sqlite_engine = create_engine('sqlite:///inventoryTracker1.db')
mysql_engine = create_engine('mysql+mysqlconnector://lizzetttapia:admin123@database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com:3306/Inventory_Tracker')

# Create sessions for both databases
SQLiteSession = sessionmaker(bind=sqlite_engine)
sqlite_session = SQLiteSession()

MySQLSession = sessionmaker(bind=mysql_engine)
mysql_session = MySQLSession()

# Ensure tables exist in both databases
Base.metadata.create_all(sqlite_engine)
Base.metadata.create_all(mysql_engine)

# Transfer data from SQLite to MySQL
def transfer_data():
    # Transfer Users
    sqlite_users = sqlite_session.query(User).all()
    for user in sqlite_users:
        mysql_session.merge(user)  # Use merge instead of add to prevent the session attachment error

    # Transfer Categories
    sqlite_categories = sqlite_session.query(Category).all()
    for category in sqlite_categories:
        mysql_session.merge(category)

    # Transfer Items
    sqlite_items = sqlite_session.query(Item).all()
    for item in sqlite_items:
        mysql_session.merge(item)

    # Transfer Suppliers
    sqlite_suppliers = sqlite_session.query(Supplier).all()
    for supplier in sqlite_suppliers:
        mysql_session.merge(supplier)

    # Commit all transactions to MySQL
    mysql_session.commit()
    print("Data transferred successfully from SQLite to MySQL.")


    mysql_session.commit()
    print("Data transferred successfully from SQLite to MySQL.")

# Run the data transfer
try:
    transfer_data()
except Exception as e:
    print("An error occurred during data transfer:", e)
    mysql_session.rollback()
finally:
    # Close sessions
    sqlite_session.close()
    mysql_session.close()
'''

'''
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, declarative_base
import getpass  # For secure password entry

Base = declarative_base()

# User Model
class User(Base):
    __tablename__ = 'users'
    
    id = Column("Id", Integer, primary_key=True, autoincrement=True)
    first_name = Column("FirstName", String(50), nullable=False)
    last_name = Column("LastName", String(50), nullable=False)
    email = Column("Email", String(100), unique=True, nullable=False)
    role = Column("Role", String(50), nullable=False)
    username = Column("Username", String(50), unique=True, nullable=False)
    password_hash = Column("PasswordHash", String(100), nullable=False)

# Category Model
class Category(Base):
    __tablename__ = 'category'
    
    id = Column("CategoryID", Integer, primary_key=True, autoincrement=True)
    name = Column("CategoryName", String(100), nullable=False)

# Item Model
class Item(Base):
    __tablename__ = 'items'
    
    id = Column("Id", Integer, primary_key=True, autoincrement=True)
    name = Column("Name", String(100), nullable=False)
    description = Column("Description", String(255), nullable=False)
    category_id = Column("CategoryID", String(100), nullable=False)
    quantity = Column("Quantity", Integer, nullable=False)
    unit = Column("Unit", String(50), nullable=False)
    location = Column("Location", String(100), nullable=False)
    supplier = Column("Supplier", String(100), nullable=False)

# Supplier Model
class Supplier(Base):
    __tablename__ = 'suppliers'
    
    id = Column("SupplierID", Integer, primary_key=True, autoincrement=True)
    name = Column("SupplierName", String(100), nullable=False)
    phone_number = Column("PhoneNumber", String(50))
    email = Column("Email", String(100))

# Get MySQL password securely from the user
mysql_password = getpass.getpass("Enter your MySQL password: ")

# Setup database connections
sqlite_engine = create_engine('sqlite:///inventoryTracker2.db')
mysql_engine = create_engine(
    f'mysql+mysqlconnector://lizzetttapia:{mysql_password}@database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com:3306/Inventory_Tracker'
)

# Create sessions for both databases
SQLiteSession = sessionmaker(bind=sqlite_engine)
sqlite_session = SQLiteSession()

MySQLSession = sessionmaker(bind=mysql_engine)
mysql_session = MySQLSession()

# Ensure tables exist in both databases
Base.metadata.create_all(sqlite_engine)
Base.metadata.create_all(mysql_engine)

# Transfer data from SQLite to MySQL
def transfer_data():
    # Transfer Users
    sqlite_users = sqlite_session.query(User).all()
    for user in sqlite_users:
        mysql_session.merge(user)

    # Transfer Categories
    sqlite_categories = sqlite_session.query(Category).all()
    for category in sqlite_categories:
        mysql_session.merge(category)

    # Transfer Items
    sqlite_items = sqlite_session.query(Item).all()
    for item in sqlite_items:
        mysql_session.merge(item)

    # Transfer Suppliers
    sqlite_suppliers = sqlite_session.query(Supplier).all()
    for supplier in sqlite_suppliers:
        mysql_session.merge(supplier)

    # Commit all transactions to MySQL
    mysql_session.commit()
    print("Data transferred successfully from SQLite to MySQL.")

# Run the data transfer
try:
    transfer_data()
except Exception as e:
    print("An error occurred during data transfer:", e)
    mysql_session.rollback()
finally:
    # Close sessions
    sqlite_session.close()
    mysql_session.close()
'''


'''
will be taking an already existing SQLite database and migrating it to MySQL using python and external python package SQLalchemy
    - object relational mapping: using python and SQLalchemy to take tables to map them to classes, and then take those classes and map them to MySQL tables

    -first thing to do: open MySQL workbench and connect to instance and create a new database so we can migrate all of this to 
        - had to install SQLAlchemy 'pip3 install SQLAlchemy'
'''

'''
Instead of defining the database schema with SQL commands, you define it as Python classes, 
which SQLAlchemy will use to create tables in the database

SQLAlchemy: an object relational mapper, which basically means that it allows us to translate python classes and python objects to database tables and database entries
    -when working w these python objects, for example we create a new python object, we delete it, we change it etc., the respective action will also be translated
    into a database action without having to write any SQL code, so dont need to do anything like create table, insert into, select from,,.. 
    everything will be done automatically by SQLAlchemy, and can therefore just focus on the python object/code

'''
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Date #tools needed in order to help define/manage all the different database tables 
from sqlalchemy.orm import sessionmaker, declarative_base #tools to help handle the database connection from local code to the AWS MySQL workbench hosted server 
import getpass  #safely ask for AWS hosted server password

#In SQLAlchemy, Base helps serve as a blueprint. it tells SQLAlchemy which classes represent database tables. when creating a table, like users or orders, the code inherits from this Base class so that way SQLAlchemy knows it is part of this database
Base = declarative_base() #creates the Base class needed for the foundation of all database table definitions. it helps define and organize them, overall keep table definitions/declarations linked together

#User model: defining a python class named User. it inherits from the Base class previously created, telling SQLAlchemy that this class represents a table
class User(Base): #Base knows that User is a table and organizes it with others(can use Base later to create all tables or overall help manage the database)
    __tablename__ = 'users' #setting the name of the database table as users. this is how it'll appear in the database and once hosted in the server
    
    #column helps specify that this is a database column, which will end up being filled w information/data
    id = Column("Id", Integer, primary_key=True, autoincrement=True) #unique ID for each user. id: defining a column named id in the users table. "Id": the column name in the database. Integer: data type of the column. primary_key=True: marks column as primary key (each row has its unique identifier). autoincrement=True: automatically increase value for each new row 
    first_name = Column("FirstName", String(50), nullable=False) #user first name. first_name: column for storing user first name. "FirstName": column name in database. String(50): string w max legnth of 50 characters. nullable=false: column must always have a value, it cannot be empty
    last_name = Column("LastName", String(50), nullable=False) #user last name. last_name: column for storing user last name. "LastName": column name in database. String(50): string w max legnth of 50 characters. nullable=false: column must always have a value, it cannot be empty
    email = Column("Email", String(100), unique=True, nullable=False) #user email address, which must be unique. email: column for storing user email address. unique=True: makes sure that no two rows have the same email address
    role = Column("Role", String(50), nullable=False) #the role of the user, such as student, TA, or professor. will later on help classify users in the web/app and give cetain roles
    username = Column("Username", String(50), unique=True, nullable=False) #user username for login. must be unique(no repeats) and column cannot be empty (needs data)
    password_hash = Column("PasswordHash", String(100), nullable=False) #the user encrypted password (for security purposes)

#Category Model: defining a python class named Category. it inherits from the Base class previously created, telling SQLAlchemy that this class represents a table
class Category(Base): #Base knows that Category is a table and organizes it with others (helps manage the database)
    __tablename__ = 'category' #setting the name of the database table as category. this is how it'll appear in the database and once hosted in the server
    
    id = Column("CategoryID", Integer, primary_key=True, autoincrement=True) #unique ID for each category. id: defining a column named id in the category table. "CategoryId": the column name in the database. Integer: data type of the column. primary_key=True: marks column as primary key (each row has its unique identifier). autoincrement=True: automatically increase value for each new row 
    name = Column("CategoryName", String(100), nullable=False) #creating column for name of each category. String(50): string w max legnth of 50 characters. nullable=false: column must always have a value, it cannot be empty

#Item Model: defining a python class named Item. it inherits from the Base class previously created, telling SQLAlchemy that this class represents a table
class Item(Base): #Base knows that Item is a table and organizes it with others (helps manage the database)
    __tablename__ = 'items' #setting the name of the database table as items. this is how it'll appear in the database and once hosted in the server
    
    id = Column("Id", Integer, primary_key=True, autoincrement=True) #unique ID for each item. id: defining a column named id in the items table. "Id": the column name in the database. Integer: data type of the column. primary_key=True: marks column as primary key (each row has its unique identifier). autoincrement=True: automatically increase value for each new row 
    name = Column("Name", String(100), nullable=False) #creating column to store name of the item, string w max 100 characters, nullable=false: column must always have a value, it cannot be empty.
    description = Column("Description", String(255), nullable=False) #creating column for item description, string w max 255 characters, nullable=false: column must always have a value, it cannot be empty
    category_id = Column("CategoryID", String(100), nullable=False) #creating column for store the category in which the item falls under, string w max 100 characters, nullable=false: column must always have a value, it cannot be empty
    quantity = Column("Quantity", Integer, nullable=False) #column which stores the quanitity of each item, must be an integer, nullable=false: column must always have a value, it cannot be empty
    unit = Column("Unit", String(50), nullable=False) #column states the type of unit per item, such a kit or pieces, string w max 100 characters, nullable=false: column must always have a value, it cannot be empty
    location = Column("Location", String(100), nullable=False) #column which states the location of the item, string w max 100 characters, nullable=false: column must always have a value, it cannot be empty
    supplier = Column("Supplier", String(100), nullable=False) #column whic states the supplier for each specific item. nullable=false: column must always have a value, it cannot be empty

#Supplier Model: defining a python class named Supplier. it inherits from the Base class previously created, telling SQLAlchemy that this class represents a table
class Supplier(Base): #Base knows that Supplier is a table and organizes it with others (helps manage the database)
    __tablename__ = 'suppliers' #setting the name of the database table as suppliers. this is how it'll appear in the database and once hosted in the server
    
    id = Column("SupplierID", Integer, primary_key=True, autoincrement=True) #unique ID for each category. id: defining a column named SupplierID in the supplier table. "SupplierID": the column name in the database. primary_key=True: marks column as primary key (each row has its unique identifier). autoincrement=True: automatically increase value for each new row 
    name = Column("SupplierName", String(100), nullable=False) #column which holds the supplier name, nullable=false: column must always have a value, it cannot be empty
    phone_number = Column("PhoneNumber", String(50)) #column which has supplier phone number
    email = Column("Email", String(100)) #column which has the email for the supplier 

#Orders Model: defining a python class named Orders. it inherits from the Base class previously created, telling SQLAlchemy that this class represents a table
class Order(Base): #Base knows that Order is a table and organizes it with others (helps manage the database)
    __tablename__ = 'orders' #setting the name of the database table as orders. this is how it'll appear in the database and once hosted in the server
    
    id = Column("OrderID", Integer, primary_key=True, autoincrement=True) #unique ID for each order made. id: defining a column named orderID in the orders table. "OrderID": the column name in the database. primary_key=True: marks column as primary key (each row has its unique identifier). autoincrement=True: automatically increase value for each new row 
    user_id = Column("UserID", Integer, ForeignKey('users.Id'), nullable=False) #column that links an order to a specific user. ForeignKey('users.Id'): states that this column refers to the id column in the users table. nullable=False: it cannot be empty. overall, helps establihs a relationship btwn the orders and users table 
    item_id = Column("ItemID", Integer, ForeignKey('items.Id'), nullable=False) #column that links an order to a specific item. 
    quantity_ordered = Column("QuantityOrdered", Integer, nullable=False) #column that states an integer which represent how much of each item has been ordered 
    order_date = Column("OrderDate", Date, nullable=False) #sets a date to when a specific item is ordered 

mysql_password = getpass.getpass("Enter your MySQL password: ") #Get MySQL password securely from the user (for security purposes)

# Setup database connections
sqlite_engine = create_engine('sqlite:///inventoryTracker2.db') #create_engine(): helps create a connection to the SQLite database, and it points to the inventoryTracker2.db database file. if it does not exist, then it will be created 
mysql_engine = create_engine( 
    f'mysql+mysqlconnector://lizzetttapia:{mysql_password}@database-1.chwuw2260pwi.us-east-1.rds.amazonaws.com:3306/Inventory_Tracker' #connects to the MySQL database. links the python codes to a MySQL hosted server 
)

#Create sessions, for both databases, for interacting w the SQLite and MySQL databases. Purpose of the session to create a connection to the database that allows one to perfom operations of updating data, adding, or querying
SQLiteSession = sessionmaker(bind=sqlite_engine) #telling SQLAlchemy that this session is sonnected to the SQLite database(can now produce sessions for the SQLite database)
sqlite_session = SQLiteSession() #the actual session object, which enables doing all the operations of adding, updating, or querying data in the SQLite database

MySQLSession = sessionmaker(bind=mysql_engine) #creating a session for the MySQL database, linking it to the mysql_engine
mysql_session = MySQLSession() #creating a new session for interaction w the MySQL database, which allows adding, querying, or updating data in the MySQL database

#Ensure tables exist in both databases
Base.metadata.create_all(sqlite_engine) #creates all tables in the database if they dont already exists. specifies to create the tables in SQLite
Base.metadata.create_all(mysql_engine) #creates all tables in the database if they dont already exists. specifies to create the tables in MySQL

#Transfer data from SQLite to MySQL
def transfer_data(): #function named trasnfer_data that helps transfer data from the SQLite database to the MySQL databaase
    #Transfer Users
    sqlite_users = sqlite_session.query(User).all() #sqlite_session.query(user): query all rows from the uers table in the SQLite database, .all(): get all rows as a list of the User, sqlite_users: variable to hold all the user data grabbed from SQLite
    for user in sqlite_users: #loop through each User data grabbed from SQLite
        mysql_session.merge(user) #add and update the User data to the MySQL session, if it doesnt exist yet

    #Transfer Categories
    sqlite_categories = sqlite_session.query(Category).all() #similar ot users, grabs all rows from the category table in SQLite
    for category in sqlite_categories: #looping through each data from SQLite and adding it into MySQL
        mysql_session.merge(category)

    #Transfer Items
    sqlite_items = sqlite_session.query(Item).all() #grabbing all the items from SQLite database
    for item in sqlite_items: #looping through each item data from SQLite and adding it into MySQL
        mysql_session.merge(item)

    #Transfer Suppliers
    sqlite_suppliers = sqlite_session.query(Supplier).all() #grab all rows/data from suppliers table in SQLite
    for supplier in sqlite_suppliers: #looping through eachsupplier data and transferring into MySQL
        mysql_session.merge(supplier)

    #Transfer Orders
    sqlite_orders = sqlite_session.query(Order).all() #grab all rows/data from orders table in SQLite
    for order in sqlite_orders: #add/update each order data into MySQL
        mysql_session.merge(order)

    #Commit all transactions to MySQL
    mysql_session.commit() #save all changes made to teh MySQL database and ensure that transfer is finalized
    print("Data transferred successfully from SQLite to MySQL.") #print confirmation message output to the terminal when the code is ran

#Run the data transfer and handling any errors that may appear 
try: #try block: runs transfer_data() function and if theres an error, then will jump to the except block
    transfer_data()
except Exception as e: #capturing any errors that may occur/come up
    print("An error occurred during data transfer:", e) #display error message to the terminal when code is ran 
    mysql_session.rollback() #undoes any changes made to MySQL during the transfer, when theres an error, in order to keep the databse consistent to how it previosuly was 
finally: #closing database session. this finally block ensures that the code inside runs whether an error occuer or not 
    sqlite_session.close() #closing SQLite database connection
    mysql_session.close() #closing MySQL database connection 