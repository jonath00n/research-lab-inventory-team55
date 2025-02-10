import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'login_page.dart';
import 'itemlistscreen.dart';
// all packages and other pages referenced for this page ^


// This is the page that is in charge of the local database
// this page will likely not be used in the final app because the local database is temporary
// This page is in charge of creating the database as well as some funcions relating to it

// The line below creates a class for the AuthenticationDB
class AuthenticationDB {

  static final AuthenticationDB _instance = AuthenticationDB._internal();
  static Database? _database;  // instance is shared across all files

  factory AuthenticationDB() {
    return _instance;  // ensures that only one instance of the database is used
  }

  // attributes for the database
  // title and version
  static const String _dbName = 'auth.db';
  static const int _dbVersion = 1;

  // First table "users"
  // contains columns for id, email, and password for users
  static const String _tableName = 'users';
  static const String columnId = 'id';
  static const String columnName = 'name'; // NEW
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';
  static const String columnColor = 'color'; // NEW
  static const String columnPermission = 'Permission'; // NEW
  static const String columnCart = 'Cart'; // NEW
  static const String columnItemsToReturn = 'Items_to_return'; // NEW
  static const String columnLastLogin = 'LastLogin'; // NEW
  static const String columnLastLogOut = 'LastLogOut'; // NEW


  // Second table "items"

  // contains columns for id, item, quantity, availability, and the returnable attribute
  static const String _table2Name = 'items';
  static const String columnId2 = 'id2';
  static const String columnItem = 'item';
  static const String columnDescription = 'description'; // NEW
  static const String columnCategory = 'Category'; // NEW
  static const String columnQuantity = 'quantity'; // Change to int
  static const String columnUnit = 'Unit'; // NEW
  static const String columnLocation = 'Location'; // NEW
  static const String columnSupplier = 'Supplier'; // NEW
  static const String columnAvailability = 'availability'; // Remove
  static const String columnReturnable = 'returnable'; // Change to bool

  // Third table "orders"

  // contains columns for all past orders recording the users and items

  static const String _table3Name = 'orders';
  static const String columnId3 = 'id3';
  static const String columnUser_Name = 'User_name'; // NEW
  static const String columnUser_Email = 'User_email'; // NEW
  static const String columnItem_id = 'Item_id'; // NEW
  static const String columnItem_name = 'Item_name'; // NEW
  static const String columnIs_returnable = 'Is_returnable'; // NEW
  static const String columnItem_Quantity = 'Item_quantity'; // NEW
  static const String columnTimestamp = 'Timestamp'; // NEW


  // Table four for "active checkout list"
  // contains columns for id, user email, checkout item, and checkout quantity
  static const String _table4Name = 'checkoutList';
  static const String columnId4 = 'id4';
  static const String columnUserEmail = 'userEmail';
  static const String columnCheckoutItem = 'checkoutItem';
  static const String columnCheckoutQuantity = 'checkoutQuantity';


// possibly unnecessary
  AuthenticationDB._internal();

  // factory AuthenticationDB() => _instance;

  Future<Database> get database async { // allows you to access the database which is asynchronous
    if (_database != null) return _database!; // Initializes database if it does not exist
    _database = await _initDatabase();
    return _database!; // ! ensures that it is no longer null
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);  // retrieves path of where database is stored
    return await openDatabase(  // opens the database in path with version
      path,
      version: _dbVersion,
      onCreate: _onCreate, // triggered when database is created
    );
  }

  // when the database is first created
  // makes each of the three tables as stated above
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $_tableName('
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnName TEXT NOT NULL,' // NEW
        '$columnEmail TEXT NOT NULL UNIQUE,'
        '$columnPassword TEXT NOT NULL,'
        '$columnColor TEXT,' // NEW
        '$columnPermission TEXT,' // NEW
        '$columnCart TEXT,' // NEW
        '$columnItemsToReturn TEXT,' // NEW
        '$columnLastLogin TEXT,' // NEW
        '$columnLastLogOut TEXT)'); // NEW

    await db.execute('CREATE TABLE $_table2Name('
        '$columnId2 INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnItem TEXT NOT NULL,'
        '$columnDescription TEXT,' // NEW
        '$columnCategory TEXT,' // NEW
        '$columnQuantity TEXT NOT NULL,' // Change to int
        '$columnUnit TEXT,' // NEW
        '$columnLocation TEXT,' // NEW
        '$columnSupplier TEXT,' // NEW
        '$columnReturnable INTEGER NOT NULL DEFAULT 0)');

    await db.execute('CREATE TABLE $_table3Name('
        '$columnId3 INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnUser_Name TEXT NOT NULL,' // NEW
        '$columnUser_Email TEXT NOT NULL,' // NEW
        '$columnItem_id INTEGER NOT NULL,' // NEW
        '$columnItem_name TEXT NOT NULL,' // NEW
        '$columnIs_returnable INTEGER NOT NULL,' // NEW (change to bool)
        '$columnItem_Quantity INTEGER NOT NULL,' // NEW
        '$columnTimestamp TEXT NOT NULL)'); // NEW

    await db.execute('CREATE TABLE $_table4Name('
        '$columnId4 INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$columnUserEmail TEXT NOT NULL,'
        '$columnCheckoutItem TEXT NOT NULL,'
        '$columnCheckoutQuantity INTEGER NOT NULL)'); // Changed to int
  }


  // Register user
  // adds user to "users" table with email and password
  // email and password are accessed from controllers input to the function
  Future<int> registerUser(String email, String password, String name) async {
    final db = await database;
    try {
      return await db.insert(
        _tableName,
        {
          columnEmail: email,
          columnPassword: password,
          columnName: name,

        },
      );
    } catch (e) {
      return -1;  // If email already exists, return error code
    }
  }

  // Adds an item to the "items" table
  // also sets availability based on quantity
  Future<int> addItem(String item, String quantity, {bool returnable = false}) async {
    final db = await database;
    int integerQuantity = int.tryParse(quantity) ?? 0;
    // String availability = (integerQuantity > 0) ? 'YES' : 'NO';
    int returnability = returnable ? 1 : 0;
    try {
      return await db.insert(
        _table2Name,  // 'items' table
        {
          columnItem: item,
          columnQuantity: quantity,
          // columnAvailability: availability,
          columnReturnable: returnability,
        },
      );
    } catch (e) {
      print("Error inserting item: $e");  // Check what error is printed
      return -1;
    }
  }

  // ads a user with item and quantity to the active checkout table
  // email is a global variable
  // also determines if there is already an entry for that item with that email
  Future<int> addCheckoutList(String item, String quantity) async {
    final db = await database;

    if (userEmail == null) {
      userEmail = 'usernotfound';
    }

    //checks to see if there is an existing entry with the email and item
    final existingEntry = await db.query(
      _table4Name,
      where: '$columnUserEmail = ? AND $columnCheckoutItem = ?',
      whereArgs: [userEmail, item],
    );

    // if there is an existing entry it simply edits that entry
    if ( existingEntry.isNotEmpty ) {
      int existingQuantity = int.tryParse(existingEntry[0][columnCheckoutQuantity].toString()) ?? 0;
      int checkoutQuantity = int.tryParse(quantity)?? 0;
      int newQuantity = existingQuantity + checkoutQuantity;
      int entryId = existingEntry[0][columnId4] as int;
      try {
        int result = await db.update(
          _table4Name,
          {
            columnCheckoutQuantity: newQuantity.toString(),
          },
          where: '$columnId4 = ?', // Ensure this corresponds to your column name
          whereArgs: [entryId],
        );

        return result; // Return the number of affected rows
      } catch (e) {
        return 0; // Return 0 if an error occurs
      }

    }
    else { // if entry does not exist then it creates a new one
      try {
        return await db.insert(
          _table4Name, // 'items' table
          {
            columnUserEmail: userEmail,
            columnCheckoutItem: item,
            columnCheckoutQuantity: quantity,
          },
        );
      } catch (e) {
        print("Error inserting item: $e");
        return -1;
      }
    }
  }

 // this function subtracts from the active checkout list when items are checked in
  Future<int> subtractCheckoutList(String item, String quantity) async {
    final db = await database;

    if (userEmail == null) {
      userEmail = 'usernotfound';
    }

    // checks to see if there is an existing entry with email and item
    final existingEntry = await db.query(
      _table4Name,
      where: '$columnUserEmail = ? AND $columnCheckoutItem = ?',
      whereArgs: [userEmail, item],
    );

    // if there is an existing entry this edits the quantity based on the amount checked in
    if ( existingEntry.isNotEmpty ) {
      int existingQuantity = int.tryParse(
          existingEntry[0][columnCheckoutQuantity].toString()) ?? 0;
      int checkoutQuantity = int.tryParse(quantity) ?? 0;
      int newQuantity = existingQuantity - checkoutQuantity;
      int entryId = existingEntry[0][columnId4] as int;
      if (newQuantity < 0) {
        return -1;
      }
      else if (newQuantity == 0) {
        // if the new quantity checked out is zero, delete the entry
        try {
          int result = await db.delete(
            _table4Name,
            where: '$columnId4 = ?',
            whereArgs: [entryId],
          );
          return result;
        } catch (e) {
          return 0; // Return 0 if an error occurs
        }

      }
      else {
      // sets the new quantity
      try {
        int result = await db.update(
          _table4Name,
          {
            columnCheckoutQuantity: newQuantity.toString(),
          },
          where: '$columnId4 = ?',
          whereArgs: [entryId],
        );

        return result;
      } catch (e) {
        return 0;
      }
    }

    }
    else {
        return -1;
    }
  }


// deletes a table from the database
  // not currently used in the app
  Future<int> deleteUser(String email, String password) async {
    final db = await database;
    try {
      return await db.delete(
        _tableName,
      );
    } catch (e) {
      return 1;  // If email already exists, return error code
    }
  }

  // Login user
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: '$columnEmail = ? AND $columnPassword = ?', // checks if there is an entry in
      whereArgs: [email, password],  // database with email and password
    );

    return result.isNotEmpty;
  }

  // Check if user exists
  // check if email is present in users table
  Future<bool> isUserExists(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // creates the query with all items from items table
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM items');  // Using rawQuery to make it so that  only 'items' table is queried
  }
  // creates the query for all entries from active checkout list
  Future<List<Map<String, dynamic>>> getCheckoutList() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM checkoutList');  // Using rawQuery make it so that only 'items' table is queried
  }

  // creates the query based on the item that is searched
  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final db = await database; // Reference to your SQLite database

    return await db.query(
      'items', // Table name
      where: "item LIKE ?",
      whereArgs: ['%$query%'], // retrieves items from item searched
    );
  }

  Future<List<Map<String, dynamic>>> searchCheckoutList(String query) async {
    final db = await database;

    return await db.query(
      'checkoutList',
      where: "userEmail LIKE ?",
      whereArgs: ['%$query%'],
    );
  }

  // search functionality for dropdown menus
  // not currently used in app
    Future<List<Map<String, dynamic>>> searchDropdownItems(String query) async {
    final db = await database;

    return await db.query(
      'items', // Table name
      where: "(item LIKE ?) OR (quantity = 0)",
      whereArgs: ['%$query%', '%$query%'],
    );
  }

// creates a query with all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // meant to delete database
  // not currently used
  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), _dbName);
    await deleteDatabase(path);
    print('Database deleted');
  }

  // updates the item quantity based on new quantity
  Future<int> updateItemQuantity(int itemId, int newQuantity) async {
    final db = await database;

    try {
      int result = await db.update(
        _table2Name,
        {
          columnQuantity: newQuantity.toString(),
       //   columnAvailability: newQuantity > 0 ? 'YES' : 'NO',
        },
        where: '$columnId2 = ?',
        whereArgs: [itemId],
      );

      return result;
    } catch (e) {
      print('Error updating item quantity: $e');
      return 0;
    }
  }



}




